import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/ad_service.dart';
import '../services/stripe_service.dart';
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
  double _dragOffset = 0;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 900;
    final hasRightSidebar = screenWidth >= 1120 && !_isGridMode;

    return Column(
      children: [
        GlobalIntentFilterBar(state: state),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 28 : 14,
              vertical: 14,
            ),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1280),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCompactToolbar(context, state),
                      const SizedBox(height: 12),
                      if (_isGridMode) ...[
                        _buildExplorerGrid(context, state, screenWidth),
                        const SizedBox(height: 18),
                        _CleanBrandSideCard(state: state, horizontal: true),
                      ] else if (hasRightSidebar)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 8,
                              child: _buildInteractiveDiscoveryDeck(
                                context,
                                state,
                                isWide: true,
                              ),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: 310,
                              child: _CleanBrandSideCard(
                                state: state,
                                horizontal: false,
                              ),
                            ),
                          ],
                        )
                      else ...[
                        _buildInteractiveDiscoveryDeck(
                          context,
                          state,
                          isWide: isWide,
                        ),
                        const SizedBox(height: 16),
                        _CleanBrandSideCard(state: state, horizontal: isWide),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactToolbar(BuildContext context, AviajState state) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(
            color: AviajTheme.horizonTeal,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.flight_takeoff_rounded,
            color: Colors.white,
            size: 14,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _isGridMode
                ? 'Travel Buddy & Romance Directory (${state.filteredProfiles.length})'
                : 'Co-Pilot Discovery Deck (${state.unswipedProfiles.length} travellers nearby)',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (!_isGridMode && state.canUndoSwipe)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: state.undoLastSwipe,
              icon: const Icon(Icons.replay_rounded, size: 16),
              label: const Text('Rewind'),
            ),
          ),
        SegmentedButton<bool>(
          style: const ButtonStyle(
            visualDensity: VisualDensity.compact,
          ),
          segments: const [
            ButtonSegment<bool>(
              value: false,
              icon: Icon(Icons.style_rounded, size: 16),
              label: Text('Deck', style: TextStyle(fontSize: 12.5)),
            ),
            ButtonSegment<bool>(
              value: true,
              icon: Icon(Icons.grid_view_rounded, size: 16),
              label: Text('Grid', style: TextStyle(fontSize: 12.5)),
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
    );
  }

  Widget _buildInteractiveDiscoveryDeck(
    BuildContext context,
    AviajState state, {
    required bool isWide,
  }) {
    final queue = state.unswipedProfiles;
    if (queue.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AviajTheme.softTerracotta,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.flight_takeoff_rounded,
                  size: 38,
                  color: AviajTheme.sunsetTerracotta,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'You’ve Explored All Travellers in This Destination!',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: state.resetAllSwipes,
                    style: FilledButton.styleFrom(
                      backgroundColor: AviajTheme.horizonTeal,
                    ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reset Discovery Deck'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _isGridMode = true),
                    icon: const Icon(Icons.grid_view_rounded),
                    label: const Text('Open Grid'),
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

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragOffset += details.delta.dx;
        });
      },
      onHorizontalDragEnd: (details) {
        if (_dragOffset > 100) {
          _handleLike(context, state, profile, isSuper: false);
        } else if (_dragOffset < -100) {
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
                    child: _buildTravellerPhotoCard(
                      context,
                      state,
                      profile,
                      compatibility,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 6,
                    child: _buildTravellerItineraryPanel(
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
                  _buildTravellerPhotoCard(
                    context,
                    state,
                    profile,
                    compatibility,
                  ),
                  const SizedBox(height: 14),
                  _buildTravellerItineraryPanel(
                    context,
                    state,
                    profile,
                    compatibility,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTravellerPhotoCard(
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
                height: 395,
                width: double.infinity,
                fallbackLabel: profile.name,
              ),
              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IntentBadge(
                      intent: profile.primaryIntent,
                      compact: true,
                      solid: true,
                    ),
                    CompatibilityPill(score: compatibility),
                  ],
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AviajTheme.midnightNavy.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(18),
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
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (profile.isVerified) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.verified_rounded,
                              color: AviajTheme.skyAzure,
                              size: 19,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${profile.occupation} • ${profile.homeCity}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AviajTheme.horizonTeal,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.flight_takeoff_rounded,
                              color: Colors.white,
                              size: 15,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${profile.nextDestination} (${profile.nextTripWindow})',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12,
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
          // 5-Button Travel & Romance Action Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AviajRoundActionButton(
                  icon: Icons.replay_rounded,
                  tooltip: 'Rewind',
                  size: 42,
                  iconSize: 20,
                  bgColor: const Color(0xFFF4EFEA),
                  fgColor: AviajTheme.compassAmber,
                  onTap: state.canUndoSwipe ? state.undoLastSwipe : () {},
                ),
                _AviajRoundActionButton(
                  icon: Icons.close_rounded,
                  tooltip: 'Pass',
                  size: 52,
                  iconSize: 26,
                  bgColor: const Color(0xFFF3F4F6),
                  fgColor: AviajTheme.midnightNavy,
                  onTap: () => state.passProfile(profile.id),
                ),
                _AviajRoundActionButton(
                  icon: Icons.airplane_ticket_rounded,
                  tooltip: 'Send Priority Boarding Pass',
                  size: 46,
                  iconSize: 22,
                  bgColor: AviajTheme.compassAmber,
                  fgColor: Colors.white,
                  onTap: () => _handleLike(
                    context,
                    state,
                    profile,
                    isSuper: true,
                  ),
                ),
                _AviajRoundActionButton(
                  icon: Icons.favorite_rounded,
                  tooltip: 'Connect as Co-Pilot / Date',
                  size: 56,
                  iconSize: 28,
                  bgColor: AviajTheme.sunsetTerracotta,
                  fgColor: Colors.white,
                  onTap: () => _handleLike(
                    context,
                    state,
                    profile,
                    isSuper: false,
                  ),
                ),
                _AviajRoundActionButton(
                  icon: Icons.radar_rounded,
                  tooltip: 'Watch Rewarded Ad for +3 Priority Passes & Boost',
                  size: 42,
                  iconSize: 20,
                  bgColor: AviajTheme.horizonTeal,
                  fgColor: Colors.white,
                  onTap: () => AviajAdService.instance.showRewardedAd(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTravellerItineraryPanel(
    BuildContext context,
    AviajState state,
    TravellerProfile profile,
    int compatibility,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Departure Icebreaker Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AviajTheme.horizonTeal,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.airplane_ticket_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'DEPARTURE LOUNGE PROMPT • Connect with ${profile.name.split(' ').first} before takeoff!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: profile.intents
                  .map((i) => IntentBadge(
                        intent: i,
                        compact: true,
                        solid: i == profile.primaryIntent,
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
            Text(
              profile.bio,
              style: const TextStyle(
                fontSize: 14,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                const _BasicPill(
                  icon: Icons.favorite_border_rounded,
                  label: 'Single Traveller',
                ),
                _BasicPill(
                  icon: Icons.public_rounded,
                  label: '${profile.countriesVisited} Countries',
                ),
                _BasicPill(
                  icon: Icons.payments_outlined,
                  label: profile.budgetTier,
                ),
                _BasicPill(
                  icon: Icons.translate_rounded,
                  label: profile.languages.take(2).join(', '),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (profile.prompts.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color:
                      isDark ? const Color(0xFF263349) : AviajTheme.warmSand,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AviajTheme.softTerracotta,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.prompts.first.question,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AviajTheme.sunsetTerracotta,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '“${profile.prompts.first.answer}”',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _handleLike(
                          context,
                          state,
                          profile,
                          isSuper: false,
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: AviajTheme.sunsetTerracotta,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: const Icon(Icons.reply_rounded, size: 16),
                        label: Text(
                          'Send Boarding Invite to ${profile.name.split(' ').first}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: profile.bucketList
                  .map(
                    (item) => Chip(
                      visualDensity: VisualDensity.compact,
                      avatar: const Icon(
                        Icons.place_rounded,
                        size: 14,
                        color: AviajTheme.horizonTeal,
                      ),
                      label: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 11.5,
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
          child: Text('No travellers match the current destination filter.'),
        ),
      );
    }

    int crossAxisCount = 1;
    if (screenWidth >= 1150) {
      crossAxisCount = 3;
    } else if (screenWidth >= 720) {
      crossAxisCount = 2;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: profiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        mainAxisExtent: 460,
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
                    height: 215,
                    width: double.infinity,
                    fallbackLabel: profile.name,
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IntentBadge(
                      intent: profile.primaryIntent,
                      compact: true,
                      solid: true,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CompatibilityPill(score: compatibility),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${profile.name}, ${profile.age} ${profile.countryFlag}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (profile.isVerified)
                            const Icon(
                              Icons.verified_rounded,
                              color: AviajTheme.skyAzure,
                              size: 17,
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AviajTheme.horizonTeal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.flight_takeoff_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                '${profile.nextDestination} (${profile.nextTripWindow})',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
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
                        style: const TextStyle(fontSize: 12.5, height: 1.35),
                      ),
                      const Spacer(),
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
                                    ? AviajTheme.midnightNavy
                                    : AviajTheme.sunsetTerracotta,
                              ),
                              icon: Icon(
                                isLiked
                                    ? Icons.chat_bubble_rounded
                                    : Icons.favorite_rounded,
                                size: 15,
                              ),
                              label: Text(
                                isLiked ? 'Chat' : 'Connect',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            style: IconButton.styleFrom(
                              backgroundColor: AviajTheme.compassAmber,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => _handleLike(
                              context,
                              state,
                              profile,
                              isSuper: true,
                            ),
                            icon: const Icon(
                              Icons.airplane_ticket_rounded,
                              size: 18,
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

/// Compact, clean sidebar card containing the Solid-Color Aviaj Brand,
/// App Store & Google Play Store badges, Stripe Business Class upgrade, and AdMob/Unity Rewarded Ad trigger.
class _CleanBrandSideCard extends StatelessWidget {
  final AviajState state;
  final bool horizontal;

  const _CleanBrandSideCard({
    required this.state,
    required this.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    final adService = AviajAdService.instance;
    return ListenableBuilder(
      listenable: adService,
      builder: (context, _) {
        return Column(
          children: [
            // Solid Aegean Teal Brand + Mobile App Store Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AviajTheme.horizonTeal,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AviajTheme.compassAmber,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'AVIAJ • TRAVEL & ROMANCE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Meet Your Co-Pilot Before You Board.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Destination Radar & Departure Lounge matching for solo & group travellers.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const AppStoreDownloadBadges(
                    lightOnDark: true,
                    compact: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Compact Stripe Business Class + AdMob/Unity Reward Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AviajTheme.midnightNavy,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.workspace_premium_rounded,
                        color: AviajTheme.compassAmber,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${adService.superBoardingPassCredits} Priority Passes • ${adService.spotlightBoostMinutes}m Radar',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => showStripeStorefrontModal(context),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF635BFF),
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                      ),
                      icon: const Icon(Icons.credit_card_rounded, size: 15),
                      label: const Text(
                        'Business Class • Stripe (\$14.99)',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => adService.showRewardedAd(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AviajTheme.compassAmber,
                            side: const BorderSide(
                              color: AviajTheme.compassAmber,
                            ),
                            visualDensity: VisualDensity.compact,
                          ),
                          icon: const Icon(
                            Icons.play_circle_fill_rounded,
                            size: 14,
                          ),
                          label: const Text(
                            'Watch Ad (+3)',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        tooltip: 'AdMob & Unity Ads Setup',
                        onPressed: () => showAdMobUnityConsoleModal(context),
                        icon: const Icon(
                          Icons.tune_rounded,
                          color: Colors.white70,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AviajRoundActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final double size;
  final double iconSize;
  final Color bgColor;
  final Color fgColor;
  final VoidCallback onTap;

  const _AviajRoundActionButton({
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF263349) : const Color(0xFFF4EFEA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AviajTheme.horizonTeal),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
