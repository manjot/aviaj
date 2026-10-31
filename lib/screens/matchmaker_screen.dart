import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/aviaj_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class MatchmakerScreen extends StatefulWidget {
  final AviajState state;

  const MatchmakerScreen({super.key, required this.state});

  @override
  State<MatchmakerScreen> createState() => _MatchmakerScreenState();
}

class _MatchmakerScreenState extends State<MatchmakerScreen> {
  ConnectionIntent _goal = ConnectionIntent.longTermPartner;
  TravelStyle _preferredStyle = TravelStyle.foodieCulture;
  String _budget = r'$$';
  String _rhythm = 'Night Owl';

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 920;

    final ranked = List<TravellerProfile>.from(state.allProfiles)
      ..sort((a, b) => _scoreProfile(b).compareTo(_scoreProfile(a)));

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 32 : 16,
        vertical: 24,
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [AviajTheme.oceanTeal, AviajTheme.deepNavy],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.compass_calibration_rounded,
                    color: Colors.amberAccent,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AVIAJ COMPASS MATCHMAKER',
                    style: TextStyle(
                      color: Colors.amberAccent.shade100,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Tune Your Relationship Horizon & Travel Chemistry',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Tell us whether you’re seeking a long-term romantic co-pilot, a spontaneous short-term vacation spark, a platonic travel buddy, or a solo group squad.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '1. What connection are you looking for right now?',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: ConnectionIntent.values.map((intent) {
                    final selected = _goal == intent;
                    return ChoiceChip(
                      avatar: Icon(
                        intent.icon,
                        size: 16,
                        color: selected ? Colors.white : intent.color,
                      ),
                      label: Text(intent.label),
                      selected: selected,
                      selectedColor: intent.color,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : null,
                        fontWeight: FontWeight.w700,
                      ),
                      onSelected: (_) => setState(() => _goal = intent),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                const Text(
                  '2. Pick your ideal trip vibe & style',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: TravelStyle.values.map((style) {
                    final selected = _preferredStyle == style;
                    return ChoiceChip(
                      avatar: Icon(style.icon, size: 16),
                      label: Text(style.label),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _preferredStyle = style),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 28,
                  runSpacing: 14,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '3. Shared Budget Tier',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(value: r'$', label: Text(r'$ Chill')),
                            ButtonSegment(
                                value: r'$$', label: Text(r'$$ Boutique')),
                            ButtonSegment(
                                value: r'$$$', label: Text(r'$$$ Luxury')),
                          ],
                          selected: {_budget},
                          onSelectionChanged: (s) =>
                              setState(() => _budget = s.first),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '4. Daily Travel Rhythm',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'Early Bird',
                              label: Text('Sunrise Explorer'),
                            ),
                            ButtonSegment(
                              value: 'Night Owl',
                              label: Text('Sunset & Night Owl'),
                            ),
                          ],
                          selected: {_rhythm},
                          onSelectionChanged: (s) =>
                              setState(() => _rhythm = s.first),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Top Co-Pilot Matches for ${_goal.label}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        ...ranked.take(4).map((profile) {
          final score = _scoreProfile(profile);
          final suggestedDate = _buildSuggestedDateIdea(profile);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Wrap(
                  spacing: 18,
                  runSpacing: 14,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: AviajNetworkImage(
                        imageUrl: profile.imageUrl,
                        width: 96,
                        height: 96,
                        fallbackLabel: profile.name,
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${profile.name}, ${profile.age} ${profile.countryFlag}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(width: 8),
                              CompatibilityPill(score: score),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Next: ${profile.nextDestination} (${profile.nextTripWindow})',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AviajTheme.oceanTeal,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: profile.intents
                                .map((i) => IntentBadge(
                                      intent: i,
                                      compact: true,
                                      solid: i == _goal,
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AviajTheme.coralPrimary
                                  .withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.wine_bar_rounded,
                                  size: 16,
                                  color: AviajTheme.coralPrimary,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'Suggested First Date: $suggestedDate',
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        state.likeProfile(
                          profile.id,
                          isSuperBoardingPass: true,
                        );
                        state.sendMessage(
                          profile.id,
                          'Would love to try this together on our trip!',
                          isDateProposal: true,
                          proposalTitle: suggestedDate,
                          proposalLocation: profile.nextDestination,
                          proposalWhen: profile.nextTripWindow,
                        );
                        state.selectConversation(profile.id);
                        state.setActiveTab(3);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AviajTheme.coralPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: const Text('Send Date Invite'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  int _scoreProfile(TravellerProfile profile) {
    int score = 82;
    if (profile.primaryIntent == _goal) {
      score += 9;
    } else if (profile.intents.contains(_goal)) {
      score += 6;
    }
    if (profile.travelStyles.contains(_preferredStyle)) {
      score += 5;
    }
    if (profile.budgetTier == _budget) {
      score += 2;
    }
    if (profile.sleepSchedule == _rhythm) {
      score += 2;
    }
    return score.clamp(80, 99);
  }

  String _buildSuggestedDateIdea(TravellerProfile profile) {
    switch (_goal) {
      case ConnectionIntent.longTermPartner:
        return 'Golden hour boat ride & candlelit dinner in ${profile.nextDestination.split(',').first}';
      case ConnectionIntent.shortTermDating:
        return 'Rooftop cocktails & midnight street-food crawl in ${profile.nextDestination.split(',').first}';
      case ConnectionIntent.travelBuddy:
        return 'Split a scenic coastal roadtrip & sunrise viewpoints in ${profile.nextDestination.split(',').first}';
      case ConnectionIntent.soloGroupSquad:
        return 'Group villa welcome dinner & island catamaran day in ${profile.nextDestination.split(',').first}';
    }
  }
}

