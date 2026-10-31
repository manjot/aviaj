import 'dart:async';
import 'dart:js_interop';

@JS('__aviajFetchCountry')
external JSPromise<JSString>? _jsFetchCountry();

@JS('__aviajDetectedCountry')
external JSString? get _jsDetectedCountry;

/// Web implementation that invokes `window.__aviajFetchCountry()` in `index.html`
/// to detect the visitor's real or VPN IP country code (`US`, `IN`, `AE`, `GB`, `JP`, etc.).
class IpGeoPlatform {
  static Future<String?> fetchLiveCountryCode() async {
    try {
      final promise = _jsFetchCountry();
      if (promise != null) {
        final jsStr = await promise.toDart.timeout(
          const Duration(seconds: 4),
          onTimeout: () => (_jsDetectedCountry ?? ''.toJS),
        );
        final code = jsStr.toDart.trim().toUpperCase();
        if (code.length == 2) return code;
      }
      final cached = _jsDetectedCountry?.toDart.trim().toUpperCase() ?? '';
      if (cached.length == 2) return cached;
    } catch (_) {}
    return null;
  }
}

