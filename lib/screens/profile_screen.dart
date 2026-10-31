import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/aviaj_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class ProfileScreen extends StatefulWidget {
  final AviajState state;

  const ProfileScreen({super.key, required this.state});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _occupationCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _destCtrl;
  late TextEditingController _windowCtrl;
  late TextEditingController _bioCtrl;
  late ConnectionIntent _primaryIntent;
  late Set<ConnectionIntent> _selectedIntents;
  late Set<TravelStyle> _selectedStyles;
  late String _budget;

  @override
  void initState() {
    super.initState();
    _syncFromUser(widget.state.currentUser);
  }

  void _syncFromUser(TravellerProfile user) {
    _nameCtrl = TextEditingController(text: user.name);
    _occupationCtrl = TextEditingController(text: user.occupation);
    _cityCtrl = TextEditingController(text: user.homeCity);
    _destCtrl = TextEditingController(text: user.nextDestination);
    _windowCtrl = TextEditingController(text: user.nextTripWindow);
    _bioCtrl = TextEditingController(text: user.bio);
    _primaryIntent = user.primaryIntent;
    _selectedIntents = Set<ConnectionIntent>.from(user.intents);
    _selectedStyles = Set<TravelStyle>.from(user.travelStyles);
    _budget = user.budgetTier;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _occupationCtrl.dispose();
    _cityCtrl.dispose();
    _destCtrl.dispose();
    _windowCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final user = state.currentUser;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 900;
    final joinedTrips = state.trips
        .where((t) => t.participantProfileIds.contains('me'))
        .toList();

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 32 : 16,
        vertical: 24,
      ),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Solid-Color Single-Love Passport Header Card
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(26),
                    decoration: const BoxDecoration(
                      color: AviajTheme.loveCrimson,
                    ),
                    child: Wrap(
                      spacing: 24,
                      runSpacing: 16,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AviajTheme.bumbleHoney,
                          child: ClipOval(
                            child: AviajNetworkImage(
                              imageUrl: user.imageUrl,
                              width: 96,
                              height: 96,
                              fallbackLabel: user.name,
                            ),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 620),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 11,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: AviajTheme.bumbleHoney,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'VERIFIED AVIAJ SINGLE LOVE & TRAVEL PASSPORT',
                                  style: TextStyle(
                                    color: AviajTheme.obsidian,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 11,
                                    letterSpacing: 0.7,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${user.name}, ${user.age} ${user.countryFlag}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${user.occupation} • ${user.homeCity}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const AppStoreDownloadBadges(
                                lightOnDark: true,
                                compact: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Trips I'm Joining
                if (joinedTrips.isNotEmpty) ...[
                  const Text(
                    'My Reserved Departures & Co-Pilot Trips',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: joinedTrips
                        .map(
                          (trip) => Card(
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.flight_takeoff_rounded,
                                    color: AviajTheme.coralPrimary,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trip.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        '${trip.destination} • ${trip.dateRange}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                ],
                // Edit Profile Form
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Customize Your Travel & Dating Preferences',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _nameCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Full Name',
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: TextField(
                                controller: _cityCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Home City / Base',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _destCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Next Destination Radar',
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: TextField(
                                controller: _windowCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Travel Dates',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _bioCtrl,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Your Travel & Relationship Bio',
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Primary Relationship / Travel Goal',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ConnectionIntent.values.map((intent) {
                            final selected = _primaryIntent == intent;
                            return ChoiceChip(
                              label: Text(intent.label),
                              selected: selected,
                              selectedColor: intent.color,
                              labelStyle: TextStyle(
                                color: selected ? Colors.white : null,
                                fontWeight: FontWeight.w700,
                              ),
                              onSelected: (_) {
                                setState(() {
                                  _primaryIntent = intent;
                                  _selectedIntents.add(intent);
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'All Vibes You’re Open To',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ConnectionIntent.values.map((intent) {
                            final checked = _selectedIntents.contains(intent);
                            return FilterChip(
                              label: Text(intent.label),
                              selected: checked,
                              onSelected: (val) {
                                setState(() {
                                  if (val) {
                                    _selectedIntents.add(intent);
                                  } else if (_selectedIntents.length > 1) {
                                    _selectedIntents.remove(intent);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Travel Styles',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: TravelStyle.values.map((style) {
                            final checked = _selectedStyles.contains(style);
                            return FilterChip(
                              label: Text(style.label),
                              selected: checked,
                              onSelected: (val) {
                                setState(() {
                                  if (val) {
                                    _selectedStyles.add(style);
                                  } else if (_selectedStyles.length > 1) {
                                    _selectedStyles.remove(style);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () {
                              state.updateCurrentUser(
                                name: _nameCtrl.text.trim(),
                                age: user.age,
                                occupation: _occupationCtrl.text.trim(),
                                homeCity: _cityCtrl.text.trim(),
                                bio: _bioCtrl.text.trim(),
                                nextDestination: _destCtrl.text.trim(),
                                nextTripWindow: _windowCtrl.text.trim(),
                                budgetTier: _budget,
                                primaryIntent: _primaryIntent,
                                intents: _selectedIntents.toList(),
                                travelStyles: _selectedStyles.toList(),
                                bucketList: user.bucketList,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Passport & Relationship Preferences Saved!',
                                  ),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AviajTheme.coralPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            icon: const Icon(Icons.save_rounded),
                            label: const Text('Save Passport Profile'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

