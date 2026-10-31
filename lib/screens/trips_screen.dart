import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/ad_service.dart';
import '../state/aviaj_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class TripsScreen extends StatelessWidget {
  final AviajState state;

  const TripsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 900;
    final trips = state.filteredTrips;

    return Column(
      children: [
        GlobalIntentFilterBar(
          state: state,
          searchHint:
              'Search trips by destination (Amalfi, Kyoto, Patagonia, Bali, Madeira)...',
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 32 : 16,
              vertical: 20,
            ),
            children: [
              const AviajAdBannerWidget(placementLabel: 'Trips Board'),
              const SizedBox(height: 18),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Solo & Group Departures + Romantic Villas',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Join a small crew of solo travellers, a singles dating villa, or propose a 1-on-1 co-pilot itinerary.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13.5,
                        ),
                      ),
                    ],
                  ),
                  FilledButton.icon(
                    onPressed: () => _showCreateTripDialog(context, state),
                    style: FilledButton.styleFrom(
                      backgroundColor: AviajTheme.coralPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                    ),
                    icon: const Icon(Icons.add_location_alt_rounded),
                    label: const Text('Host a Trip / Find Co-Pilot'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (trips.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.luggage_rounded,
                          size: 44,
                          color: AviajTheme.coralPrimary,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No departures match this filter yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: state.clearFilters,
                          child: const Text('Show All Trips'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...trips.map(
                  (trip) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _TripCard(
                      trip: trip,
                      state: state,
                      isWide: isWide,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showCreateTripDialog(
    BuildContext context,
    AviajState state,
  ) async {
    final titleCtrl = TextEditingController();
    final destCtrl = TextEditingController();
    final countryCtrl = TextEditingController(text: 'Greece 🇬🇷');
    final datesCtrl = TextEditingController(text: 'Dec 10 – Dec 18, 2026');
    final costCtrl = TextEditingController(text: '1450');
    final summaryCtrl = TextEditingController();
    ConnectionIntent selectedIntent = ConnectionIntent.longTermPartner;
    String selectedFormat = '1-on-1 Romantic Co-Pilot (Max 2)';
    int maxSpots = 2;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.flight_takeoff_rounded,
                            color: AviajTheme.coralPrimary,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Post a Solo/Group Trip or Co-Pilot Invite',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: titleCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Trip Title',
                          hintText:
                              'e.g., Santorini Sunset Sailing & Winery Week',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: destCtrl,
                              decoration: const InputDecoration(
                                labelText: 'City / Region',
                                hintText: 'e.g., Oia & Naxos',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: countryCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Country & Flag',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: datesCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Dates',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: costCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Est. Shared Cost (USD)',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Trip Relationship / Group Vibe',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ConnectionIntent.values.map((intent) {
                          final isSelected = selectedIntent == intent;
                          return ChoiceChip(
                            label: Text(intent.label),
                            selected: isSelected,
                            onSelected: (_) {
                              setModalState(() {
                                selectedIntent = intent;
                                if (intent ==
                                    ConnectionIntent.soloGroupSquad) {
                                  selectedFormat =
                                      'Solo Group Adventure Squad (Max 6)';
                                  maxSpots = 6;
                                } else if (intent ==
                                    ConnectionIntent.travelBuddy) {
                                  selectedFormat =
                                      'Platonic Travel Buddy Pod (Max 4)';
                                  maxSpots = 4;
                                } else {
                                  selectedFormat =
                                      '1-on-1 Romantic Co-Pilot (Max 2)';
                                  maxSpots = 2;
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: summaryCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'What makes this trip special?',
                          hintText:
                              'Describe your ideal travel partner or group vibe, activities, and accommodation style...',
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            final title = titleCtrl.text.trim().isEmpty
                                ? 'Cyclades Sunset Island Hop'
                                : titleCtrl.text.trim();
                            final dest = destCtrl.text.trim().isEmpty
                                ? 'Santorini & Paros'
                                : destCtrl.text.trim();
                            state.createNewTrip(
                              title: title,
                              destination: dest,
                              country: countryCtrl.text.trim(),
                              dateRange: datesCtrl.text.trim(),
                              durationDays: 7,
                              vibeIntent: selectedIntent,
                              groupFormat: selectedFormat,
                              estimatedCostUsd:
                                  int.tryParse(costCtrl.text.trim()) ?? 1450,
                              maxParticipants: maxSpots,
                              summary: summaryCtrl.text.trim().isEmpty
                                  ? 'Looking for an adventurous co-pilot or small crew to explore $dest together!'
                                  : summaryCtrl.text.trim(),
                              highlights: [
                                'Handpicked boutique stays in $dest',
                                'Sunset coastal dining & hidden local coves',
                                'Zero single-supplement split costs',
                              ],
                              styles: [
                                TravelStyle.islandHopper,
                                TravelStyle.foodieCulture,
                              ],
                            );
                            Navigator.of(ctx).pop();
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AviajTheme.coralPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          icon: const Icon(Icons.publish_rounded),
                          label: const Text('Publish Trip to Aviaj Board'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _TripCard extends StatelessWidget {
  final GroupTrip trip;
  final AviajState state;
  final bool isWide;

  const _TripCard({
    required this.trip,
    required this.state,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    final host = state.getProfileById(trip.hostProfileId) ?? state.currentUser;
    final joined = state.isUserJoinedTrip(trip.id);

    final imageSection = Stack(
      children: [
        AviajNetworkImage(
          imageUrl: trip.imageUrl,
          height: isWide ? 310 : 220,
          width: isWide ? 360 : double.infinity,
          fallbackLabel: trip.destination,
        ),
        Positioned(
          top: 12,
          left: 12,
          child: IntentBadge(intent: trip.vibeIntent, solid: true),
        ),
        Positioned(
          bottom: 12,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '\$${trip.estimatedCostUsd} est. split • ${trip.durationDays} days',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12.5,
              ),
            ),
          ),
        ),
      ],
    );

    final detailsSection = Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '${trip.destination} • ${trip.country}',
                style: const TextStyle(
                  color: AviajTheme.coralPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AviajTheme.oceanTeal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trip.groupFormat,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AviajTheme.oceanTeal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            trip.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                trip.dateRange,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.event_seat_rounded,
                size: 16,
                color: AviajTheme.coralPrimary,
              ),
              const SizedBox(width: 5),
              Text(
                '${trip.spotsRemaining} of ${trip.maxParticipants} spots open',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: AviajTheme.coralPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            trip.summary,
            style: const TextStyle(fontSize: 14, height: 1.45),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: trip.highlights
                .take(3)
                .map(
                  (h) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 15,
                        color: Color(0xFF10B981),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        h,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  children: [
                    const Text(
                      'Crew on board:',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    ...trip.participantProfileIds.map((pid) {
                      final p = state.getProfileById(pid);
                      if (p == null) return const SizedBox.shrink();
                      return Tooltip(
                        message: '${p.name} (${p.primaryIntent.label})',
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: p.primaryIntent.color,
                          child: ClipOval(
                            child: AviajNetworkImage(
                              imageUrl: p.imageUrl,
                              width: 27,
                              height: 27,
                              fallbackLabel: p.name.substring(0, 1),
                            ),
                          ),
                        ),
                      );
                    }),
                    Text(
                      'Hosted by ${host.name.split(' ').first}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => _showItineraryModal(context, trip, host),
                icon: const Icon(Icons.map_rounded, size: 17),
                label: const Text('Itinerary'),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                onPressed: () => state.toggleJoinTrip(trip.id),
                style: FilledButton.styleFrom(
                  backgroundColor:
                      joined ? AviajTheme.oceanTeal : AviajTheme.coralPrimary,
                ),
                icon: Icon(
                  joined
                      ? Icons.check_circle_rounded
                      : Icons.flight_takeoff_rounded,
                  size: 17,
                ),
                label: Text(joined ? 'Spot Reserved' : 'Join Trip'),
              ),
            ],
          ),
        ],
      ),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageSection,
                Expanded(child: detailsSection),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                imageSection,
                detailsSection,
              ],
            ),
    );
  }

  Future<void> _showItineraryModal(
    BuildContext context,
    GroupTrip trip,
    TravellerProfile host,
  ) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IntentBadge(intent: trip.vibeIntent),
                  const SizedBox(height: 10),
                  Text(
                    trip.title,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${trip.destination}, ${trip.country} • ${trip.dateRange}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const Divider(height: 24),
                  const Text(
                    'DAY-BY-DAY HIGHLIGHTS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: AviajTheme.oceanTeal,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...trip.itinerary.map(
                    (plan) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AviajTheme.coralPrimary
                                  .withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Day ${plan.day}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AviajTheme.coralPrimary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plan.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14.5,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  plan.description,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Close'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: () {
                          state.toggleJoinTrip(trip.id);
                          Navigator.of(ctx).pop();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AviajTheme.coralPrimary,
                        ),
                        icon: const Icon(Icons.flight_takeoff_rounded),
                        label: Text(
                          state.isUserJoinedTrip(trip.id)
                              ? 'Leave Trip'
                              : 'Reserve My Spot',
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
}

