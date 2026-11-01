import 'dart:js_interop';
import 'seo_service.dart';

@JS('__aviajGetCurrentPath')
external JSString? _jsGetCurrentPath();

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

AviajSeoPage detectInitialPage() {
  try {
    final raw = _jsGetCurrentPath()?.toDart ?? '/';
    return AviajSeoPage.fromPath(raw);
  } catch (_) {
    return AviajSeoPage.home;
  }
}

void applyPageSeo(AviajSeoPage page, {bool pushHistory = true}) {
  try {
    _jsApplySeo(
      page.path.toJS,
      page.title.toJS,
      page.description.toJS,
      page.keywords.toJS,
      page.canonicalUrl.toJS,
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

