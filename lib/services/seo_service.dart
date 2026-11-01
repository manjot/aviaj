import 'dart:convert';
import 'seo_service_stub.dart'
    if (dart.library.js_interop) 'seo_service_web.dart' as impl;

/// Dedicated SEO-optimised pages for every top header and mega-menu route on `https://aviaj.com/`.
enum AviajSeoPage {
  home(
    path: '/',
    navGroup: 'Home',
    breadcrumbLabel: 'Home',
    title:
        'Aviaj — Travel Buddy, Vacation Romance & Relationship Dating App',
    description:
        'Meet your next co-pilot on Aviaj. Connect with verified solo & group travel buddies, vacation romance matches, and lifelong relationship partners across Manali, Goa, Andaman, USA, Europe & Middle East.',
    keywords:
        'Aviaj, travel dating app, travel buddy app, vacation romance, solo travel companions, Manali trek buddies, Goa travel dating, relationship app',
  ),
  date(
    path: '/date',
    navGroup: 'Date',
    breadcrumbLabel: 'Explore Date',
    title:
        'Aviaj Date — Features Designed to Make Online Dating Enjoyable | Aviaj',
    description:
        'Explore Aviaj Date features designed for real, respectful, and meaningful connections: Compliments, Incognito Mode, HD Video Calls, Travel Mode, Snooze Mode, and SuperSwipe.',
    keywords:
        'Aviaj Date, online dating features, respectful dating app, Compliments, Incognito Mode, Travel Mode, Video Calls, Snooze Mode, SuperSwipe',
  ),
  dateCompliments(
    path: '/date/compliments',
    navGroup: 'Date',
    breadcrumbLabel: 'Compliments',
    title:
        'Aviaj Compliments — Send a Kind Note Before You Match | Aviaj Date',
    description:
        'Make them blush with Aviaj Compliments. Send a thoughtful message on a profile prompt, travel itinerary, or photo before you even match.',
    keywords:
        'Aviaj Compliments, message before matching, dating app compliments, profile prompt reply, stand out on Aviaj Date',
  ),
  dateIncognito(
    path: '/date/incognito-mode',
    navGroup: 'Date',
    breadcrumbLabel: 'Incognito Mode',
    title:
        'Aviaj Incognito Mode — Browse Profiles Privately & Control Who Sees You | Aviaj Date',
    description:
        'Go undercover with Aviaj Incognito Mode. Hide your profile from your boss, relatives, or exes, and only be visible to people you swipe right on.',
    keywords:
        'Aviaj Incognito Mode, private dating app mode, hide dating profile, anonymous browsing dating, Aviaj Premium privacy',
  ),
  dateVideoCalls(
    path: '/date/video-calls',
    navGroup: 'Date',
    breadcrumbLabel: 'Video Calls',
    title:
        'Aviaj Video Calls & Audio Chats — Vibe Check Before Meeting IRL | Aviaj Date',
    description:
        'Sound it out with Aviaj in-app HD video calls and audio chats. Get as close to IRL without leaving your house or sharing your personal phone number.',
    keywords:
        'Aviaj Video Calls, in-app audio chat, safe virtual date, video call dating app, verify chemistry before meeting',
  ),
  dateTravelMode(
    path: '/date/travel-mode',
    navGroup: 'Date',
    breadcrumbLabel: 'Travel Mode',
    title:
        'Aviaj Travel Mode — Match with Locals & Travellers Before You Land | Aviaj Date',
    description:
        'Take us away with Aviaj Travel Mode. Set your destination city or trek route before departure and match with locals and co-travellers anywhere in the world.',
    keywords:
        'Aviaj Travel Mode, match in another city, travel dating passport, destination matching, Manali Goa Bali Paris Dubai dating',
  ),
  dateSnoozeMode(
    path: '/date/snooze-mode',
    navGroup: 'Date',
    breadcrumbLabel: 'Snooze Mode',
    title:
        'Aviaj Snooze Mode — Take a Mindful Break Without Losing Matches | Aviaj Date',
    description:
        'Put dating on hold with Aviaj Snooze Mode for 24 hours, 72 hours, a week, or indefinitely while keeping all your existing matches and conversations safe.',
    keywords:
        'Aviaj Snooze Mode, pause dating profile, digital detox dating, take a break from online dating, keep matches paused',
  ),
  dateSuperSwipe(
    path: '/date/superswipe',
    navGroup: 'Date',
    breadcrumbLabel: 'SuperSwipe',
    title:
        'Aviaj SuperSwipe — Let Someone Special Know They Passed the Vibe Check | Aviaj Date',
    description:
        'Get their attention with Aviaj SuperSwipe. Highlight your profile at the top of their queue and multiply your chance of an instant connection.',
    keywords:
        'Aviaj SuperSwipe, priority like dating app, stand out to matches, boost match rate Aviaj',
  ),
  aff(
    path: '/aff',
    navGroup: 'AFF',
    breadcrumbLabel: 'Explore AFF',
    title:
        'AFF (Aviaj Friends Forever) — Find Travel Friends, Local Crews & Group Departures',
    description:
        'Whether you moved to a new city, landed solo abroad, or want to expand your circle, AFF (Aviaj Friends Forever) makes it easy to meet like-minded people.',
    keywords:
        'AFF, Aviaj Friends Forever, platonic friendship app, find travel buddies, solo group travel crew, make friends in a new city',
  ),
  affDeparturePlans(
    path: '/aff/departure-plans',
    navGroup: 'AFF',
    breadcrumbLabel: 'Departure Plans',
    title:
        'AFF Departure Plans — Match with Co-Travellers on Your Exact Dates | Aviaj AFF',
    description:
        'Share your upcoming trek, island getaway, or city break on AFF Departure Plans to build a verified Villa Crew and Route Chat before takeoff.',
    keywords:
        'AFF Departure Plans, shared travel itinerary, group trip matching, Villa Crew, Route Chat, co-traveller finder',
  ),
  affCommunityLeaders(
    path: '/aff/community-leaders',
    navGroup: 'AFF',
    breadcrumbLabel: 'Community Leaders',
    title:
        'AFF Community Leaders — Verified Local Hosts & Group Trek Organizers | Aviaj AFF',
    description:
        'Join verified AFF Community Leaders hosting local social mixers, Himalayan treks, coastal runs, and newcomer meetups in 190+ destinations.',
    keywords:
        'AFF Community Leaders, local meetup hosts, verified group trip leaders, Aviaj ambassadors, city friendship events',
  ),
  stories(
    path: '/stories',
    navGroup: 'Stories',
    breadcrumbLabel: 'Love Stories',
    title:
        'Aviaj Love Stories — For the Love of Love | Real Couples Who Met on Aviaj',
    description:
        'From Tokyo to Toronto and Dublin to Goa, explore real love stories from couples who met on Aviaj. Read Tosin & Kieron’s story or submit your own.',
    keywords:
        'Aviaj Love Stories, dating app success stories, couples met on Aviaj, Tosin and Kieron, Share Your Love Story',
  ),
  friendshipHub(
    path: '/friendship-hub',
    navGroup: 'Stories',
    breadcrumbLabel: 'The Friendship Hub',
    title:
        'The Friendship Hub — Advice & Guides for Building Meaningful Friendships | Aviaj AFF',
    description:
        'Advice, guides, and stories to help you build the friendships you want. Learn how to make friends in a new city and navigate adult friendships on AFF.',
    keywords:
        'The Friendship Hub, how to make friends as an adult, platonic friendship guides, AFF friendship advice, App Store Trend of the Year Connection',
  ),
  seasonalGuides(
    path: '/seasonal-dating-guides',
    navGroup: 'Stories',
    breadcrumbLabel: 'Seasonal Dating Guides',
    title:
        'Seasonal Dating Guides — Winter, Spring & Summer Date Ideas | Aviaj',
    description:
        'Plan the perfect date—no matter when, where, or who you are dating. Explore Aviaj’s curated Winter, Spring, and Summer seasonal dating guides.',
    keywords:
        'Seasonal Dating Guides, winter date ideas, spring dating guide, summer romance tips, outdoor date ideas Aviaj',
  ),
  safety(
    path: '/safety',
    navGroup: 'Safety',
    breadcrumbLabel: 'Safety Center',
    title:
        'Aviaj Safety Center — Your Safety Comes First, Always | Verification & Safety Tools',
    description:
        'The Aviaj Safety Center guides you toward safe and meaningful connections with Photo & ID Verification, Private Detector, Deception Detector™, Share Date, and global safety partnerships.',
    keywords:
        'Aviaj Safety Center, Photo Verification, ID Verification badge, Deception Detector, Private Detector, Share Date, online dating safety handbook',
  ),
  support(
    path: '/support',
    navGroup: 'Support',
    breadcrumbLabel: 'Support Center',
    title:
        'Aviaj Support & Help Center — How Can We Help? | Account, Profile & Safety Guides',
    description:
        'Search Aviaj Support for answers about your account, connections, subscriptions, ID verification, troubleshooting, and safety resources.',
    keywords:
        'Aviaj Support, Aviaj Help Center, cancel subscription, verify ID on Aviaj, report someone, online dating help',
  ),
  appOnly(
    path: '/web-not-available',
    navGroup: 'Sign In',
    breadcrumbLabel: 'Get the Aviaj App',
    title:
        'Aviaj Is Now App-Only — Download Aviaj on the App Store & Google Play',
    description:
        'So we can keep bringing you the best experience and safety features, Aviaj is now app-only. Scan the QR code to download Aviaj on iOS or Android.',
    keywords:
        'Aviaj app download, Aviaj iOS app, Aviaj Android app, switch to Aviaj app, Aviaj QR code',
  );

  final String path;
  final String navGroup;
  final String breadcrumbLabel;
  final String title;
  final String description;
  final String keywords;

  const AviajSeoPage({
    required this.path,
    required this.navGroup,
    required this.breadcrumbLabel,
    required this.title,
    required this.description,
    required this.keywords,
  });

  String get canonicalUrl =>
      path == '/' ? 'https://aviaj.com/' : 'https://aviaj.com$path';

  String get jsonLdString {
    final schema = {
      '@context': 'https://schema.org',
      '@type': 'WebPage',
      'name': title,
      'description': description,
      'url': canonicalUrl,
      'isPartOf': {
        '@type': 'WebSite',
        'name': 'Aviaj',
        'url': 'https://aviaj.com/',
      },
      'breadcrumb': {
        '@type': 'BreadcrumbList',
        'itemListElement': [
          {
            '@type': 'ListItem',
            'position': 1,
            'name': 'Aviaj',
            'item': 'https://aviaj.com/',
          },
          if (this != AviajSeoPage.home)
            {
              '@type': 'ListItem',
              'position': 2,
              'name': breadcrumbLabel,
              'item': canonicalUrl,
            },
        ],
      },
    };
    return jsonEncode(schema);
  }

  static AviajSeoPage fromPath(String rawPath) {
    final cleaned = rawPath.trim().toLowerCase();
    final withoutTrailing = cleaned.length > 1 && cleaned.endsWith('/')
        ? cleaned.substring(0, cleaned.length - 1)
        : cleaned;
    switch (withoutTrailing) {
      case '':
      case '/':
      case '/index.html':
        return AviajSeoPage.home;
      case '/date':
      case '/explore-date':
        return AviajSeoPage.date;
      case '/date/compliments':
      case '/compliments':
        return AviajSeoPage.dateCompliments;
      case '/date/incognito-mode':
      case '/incognito-mode':
        return AviajSeoPage.dateIncognito;
      case '/date/video-calls':
      case '/video-calls':
        return AviajSeoPage.dateVideoCalls;
      case '/date/travel-mode':
      case '/travel-mode':
        return AviajSeoPage.dateTravelMode;
      case '/date/snooze-mode':
      case '/snooze-mode':
        return AviajSeoPage.dateSnoozeMode;
      case '/date/superswipe':
      case '/superswipe':
        return AviajSeoPage.dateSuperSwipe;
      case '/aff':
      case '/bff':
      case '/bff-us':
        return AviajSeoPage.aff;
      case '/aff/departure-plans':
      case '/departure-plans':
        return AviajSeoPage.affDeparturePlans;
      case '/aff/community-leaders':
      case '/community-leaders':
        return AviajSeoPage.affCommunityLeaders;
      case '/stories':
      case '/love-stories':
        return AviajSeoPage.stories;
      case '/friendship-hub':
      case '/stories/friendship-hub':
      case '/aff/friendship':
        return AviajSeoPage.friendshipHub;
      case '/seasonal-dating-guides':
      case '/stories/seasonal-dating-guides':
      case '/date/seasonal':
        return AviajSeoPage.seasonalGuides;
      case '/safety':
      case '/safety-center':
        return AviajSeoPage.safety;
      case '/support':
      case '/help':
      case '/hc':
        return AviajSeoPage.support;
      case '/web-not-available':
      case '/sign-in':
      case '/app-only':
        return AviajSeoPage.appOnly;
      default:
        return AviajSeoPage.home;
    }
  }
}

class SeoService {
  static AviajSeoPage detectInitialPage() => impl.detectInitialPage();

  static void applyPageSeo(AviajSeoPage page, {bool pushHistory = true}) {
    impl.applyPageSeo(page, pushHistory: pushHistory);
  }

  static void listenPopState(void Function(AviajSeoPage page) onRouteChanged) {
    impl.listenPopState(onRouteChanged);
  }
}

