import 'dart:convert';
import 'dart:js_interop';

@JS('__aviajCreateStripeSession')
external JSPromise<JSString>? _jsCreateStripeSession(JSString payloadJson);

class StripeGatewayClient {
  static Future<Map<String, dynamic>?> createProductionPayment({
    required String endpointUrl,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final promise = _jsCreateStripeSession(jsonEncode(payload).toJS);
      if (promise != null) {
        final rawJs = await promise.toDart.timeout(const Duration(seconds: 8));
        final raw = rawJs.toDart.trim();
        if (raw.isNotEmpty) {
          final decoded = jsonDecode(raw);
          if (decoded is Map<String, dynamic>) {
            return decoded;
          }
        }
      }
    } catch (_) {
      // Fallback to local receipt generation when offline
    }
    return null;
  }
}

