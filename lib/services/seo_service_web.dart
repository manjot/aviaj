import 'dart:js_interop';
import 'seo_service.dart';

@JS('__aviajGetCurrentPath')
external JSString? _jsGetCurrentPath();

@JS('__aviajGetInitialLang')
external JSString? _jsGetInitialLang();

@JS('__aviajSetLang')
external void _jsSetLang(JSString langCode);

@JS('__aviajApplySeo')
external void _jsApplySeo(
  JSString path,
  JSString title,
  JSString description,
  JSString keywords,
  JSString canonicalUrl,
  JSString jsonLd,
  JSBoolean pushHistory,
);

@JS('__aviajRegisterPopState')
external void _jsRegisterPopState(JSFunction callback);

@JS('__aviajHasPrivacyConsent')
external JSBoolean? _jsHasPrivacyConsent();

@JS('__aviajSetPrivacyConsent')
external void _jsSetPrivacyConsent(JSBoolean accepted);

AviajSeoPage detectInitialPage() {
  try {
    final raw = _jsGetCurrentPath()?.toDart ?? '/';
    return AviajSeoPage.fromPath(raw);
  } catch (_) {
    return AviajSeoPage.home;
  }
}

String? detectInitialLangCode() {
  try {
    final rawPath = _jsGetCurrentPath()?.toDart ?? '/';
    final fromPath = AviajSeoPage.extractLangPrefixFromPath(rawPath);
    if (fromPath != null && fromPath.isNotEmpty) return fromPath;
    final fromJs = _jsGetInitialLang()?.toDart;
    if (fromJs != null && fromJs.trim().isNotEmpty) return fromJs.trim();
  } catch (_) {}
  return null;
}

void applyPageSeo(
  AviajSeoPage page, {
  bool pushHistory = true,
  String langCode = 'en',
  String? localizedTitle,
}) {
  try {
    final normLang = langCode.trim().toLowerCase();
    _jsSetLang(normLang.toJS);
    final effectivePath = (normLang.isEmpty || normLang == 'en')
        ? page.path
        : (page.path == '/' ? '/$normLang' : '/$normLang${page.path}');
    final effectiveCanonical = effectivePath == '/'
        ? 'https://aviaj.com/'
        : 'https://aviaj.com$effectivePath';
    final effectiveTitle = localizedTitle ?? page.title;
    _jsApplySeo(
      effectivePath.toJS,
      effectiveTitle.toJS,
      page.description.toJS,
      page.keywords.toJS,
      effectiveCanonical.toJS,
      page.jsonLdString.toJS,
      pushHistory.toJS,
    );
  } catch (_) {}
}

void listenPopState(void Function(AviajSeoPage page) onRouteChanged) {
  try {
    void handlePath(JSString rawPath) {
      onRouteChanged(AviajSeoPage.fromPath(rawPath.toDart));
    }

    _jsRegisterPopState(handlePath.toJS);
  } catch (_) {}
}

bool hasPrivacyConsent() {
  try {
    return _jsHasPrivacyConsent()?.toDart ?? false;
  } catch (_) {
    return false;
  }
}

void setPrivacyConsent(bool accepted) {
  try {
    _jsSetPrivacyConsent(accepted.toJS);
  } catch (_) {}
}

