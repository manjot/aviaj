import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'ad_service.dart';
import 'stripe_http_client_stub.dart'
    if (dart.library.js_interop) 'stripe_http_client_web.dart'
    if (dart.library.io) 'stripe_http_client_io.dart';

class StripeProductPlan {
  final String id;
  final String name;
  final String subtitle;
  final double amountUsd;
  final String interval; // 'month', 'one_time', 'trip_deposit'
  final List<String> perks;
  final Color badgeColor;

  const StripeProductPlan({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.amountUsd,
    required this.interval,
    required this.perks,
    required this.badgeColor,
  });
}

class StripePaymentReceipt {
  final String receiptId;
  final String stripeAccountId;
  final String planName;
  final double amountUsd;
  final String last4;
  final String paymentMethod;
  final DateTime paidAt;

  const StripePaymentReceipt({
    required this.receiptId,
    required this.stripeAccountId,
    required this.planName,
    required this.amountUsd,
    required this.last4,
    required this.paymentMethod,
    required this.paidAt,
  });
}

/// Centralized Stripe Payment Gateway Service for Aviaj
/// Linked to Stripe Account: acct_1TNTVyJD1U0jWVOT
class AviajStripeService extends ChangeNotifier {
  static final AviajStripeService instance = AviajStripeService._();

  AviajStripeService._();

  static const String defaultStripeAccountId = 'acct_1TNTVyJD1U0jWVOT';
  static const String defaultStripeKeyId = 'mk_1TNTWCJD1U0jWVOTgYhISbYg';
  static const String defaultPublishableKey =
      'pk_live_51TNTVyJD1U0jWVOTXThh0lXTT4rkotsCfEsJqrZLSAVpDolQ0oCJufXs7nP2rt74h2C5xpIpwun8VqW0bu060Atx00YTtwEXTI';
  static const String productionEndpointUrl =
      'https://aviaj.com/stripe_checkout.php';

  String stripeAccountId = defaultStripeAccountId;
  String stripeKeyId = defaultStripeKeyId;
  String? lastCheckoutUrl;
  String publishableKey = const String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: defaultPublishableKey,
  );
  String checkoutMode = 'Production • https://aviaj.com/stripe_checkout.php';
  String activeTier = 'Economy Boarding Pass';
  bool isPremiumSubscriber = false;

  final List<StripePaymentReceipt> receipts = [];

  static const List<StripeProductPlan> plans = [
    StripeProductPlan(
      id: 'price_aviaj_business_monthly',
      name: 'Aviaj Business Class™',
      subtitle: 'Most Popular for Solo & Romantic Travellers',
      amountUsd: 14.99,
      interval: 'month',
      badgeColor: AviajTheme.horizonTeal,
      perks: [
        'Unlimited Co-Pilot Connects & Destination Matches Worldwide',
        'Destination Radar: Match in Any City Before Your Flight Departs',
        '5 Free Priority Boarding Passes Every Week',
        '100% Ad-Free Experience Across All Destinations',
        'Unlimited Rewinds on Accidental Passes',
      ],
    ),
    StripeProductPlan(
      id: 'price_aviaj_first_class_monthly',
      name: 'Aviaj First Class™ VIP',
      subtitle: 'Ultimate Travel Dating & Villa Concierge Access',
      amountUsd: 29.99,
      interval: 'month',
      badgeColor: AviajTheme.sunsetTerracotta,
      perks: [
        'Everything in Aviaj Business Class™ Included',
        'Priority Departure Lounge: Your Invites Appear First',
        'See Everyone Already Heading to Your Next Destination',
        '2x Weekly 60-Minute Horizon Radar Boosts',
        '\$150 Off Any Curated Singles Villa or Group Departure',
      ],
    ),
    StripeProductPlan(
      id: 'price_aviaj_boarding_pack',
      name: '10x Priority Boarding Passes + 2x Radar Boosts',
      subtitle: 'One-Time Instant Travel Boost Pack',
      amountUsd: 9.99,
      interval: 'one_time',
      badgeColor: AviajTheme.compassAmber,
      perks: [
        '+10 Instant Priority Boarding Passes',
        '+60 Minutes Destination Radar Boost in Your Target City',
        'Never Expires',
      ],
    ),
  ];

  void updateStripeConfig({
    required String newAccountId,
    required String newPublishableKey,
  }) {
    stripeAccountId = newAccountId.trim().isEmpty
        ? defaultStripeAccountId
        : newAccountId.trim();
    publishableKey = newPublishableKey.trim();
    notifyListeners();
  }

  Future<StripePaymentReceipt> authorizeProductionPayment({
    required StripeProductPlan plan,
    required String last4,
    required String paymentMethod,
    required String customerName,
    VoidCallback? onAfterSuccess,
  }) async {
    final remoteResponse = await StripeGatewayClient.createProductionPayment(
      endpointUrl: productionEndpointUrl,
      payload: {
        'stripe_account': stripeAccountId,
        'stripe_key_id': stripeKeyId,
        'plan_id': plan.id,
        'plan_name': plan.name,
        'amount_usd': plan.amountUsd,
        'currency': 'usd',
        'payment_method': paymentMethod,
        'customer_name': customerName,
      },
    );

    final remoteReceiptId = remoteResponse?['receipt_id'] as String?;
    final remoteCheckoutUrl = remoteResponse?['checkout_url'] as String?;
    if (remoteCheckoutUrl != null && remoteCheckoutUrl.isNotEmpty) {
      lastCheckoutUrl = remoteCheckoutUrl;
    }

    final receipt = StripePaymentReceipt(
      receiptId: remoteReceiptId ??
          'ch_${stripeAccountId.replaceAll('acct_', '')}_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      stripeAccountId: stripeAccountId,
      planName: plan.name,
      amountUsd: plan.amountUsd,
      last4: last4,
      paymentMethod: paymentMethod,
      paidAt: DateTime.now(),
    );
    receipts.insert(0, receipt);

    if (plan.interval == 'month') {
      isPremiumSubscriber = true;
      activeTier = plan.name;
      // Automatically disable ads and grant bonus Boarding Passes + Radar Boost
      AviajAdService.instance.toggleAdsEnabled(false);
      AviajAdService.instance.superBoardingPassCredits += 10;
      AviajAdService.instance.spotlightBoostMinutes += 60;
    } else if (plan.id == 'price_aviaj_boarding_pack') {
      AviajAdService.instance.superBoardingPassCredits += 10;
      AviajAdService.instance.spotlightBoostMinutes += 60;
    }

    notifyListeners();
    onAfterSuccess?.call();
    return receipt;
  }
}

/// Opens the Aviaj Storefront & Stripe Checkout Modal
/// for Subscriptions (Business Class / First Class), Priority Boarding Packs, or Trip Deposits.
Future<void> showStripeStorefrontModal(
  BuildContext context, {
  StripeProductPlan? customTripPlan,
  VoidCallback? onCustomPlanPaid,
}) async {
  final stripe = AviajStripeService.instance;
  final isCustomTripOnly = customTripPlan != null &&
      !AviajStripeService.plans.any((p) => p.id == customTripPlan.id);
  StripeProductPlan selectedPlan =
      customTripPlan ?? AviajStripeService.plans[0];
  String selectedMethod = 'Card (Visa / Mastercard / Amex)';
  final nameCtrl = TextEditingController();
  bool isProcessing = false;

  await showDialog<void>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return ListenableBuilder(
            listenable: stripe,
            builder: (context, _) {
              final availablePlans = isCustomTripOnly
                  ? [customTripPlan, ...AviajStripeService.plans]
                  : AviajStripeService.plans;

              return Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(26),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header bar with Secure Stripe Checkout badge
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AviajTheme.loveRed,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.lock_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'SECURE STRIPE CHECKOUT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 11,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              icon: const Icon(Icons.close_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isCustomTripOnly
                              ? 'Reserve Your Trip Spot or Upgrade with Stripe'
                              : 'Upgrade Your Aviaj Cabin Class',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: AviajTheme.midnightNavy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Current Tier: ${stripe.activeTier} • 256-Bit SSL Encrypted Checkout',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF555560),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Plan Selector Cards
                        ...availablePlans.map((plan) {
                          final isSelected = selectedPlan.id == plan.id;
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedPlan = plan;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 160),
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AviajTheme.warmSand
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AviajTheme.sunsetTerracotta
                                      : const Color(0xFFE2DAD0),
                                  width: isSelected ? 2.2 : 1.2,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        isSelected
                                            ? Icons.radio_button_checked_rounded
                                            : Icons.radio_button_off_rounded,
                                        color: isSelected
                                            ? AviajTheme.sunsetTerracotta
                                            : Colors.grey,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          plan.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 15,
                                            color: AviajTheme.midnightNavy,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: plan.badgeColor,
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Text(
                                          plan.interval == 'month'
                                              ? '\$${plan.amountUsd.toStringAsFixed(2)}/mo'
                                              : '\$${plan.amountUsd.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ...plan.perks.take(3).map(
                                        (perk) => Padding(
                                          padding: const EdgeInsets.only(
                                            left: 28,
                                            top: 3,
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.check_circle_rounded,
                                                size: 14,
                                                color: AviajTheme.solidEmerald,
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  perk,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF444450),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ),
                          );
                        }),
                        const Divider(height: 24),
                        // Express Checkout Methods (Apple Pay / Google Pay / Link / Card)
                        const Text(
                          'STRIPE PAYMENT METHOD',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                            color: AviajTheme.loveRed,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            'Card (Visa / Mastercard / Amex)',
                            'Apple Pay',
                            'Google Pay',
                            'Stripe Link™ Instant',
                          ].map((method) {
                            final active = selectedMethod == method;
                            return ChoiceChip(
                              label: Text(method),
                              selected: active,
                              selectedColor: AviajTheme.loveRed,
                              labelStyle: TextStyle(
                                color: active
                                    ? Colors.white
                                    : AviajTheme.midnightNavy,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                              onSelected: (_) {
                                setModalState(() {
                                  selectedMethod = method;
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: nameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Full Name or Email (Optional)',
                            prefixIcon: Icon(Icons.person_outline_rounded),
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Pay Button
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: isProcessing
                                ? null
                                : () async {
                                    setModalState(() {
                                      isProcessing = true;
                                    });
                                    final customerLabel =
                                        nameCtrl.text.trim().isEmpty
                                            ? 'Aviaj Member'
                                            : nameCtrl.text.trim();
                                    await stripe.authorizeProductionPayment(
                                      plan: selectedPlan,
                                      last4: 'Live',
                                      paymentMethod: selectedMethod,
                                      customerName: customerLabel,
                                      onAfterSuccess: onCustomPlanPaid,
                                    );
                                    final liveUrl = stripe.lastCheckoutUrl;
                                    if (liveUrl != null &&
                                        liveUrl.startsWith('https://')) {
                                      StripeGatewayClient.openCheckoutUrl(
                                        liveUrl,
                                      );
                                    }
                                    if (ctx.mounted) {
                                      Navigator.of(ctx).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor:
                                              AviajTheme.solidEmerald,
                                          content: Text(
                                            '✓ Redirecting to Secure Stripe Checkout for ${selectedPlan.name}...',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            style: FilledButton.styleFrom(
                              backgroundColor: AviajTheme.loveRed,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            icon: Icon(
                              isProcessing
                                  ? Icons.hourglass_top_rounded
                                  : Icons.lock_rounded,
                              size: 18,
                            ),
                            label: Text(
                              isProcessing
                                  ? 'Connecting to Secure Stripe Checkout...'
                                  : 'Continue to Stripe Checkout (\$${selectedPlan.amountUsd.toStringAsFixed(2)})',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        if (stripe.receipts.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'RECENT STRIPE RECEIPTS',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w900,
                                    color: AviajTheme.loveRed,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ...stripe.receipts.take(2).map(
                                      (r) => Text(
                                        '• ${r.receiptId} — ${r.planName} (\$${r.amountUsd.toStringAsFixed(2)} via ${r.paymentMethod})',
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}
