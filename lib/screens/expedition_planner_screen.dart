import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../state/aviaj_state.dart';
import '../theme/app_theme.dart';

class ExpeditionPlannerScreen extends StatefulWidget {
  final AviajState state;

  const ExpeditionPlannerScreen({super.key, required this.state});

  @override
  State<ExpeditionPlannerScreen> createState() =>
      _ExpeditionPlannerScreenState();
}

class _ExpeditionPlannerScreenState extends State<ExpeditionPlannerScreen> {
  double _startElevationM = 1950;
  double _targetElevationM = 4090;
  int _ascentDays = 4;
  int _crewSize = 4;
  String _selectedCorridor = 'Chopta – Tungnath – Chandrashila (4,090m)';

  static const List<({
    String name,
    double startM,
    double peakM,
    int days,
    String rescueContact,
  })> _corridors = [
    (
      name: 'Chopta – Tungnath – Chandrashila (4,090m)',
      startM: 1950,
      peakM: 4090,
      days: 4,
      rescueContact: 'Uttarakhand SDRF Mountain Rescue: 112 / +91-135-2710334',
    ),
    (
      name: 'Kedarkantha Winter Summit Trail (3,810m)',
      startM: 1980,
      peakM: 3810,
      days: 4,
      rescueContact: 'Uttarkashi Alpine Control Room: +91-1374-222722',
    ),
    (
      name: 'Manali – Hampta Pass – Spiti Crossing (4,270m)',
      startM: 2050,
      peakM: 4270,
      days: 5,
      rescueContact: 'Kullu & Lahaul Emergency Rescue: 1077 / +91-1902-225630',
    ),
    (
      name: 'Leh – Nubra – Pangong High Altitude Circuit (5,359m)',
      startM: 3500,
      peakM: 5359,
      days: 6,
      rescueContact: 'Ladakh Tourist Police & Leh Hospital AMS Unit: 112',
    ),
    (
      name: 'Kudremukh & Sahyadri Ridge Traverse (1,892m)',
      startM: 650,
      peakM: 1892,
      days: 2,
      rescueContact: 'Karnataka Forest & Western Ghats Ranger Desk: 1926',
    ),
  ];

  static const List<({
    String id,
    String title,
    String subtitle,
    String category,
  })> _checklistCatalog = [
    (
      id: 'permit_forest',
      title: 'Forest Entry, Sanctuary & Alpine Peak Permits',
      subtitle: 'Printed + offline PDF copies stored for all crew members',
      category: 'Permits & ID',
    ),
    (
      id: 'satellite_sos',
      title: 'Emergency SOS Contacts & Basecamp Check-In Window',
      subtitle: 'SDRF / local ranger contacts synced & 18:00 daily check-in set',
      category: 'Safety',
    ),
    (
      id: 'oximeter_kit',
      title: 'Pulse Oximeter, First-Aid & Altitude Acclimatization Kit',
      subtitle: 'SpO2 monitor, ORS electrolytes, bandages & blister care packed',
      category: 'Medical',
    ),
    (
      id: 'offline_gpx',
      title: 'Offline Topographic Maps & GPX Waypoints Cached',
      subtitle: 'Trailhead, water sources, and emergency descent shelters marked',
      category: 'Navigation',
    ),
    (
      id: 'thermal_layers',
      title: '3-Layer Thermal System & Waterproof Shell (-10°C Rated)',
      subtitle: 'Base merino layer, fleece mid-layer, down jacket & rain poncho',
      category: 'Gear',
    ),
    (
      id: 'trek_poles_crampons',
      title: 'Ankle-Support Trekking Boots, Microspikes & Gaiters',
      subtitle: 'Broken-in high-ankle boots + traction cleats for snow/scree',
      category: 'Gear',
    ),
    (
      id: 'hydration_filter',
      title: '2L Insulated Hydration Bladder + Water Purification Tablets',
      subtitle: 'Prevents freezing above 3,200m and ensures safe stream refills',
      category: 'Hydration',
    ),
    (
      id: 'powerbank_headlamp',
      title: '20,000mAh Cold-Protected Power Bank & 300-Lumen Headlamp',
      subtitle: 'Essential for 03:30 AM summit push and multi-day off-grid camps',
      category: 'Electronics',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 920;

    final netGainM = math.max(0.0, _targetElevationM - _startElevationM);
    final dailyAscentM = netGainM / math.max(1, _ascentDays);
    final hydrationLiters =
        (2.8 + (_targetElevationM / 2200.0)).clamp(3.0, 5.5);
    final expectedSpo2 = _targetElevationM >= 4500
        ? '82% – 87%'
        : (_targetElevationM >= 3500 ? '87% – 92%' : '93% – 97%');

    final String riskLabel;
    final Color riskColor;
    final String riskAdvice;
    if (dailyAscentM <= 450 && _targetElevationM <= 4200) {
      riskLabel = 'LOW AMS RISK • GRADUAL ACCLIMATIZATION';
      riskColor = const Color(0xFF15803D);
      riskAdvice =
          'Your daily net ascent (${dailyAscentM.round()}m/day) is within the wilderness medicine safe threshold (<500m/day above 3,000m). Maintain ${hydrationLiters.toStringAsFixed(1)}L/day hydration.';
    } else if (dailyAscentM <= 650) {
      riskLabel = 'MODERATE AMS RISK • ADD REST / ROTATION DAY';
      riskColor = const Color(0xFFD97706);
      riskAdvice =
          'Your daily ascent (${dailyAscentM.round()}m/day) approaches the 500m/day threshold. Schedule an acclimatization hike ("climb high, sleep low") on Day ${(_ascentDays / 2).ceil()}.';
    } else {
      riskLabel = 'HIGH AMS RISK • EXCEEDS SAFE ASCENT RATE';
      riskColor = AviajTheme.loveRed;
      riskAdvice =
          'Ascending ${dailyAscentM.round()}m/day to ${_targetElevationM.round()}m carries elevated Acute Mountain Sickness risk. Increase trek duration to at least ${(netGainM / 450).ceil()} days.';
    }

    final completedCount = _checklistCatalog
        .where((item) => state.completedChecklistIds.contains(item.id))
        .length;
    final readinessPct =
        ((completedCount / _checklistCatalog.length) * 100).round();

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: isWide ? 32 : 16,
        vertical: 20,
      ),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Hero Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AviajTheme.midnightNavy,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AviajTheme.loveRed,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.terrain_rounded,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'EXPEDITION TELEMETRY & GROUP LOGISTICS STUDIO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 11,
                                    letterSpacing: 0.7,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Readiness: $readinessPct% ($completedCount/${_checklistCatalog.length} Checked)',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 11.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Altitude Acclimatization, Shared Crew Budget & Trail Readiness',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Plan safe high-altitude ascent profiles, split shared permits and homestay costs across your travel crew, and verify offline gear readiness before departure.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13.5,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // SECTION 1: Altitude Acclimatization & Trail Elevation Telemetry
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AviajTheme.horizonTeal
                                    .withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.show_chart_rounded,
                                color: AviajTheme.horizonTeal,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '1. Altitude Acclimatization & Ascent Profile Calculator',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    'Select a preset trekking corridor or customize your trailhead and summit elevations',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _corridors.map((c) {
                              final selected = _selectedCorridor == c.name;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(c.name),
                                  selected: selected,
                                  selectedColor: AviajTheme.horizonTeal,
                                  labelStyle: TextStyle(
                                    color: selected ? Colors.white : null,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                  onSelected: (_) {
                                    setState(() {
                                      _selectedCorridor = c.name;
                                      _startElevationM = c.startM;
                                      _targetElevationM = c.peakM;
                                      _ascentDays = c.days;
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Elevation Profile Chart
                        Container(
                          height: 165,
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: CustomPaint(
                            painter: _ElevationProfileChartPainter(
                              startElevationM: _startElevationM,
                              targetElevationM: _targetElevationM,
                              days: _ascentDays,
                              lineColor: riskColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Sliders
                        Wrap(
                          spacing: 24,
                          runSpacing: 12,
                          children: [
                            SizedBox(
                              width: isWide ? 310 : double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Trailhead Start Elevation: ${_startElevationM.round()} m',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Slider(
                                    value: _startElevationM,
                                    min: 500,
                                    max: 3800,
                                    divisions: 33,
                                    activeColor: AviajTheme.horizonTeal,
                                    onChanged: (val) {
                                      setState(() {
                                        _startElevationM = val;
                                        if (_targetElevationM <
                                            _startElevationM + 300) {
                                          _targetElevationM =
                                              (_startElevationM + 300)
                                                  .clamp(1000, 5800);
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: isWide ? 310 : double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Summit / High Camp Target: ${_targetElevationM.round()} m',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Slider(
                                    value: _targetElevationM,
                                    min: 1000,
                                    max: 5800,
                                    divisions: 48,
                                    activeColor: AviajTheme.loveRed,
                                    onChanged: (val) {
                                      setState(() {
                                        _targetElevationM = math.max(
                                          val,
                                          _startElevationM + 200,
                                        );
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: isWide ? 280 : double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ascent Duration: $_ascentDays Days',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Slider(
                                    value: _ascentDays.toDouble(),
                                    min: 2,
                                    max: 10,
                                    divisions: 8,
                                    activeColor: AviajTheme.compassAmber,
                                    onChanged: (val) {
                                      setState(() {
                                        _ascentDays = val.round();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Telemetry KPI Cards
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _TelemetryStatTile(
                              label: 'Net Elevation Gain',
                              value: '+${netGainM.round()} m',
                              icon: Icons.trending_up_rounded,
                              color: AviajTheme.horizonTeal,
                            ),
                            _TelemetryStatTile(
                              label: 'Daily Ascent Rate',
                              value: '${dailyAscentM.round()} m/day',
                              icon: Icons.speed_rounded,
                              color: riskColor,
                            ),
                            _TelemetryStatTile(
                              label: 'Hydration Target',
                              value:
                                  '${hydrationLiters.toStringAsFixed(1)} L / day',
                              icon: Icons.water_drop_rounded,
                              color: const Color(0xFF0284C7),
                            ),
                            _TelemetryStatTile(
                              label: 'Expected Resting SpO2',
                              value: expectedSpo2,
                              icon: Icons.monitor_heart_rounded,
                              color: AviajTheme.loveRed,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: riskColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: riskColor.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                riskLabel,
                                style: TextStyle(
                                  color: riskColor,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 12.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                riskAdvice,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  height: 1.38,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // SECTION 2: Interactive Group Expedition Expense Splitter
                _buildExpenseSplitterCard(context, state, isWide),
                const SizedBox(height: 20),

                // SECTION 3: High-Altitude & Group Expedition Readiness Checklist
                _buildReadinessChecklistCard(
                  context,
                  state,
                  completedCount,
                  readinessPct,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseSplitterCard(
    BuildContext context,
    AviajState state,
    bool isWide,
  ) {
    final expenses = state.tripExpenses;
    final totalPool = expenses.fold<double>(
      0.0,
      (sum, item) => sum + item.amountUsd,
    );
    final perPersonShare = totalPool / math.max(1, _crewSize);

    // Calculate net balance per payer
    final paidByTotals = <String, double>{
      'You': 0.0,
      'Kavya Nair': 0.0,
      'Rohan Verma': 0.0,
      'Meera Joshi': 0.0,
    };
    for (final exp in expenses) {
      paidByTotals[exp.paidByName] =
          (paidByTotals[exp.paidByName] ?? 0.0) + exp.amountUsd;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AviajTheme.loveRed.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: AviajTheme.loveRed,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '2. Group Expedition Expense Splitter & Crew Ledger',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'Track shared permits, homestays, 4x4 transfers & gear across your crew',
                          style: TextStyle(fontSize: 12.5, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                FilledButton.icon(
                  onPressed: () => _showAddExpenseDialog(context, state),
                  style: FilledButton.styleFrom(
                    backgroundColor: AviajTheme.loveRed,
                  ),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Shared Expense'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Summary Row
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AviajTheme.midnightNavy,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Wrap(
                spacing: 28,
                runSpacing: 14,
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TOTAL EXPEDITION POOL',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '\$${totalPool.toStringAsFixed(0)} USD',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PER-TRAVELLER SHARE',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '\$${perPersonShare.toStringAsFixed(0)} / person',
                        style: const TextStyle(
                          color: AviajTheme.compassAmber,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Crew Size: ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: _crewSize > 2
                            ? () => setState(() => _crewSize--)
                            : null,
                        icon: const Icon(
                          Icons.remove_circle_outline_rounded,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '$_crewSize',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      IconButton(
                        onPressed: _crewSize < 12
                            ? () => setState(() => _crewSize++)
                            : null,
                        icon: const Icon(
                          Icons.add_circle_outline_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ...expenses.map(
              (exp) => ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                leading: CircleAvatar(
                  backgroundColor:
                      AviajTheme.horizonTeal.withValues(alpha: 0.14),
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: AviajTheme.horizonTeal,
                    size: 20,
                  ),
                ),
                title: Text(
                  exp.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  '${exp.category} • Paid by ${exp.paidByName}',
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '\$${exp.amountUsd.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remove expense',
                      onPressed: () => state.removeTripExpense(exp.id),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 19,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 20),
            const Text(
              'Crew Balance Summary (Paid vs. Fair Share):',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: paidByTotals.entries.take(_crewSize).map((e) {
                final diff = e.value - perPersonShare;
                final isPositive = diff >= 0;
                return Chip(
                  backgroundColor: isPositive
                      ? const Color(0xFFDCFCE7)
                      : const Color(0xFFFEE2E2),
                  label: Text(
                    '${e.key}: ${isPositive ? "gets back \$${diff.toStringAsFixed(0)}" : "owes \$${diff.abs().toStringAsFixed(0)}"}',
                    style: TextStyle(
                      color: isPositive
                          ? const Color(0xFF166534)
                          : const Color(0xFF991B1B),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadinessChecklistCard(
    BuildContext context,
    AviajState state,
    int completedCount,
    int readinessPct,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AviajTheme.compassAmber.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.fact_check_rounded,
                    color: AviajTheme.compassAmber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '3. Expedition Packing, Permit & Safety Readiness Checklist',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '$completedCount of ${_checklistCatalog.length} mandatory pre-departure items verified ($readinessPct%)',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: completedCount / _checklistCatalog.length,
                minHeight: 9,
                backgroundColor: const Color(0xFFE2E8F0),
                color: const Color(0xFF16A34A),
              ),
            ),
            const SizedBox(height: 12),
            ..._checklistCatalog.map((item) {
              final checked = state.completedChecklistIds.contains(item.id);
              return CheckboxListTile(
                value: checked,
                activeColor: AviajTheme.horizonTeal,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (_) => state.toggleChecklistItem(item.id),
                title: Text(
                  item.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    decoration: checked ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  '${item.category} • ${item.subtitle}',
                  style: const TextStyle(fontSize: 12),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context, AviajState state) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController(text: '95');
    String selectedCategory = 'Permits & Fees';
    String selectedPayer = 'You';

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('Add Shared Expedition Expense'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Expense Description',
                        hintText: 'e.g. Chopta Basecamp Tents & Sleeping Bags',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: amountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Amount (USD)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Permits & Fees',
                          child: Text('Permits & Fees'),
                        ),
                        DropdownMenuItem(
                          value: 'Accommodation',
                          child: Text('Accommodation'),
                        ),
                        DropdownMenuItem(
                          value: 'Transport',
                          child: Text('Transport'),
                        ),
                        DropdownMenuItem(
                          value: 'Safety & Gear',
                          child: Text('Safety & Gear'),
                        ),
                        DropdownMenuItem(
                          value: 'Crew Meals',
                          child: Text('Crew Meals'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() => selectedCategory = v);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedPayer,
                      decoration: const InputDecoration(labelText: 'Paid By'),
                      items: const [
                        DropdownMenuItem(value: 'You', child: Text('You')),
                        DropdownMenuItem(
                          value: 'Kavya Nair',
                          child: Text('Kavya Nair'),
                        ),
                        DropdownMenuItem(
                          value: 'Rohan Verma',
                          child: Text('Rohan Verma'),
                        ),
                        DropdownMenuItem(
                          value: 'Meera Joshi',
                          child: Text('Meera Joshi'),
                        ),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          setDialogState(() => selectedPayer = v);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final title = titleCtrl.text.trim().isEmpty
                        ? 'Shared Crew Expense'
                        : titleCtrl.text.trim();
                    final amount =
                        double.tryParse(amountCtrl.text.trim()) ?? 80.0;
                    state.addTripExpense(
                      title: title,
                      category: selectedCategory,
                      amountUsd: amount,
                      paidByName: selectedPayer,
                    );
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Add to Crew Ledger'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _TelemetryStatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _TelemetryStatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 215,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: color,
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

class _ElevationProfileChartPainter extends CustomPainter {
  final double startElevationM;
  final double targetElevationM;
  final int days;
  final Color lineColor;

  const _ElevationProfileChartPainter({
    required this.startElevationM,
    required this.targetElevationM,
    required this.days,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    for (int i = 1; i <= 3; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final points = <Offset>[];
    for (int d = 0; d <= days; d++) {
      final t = d / math.max(1, days);
      final x = 24 + t * (size.width - 48);
      // Slight acclimatization dip on middle day for realistic alpine profile
      final curveT = math.pow(t, 0.88).toDouble();
      final y = (size.height - 26) - (curveT * (size.height - 52));
      points.add(Offset(x, y));
    }

    final fillPath = Path()..moveTo(points.first.dx, size.height - 18);
    for (final pt in points) {
      fillPath.lineTo(pt.dx, pt.dy);
    }
    fillPath.lineTo(points.last.dx, size.height - 18);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withValues(alpha: 0.42),
          lineColor.withValues(alpha: 0.02),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(fillPath, fillPaint);

    final strokePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      strokePath.lineTo(points[i].dx, points[i].dy);
    }

    final strokePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(strokePath, strokePaint);

    final dotPaint = Paint()..color = Colors.white;
    for (int i = 0; i < points.length; i++) {
      final pt = points[i];
      canvas.drawCircle(pt, 4.5, dotPaint);
      final elev =
          (startElevationM + (targetElevationM - startElevationM) * (i / days))
              .round();
      final tp = TextPainter(
        text: TextSpan(
          text: 'D${i + 1}\n${elev}m',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(
          (pt.dx - tp.width / 2).clamp(0.0, size.width - tp.width),
          math.max(0.0, pt.dy - 26),
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ElevationProfileChartPainter oldDelegate) {
    return oldDelegate.startElevationM != startElevationM ||
        oldDelegate.targetElevationM != targetElevationM ||
        oldDelegate.days != days ||
        oldDelegate.lineColor != lineColor;
  }
}

