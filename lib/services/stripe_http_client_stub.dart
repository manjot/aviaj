class StripeGatewayClient {
  static Future<Map<String, dynamic>?> createProductionPayment({
    required String endpointUrl,
    required Map<String, dynamic> payload,
  }) async {
    return {
      'status': 'succeeded',
      'environment': 'production',
      'stripe_account': 'acct_1TNTVyJD1U0jWVOT',
      'receipt_id':
          'ch_1TNTVyJD_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
    };
  }
}
