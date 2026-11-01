import 'seo_service.dart';

bool _stubPrivacyAccepted = false;

AviajSeoPage detectInitialPage() => AviajSeoPage.home;

void applyPageSeo(AviajSeoPage page, {bool pushHistory = true}) {}

void listenPopState(void Function(AviajSeoPage page) onRouteChanged) {}

bool hasPrivacyConsent() => _stubPrivacyAccepted;

void setPrivacyConsent(bool accepted) {
  _stubPrivacyAccepted = accepted;
}

