import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../state/aviaj_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class MessagesScreen extends StatefulWidget {
  final AviajState state;

  const MessagesScreen({super.key, required this.state});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _msgCtrl = TextEditingController();

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final conversations = state.conversations;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 860;

    if (conversations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.mark_chat_unread_rounded,
                size: 52,
                color: AviajTheme.coralPrimary,
              ),
              const SizedBox(height: 14),
              const Text(
                'No Lounge Matches Yet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                'Swipe or connect with travellers in Discover to start planning your trip or date!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => state.setActiveTab(0),
                child: const Text('Explore Travellers'),
              ),
            ],
          ),
        ),
      );
    }

    final activeProfileId =
        state.selectedConversationProfileId ?? conversations.first.profileId;
    final activeConv = conversations.firstWhere(
      (c) => c.profileId == activeProfileId,
      orElse: () => conversations.first,
    );
    final activePartner =
        state.getProfileById(activeConv.profileId) ?? state.allProfiles.first;

    if (isWide) {
      return Row(
        children: [
          SizedBox(
            width: 350,
            child: _buildConversationSidebar(
              context,
              state,
              conversations,
              activeConv.profileId,
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: _buildChatPane(
              context,
              state,
              activeConv,
              activePartner,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 112,
          child: _buildMobileMatchCarousel(
            context,
            state,
            conversations,
            activeConv.profileId,
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _buildChatPane(
            context,
            state,
            activeConv,
            activePartner,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileMatchCarousel(
    BuildContext context,
    AviajState state,
    List<MatchConversation> conversations,
    String activeId,
  ) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conv = conversations[index];
        final profile = state.getProfileById(conv.profileId);
        if (profile == null) return const SizedBox.shrink();
        final isSelected = conv.profileId == activeId;

        return GestureDetector(
          onTap: () => state.selectConversation(conv.profileId),
          child: Container(
            margin: const EdgeInsets.only(right: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AviajTheme.coralPrimary
                          : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 26,
                    child: ClipOval(
                      child: AviajNetworkImage(
                        imageUrl: profile.imageUrl,
                        width: 52,
                        height: 52,
                        fallbackLabel: profile.name,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.name.split(' ').first,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 12,
                    color: isSelected ? AviajTheme.coralPrimary : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConversationSidebar(
    BuildContext context,
    AviajState state,
    List<MatchConversation> conversations,
    String activeId,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            children: [
              const Icon(
                Icons.favorite_rounded,
                color: AviajTheme.coralPrimary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Departure Lounge Matches (${conversations.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            itemCount: conversations.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final conv = conversations[index];
              final profile = state.getProfileById(conv.profileId);
              if (profile == null) return const SizedBox.shrink();
              final isSelected = conv.profileId == activeId;
              final lastMsg = conv.lastMessage;

              return ListTile(
                selected: isSelected,
                selectedTileColor:
                    AviajTheme.coralPrimary.withValues(alpha: 0.08),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                onTap: () => state.selectConversation(conv.profileId),
                leading: Stack(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      child: ClipOval(
                        child: AviajNetworkImage(
                          imageUrl: profile.imageUrl,
                          width: 52,
                          height: 52,
                          fallbackLabel: profile.name,
                        ),
                      ),
                    ),
                    if (conv.isSuperBoardingPass)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AviajTheme.goldPassport,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.workspace_premium_rounded,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${profile.name} ${profile.countryFlag}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    IntentBadge(intent: conv.matchedIntent, compact: true),
                    const SizedBox(height: 5),
                    Text(
                      lastMsg?.text ?? 'Start planning your trip together!',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.5),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatPane(
    BuildContext context,
    AviajState state,
    MatchConversation conv,
    TravellerProfile partner,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        // Partner header bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151F32) : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isDark ? const Color(0xFF26334D) : Colors.grey.shade200,
              ),
            ),
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 22,
                    child: ClipOval(
                      child: AviajNetworkImage(
                        imageUrl: partner.imageUrl,
                        width: 44,
                        height: 44,
                        fallbackLabel: partner.name,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${partner.name}, ${partner.age} ${partner.countryFlag}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IntentBadge(
                            intent: partner.primaryIntent,
                            compact: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Heading to ${partner.nextDestination} (${partner.nextTripWindow})',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              FilledButton.tonalIcon(
                onPressed: () =>
                    _showProposeDateDialog(context, state, partner),
                icon: const Icon(Icons.wine_bar_rounded, size: 17),
                label: const Text('Propose Travel Date / Itinerary'),
              ),
            ],
          ),
        ),
        // Messages list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: conv.messages.length,
            itemBuilder: (context, index) {
              final msg = conv.messages[index];
              final isMe = msg.senderId == 'me';

              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isMe
                          ? AviajTheme.coralPrimary
                          : (isDark
                              ? const Color(0xFF1E293B)
                              : Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      border: isMe
                          ? null
                          : Border.all(
                              color: isDark
                                  ? const Color(0xFF334155)
                                  : Colors.grey.shade200,
                            ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (msg.isDateProposal) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.white.withValues(alpha: 0.18)
                                  : AviajTheme.goldPassport
                                      .withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.airplane_ticket_rounded,
                                      size: 18,
                                      color: isMe
                                          ? Colors.amberAccent
                                          : AviajTheme.coralPrimary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'BOARDING DATE INVITE',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.8,
                                        color: isMe
                                            ? Colors.amberAccent
                                            : AviajTheme.coralPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  msg.proposalTitle ?? 'Sunset Travel Date',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: isMe ? Colors.white : null,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${msg.proposalLocation ?? partner.nextDestination} • ${msg.proposalWhen ?? partner.nextTripWindow}',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: isMe
                                        ? Colors.white70
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        Text(
                          msg.text,
                          style: TextStyle(
                            color: isMe ? Colors.white : null,
                            fontSize: 14.5,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Icebreaker chips
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: AviajMockData.travelIcebreakers.map((icebreaker) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  avatar: const Icon(
                    Icons.auto_awesome_rounded,
                    size: 15,
                    color: AviajTheme.coralPrimary,
                  ),
                  label: Text(
                    icebreaker,
                    style: const TextStyle(fontSize: 12),
                  ),
                  onPressed: () {
                    state.sendMessage(partner.id, icebreaker);
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 6),
        // Message input bar
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _msgCtrl,
                  onSubmitted: (_) => _sendCurrentText(state, partner.id),
                  decoration: InputDecoration(
                    hintText:
                        'Message ${partner.name.split(' ').first} about ${partner.nextDestination}...',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                onPressed: () => _sendCurrentText(state, partner.id),
                style: FilledButton.styleFrom(
                  backgroundColor: AviajTheme.coralPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                icon: const Icon(Icons.send_rounded, size: 18),
                label: const Text('Send'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _sendCurrentText(AviajState state, String profileId) {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    state.sendMessage(profileId, text);
    _msgCtrl.clear();
  }

  Future<void> _showProposeDateDialog(
    BuildContext context,
    AviajState state,
    TravellerProfile partner,
  ) async {
    final titleCtrl = TextEditingController(
      text: 'Sunset Rooftop Drinks & Night Market Walk',
    );
    final locationCtrl = TextEditingController(text: partner.nextDestination);
    final whenCtrl = TextEditingController(text: partner.nextTripWindow);
    final noteCtrl = TextEditingController(
      text:
          'Would love to meet up in ${partner.nextDestination.split(',').first} and kick off the trip together!',
    );

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Propose a Travel Date with ${partner.name.split(' ').first}',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Date / Activity Idea',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: locationCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Destination / Spot',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: whenCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Proposed Date / Time',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: noteCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Personal Note',
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: () {
                          state.sendMessage(
                            partner.id,
                            noteCtrl.text.trim(),
                            isDateProposal: true,
                            proposalTitle: titleCtrl.text.trim(),
                            proposalLocation: locationCtrl.text.trim(),
                            proposalWhen: whenCtrl.text.trim(),
                          );
                          Navigator.of(ctx).pop();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AviajTheme.coralPrimary,
                        ),
                        icon: const Icon(Icons.airplane_ticket_rounded),
                        label: const Text('Send Boarding Date Card'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

