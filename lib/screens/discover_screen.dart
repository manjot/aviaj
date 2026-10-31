import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/ad_service.dart';
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
                _SolidBrandHeroBanner(
                  state: state,
                  onDismiss: () => setState(() => _showHeroBanner = false),
                  onExploreTrips: () => state.setActiveTab(1),
                  onOpenMatchmaker: () => state.setActiveTab(2),
                ),
                const SizedBox(height: 22),
              ],
              const AviajAdBannerWidget(placementLabel: 'Discover Feed'),
              const SizedBox(height: 18),
              _buildModeToolbar(context, state),
              const SizedBox(height: 16),
              if (_isGridMode)
                _buildExplorerGrid(context, state, screenWidth)
              else
                _buildInteractiveSwipeDeck(context, state, isWide),
              const SizedBox(height: 28),
              _MobileAppStoreFooterBanner(state: state),
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
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AviajTheme.loveCrimson,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    _isGridMode
                        ? 'Single Love & Travel Directory (${state.filteredProfiles.length} active)'
                        : 'Swipe & First-Move Deck (${state.unswipedProfiles.length} singles nearby)',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Tinder Swipe® speed + Bumble Opening Moves™ for single solo & group travellers.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
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
                  icon: const Icon(Icons.replay_rounded, size: 17),
                  label: const Text('Rewind'),
                ),
              ),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(
                  value: false,
                  icon: Icon(Icons.local_fire_department_rounded, size: 18),
                  label: Text('Swipe Deck'),
                ),
                ButtonSegment<bool>(
                  value: true,
                  icon: Icon(Icons.grid_view_rounded, size: 18),
                  label: Text('Bumble Grid'),
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
                decoration: const BoxDecoration(
                  color: AviajTheme.softBlush,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  size: 44,
                  color: AviajTheme.loveCrimson,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'You’ve Swiped Everyone in This Passport™ City!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Rewind your deck, switch to Bumble Grid view, or teleport your Passport™ filter to discover more singles.',
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
                      backgroundColor: AviajTheme.loveCrimson,
                    ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reset Swipe Deck'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _isGridMode = true),
                    icon: const Icon(Icons.grid_view_rounded),
                    label: const Text('Open Bumble Grid'),
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
        constraints: const BoxConstraints(maxWidth: 1080),
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
                        child: _buildTinderSwipeCard(
                          context,
                          state,
                          profile,
                          compatibility,
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 6,
                        child: _buildBumbleStoryPanel(
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
                      _buildTinderSwipeCard(
                        context,
                        state,
                        profile,
                        compatibility,
                      ),
                      const SizedBox(height: 16),
                      _buildBumbleStoryPanel(
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

  Widget _buildTinderSwipeCard(
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
                height: 470,
                width: double.infinity,
                fallbackLabel: profile.name,
              ),
              // Top Badges: Primary Intent + Compatibility
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
              // Solid bottom info card overlay (no gradient, crisp solid contrast)
              Positioned(
                bottom: 14,
                left: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AviajTheme.obsidian.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.14),
                    ),
                  ),
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
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (profile.isVerified) ...[
                            const SizedBox(width: 8),
                            const Tooltip(
                              message: 'Photo & Passport Verified Single',
                              child: Icon(
                                Icons.verified_rounded,
                                color: AviajTheme.passportBlue,
                                size: 22,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${profile.occupation} • ${profile.homeCity}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Solid Bumble Honey Destination Bar
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AviajTheme.bumbleHoney,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.flight_takeoff_rounded,
                              color: AviajTheme.obsidian,
                              size: 17,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Flying to: ${profile.nextDestination} (${profile.nextTripWindow})',
                                style: const TextStyle(
                                  color: AviajTheme.obsidian,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12.5,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Tinder-style 5 Circular Action Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _TinderRoundButton(
                  icon: Icons.replay_rounded,
                  tooltip: 'Rewind Last Swipe',
                  size: 46,
                  iconSize: 22,
                  bgColor: const Color(0xFFFFF3D1),
                  fgColor: const Color(0xFFD97706),
                  onTap: state.canUndoSwipe
                      ? state.undoLastSwipe
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Swipe a profile first to Rewind!'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                ),
                _TinderRoundButton(
                  icon: Icons.close_rounded,
                  tooltip: 'Nope / Pass',
                  size: 58,
                  iconSize: 30,
                  bgColor: const Color(0xFFF3F4F6),
                  fgColor: AviajTheme.obsidian,
                  onTap: () => state.passProfile(profile.id),
                ),
                _TinderRoundButton(
                  icon: Icons.star_rounded,
                  tooltip: 'Super Like • Golden Boarding Pass',
                  size: 50,
                  iconSize: 25,
                  bgColor: AviajTheme.passportBlue,
                  fgColor: Colors.white,
                  onTap: () => _handleLike(
                    context,
                    state,
                    profile,
                    isSuper: true,
                  ),
                ),
                _TinderRoundButton(
                  icon: Icons.favorite_rounded,
                  tooltip: 'Swipe Right • Love Match',
                  size: 62,
                  iconSize: 32,
                  bgColor: AviajTheme.loveCrimson,
                  fgColor: Colors.white,
                  onTap: () => _handleLike(
                    context,
                    state,
                    profile,
                    isSuper: false,
                  ),
                ),
                _TinderRoundButton(
                  icon: Icons.bolt_rounded,
                  tooltip: 'Bumble Spotlight / Passport™ Boost',
                  size: 46,
                  iconSize: 22,
                  bgColor: AviajTheme.bumbleHoney,
                  fgColor: AviajTheme.obsidian,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AviajTheme.obsidian,
                        content: Text(
                          '⚡ Spotlight Active! Your profile is priority #1 in ${profile.nextDestination} for 30 mins.',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBumbleStoryPanel(
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
            // Bumble-style 24h First Move Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AviajTheme.bumbleHoney,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.bolt_rounded,
                    color: AviajTheme.obsidian,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'BUMBLE OPENING MOVE™ • Reply to ${profile.name.split(' ').first} to unlock instant chat!',
                      style: const TextStyle(
                        color: AviajTheme.obsidian,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'RELATIONSHIP & TRAVEL GOALS',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
                color: AviajTheme.loveCrimson,
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
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const Divider(height: 28),
            const Text(
              'ABOUT ME & SINGLE LOVE BIO',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              profile.bio,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            // Bumble-style Basic Info Badges
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _BasicPill(
                  icon: Icons.favorite_border_rounded,
                  label: 'Single • Ready to Date',
                ),
                _BasicPill(
                  icon: Icons.public_rounded,
                  label: '${profile.countriesVisited} Countries',
                ),
                _BasicPill(
                  icon: Icons.payments_outlined,
                  label: 'Budget: ${profile.budgetTier}',
                ),
                _BasicPill(
                  icon: Icons.schedule_rounded,
                  label: profile.sleepSchedule,
                ),
                _BasicPill(
                  icon: Icons.translate_rounded,
                  label: profile.languages.join(', '),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Bumble Opening Move Prompts (interactive tap to reply!)
            ...profile.prompts.map(
              (prompt) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF25252E)
                      : AviajTheme.warmCream,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AviajTheme.softBlush, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AviajTheme.loveCrimson,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'OPENING MOVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            prompt.question,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: AviajTheme.loveCrimson,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '“${prompt.answer}”',
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _handleLike(
                          context,
                          state,
                          profile,
                          isSuper: false,
                        ),
                        icon: const Icon(
                          Icons.reply_rounded,
                          size: 16,
                          color: AviajTheme.loveCrimson,
                        ),
                        label: Text(
                          'Send First Move to ${profile.name.split(' ').first}',
                          style: const TextStyle(
                            color: AviajTheme.loveCrimson,
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'COUPLE & SOLO BUCKET LIST',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
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
                        color: AviajTheme.loveCrimson,
                      ),
                      label: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
          child: Text('No singles or travel buddies match the current filter.'),
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
        mainAxisExtent: 500,
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
                                fontWeight: FontWeight.w900,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (profile.isVerified)
                            const Icon(
                              Icons.verified_rounded,
                              color: AviajTheme.passportBlue,
                              size: 18,
                            ),
                        ],
                      ),
                      Text(
                        '${profile.occupation} • ${profile.homeCity}',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
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
                          color: AviajTheme.bumbleHoney,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.flight_takeoff_rounded,
                              size: 15,
                              color: AviajTheme.obsidian,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${profile.nextDestination} (${profile.nextTripWindow})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: AviajTheme.obsidian,
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
                                    ? AviajTheme.obsidian
                                    : AviajTheme.loveCrimson,
                              ),
                              icon: Icon(
                                isLiked
                                    ? Icons.chat_bubble_rounded
                                    : Icons.favorite_rounded,
                                size: 16,
                              ),
                              label: Text(
                                isLiked
                                    ? 'Matched • First Move'
                                    : 'Swipe Right • Match',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            tooltip: 'Send Super Like Boarding Pass',
                            style: IconButton.styleFrom(
                              backgroundColor: AviajTheme.passportBlue,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _handleLike(
                              context,
                              state,
                              profile,
                              isSuper: true,
                            ),
                            icon: const Icon(Icons.star_rounded),
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

/// Solid-Color Single-Love Relationship Travel Brand Hero (Tinder + Bumble combination)
/// with App Store & Google Play Store Download CTAs.
class _SolidBrandHeroBanner extends StatelessWidget {
  final AviajState state;
  final VoidCallback onDismiss;
  final VoidCallback onExploreTrips;
  final VoidCallback onOpenMatchmaker;

  const _SolidBrandHeroBanner({
    required this.state,
    required this.onDismiss,
    required this.onExploreTrips,
    required this.onOpenMatchmaker,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        // Strictly SOLID Love Crimson brand color — no gradients!
        color: AviajTheme.loveCrimson,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: AviajTheme.bumbleHoney,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        color: AviajTheme.obsidian,
                        size: 15,
                      ),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'AVIAJ • SINGLE LOVE & TRAVEL APP',
                          style: TextStyle(
                            color: AviajTheme.obsidian,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            letterSpacing: 0.7,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onDismiss,
                icon: const Icon(Icons.close_rounded, color: Colors.white),
                tooltip: 'Hide banner',
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Never Travel Single Unless You Want To.\nSwipe Right® on Your Next Destination. Make the First Move Abroad.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'The #1 single-love relationship & travel app combining Tinder’s global Passport™ matching with Bumble’s 24-hour First Move. Meet verified singles for short-term vacation sparks, long-term life partners, or solo group villa trips.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 14,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const AppStoreDownloadBadges(lightOnDark: true),
              FilledButton.icon(
                onPressed: onExploreTrips,
                style: FilledButton.styleFrom(
                  backgroundColor: AviajTheme.bumbleHoney,
                  foregroundColor: AviajTheme.obsidian,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.luggage_rounded, size: 19),
                label: const Text(
                  'Explore Singles & Group Trips',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              OutlinedButton.icon(
                onPressed: onOpenMatchmaker,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 1.8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.compass_calibration_rounded, size: 18),
                label: const Text(
                  'Love Compatibility Quiz',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Bottom solid Bumble-Honey + Obsidian App Store & Google Play Store showcase section.
class _MobileAppStoreFooterBanner extends StatelessWidget {
  final AviajState state;

  const _MobileAppStoreFooterBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AviajTheme.obsidian,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 24,
        runSpacing: 20,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AviajTheme.bumbleHoney,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'DOWNLOAD THE AVIAJ MOBILE APP • 4.9 ★ ON APP STORE & GOOGLE PLAY',
                    style: TextStyle(
                      color: AviajTheme.obsidian,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Take Single Love & Travel Matching Everywhere You Fly.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Get instant boarding-gate match alerts, offline itinerary chat, Passport™ teleportation, and Bumble-style 24h First Move notifications on iOS and Android.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const AppStoreDownloadBadges(lightOnDark: false),
        ],
      ),
    );
  }
}

class _TinderRoundButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final double size;
  final double iconSize;
  final Color bgColor;
  final Color fgColor;
  final VoidCallback onTap;

  const _TinderRoundButton({
    required this.icon,
    required this.tooltip,
    required this.size,
    required this.iconSize,
    required this.bgColor,
    required this.fgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: fgColor.withValues(alpha: 0.18),
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: fgColor, size: iconSize),
        ),
      ),
    );
  }
}

class _BasicPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BasicPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF25252E) : const Color(0xFFF6F1F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: AviajTheme.loveCrimson),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
