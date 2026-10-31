import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/aviaj_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class DiscoverScreen extends StatefulWidget {
  final AviajState state;

  const DiscoverScreen({super.key, required this.state});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  bool _isGridMode = false;
  bool _showHeroBanner = true;
  double _dragOffset = 0;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 900;

    return Column(
      children: [
        GlobalIntentFilterBar(state: state),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 32 : 16,
              vertical: 20,
            ),
            children: [
              if (_showHeroBanner) ...[
                _WebsiteHeroBanner(
                  state: state,
                  onDismiss: () => setState(() => _showHeroBanner = false),
                  onExploreTrips: () => state.setActiveTab(1),
                  onOpenMatchmaker: () => state.setActiveTab(2),
                ),
                const SizedBox(height: 20),
              ],
              _buildModeToolbar(context, state),
              const SizedBox(height: 16),
              if (_isGridMode)
                _buildExplorerGrid(context, state, screenWidth)
              else
                _buildInteractiveSwipeDeck(context, state, isWide),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModeToolbar(BuildContext context, AviajState state) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.radar_rounded,
                  color: AviajTheme.coralPrimary,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  _isGridMode
                      ? 'Traveller Directory (${state.filteredProfiles.length} active)'
                      : 'Co-Pilot & Dating Deck (${state.unswipedProfiles.length} in queue)',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              'Match by relationship goal (Short-Term, Long-Term, Travel Buddy, or Solo Group) & upcoming destination.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!_isGridMode && state.canUndoSwipe)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: OutlinedButton.icon(
                  onPressed: state.undoLastSwipe,
                  icon: const Icon(Icons.undo_rounded, size: 17),
                  label: const Text('Undo'),
                ),
              ),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(
                  value: false,
                  icon: Icon(Icons.style_rounded, size: 18),
                  label: Text('Swipe Deck'),
                ),
                ButtonSegment<bool>(
                  value: true,
                  icon: Icon(Icons.grid_view_rounded, size: 18),
                  label: Text('Web Grid'),
                ),
              ],
              selected: {_isGridMode},
              onSelectionChanged: (selection) {
                setState(() {
                  _isGridMode = selection.first;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInteractiveSwipeDeck(
    BuildContext context,
    AviajState state,
    bool isWide,
  ) {
    final queue = state.unswipedProfiles;
    if (queue.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 48),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AviajTheme.coralPrimary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.flight_land_rounded,
                  size: 44,
                  color: AviajTheme.coralPrimary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'You’ve seen everyone in this departure lounge!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Reset your swipe deck, switch to Web Grid view, or clear destination filters to revisit all solo & group travellers.',
                style: TextStyle(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: state.resetAllSwipes,
                    style: FilledButton.styleFrom(
                      backgroundColor: AviajTheme.coralPrimary,
                    ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reload Deck'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _isGridMode = true),
                    icon: const Icon(Icons.grid_view_rounded),
                    label: const Text('Browse All in Web Grid'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final profile = queue.first;
    final compatibility = state.calculateCompatibility(profile);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1060),
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _dragOffset += details.delta.dx;
            });
          },
          onHorizontalDragEnd: (details) {
            if (_dragOffset > 110) {
              _handleLike(context, state, profile, isSuper: false);
            } else if (_dragOffset < -110) {
              state.passProfile(profile.id);
            }
            setState(() {
              _dragOffset = 0;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            transform: Matrix4.translationValues(_dragOffset * 0.35, 0, 0),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: _buildPhotoHeroCard(
                          context,
                          state,
                          profile,
                          compatibility,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 6,
                        child: _buildDetailedProfilePanel(
                          context,
                          state,
                          profile,
                          compatibility,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _buildPhotoHeroCard(
                        context,
                        state,
                        profile,
                        compatibility,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailedProfilePanel(
                        context,
                        state,
                        profile,
                        compatibility,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoHeroCard(
    BuildContext context,
    AviajState state,
    TravellerProfile profile,
    int compatibility,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Stack(
            children: [
              AviajNetworkImage(
                imageUrl: profile.imageUrl,
                height: 460,
                width: double.infinity,
                fallbackLabel: profile.name,
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.25),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.82),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.42, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IntentBadge(intent: profile.primaryIntent, solid: true),
                    CompatibilityPill(score: compatibility),
                  ],
                ),
              ),
              Positioned(
                bottom: 18,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${profile.name}, ${profile.age} ${profile.countryFlag}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        if (profile.isVerified) ...[
                          const SizedBox(width: 8),
                          const Tooltip(
                            message: 'Passport & Photo Verified Traveller',
                            child: Icon(
                              Icons.verified_rounded,
                              color: Color(0xFF38BDF8),
                              size: 22,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${profile.occupation} • Lives in ${profile.homeCity}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.flight_takeoff_rounded,
                            color: Colors.amberAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Next Trip: ${profile.nextDestination} (${profile.nextTripWindow})',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _DeckActionButton(
                  icon: Icons.close_rounded,
                  label: 'Pass',
                  color: Colors.grey.shade600,
                  onTap: () => state.passProfile(profile.id),
                ),
                _DeckActionButton(
                  icon: Icons.workspace_premium_rounded,
                  label: 'Boarding Pass',
                  color: AviajTheme.goldPassport,
                  isHighlighted: true,
                  onTap: () => _handleLike(
                    context,
                    state,
                    profile,
                    isSuper: true,
                  ),
                ),
                _DeckActionButton(
                  icon: Icons.favorite_rounded,
                  label: 'Match & Connect',
                  color: AviajTheme.coralPrimary,
                  isPrimary: true,
                  onTap: () => _handleLike(
                    context,
                    state,
                    profile,
                    isSuper: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedProfilePanel(
    BuildContext context,
    AviajState state,
    TravellerProfile profile,
    int compatibility,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'OPEN TO CONNECTING FOR',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: AviajTheme.coralPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.intents
                  .map((i) => IntentBadge(
                        intent: i,
                        solid: i == profile.primaryIntent,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            Text(
              profile.primaryIntent.shortTagline,
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
            const Divider(height: 28),
            const Text(
              'ABOUT & WANDERLUST BIO',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: AviajTheme.oceanTeal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              profile.bio,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _StatBadge(
                  icon: Icons.public_rounded,
                  label: '${profile.countriesVisited} Countries',
                ),
                _StatBadge(
                  icon: Icons.payments_outlined,
                  label: 'Budget: ${profile.budgetTier}',
                ),
                _StatBadge(
                  icon: Icons.schedule_rounded,
                  label: profile.sleepSchedule,
                ),
                _StatBadge(
                  icon: Icons.translate_rounded,
                  label: profile.languages.join(', '),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'TRAVEL STYLES',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: AviajTheme.oceanTeal,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.travelStyles.map((style) {
                final isShared =
                    state.currentUser.travelStyles.contains(style);
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isShared
                        ? AviajTheme.coralPrimary.withValues(alpha: 0.12)
                        : (isDark
                            ? const Color(0xFF1E293B)
                            : Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isShared
                          ? AviajTheme.coralPrimary
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        style.icon,
                        size: 15,
                        color: isShared
                            ? AviajTheme.coralPrimary
                            : Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        style.label,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight:
                              isShared ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ...profile.prompts.map(
              (prompt) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFFFF7F5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AviajTheme.coralPrimary.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prompt.question,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AviajTheme.coralPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '“${prompt.answer}”',
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'SHARED BUCKET LIST DREAMS',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: AviajTheme.oceanTeal,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.bucketList
                  .map(
                    (item) => Chip(
                      avatar: const Icon(
                        Icons.place_rounded,
                        size: 16,
                        color: AviajTheme.coralPrimary,
                      ),
                      label: Text(item, style: const TextStyle(fontSize: 12.5)),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplorerGrid(
    BuildContext context,
    AviajState state,
    double screenWidth,
  ) {
    final profiles = state.filteredProfiles;
    if (profiles.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Text('No travellers match the current filters.'),
        ),
      );
    }

    int crossAxisCount = 1;
    if (screenWidth >= 1200) {
      crossAxisCount = 3;
    } else if (screenWidth >= 760) {
      crossAxisCount = 2;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: profiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        mainAxisExtent: 495,
      ),
      itemBuilder: (context, index) {
        final profile = profiles[index];
        final compatibility = state.calculateCompatibility(profile);
        final isLiked = state.likedProfileIds.contains(profile.id);

        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AviajNetworkImage(
                    imageUrl: profile.imageUrl,
                    height: 235,
                    width: double.infinity,
                    fallbackLabel: profile.name,
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: IntentBadge(
                      intent: profile.primaryIntent,
                      compact: true,
                      solid: true,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: CompatibilityPill(score: compatibility),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${profile.name}, ${profile.age} ${profile.countryFlag}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (profile.isVerified)
                            const Icon(
                              Icons.verified_rounded,
                              color: Color(0xFF38BDF8),
                              size: 18,
                            ),
                        ],
                      ),
                      Text(
                        '${profile.occupation} • ${profile.homeCity}',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AviajTheme.oceanTeal.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.flight_takeoff_rounded,
                              size: 15,
                              color: AviajTheme.oceanTeal,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${profile.nextDestination} (${profile.nextTripWindow})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile.bio,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, height: 1.4),
                      ),
                      const Spacer(),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: profile.intents
                            .map((i) => IntentBadge(intent: i, compact: true))
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: () => _handleLike(
                                context,
                                state,
                                profile,
                                isSuper: false,
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: isLiked
                                    ? AviajTheme.oceanTeal
                                    : AviajTheme.coralPrimary,
                              ),
                              icon: Icon(
                                isLiked
                                    ? Icons.chat_bubble_rounded
                                    : Icons.favorite_rounded,
                                size: 16,
                              ),
                              label: Text(
                                isLiked ? 'Matched • Chat' : 'Match & Travel',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.outlined(
                            tooltip: 'Send Golden Boarding Pass',
                            onPressed: () => _handleLike(
                              context,
                              state,
                              profile,
                              isSuper: true,
                            ),
                            icon: const Icon(
                              Icons.workspace_premium_rounded,
                              color: AviajTheme.goldPassport,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleLike(
    BuildContext context,
    AviajState state,
    TravellerProfile profile, {
    required bool isSuper,
  }) {
    state.likeProfile(profile.id, isSuperBoardingPass: isSuper);
    showBoardingMatchModal(
      context: context,
      profile: profile,
      isSuperBoardingPass: isSuper,
      state: state,
    );
  }
}

class _WebsiteHeroBanner extends StatelessWidget {
  final AviajState state;
  final VoidCallback onDismiss;
  final VoidCallback onExploreTrips;
  final VoidCallback onOpenMatchmaker;

  const _WebsiteHeroBanner({
    required this.state,
    required this.onDismiss,
    required this.onExploreTrips,
    required this.onOpenMatchmaker,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            AviajTheme.deepNavy,
            AviajTheme.oceanTeal,
            Color(0xFF9A3412),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AviajTheme.deepNavy.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.flight_takeoff_rounded,
                      color: Colors.amberAccent,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'AVIAJ • SOLO & GROUP TRAVEL + DATING NETWORK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 11.5,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onDismiss,
                icon: const Icon(Icons.close_rounded, color: Colors.white70),
                tooltip: 'Hide welcome banner',
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Never Travel Solo Unless You Want To.\nFind Your Travel Buddy, Vacation Spark, or Forever Co-Pilot.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w900,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Whether you want a platonic buddy to split a 4x4 in Patagonia, a spontaneous short-term romance in Kyoto, a small solo-group villa in Bali, or a long-term relationship with a fellow explorer—Aviaj matches you before you even board.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.5,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: onExploreTrips,
                style: FilledButton.styleFrom(
                  backgroundColor: AviajTheme.coralPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.luggage_rounded, size: 18),
                label: const Text('Explore Solo & Group Trips'),
              ),
              OutlinedButton.icon(
                onPressed: onOpenMatchmaker,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                ),
                icon: const Icon(Icons.compass_calibration_rounded, size: 18),
                label: const Text('Take Compatibility Quiz'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeckActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isPrimary;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _DeckActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.isPrimary = false,
    this.isHighlighted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isPrimary ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPrimary ? color : color.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isPrimary ? Colors.white : color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : color,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AviajTheme.oceanTeal),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

