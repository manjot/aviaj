import 'seo_service.dart';

bool _stubPrivacyAccepted = false;

AviajSeoPage detectInitialPage() => AviajSeoPage.home;

String? detectInitialLangCode() => null;

void applyPageSeo(
  AviajSeoPage page, {
  bool pushHistory = true,
  String langCode = 'en',
  String? localizedTitle,
}) {}

void listenPopState(void Function(AviajSeoPage page) onRouteChanged) {}

bool hasPrivacyConsent() => _stubPrivacyAccepted;

void setPrivacyConsent(bool accepted) {
  _stubPrivacyAccepted = accepted;
}

