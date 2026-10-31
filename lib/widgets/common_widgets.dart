import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/aviaj_state.dart';
import '../theme/app_theme.dart';

class AviajNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String fallbackLabel;

  const AviajNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackLabel = 'Aviaj',
  });

  @override
  Widget build(BuildContext context) {
    final child = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AviajTheme.oceanTeal,
                AviajTheme.coralPrimary,
                AviajTheme.sunsetOrange,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.flight_takeoff_rounded,
                color: Colors.white70,
                size: 36,
              ),
              const SizedBox(height: 6),
              Text(
                fallbackLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: child,
      );
    }
    return child;
  }
}

class IntentBadge extends StatelessWidget {
  final ConnectionIntent intent;
  final bool compact;
  final bool solid;

  const IntentBadge({
    super.key,
    required this.intent,
    this.compact = false,
    this.solid = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = intent.color;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 12,
        vertical: compact ? 5 : 6,
      ),
      decoration: BoxDecoration(
        color: solid ? color : color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: solid ? color : color.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            intent.icon,
            size: compact ? 13 : 15,
            color: solid ? Colors.white : color,
          ),
          const SizedBox(width: 5),
          Text(
            intent.label,
            style: TextStyle(
              color: solid ? Colors.white : color,
              fontWeight: FontWeight.w700,
              fontSize: compact ? 11.5 : 12.5,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class CompatibilityPill extends StatelessWidget {
  final int score;

  const CompatibilityPill({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AviajTheme.coralPrimary, AviajTheme.sunsetOrange],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AviajTheme.coralPrimary.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            '$score% Match',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class GlobalIntentFilterBar extends StatelessWidget {
  final AviajState state;
  final String searchHint;

  const GlobalIntentFilterBar({
    super.key,
    required this.state,
    this.searchHint =
        'Search destination (Kyoto, Amalfi, Bali), city, or traveller...',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151F32) : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF26334D) : Colors.grey.shade200,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: state.setSearchQuery,
                  decoration: InputDecoration(
                    hintText: searchHint,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: state.searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () => state.setSearchQuery(''),
                            icon: const Icon(Icons.close_rounded, size: 18),
                          )
                        : null,
                  ),
                ),
              ),
              if (state.selectedIntentFilter != null ||
                  state.selectedStyleFilter != null ||
                  state.searchQuery.isNotEmpty) ...[
                const SizedBox(width: 12),
                TextButton.icon(
                  onPressed: state.clearFilters,
                  icon: const Icon(Icons.restart_alt_rounded, size: 18),
                  label: const Text('Reset Filters'),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChipItem(
                  label: 'All Relationship & Travel Vibes',
                  icon: Icons.public_rounded,
                  isSelected: state.selectedIntentFilter == null,
                  activeColor: AviajTheme.oceanTeal,
                  onTap: () => state.setIntentFilter(null),
                ),
                const SizedBox(width: 8),
                ...ConnectionIntent.values.map(
                  (intent) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FilterChipItem(
                      label: intent.label,
                      icon: intent.icon,
                      isSelected: state.selectedIntentFilter == intent,
                      activeColor: intent.color,
                      onTap: () => state.setIntentFilter(
                        state.selectedIntentFilter == intent ? null : intent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor
              : (isDark ? const Color(0xFF1E293B) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? activeColor
                : (isDark ? const Color(0xFF334155) : Colors.grey.shade300),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white70 : Colors.grey.shade700),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : Colors.grey.shade800),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showBoardingMatchModal({
  required BuildContext context,
  required TravellerProfile profile,
  required bool isSuperBoardingPass,
  required AviajState state,
}) async {
  final noteController = TextEditingController();
  await showDialog<void>(
    context: context,
    builder: (ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSuperBoardingPass
                          ? [
                              AviajTheme.goldPassport,
                              AviajTheme.sunsetOrange,
                            ]
                          : [
                              AviajTheme.coralPrimary,
                              AviajTheme.roseRomance,
                            ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSuperBoardingPass
                            ? Icons.workspace_premium_rounded
                            : Icons.favorite_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isSuperBoardingPass
                            ? 'GOLDEN BOARDING PASS SENT!'
                            : 'IT’S A CO-PILOT MATCH!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: AviajTheme.coralPrimary,
                      child: ClipOval(
                        child: AviajNetworkImage(
                          imageUrl: state.currentUser.imageUrl,
                          width: 80,
                          height: 80,
                          fallbackLabel: state.currentUser.name,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              AviajTheme.coralPrimary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.flight_takeoff_rounded,
                          color: AviajTheme.coralPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: profile.primaryIntent.color,
                      child: ClipOval(
                        child: AviajNetworkImage(
                          imageUrl: profile.imageUrl,
                          width: 80,
                          height: 80,
                          fallbackLabel: profile.name,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'You & ${profile.name} matched!',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Next trip radar: ${profile.nextDestination} (${profile.nextTripWindow})',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                IntentBadge(intent: profile.primaryIntent),
                const SizedBox(height: 18),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    hintText:
                        'Send an instant travel note or date idea to ${profile.name.split(' ').first}...',
                    prefixIcon: const Icon(Icons.send_rounded, size: 18),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Keep Exploring'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          if (noteController.text.trim().isNotEmpty) {
                            state.sendMessage(
                              profile.id,
                              noteController.text.trim(),
                            );
                          }
                          state.selectConversation(profile.id);
                          Navigator.of(ctx).pop();
                          state.setActiveTab(3); // Switch to Lounge Chat tab
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AviajTheme.coralPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.chat_bubble_rounded, size: 18),
                        label: const Text('Open Lounge Chat'),
                      ),
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

