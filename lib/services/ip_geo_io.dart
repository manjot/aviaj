import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Native iOS & Android implementation that queries `https://api.country.is/`
/// and `https://ipwho.is/` to detect the device's real or VPN IP country code.
class IpGeoPlatform {
  static Future<String?> fetchLiveCountryCode() async {
    final endpoints = [
      'https://api.country.is/',
      'https://ipwho.is/',
    ];
    for (final url in endpoints) {
      final client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 3);
      try {
        final req = await client.getUrl(Uri.parse(url));
        req.headers.set(HttpHeaders.cacheControlHeader, 'no-cache');
        final res = await req.close().timeout(const Duration(seconds: 3));
        if (res.statusCode == 200) {
          final body = await res.transform(utf8.decoder).join();
          final map = jsonDecode(body) as Map<String, dynamic>;
          final raw =
              (map['country'] ?? map['country_code'] ?? '').toString().trim();
          if (raw.length == 2) {
            return raw.toUpperCase();
          }
        }
      } catch (_) {
        // Try next endpoint
      } finally {
        client.close(force: true);
      }
    }
    return null;
  }
}

