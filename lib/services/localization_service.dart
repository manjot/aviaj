import '../data/regional_data.dart';
import 'seo_service.dart';

/// Complete 28-language localization pack for `https://aviaj.com/`.
/// Keeps the main brand name (`Aviaj`, `AVIAJ`) and core SEO segments
/// (`Date`, `AFF`, `Compliments`, `Incognito Mode`, `Video Calls`, `Travel Mode`,
/// `Snooze Mode`, `SuperSwipe`, `Premium+`, `Destination Radar™`, `Deception Detector™`)
/// intact in English to preserve search-engine ranking, while translating all
/// website UI, navigation, hero copy, feature pages, mockups, and footer content.
class AviajLangPack {
  final String code; // e.g. 'en', 'hi', 'de', 'fr', 'es', ...
  final String label; // e.g. 'हिंदी', 'English (United Kingdom)', ...
  final AviajRegion defaultRegion;

  // Top Header Navigation (Note: 'Date' and 'AFF' stay 'Date' and 'AFF' for SEO!)
  final String navStories;
  final String navSafety;
  final String navSupport;
  final String navSignIn;

  // Mega-Menu Headers & Descriptions (Segment names stay intact for SEO)
  final String exploreDateTitle;
  final String exploreDateDesc;
  final String complimentsDesc;
  final String incognitoDesc;
  final String videoCallsDesc;
  final String travelModeDesc;
  final String snoozeModeDesc;
  final String superSwipeDesc;

  final String exploreAffTitle;
  final String exploreAffDesc;
  final String affPlansDesc;
  final String affLeadersDesc;

  final String exploreStoriesTitle;
  final String exploreStoriesDesc;
  final String loveStoriesDesc;
  final String friendshipHubDesc;
  final String seasonalGuidesDesc;

  // Home Hero & Core Sections
  final String getTheAviajApp;
  final String heroMainHeadline;
  final String heroSubheadline;
  final String downloadOnThe;
  final String getItOn;
  final String joinDepartureCircle;
  final String shareYourNextItinerary;
  final String shareYourNextItineraryBody;
  final String signUp;
  final String scanQrToGetApp;
  final String downloadAviajBtn;
  final String learnMore;
  final String readMore;

  // Feature Page Interactive Phone Mockup & "How [Feature] Works" Section
  // (Matches `COMPLIMENTS फ़ीचर कैसे काम करता है` in Hindi, etc.)
  final String Function(String seoSegmentUpper) howFeatureWorksTitle;
  final String Function(String seoSegmentName) howFeatureWorksBody;
  final String Function(String seoSegmentUpper) featureOnAviajTitle;
  final String Function(String seoSegmentName) featureOnAviajSubtitle;
  final String mockupProfileNameAge;
  final String mockupProfileRole;
  final String mockupProfileUni;
  final String mockupComplimentHeader;
  final String mockupComplimentQuote;
  final String mockupTabProfile;
  final String mockupTabDiscover;
  final String mockupTabPeople;
  final String mockupTabLikedYou;
  final String mockupTabChats;

  // Safety, Support, App-Only & Footer
  final String safetyHeroTitle;
  final String safetyHeroSubtitle;
  final String safetyFeaturesTitle;
  final String supportHeroTitle;
  final String supportHeroSubtitle;
  final String appOnlyHeroTitle;
  final String appOnlyHeroSubtitle;
  final String footerBrandParagraph;
  final String footerLegalHeading;
  final String footerDestinationsHeading;
  final String footerCareersHeading;
  final String footerGetAppHeading;

  const AviajLangPack({
    required this.code,
    required this.label,
    required this.defaultRegion,
    required this.navStories,
    required this.navSafety,
    required this.navSupport,
    required this.navSignIn,
    required this.exploreDateTitle,
    required this.exploreDateDesc,
    required this.complimentsDesc,
    required this.incognitoDesc,
    required this.videoCallsDesc,
    required this.travelModeDesc,
    required this.snoozeModeDesc,
    required this.superSwipeDesc,
    required this.exploreAffTitle,
    required this.exploreAffDesc,
    required this.affPlansDesc,
    required this.affLeadersDesc,
    required this.exploreStoriesTitle,
    required this.exploreStoriesDesc,
    required this.loveStoriesDesc,
    required this.friendshipHubDesc,
    required this.seasonalGuidesDesc,
    required this.getTheAviajApp,
    required this.heroMainHeadline,
    required this.heroSubheadline,
    required this.downloadOnThe,
    required this.getItOn,
    required this.joinDepartureCircle,
    required this.shareYourNextItinerary,
    required this.shareYourNextItineraryBody,
    required this.signUp,
    required this.scanQrToGetApp,
    required this.downloadAviajBtn,
    required this.learnMore,
    required this.readMore,
    required this.howFeatureWorksTitle,
    required this.howFeatureWorksBody,
    required this.featureOnAviajTitle,
    required this.featureOnAviajSubtitle,
    required this.mockupProfileNameAge,
    required this.mockupProfileRole,
    required this.mockupProfileUni,
    required this.mockupComplimentHeader,
    required this.mockupComplimentQuote,
    required this.mockupTabProfile,
    required this.mockupTabDiscover,
    required this.mockupTabPeople,
    required this.mockupTabLikedYou,
    required this.mockupTabChats,
    required this.safetyHeroTitle,
    required this.safetyHeroSubtitle,
    required this.safetyFeaturesTitle,
    required this.supportHeroTitle,
    required this.supportHeroSubtitle,
    required this.appOnlyHeroTitle,
    required this.appOnlyHeroSubtitle,
    required this.footerBrandParagraph,
    required this.footerLegalHeading,
    required this.footerDestinationsHeading,
    required this.footerCareersHeading,
    required this.footerGetAppHeading,
  });
}

class AviajLocalizationService {
  static AviajLangPack _englishVariant(String label, AviajRegion region, String code) {
    return AviajLangPack(
      code: code,
      label: label,
      defaultRegion: region,
      navStories: 'Stories',
      navSafety: 'Safety',
      navSupport: 'Support',
      navSignIn: 'Sign in',
      exploreDateTitle: 'Explore Date ›',
      exploreDateDesc:
          'Features designed to create space for real, respectful, and meaningful connections.',
      complimentsDesc: 'Throw some Compliments their way so you stand out.',
      incognitoDesc: 'Hide your profile from your boss, relatives, or exes.',
      videoCallsDesc: 'Get as close to IRL without leaving your house.',
      travelModeDesc: 'Find your duty-free snack and match anywhere.',
      snoozeModeDesc: 'Put dating on hold with Snooze Mode.',
      superSwipeDesc: 'Seen someone you like? Let them know.',
      exploreAffTitle: 'Explore AFF ›',
      exploreAffDesc:
          'Aviaj Friends Forever helps you meet travel buddies, local friends, and group trek crews.',
      affPlansDesc: 'Join group treks, coastal villas, and local meetups.',
      affLeadersDesc: 'Connect with verified trek captains and local hosts.',
      exploreStoriesTitle: 'Explore Stories ›',
      exploreStoriesDesc:
          'Real couples, solo group friendships, and seasonal dating guides across the world.',
      loveStoriesDesc: 'Discover real couples who met on Aviaj.',
      friendshipHubDesc: 'Advice and guides for building meaningful friendships.',
      seasonalGuidesDesc: 'Plan the perfect date in every season.',
      getTheAviajApp: 'Get the\nAviaj app',
      heroMainHeadline: 'Meet your next co-pilot.\nMake the next move.',
      heroSubheadline:
          'Connect with verified solo & group travel buddies, vacation romance matches, and lifelong relationship partners on Aviaj.',
      downloadOnThe: 'Download on the',
      getItOn: 'GET IT ON',
      joinDepartureCircle: 'Join Departure Circle',
      shareYourNextItinerary: 'Share your next itinerary',
      shareYourNextItineraryBody:
          'Help shape your next adventure by joining the Aviaj Departure Circle. Verified solo travellers share live routes, destination pins, and first-night plans before boarding.',
      signUp: 'Sign up',
      scanQrToGetApp: 'Scan the QR\ncode to get the\nAviaj app',
      downloadAviajBtn: 'Download Aviaj',
      learnMore: 'Learn More',
      readMore: 'Read more',
      howFeatureWorksTitle: (seg) => 'HOW $seg\nWORKS',
      howFeatureWorksBody: (seg) =>
          'Let a potential match know what you like about their profile (and maybe even make them blush) by using $seg on Aviaj. You get $seg as part of your Premium+ membership. It’s also a way to send and receive messages before matching.',
      featureOnAviajTitle: (seg) => '$seg ON AVIAJ',
      featureOnAviajSubtitle: (seg) =>
          'Want to make their day? Sounds like you’re ready to use $seg on Aviaj.',
      mockupProfileNameAge: 'Naveen, 32',
      mockupProfileRole: 'Marketing Manager',
      mockupProfileUni: 'Indian University',
      mockupComplimentHeader: 'They complimented your photo',
      mockupComplimentQuote:
          'Oh wow! Where was this photo taken? Looks super familiar!',
      mockupTabProfile: 'Profile',
      mockupTabDiscover: 'Discover',
      mockupTabPeople: 'People',
      mockupTabLikedYou: 'Liked You',
      mockupTabChats: 'Chats',
      safetyHeroTitle: 'Your safety comes first, always',
      safetyHeroSubtitle:
          'The Aviaj Safety Center is here to guide you toward safe and meaningful connections.',
      safetyFeaturesTitle: 'Safety features',
      supportHeroTitle: 'How can we help?',
      supportHeroSubtitle:
          'Search for answers about your account, connections, features, and more.',
      appOnlyHeroTitle: 'AVIAJ IS NOW APP-ONLY.',
      appOnlyHeroSubtitle:
          'So we can keep bringing you the best experience and safety features, Aviaj is now app-only.',
      footerBrandParagraph:
          'Aviaj is where travel connections actually start, whether you’re looking for a lifelong relationship partner, a spontaneous vacation romance, or a verified travel co-pilot. Available in 190 countries with Destination Radar™, Departure Prompts™, and Crew Villas built for every kind of connection. Download free on iOS and Android.',
      footerLegalHeading: 'LEGAL & PRIVACY',
      footerDestinationsHeading: 'DESTINATIONS',
      footerCareersHeading: 'CAREERS',
      footerGetAppHeading: 'GET THE APP',
    );
  }

  static final Map<String, AviajLangPack> _packsByLabel = {
    'English (United States)': _englishVariant(
      'English (United States)',
      AviajRegion.americas,
      'en',
    ),
    'English (United Kingdom)': _englishVariant(
      'English (United Kingdom)',
      AviajRegion.europe,
      'en',
    ),
    'English (Canada)': _englishVariant(
      'English (Canada)',
      AviajRegion.americas,
      'en',
    ),
    'English (Australia)': _englishVariant(
      'English (Australia)',
      AviajRegion.asiaPacific,
      'en',
    ),
    'English (India)': _englishVariant(
      'English (India)',
      AviajRegion.india,
      'en',
    ),

    // हिंदी (Hindi) — Matches user screenshot `bumble.com/hi/features/compliments/`
    'हिंदी': AviajLangPack(
      code: 'hi',
      label: 'हिंदी',
      defaultRegion: AviajRegion.india,
      navStories: 'कहानियाँ',
      navSafety: 'सुरक्षा',
      navSupport: 'सहायता',
      navSignIn: 'साइन इन',
      exploreDateTitle: 'Explore Date ›',
      exploreDateDesc:
          'सच्चे, सम्मानजनक और सार्थक रिश्तों के लिए बनाए गए Aviaj Date फ़ीचर्स।',
      complimentsDesc: 'अपनी पहचान बनाने के लिए उन्हें Compliments भेजें।',
      incognitoDesc:
          'Incognito Mode से अपनी प्रोफ़ाइल बॉस, रिश्तेदारों या एक्स से छुपाएं।',
      videoCallsDesc: 'घर बैठे Video Calls से असली मुलाकात जैसा अनुभव पाएं।',
      travelModeDesc: 'Travel Mode के साथ कहीं भी यात्रा से पहले मैच पाएं।',
      snoozeModeDesc: 'Snooze Mode के साथ डेटिंग से छोटा ब्रेक लें।',
      superSwipeDesc: 'कोई पसंद आया? SuperSwipe से उन्हें तुरंत बताएं।',
      exploreAffTitle: 'Explore AFF ›',
      exploreAffDesc:
          'AFF (Aviaj Friends Forever) के साथ ट्रैवल बडीज़ और नए दोस्त बनाएं।',
      affPlansDesc: 'ग्रुप ट्रेक्स, ट्रिप्स और लोकल मीटअप्स से जुड़ें।',
      affLeadersDesc: 'वेरिफ़ाइड ट्रेक कैप्टन्स और लोकल होस्ट्स से मिलें।',
      exploreStoriesTitle: 'कहानियाँ देखें ›',
      exploreStoriesDesc: 'Aviaj पर मिले असली कपल्स और ट्रैवल ग्रुप्स की कहानियाँ।',
      loveStoriesDesc: 'Aviaj पर शुरू हुई सच्ची प्रेम कहानियाँ पढ़ें।',
      friendshipHubDesc: 'सार्थक दोस्ती बनाने के लिए टिप्स और गाइड्स।',
      seasonalGuidesDesc: 'हर मौसम में परफ़ेक्ट डेट और ट्रिप प्लान करें।',
      getTheAviajApp: 'Aviaj ऐप\nप्राप्त करें',
      heroMainHeadline: 'अपने अगले को-पायलट से मिलें।\nअगला कदम बढ़ाएँ।',
      heroSubheadline:
          'Aviaj पर वेरिफ़ाइड सोलो और ग्रुप ट्रैवल बडीज़, वेकेशन रोमांस और जीवनभर के पार्टनर से जुड़ें।',
      downloadOnThe: 'डाउनलोड करें',
      getItOn: 'यहाँ से पाएं',
      joinDepartureCircle: 'Departure Circle से जुड़ें',
      shareYourNextItinerary: 'अपना अगला यात्रा प्लान साझा करें',
      shareYourNextItineraryBody:
          'Aviaj Departure Circle से जुड़कर अपने अगले एडवेंचर को खास बनाएं। वेरिफ़ाइड सोलो ट्रैवलर्स बोर्डिंग से पहले अपने लाइव रूट्स और प्लान्स साझा करते हैं।',
      signUp: 'साइन अप करें',
      scanQrToGetApp: 'Aviaj ऐप पाने के लिए\nQR कोड स्कैन करें',
      downloadAviajBtn: 'Aviaj को डाउनलोड करें',
      learnMore: 'और जानें',
      readMore: 'आगे पढ़ें',
      howFeatureWorksTitle: (seg) => '$seg\nफ़ीचर कैसे\nकाम करता है',
      howFeatureWorksBody: (seg) =>
          'Aviaj पर $seg का इस्तेमाल करके संभावित मैच को बताएं कि आपको उनकी प्रोफ़ाइल पसंद है (और शायद उन्हें शर्माने के लिए मजबूर भी कर दें)। आपको अपनी Premium+ मेंबरशिप के हिस्से के रूप में $seg मिलते हैं। यह मैच होने से पहले ही मैसेज भेजने और प्राप्त करने का एक तरीका भी है।',
      featureOnAviajTitle: (seg) => 'AVIAJ पर $seg',
      featureOnAviajSubtitle: (seg) =>
          'उनका दिन खास बनाना चाहते हैं? तो आप Aviaj पर $seg का इस्तेमाल करने के लिए तैयार हैं।',
      mockupProfileNameAge: 'नवीन, 32',
      mockupProfileRole: 'मार्केटिंग मैनेजर',
      mockupProfileUni: 'इंडियन यूनिवर्सिटी',
      mockupComplimentHeader: 'उन्होंने आपकी फ़ोटो की तारीफ़ की',
      mockupComplimentQuote:
          'अरे वाह! ये फ़ोटो कहाँ ली गई थी? यह बहुत जानी-पहचानी लग रही है!',
      mockupTabProfile: 'प्रोफ़ाइल',
      mockupTabDiscover: 'खोज',
      mockupTabPeople: 'लोग',
      mockupTabLikedYou: 'आपको पसंद किया',
      mockupTabChats: 'चैट',
      safetyHeroTitle: 'आपकी सुरक्षा हमेशा सबसे पहले आती है',
      safetyHeroSubtitle:
          'Aviaj Safety Center आपको सुरक्षित और सार्थक रिश्तों की ओर मार्गदर्शन करने के लिए यहाँ है।',
      safetyFeaturesTitle: 'सुरक्षा फ़ीचर्स',
      supportHeroTitle: 'हम आपकी कैसे मदद कर सकते हैं?',
      supportHeroSubtitle:
          'अपने अकाउंट, कनेक्शन्स, फ़ीचर्स और सुरक्षा से जुड़े सवालों के जवाब खोजें।',
      appOnlyHeroTitle: 'AVIAJ अब केवल ऐप पर उपलब्ध है।',
      appOnlyHeroSubtitle:
          'आपको बेहतरीन अनुभव और सुरक्षा फ़ीचर्स देने के लिए, Aviaj अब केवल ऐप पर उपलब्ध है।',
      footerBrandParagraph:
          'Aviaj वह जगह है जहाँ यात्रा और रिश्ते शुरू होते हैं—चाहे आप जीवनभर का पार्टनर ढूंढ रहे हों, वेकेशन रोमांस या वेरिफ़ाइड ट्रैवल को-पायलट। Destination Radar™ और AFF Crew Villas के साथ 190 देशों में उपलब्ध। iOS और Android पर मुफ़्त डाउनलोड करें।',
      footerLegalHeading: 'कानूनी और गोपनीयता',
      footerDestinationsHeading: 'डेस्टिनेशन्स',
      footerCareersHeading: 'करियर',
      footerGetAppHeading: 'ऐप डाउनलोड करें',
    ),

    // Deutsch (German)
    'Deutsch': AviajLangPack(
      code: 'de',
      label: 'Deutsch',
      defaultRegion: AviajRegion.europe,
      navStories: 'Geschichten',
      navSafety: 'Sicherheit',
      navSupport: 'Hilfe',
      navSignIn: 'Anmelden',
      exploreDateTitle: 'Explore Date ›',
      exploreDateDesc:
          'Funktionen für echte, respektvolle und bedeutungsvolle Verbindungen auf Aviaj Date.',
      complimentsDesc: 'Sende Compliments, um vor dem Match aufzufallen.',
      incognitoDesc: 'Verbirg dein Profil mit dem Incognito Mode.',
      videoCallsDesc: 'Lerne dein Match per Video Calls sicher von zu Hause kennen.',
      travelModeDesc: 'Finde mit dem Travel Mode weltweit Matches vor der Abreise.',
      snoozeModeDesc: 'Lege mit dem Snooze Mode jederzeit eine Dating-Pause ein.',
      superSwipeDesc: 'Zeige mit einem SuperSwipe besonderes Interesse.',
      exploreAffTitle: 'Explore AFF ›',
      exploreAffDesc:
          'Mit AFF (Aviaj Friends Forever) findest du Reisepartner und neue Freunde.',
      affPlansDesc: 'Tritt Gruppenwanderungen und lokalen Treffen bei.',
      affLeadersDesc: 'Vernetze dich mit verifizierten Community Leaders.',
      exploreStoriesTitle: 'Geschichten ›',
      exploreStoriesDesc: 'Echte Paare und Reisefreundschaften auf Aviaj.',
      loveStoriesDesc: 'Entdecke echte Liebesgeschichten von Aviaj.',
      friendshipHubDesc: 'Tipps und Guides für echte Freundschaften.',
      seasonalGuidesDesc: 'Plane das perfekte Date zu jeder Jahreszeit.',
      getTheAviajApp: 'Hol dir die\nAviaj App',
      heroMainHeadline: 'Triff deinen nächsten Co-Piloten.\nMach den nächsten Schritt.',
      heroSubheadline:
          'Vernetze dich mit verifizierten Reisepartnern, Urlaubsflirts und langfristigen Partnern auf Aviaj.',
      downloadOnThe: 'Laden im',
      getItOn: 'JETZT BEI',
      joinDepartureCircle: 'Departure Circle beitreten',
      shareYourNextItinerary: 'Teile deine nächste Reiseroute',
      shareYourNextItineraryBody:
          'Gestalte dein nächstes Abenteuer im Aviaj Departure Circle. Verifizierte Reisende teilen ihre Routen direkt vor dem Abflug.',
      signUp: 'Registrieren',
      scanQrToGetApp: 'QR-Code scannen,\num die Aviaj App\nzu laden',
      downloadAviajBtn: 'Aviaj herunterladen',
      learnMore: 'Mehr erfahren',
      readMore: 'Weiterlesen',
      howFeatureWorksTitle: (seg) => 'SO FUNKTIONIERT\n$seg',
      howFeatureWorksBody: (seg) =>
          'Zeige einem potenziellen Match mit $seg auf Aviaj, was dir an seinem Profil gefällt. Du erhältst $seg als Teil deiner Premium+ Mitgliedschaft, um schon vor einem Match Nachrichten zu senden.',
      featureOnAviajTitle: (seg) => '$seg AUF AVIAJ',
      featureOnAviajSubtitle: (seg) =>
          'Du möchtest jemandem den Tag versüßen? Dann nutze jetzt $seg auf Aviaj.',
      mockupProfileNameAge: 'Naveen, 32',
      mockupProfileRole: 'Marketing-Manager',
      mockupProfileUni: 'Universität',
      mockupComplimentHeader: 'Hat dein Foto komplimentiert',
      mockupComplimentQuote:
          'Wow! Wo wurde dieses Foto aufgenommen? Sieht wunderschön aus!',
      mockupTabProfile: 'Profil',
      mockupTabDiscover: 'Entdecken',
      mockupTabPeople: 'Leute',
      mockupTabLikedYou: 'Mag dich',
      mockupTabChats: 'Chats',
      safetyHeroTitle: 'Deine Sicherheit steht immer an erster Stelle',
      safetyHeroSubtitle:
          'Das Aviaj Safety Center begleitet dich zu sicheren und echten Verbindungen.',
      safetyFeaturesTitle: 'Sicherheitsfunktionen',
      supportHeroTitle: 'Wie können wir helfen?',
      supportHeroSubtitle:
          'Suche nach Antworten zu deinem Konto, Matches und Funktionen.',
      appOnlyHeroTitle: 'AVIAJ IST JETZT NUR NOCH ALS APP VERFÜGBAR.',
      appOnlyHeroSubtitle:
          'Für das beste Erlebnis und höchste Sicherheit ist Aviaj jetzt exklusiv in der App verfügbar.',
      footerBrandParagraph:
          'Aviaj ist der Ort, an dem Reiseverbindungen beginnen – egal ob für eine feste Beziehung, eine Urlaubsromanze oder einen Reisepartner. Verfügbar in 190 Ländern mit Destination Radar™.',
      footerLegalHeading: 'RECHTLICHES & DATENSCHUTZ',
      footerDestinationsHeading: 'REISEZIELE',
      footerCareersHeading: 'KARRIERE',
      footerGetAppHeading: 'HOL DIR DIE APP',
    ),

    // Français & Français (Canada)
    'Français': _frenchVariant('Français', AviajRegion.europe),
    'Français (Canada)': _frenchVariant('Français (Canada)', AviajRegion.americas),

    // Español variants
    'Español (España)': _spanishVariant('Español (España)', AviajRegion.europe),
    'Español (México)': _spanishVariant('Español (México)', AviajRegion.americas),
    'Español (Colombia)': _spanishVariant('Español (Colombia)', AviajRegion.americas),
    'Español (Argentina)': _spanishVariant('Español (Argentina)', AviajRegion.americas),

    // Italiano
    'Italiano': _customLang(
      code: 'it',
      label: 'Italiano',
      region: AviajRegion.europe,
      stories: 'Storie',
      safety: 'Sicurezza',
      support: 'Supporto',
      signIn: 'Accedi',
      heroHeadline: 'Incontra il tuo prossimo co-pilota.\nFai la prossima mossa.',
      howWorksTitle: (seg) => 'COME FUNZIONA\n$seg',
      howWorksBody: (seg) =>
          'Fai sapere a un potenziale match cosa ti piace del suo profilo usando $seg su Aviaj come parte del tuo abbonamento Premium+.',
      featureTitle: (seg) => '$seg SU AVIAJ',
      downloadBtn: 'Scarica Aviaj',
      complimentHeader: 'Ha fatto un complimento alla tua foto',
      complimentQuote: 'Wow! Dove è stata scattata questa foto? Sembra un posto familiare!',
    ),

    // Português (Brasil) & Português (Portugal)
    'Português (Brasil)': _portugueseVariant('Português (Brasil)', AviajRegion.americas),
    'Português (Portugal)': _portugueseVariant('Português (Portugal)', AviajRegion.europe),

    // Русский
    'Русский': _customLang(
      code: 'ru',
      label: 'Русский',
      region: AviajRegion.europe,
      stories: 'Истории',
      safety: 'Безопасность',
      support: 'Поддержка',
      signIn: 'Войти',
      heroHeadline: 'Встретьте своего второго пилота.\nСделайте следующий шаг.',
      howWorksTitle: (seg) => 'КАК РАБОТАЕТ\n$seg',
      howWorksBody: (seg) =>
          'Дайте понять потенциальной паре, что вам понравился её профиль, используя $seg на Aviaj в рамках подписки Premium+.',
      featureTitle: (seg) => '$seg В AVIAJ',
      downloadBtn: 'Скачать Aviaj',
      complimentHeader: 'Сделал(а) комплимент вашему фото',
      complimentQuote: 'Ух ты! Где было сделано это фото? Выглядит очень знакомо!',
    ),

    // 中文 (简体) & 中文 (繁體)
    '中文 (简体)': _customLang(
      code: 'zh',
      label: '中文 (简体)',
      region: AviajRegion.asiaPacific,
      stories: '故事',
      safety: '安全中心',
      support: '支持',
      signIn: '登录',
      heroHeadline: '遇见你的下一位旅行伴侣。\n迈出下一步。',
      howWorksTitle: (seg) => '$seg\n功能如何运作',
      howWorksBody: (seg) =>
          '在 Aviaj 上使用 $seg，在配对前向心仪对象发送赞美。您可以通过 Premium+ 会员使用 $seg 功能。',
      featureTitle: (seg) => 'AVIAJ 上的 $seg',
      downloadBtn: '下载 Aviaj',
      complimentHeader: '对方赞美了你的照片',
      complimentQuote: '哇！这张照片是在哪里拍的？看起来好眼熟！',
    ),
    '中文 (繁體)': _customLang(
      code: 'zh-TW',
      label: '中文 (繁體)',
      region: AviajRegion.asiaPacific,
      stories: '故事',
      safety: '安全中心',
      support: '支援',
      signIn: '登入',
      heroHeadline: '遇見你的下一位旅行伴侶。\n邁出下一步。',
      howWorksTitle: (seg) => '$seg\n功能如何運作',
      howWorksBody: (seg) =>
          '在 Aviaj 上使用 $seg，在配對前向心儀對象發送讚美。您可以透過 Premium+ 會員使用 $seg 功能。',
      featureTitle: (seg) => 'AVIAJ 上的 $seg',
      downloadBtn: '下載 Aviaj',
      complimentHeader: '對方讚美了你的照片',
      complimentQuote: '哇！這張照片是在哪裡拍的？看起來好眼熟！',
    ),

    // Bahasa Indonesia
    'Bahasa Indonesia': _customLang(
      code: 'id',
      label: 'Bahasa Indonesia',
      region: AviajRegion.asiaPacific,
      stories: 'Cerita',
      safety: 'Keamanan',
      support: 'Bantuan',
      signIn: 'Masuk',
      heroHeadline: 'Temukan co-pilot perjalananmu.\nAmbil langkah berikutnya.',
      howWorksTitle: (seg) => 'CARA KERJA\n$seg',
      howWorksBody: (seg) =>
          'Beri tahu calon pasangan apa yang kamu sukai dari profil mereka menggunakan $seg di Aviaj dengan langganan Premium+.',
      featureTitle: (seg) => '$seg DI AVIAJ',
      downloadBtn: 'Unduh Aviaj',
      complimentHeader: 'Memuji foto Anda',
      complimentQuote: 'Wah! Di mana foto ini diambil? Terlihat sangat familiar!',
    ),

    // Dansk
    'Dansk': _customLang(
      code: 'da',
      label: 'Dansk',
      region: AviajRegion.europe,
      stories: 'Historier',
      safety: 'Sikkerhed',
      support: 'Support',
      signIn: 'Log ind',
      heroHeadline: 'Mød din næste rejsepartner.\nTag det næste skridt.',
      howWorksTitle: (seg) => 'SÅDAN VIRKER\n$seg',
      howWorksBody: (seg) =>
          'Fortæl et potentielt match, hvad du kan lide ved deres profil, ved at bruge $seg på Aviaj med dit Premium+ medlemskab.',
      featureTitle: (seg) => '$seg PÅ AVIAJ',
      downloadBtn: 'Hent Aviaj',
      complimentHeader: 'Gav dit billede et kompliment',
      complimentQuote: 'Wow! Hvor er dette billede taget? Det ser bekendt ud!',
    ),

    // Nederlands
    'Nederlands': _customLang(
      code: 'nl',
      label: 'Nederlands',
      region: AviajRegion.europe,
      stories: 'Verhalen',
      safety: 'Veiligheid',
      support: 'Hulp',
      signIn: 'Inloggen',
      heroHeadline: 'Ontmoet je volgende co-piloot.\nZet de volgende stap.',
      howWorksTitle: (seg) => 'HOE $seg\nWERKT',
      howWorksBody: (seg) =>
          'Laat een potentiële match weten wat je leuk vindt aan hun profiel met $seg op Aviaj als onderdeel van je Premium+ lidmaatschap.',
      featureTitle: (seg) => '$seg OP AVIAJ',
      downloadBtn: 'Download Aviaj',
      complimentHeader: 'Gaf een compliment over je foto',
      complimentQuote: 'Wauw! Waar is deze foto genomen? Ziet er heel bekend uit!',
    ),

    // Norsk bokmål
    'Norsk bokmål': _customLang(
      code: 'nb',
      label: 'Norsk bokmål',
      region: AviajRegion.europe,
      stories: 'Historier',
      safety: 'Sikkerhet',
      support: 'Brukerstøtte',
      signIn: 'Logg inn',
      heroHeadline: 'Møt din neste reisepartner.\nTa det neste steget.',
      howWorksTitle: (seg) => 'SLIK FUNGERER\n$seg',
      howWorksBody: (seg) =>
          'La en potensiell match få vite hva du liker med profilen deres ved å bruke $seg på Aviaj med Premium+.',
      featureTitle: (seg) => '$seg PÅ AVIAJ',
      downloadBtn: 'Last ned Aviaj',
      complimentHeader: 'Ga bildet ditt et kompliment',
      complimentQuote: 'Oi! Hvor ble dette bildet tatt? Ser veldig kjent ut!',
    ),

    // Polski
    'Polski': _customLang(
      code: 'pl',
      label: 'Polski',
      region: AviajRegion.europe,
      stories: 'Historie',
      safety: 'Bezpieczeństwo',
      support: 'Pomoc',
      signIn: 'Zaloguj się',
      heroHeadline: 'Poznaj swojego drugiego pilota.\nZrób kolejny krok.',
      howWorksTitle: (seg) => 'JAK DZIAŁA\n$seg',
      howWorksBody: (seg) =>
          'Daj znać potencjalnej parze, co podoba Ci się w jej profilu, korzystając z funkcji $seg na Aviaj w ramach subskrypcji Premium+.',
      featureTitle: (seg) => '$seg W AVIAJ',
      downloadBtn: 'Pobierz Aviaj',
      complimentHeader: 'Skomplementował(a) Twoje zdjęcie',
      complimentQuote: 'O rany! Gdzie zrobiono to zdjęcie? Wygląda bardzo znajomo!',
    ),

    // Suomi
    'Suomi': _customLang(
      code: 'fi',
      label: 'Suomi',
      region: AviajRegion.europe,
      stories: 'Tarinat',
      safety: 'Turvallisuus',
      support: 'Tuki',
      signIn: 'Kirjaudu',
      heroHeadline: 'Tapaa seuraava matkakumppanisi.\nOta seuraava askel.',
      howWorksTitle: (seg) => 'NÄIN $seg\nTOIMII',
      howWorksBody: (seg) =>
          'Kerro kiinnostavalle henkilölle, mistä pidät hänen profiilissaan käyttämällä $seg-toimintoa Aviajssa osana Premium+-jäsenyyttäsi.',
      featureTitle: (seg) => '$seg AVIAJSSA',
      downloadBtn: 'Lataa Aviaj',
      complimentHeader: 'Kehui kuvaasi',
      complimentQuote: 'Vau! Missä tämä kuva on otettu? Näyttää todella tutulta!',
    ),

    // Svenska
    'Svenska': _customLang(
      code: 'sv',
      label: 'Svenska',
      region: AviajRegion.europe,
      stories: 'Berättelser',
      safety: 'Säkerhet',
      support: 'Support',
      signIn: 'Logga in',
      heroHeadline: 'Möt din nästa co-pilot.\nTa nästa steg.',
      howWorksTitle: (seg) => 'SÅ FUNGERAR\n$seg',
      howWorksBody: (seg) =>
          'Låt en potentiell match veta vad du gillar med deras profil genom att använda $seg på Aviaj med ditt Premium+-medlemskap.',
      featureTitle: (seg) => '$seg PÅ AVIAJ',
      downloadBtn: 'Ladda ner Aviaj',
      complimentHeader: 'Gav ditt foto en komplimang',
      complimentQuote: 'Wow! Var togs det här fotot? Ser väldigt bekant ut!',
    ),

    // 日本語
    '日本語': _customLang(
      code: 'ja',
      label: '日本語',
      region: AviajRegion.asiaPacific,
      stories: 'ストーリー',
      safety: '安全対策',
      support: 'サポート',
      signIn: 'ログイン',
      heroHeadline: '次の旅のパートナーと出会おう。\n次の一歩を踏み出そう。',
      howWorksTitle: (seg) => '$seg\nの仕組み',
      howWorksBody: (seg) =>
          'Aviaj の $seg を使って、マッチング前に気になる相手のプロフィールにメッセージを送りましょう。Premium+ メンバーシップでご利用いただけます。',
      featureTitle: (seg) => 'AVIAJ の $seg',
      downloadBtn: 'Aviaj をダウンロード',
      complimentHeader: 'あなたの写真に Compliment を送りました',
      complimentQuote: '素敵ですね！この写真はどこで撮ったのですか？見覚えがあります！',
    ),

    // 한국어
    '한국어': _customLang(
      code: 'ko',
      label: '한국어',
      region: AviajRegion.asiaPacific,
      stories: '스토리',
      safety: '안전 센터',
      support: '고객지원',
      signIn: '로그인',
      heroHeadline: '다음 여행의 동반자를 만나보세요.\n다음 걸음을 내딛으세요.',
      howWorksTitle: (seg) => '$seg\n기능 작동 방식',
      howWorksBody: (seg) =>
          'Aviaj에서 $seg 기능을 사용해 매칭 전에 상대방의 프로필에서 마음에 드는 점을 알려주세요. Premium+ 멤버십의 일부로 제공됩니다.',
      featureTitle: (seg) => 'AVIAJ의 $seg',
      downloadBtn: 'Aviaj 다운로드',
      complimentHeader: '회원님의 사진에 칭찬을 보냈습니다',
      complimentQuote: '와! 이 사진은 어디서 찍으셨나요? 정말 익숙한 곳이네요!',
    ),
  };

  static AviajLangPack _frenchVariant(String label, AviajRegion region) {
    return _customLang(
      code: 'fr',
      label: label,
      region: region,
      stories: 'Histoires',
      safety: 'Sécurité',
      support: 'Assistance',
      signIn: 'Connexion',
      heroHeadline: 'Rencontrez votre prochain copilote.\nFaites le prochain pas.',
      howWorksTitle: (seg) => 'COMMENT FONCTIONNE\n$seg',
      howWorksBody: (seg) =>
          'Faites savoir à un match potentiel ce que vous aimez sur son profil en utilisant $seg sur Aviaj dans le cadre de votre abonnement Premium+.',
      featureTitle: (seg) => '$seg SUR AVIAJ',
      downloadBtn: 'Télécharger Aviaj',
      complimentHeader: 'A complimenté votre photo',
      complimentQuote: 'Oh waouh ! Où cette photo a-t-elle été prise ? Ça me dit quelque chose !',
    );
  }

  static AviajLangPack _spanishVariant(String label, AviajRegion region) {
    return _customLang(
      code: 'es',
      label: label,
      region: region,
      stories: 'Historias',
      safety: 'Seguridad',
      support: 'Soporte',
      signIn: 'Iniciar sesión',
      heroHeadline: 'Conoce a tu próximo copiloto.\nDa el siguiente paso.',
      howWorksTitle: (seg) => 'CÓMO FUNCIONA\n$seg',
      howWorksBody: (seg) =>
          'Hazle saber a una posible conexión qué te gusta de su perfil usando $seg en Aviaj como parte de tu suscripción Premium+.',
      featureTitle: (seg) => '$seg EN AVIAJ',
      downloadBtn: 'Descargar Aviaj',
      complimentHeader: 'Elogió tu foto',
      complimentQuote: '¡Guau! ¿Dónde fue tomada esta foto? ¡Se me hace muy familiar!',
    );
  }

  static AviajLangPack _portugueseVariant(String label, AviajRegion region) {
    return _customLang(
      code: 'pt',
      label: label,
      region: region,
      stories: 'Histórias',
      safety: 'Segurança',
      support: 'Suporte',
      signIn: 'Entrar',
      heroHeadline: 'Conheça seu próximo copiloto.\nDê o próximo passo.',
      howWorksTitle: (seg) => 'COMO FUNCIONA\nO $seg',
      howWorksBody: (seg) =>
          'Mostre a um possível par o que você gostou no perfil dele usando $seg no Aviaj como parte da sua assinatura Premium+.',
      featureTitle: (seg) => '$seg NO AVIAJ',
      downloadBtn: 'Baixar o Aviaj',
      complimentHeader: 'Elogiou sua foto',
      complimentQuote: 'Uau! Onde essa foto foi tirada? Parece super familiar!',
    );
  }

  static AviajLangPack _customLang({
    required String code,
    required String label,
    required AviajRegion region,
    required String stories,
    required String safety,
    required String support,
    required String signIn,
    required String heroHeadline,
    required String Function(String) howWorksTitle,
    required String Function(String) howWorksBody,
    required String Function(String) featureTitle,
    required String downloadBtn,
    required String complimentHeader,
    required String complimentQuote,
  }) {
    final base = _englishVariant(label, region, code);
    return AviajLangPack(
      code: code,
      label: label,
      defaultRegion: region,
      navStories: stories,
      navSafety: safety,
      navSupport: support,
      navSignIn: signIn,
      exploreDateTitle: base.exploreDateTitle,
      exploreDateDesc: base.exploreDateDesc,
      complimentsDesc: base.complimentsDesc,
      incognitoDesc: base.incognitoDesc,
      videoCallsDesc: base.videoCallsDesc,
      travelModeDesc: base.travelModeDesc,
      snoozeModeDesc: base.snoozeModeDesc,
      superSwipeDesc: base.superSwipeDesc,
      exploreAffTitle: base.exploreAffTitle,
      exploreAffDesc: base.exploreAffDesc,
      affPlansDesc: base.affPlansDesc,
      affLeadersDesc: base.affLeadersDesc,
      exploreStoriesTitle: '$stories ›',
      exploreStoriesDesc: base.exploreStoriesDesc,
      loveStoriesDesc: base.loveStoriesDesc,
      friendshipHubDesc: base.friendshipHubDesc,
      seasonalGuidesDesc: base.seasonalGuidesDesc,
      getTheAviajApp: base.getTheAviajApp,
      heroMainHeadline: heroHeadline,
      heroSubheadline: base.heroSubheadline,
      downloadOnThe: base.downloadOnThe,
      getItOn: base.getItOn,
      joinDepartureCircle: base.joinDepartureCircle,
      shareYourNextItinerary: base.shareYourNextItinerary,
      shareYourNextItineraryBody: base.shareYourNextItineraryBody,
      signUp: base.signUp,
      scanQrToGetApp: base.scanQrToGetApp,
      downloadAviajBtn: downloadBtn,
      learnMore: base.learnMore,
      readMore: base.readMore,
      howFeatureWorksTitle: howWorksTitle,
      howFeatureWorksBody: howWorksBody,
      featureOnAviajTitle: featureTitle,
      featureOnAviajSubtitle: base.featureOnAviajSubtitle,
      mockupProfileNameAge: base.mockupProfileNameAge,
      mockupProfileRole: base.mockupProfileRole,
      mockupProfileUni: base.mockupProfileUni,
      mockupComplimentHeader: complimentHeader,
      mockupComplimentQuote: complimentQuote,
      mockupTabProfile: base.mockupTabProfile,
      mockupTabDiscover: base.mockupTabDiscover,
      mockupTabPeople: base.mockupTabPeople,
      mockupTabLikedYou: base.mockupTabLikedYou,
      mockupTabChats: base.mockupTabChats,
      safetyHeroTitle: base.safetyHeroTitle,
      safetyHeroSubtitle: base.safetyHeroSubtitle,
      safetyFeaturesTitle: base.safetyFeaturesTitle,
      supportHeroTitle: base.supportHeroTitle,
      supportHeroSubtitle: base.supportHeroSubtitle,
      appOnlyHeroTitle: base.appOnlyHeroTitle,
      appOnlyHeroSubtitle: base.appOnlyHeroSubtitle,
      footerBrandParagraph: base.footerBrandParagraph,
      footerLegalHeading: base.footerLegalHeading,
      footerDestinationsHeading: base.footerDestinationsHeading,
      footerCareersHeading: base.footerCareersHeading,
      footerGetAppHeading: base.footerGetAppHeading,
    );
  }

  static AviajLangPack packForLabel(String label) {
    return _packsByLabel[label] ??
        _packsByLabel['English (United Kingdom)']!;
  }

  static String? labelFromCode(String? rawCode) {
    if (rawCode == null || rawCode.trim().isEmpty) return null;
    final norm = rawCode.trim().toLowerCase();
    switch (norm) {
      case 'hi':
      case 'in-hi':
        return 'हिंदी';
      case 'de':
        return 'Deutsch';
      case 'fr':
        return 'Français';
      case 'fr-ca':
        return 'Français (Canada)';
      case 'es':
      case 'es-es':
        return 'Español (España)';
      case 'es-mx':
        return 'Español (México)';
      case 'es-co':
        return 'Español (Colombia)';
      case 'es-ar':
        return 'Español (Argentina)';
      case 'it':
        return 'Italiano';
      case 'pt':
      case 'pt-br':
        return 'Português (Brasil)';
      case 'pt-pt':
        return 'Português (Portugal)';
      case 'ru':
        return 'Русский';
      case 'zh':
      case 'zh-cn':
        return '中文 (简体)';
      case 'zh-tw':
        return '中文 (繁體)';
      case 'id':
        return 'Bahasa Indonesia';
      case 'da':
        return 'Dansk';
      case 'nl':
        return 'Nederlands';
      case 'nb':
      case 'no':
        return 'Norsk bokmål';
      case 'pl':
        return 'Polski';
      case 'fi':
        return 'Suomi';
      case 'sv':
        return 'Svenska';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'en-us':
        return 'English (United States)';
      case 'en-in':
        return 'English (India)';
      case 'en-ca':
        return 'English (Canada)';
      case 'en-au':
        return 'English (Australia)';
      case 'en':
      case 'en-gb':
        return 'English (United Kingdom)';
      default:
        return null;
    }
  }

  /// Generates localized SEO title while strictly preserving `Aviaj` and the
  /// main product segment (`Date`, `AFF`, `Compliments`, `Incognito Mode`, etc.)
  /// so SEO ranking remains strong across all languages.
  static String seoTitleFor(AviajSeoPage page, AviajLangPack lang) {
    if (lang.code == 'en') return page.title;
    return '${page.breadcrumbLabel} | Aviaj (${lang.label}) — ${page.title}';
  }
}
