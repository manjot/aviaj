import 'dart:ui' show PlatformDispatcher;
import '../models/models.dart';

/// Supported geographic regions for location-adaptive imagery and profiles.
enum AviajRegion {
  india(
    code: 'IN',
    flag: '🇮🇳',
    label: 'India',
    languageLabel: 'English (India)',
    sampleDestinations: 'Goa, Udaipur, and Ladakh',
    coPilotLocationHeader: 'Goa & Udaipur, IN ⌄',
  ),
  middleEast(
    code: 'AE',
    flag: '🇦🇪',
    label: 'Middle East',
    languageLabel: 'English (Middle East)',
    sampleDestinations: 'Dubai, AlUla, and Muscat',
    coPilotLocationHeader: 'Dubai Marina, AE ⌄',
  ),
  americas(
    code: 'US',
    flag: '🇺🇸',
    label: 'Americas',
    languageLabel: 'English (United States)',
    sampleDestinations: 'Big Sur, Tulum, and Maui',
    coPilotLocationHeader: 'Miami & Big Sur, US ⌄',
  ),
  europe(
    code: 'EU',
    flag: '🇪🇺',
    label: 'Europe',
    languageLabel: 'English (Europe)',
    sampleDestinations: 'Amalfi, Santorini, and Lisbon',
    coPilotLocationHeader: 'Amalfi Coast, IT ⌄',
  ),
  asiaPacific(
    code: 'APAC',
    flag: '🇯🇵',
    label: 'Asia-Pacific',
    languageLabel: 'English (Asia-Pacific)',
    sampleDestinations: 'Kyoto, Bali, and Jeju Island',
    coPilotLocationHeader: 'Kyoto & Bali ⌄',
  );

  final String code;
  final String flag;
  final String label;
  final String languageLabel;
  final String sampleDestinations;
  final String coPilotLocationHeader;

  const AviajRegion({
    required this.code,
    required this.flag,
    required this.label,
    required this.languageLabel,
    required this.sampleDestinations,
    required this.coPilotLocationHeader,
  });
}

/// Complete visual and editorial pack for a specific [AviajRegion].
class AviajRegionalContentPack {
  final AviajRegion region;
  final List<TravellerProfile> profiles;
  final List<({String imageUrl, String tag})> steppedCards;
  final String departureCirclePhotoUrl;
  final List<String> romanceVerifiedPortraitUrls;
  final String romancePhoneImageUrl;
  final String romancePhoneLabel;
  final String coPilotCrewImageUrl;
  final String coPilotPhoneImageUrl;
  final String coPilotPhoneLabel;
  final String storyQuote;
  final String storyAttribution;
  final String storyCoupleImageUrl;
  final List<String> fannedPhoneImageUrls;

  const AviajRegionalContentPack({
    required this.region,
    required this.profiles,
    required this.steppedCards,
    required this.departureCirclePhotoUrl,
    required this.romanceVerifiedPortraitUrls,
    required this.romancePhoneImageUrl,
    required this.romancePhoneLabel,
    required this.coPilotCrewImageUrl,
    required this.coPilotPhoneImageUrl,
    required this.coPilotPhoneLabel,
    required this.storyQuote,
    required this.storyAttribution,
    required this.storyCoupleImageUrl,
    required this.fannedPhoneImageUrls,
  });
}

class AviajRegionalCatalog {
  /// Automatically detects the visitor's region from timezone offset, timezone name, and system locale.
  /// - India (`UTC+5:30` / `IST` / `IN`) -> [AviajRegion.india]
  /// - Middle East (`UTC+3:00`..`UTC+4:00` / `AE`, `SA`, `QA`, etc.) -> [AviajRegion.middleEast]
  /// - Americas (`UTC-10:00`..`UTC-3:00` / `US`, `CA`, `MX`, `BR`) -> [AviajRegion.americas]
  /// - Asia-Pacific (`UTC+7:00`..`UTC+12:00` / `JP`, `SG`, `AU`, etc.) -> [AviajRegion.asiaPacific]
  /// - Europe (`UTC+0:00`..`UTC+2:00` / `GB`, `FR`, `DE`, `IT`, `ES`) -> [AviajRegion.europe]
  static AviajRegion detectVisitorRegion() {
    try {
      final now = DateTime.now();
      final offsetMinutes = now.timeZoneOffset.inMinutes;
      final tzName = now.timeZoneName.toUpperCase();
      final countryCode =
          (PlatformDispatcher.instance.locale.countryCode ?? '').toUpperCase();

      // 1. Check India first (IST = UTC+5:30 = 330 minutes, or IN locale)
      if (offsetMinutes == 330 ||
          offsetMinutes == 345 ||
          tzName.contains('IST') ||
          tzName.contains('INDIA') ||
          tzName.contains('KOLKATA') ||
          tzName.contains('CALCUTTA') ||
          countryCode == 'IN') {
        return AviajRegion.india;
      }

      // 2. Check Middle East (UTC+3 to UTC+4 = 180..240 minutes, or MENA country codes)
      const middleEastCodes = {
        'AE',
        'SA',
        'QA',
        'KW',
        'BH',
        'OM',
        'JO',
        'LB',
        'EG',
        'IQ',
      };
      if (middleEastCodes.contains(countryCode) ||
          (offsetMinutes >= 180 && offsetMinutes <= 240)) {
        return AviajRegion.middleEast;
      }

      // 3. Check Americas (Western Hemisphere negative UTC offsets or Americas country codes)
      const americasCodes = {
        'US',
        'CA',
        'MX',
        'BR',
        'AR',
        'CO',
        'CL',
        'PE',
      };
      if (americasCodes.contains(countryCode) || offsetMinutes < 0) {
        return AviajRegion.americas;
      }

      // 4. Check Asia-Pacific (UTC+7 to UTC+12)
      const apacCodes = {
        'JP',
        'SG',
        'KR',
        'TH',
        'ID',
        'MY',
        'PH',
        'VN',
        'AU',
        'NZ',
        'HK',
        'TW',
      };
      if (apacCodes.contains(countryCode) || offsetMinutes >= 420) {
        return AviajRegion.asiaPacific;
      }

      // 5. Default to Europe for UTC+0..UTC+2
      return AviajRegion.europe;
    } catch (_) {
      return AviajRegion.india;
    }
  }

  static AviajRegionalContentPack packFor(AviajRegion region) {
    switch (region) {
      case AviajRegion.india:
        return _indiaPack;
      case AviajRegion.middleEast:
        return _middleEastPack;
      case AviajRegion.americas:
        return _americasPack;
      case AviajRegion.europe:
        return _europePack;
      case AviajRegion.asiaPacific:
        return _asiaPacificPack;
    }
  }

  // ===========================================================================
  // 1. INDIA REGION PACK (🇮🇳 Authentic Indian Portraits, Names & Destinations)
  // ===========================================================================
  static const AviajRegionalContentPack _indiaPack = AviajRegionalContentPack(
    region: AviajRegion.india,
    profiles: [
      TravellerProfile(
        id: 'p1',
        name: 'Ananya Sharma',
        age: 26,
        gender: 'Woman',
        occupation: 'Architecture Curator & Filmmaker',
        homeCity: 'Mumbai',
        countryFlag: '🇮🇳',
        bio:
            'Chasing heritage palace sunsets in Udaipur and coastal coffee mornings in Goa. Looking for a warm, travel-loving partner whose suitcase is always ready for the next long weekend.',
        primaryIntent: ConnectionIntent.longTermPartner,
        intents: [
          ConnectionIntent.longTermPartner,
          ConnectionIntent.travelBuddy,
        ],
        travelStyles: [
          TravelStyle.foodieCulture,
          TravelStyle.boutiqueLuxury,
          TravelStyle.islandHopper,
        ],
        nextDestination: 'Udaipur & Goa Coastline',
        nextTripWindow: 'Nov 14 – Nov 24',
        budgetTier: r'$$',
        languages: ['English', 'Hindi', 'Marathi'],
        bucketList: [
          'Lake Pichola private sunset boat in Udaipur',
          'Shikara stay on Dal Lake, Kashmir',
          'Scuba diving in Havelock, Andaman',
        ],
        prompts: [
          ProfilePrompt(
            question: 'My ideal first travel date is...',
            answer:
                'Filter coffee in Fontainhas, Goa followed by a scooter ride to a hidden sunset cliff in Cabo de Rama.',
          ),
        ],
        imageUrl:
            'https://images.pexels.com/photos/15026763/pexels-photo-15026763.jpeg?auto=compress&cs=tinysrgb&w=900',
        galleryUrls: [
          'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?auto=format&fit=crop&w=900&q=80',
        ],
        isVerified: true,
        countriesVisited: 14,
        sleepSchedule: 'Night Owl',
        baseCompatibility: 97,
      ),
      TravellerProfile(
        id: 'p2',
        name: 'Rohan Verma',
        age: 28,
        gender: 'Man',
        occupation: 'AI Product Lead & Mountaineer',
        homeCity: 'Bengaluru',
        countryFlag: '🇮🇳',
        bio:
            'Planning a roadtrip across Ladakh & Pangong Tso. Open to meeting my forever adventure partner or a spontaneous travel co-pilot who loves mountain cafés.',
        primaryIntent: ConnectionIntent.longTermPartner,
        intents: [
          ConnectionIntent.longTermPartner,
          ConnectionIntent.shortTermDating,
          ConnectionIntent.travelBuddy,
        ],
        travelStyles: [
          TravelStyle.adventureTrek,
          TravelStyle.roadTripper,
          TravelStyle.digitalNomad,
        ],
        nextDestination: 'Leh, Nubra & Pangong, Ladakh',
        nextTripWindow: 'Nov 18 – Nov 29',
        budgetTier: r'$$',
        languages: ['English', 'Hindi', 'Kannada'],
        bucketList: [
          'Stargazing at Hanle Dark Sky Reserve',
          'Spiti Valley winter expedition',
          'Surfing in Mulki & Varkala',
        ],
        prompts: [
          ProfilePrompt(
            question: 'Together we could...',
            answer:
                'Drive across Khardung La at dawn and share hot Maggi and kahwa at 17,000 feet.',
          ),
        ],
        imageUrl:
            'https://images.pexels.com/photos/18360995/pexels-photo-18360995.jpeg?auto=compress&cs=tinysrgb&w=900',
        galleryUrls: [
          'https://images.pexels.com/photos/2897507/pexels-photo-2897507.jpeg?auto=compress&cs=tinysrgb&w=900',
        ],
        isVerified: true,
        countriesVisited: 16,
        sleepSchedule: 'Early Bird',
        baseCompatibility: 95,
      ),
      TravellerProfile(
        id: 'p3',
        name: 'Kavya Nair',
        age: 25,
        gender: 'Woman',
        occupation: 'Fashion Stylist & Ceramicist',
        homeCity: 'New Delhi',
        countryFlag: '🇮🇳',
        bio:
            'Boutique havelis in Jaipur by day, rooftop sufi nights by evening. Looking for a romantic vacation spark or a creative co-pilot for Rajasthan & Rishikesh.',
        primaryIntent: ConnectionIntent.shortTermDating,
        intents: [
          ConnectionIntent.shortTermDating,
          ConnectionIntent.longTermPartner,
        ],
        travelStyles: [
          TravelStyle.boutiqueLuxury,
          TravelStyle.foodieCulture,
          TravelStyle.nightlifeSocial,
        ],
        nextDestination: 'Jaipur & Jaisalmer, Rajasthan',
        nextTripWindow: 'Nov 16 – Nov 25',
        budgetTier: r'$$$',
        languages: ['English', 'Hindi', 'Malayalam'],
        bucketList: [
          'Hot air balloon over Amber Fort',
          'Thar Desert luxury camp under the stars',
          'Ganga Aarti in Rishikesh',
        ],
        prompts: [
          ProfilePrompt(
            question: 'Way to win my heart on a trip...',
            answer:
                'Golden hour portraits in old city courtyards and knowing where to find the best kulhad chai.',
          ),
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?auto=format&fit=crop&w=900&q=80',
        galleryUrls: [
          'https://images.pexels.com/photos/16605844/pexels-photo-16605844.jpeg?auto=compress&cs=tinysrgb&w=900',
        ],
        isVerified: true,
        countriesVisited: 12,
        sleepSchedule: 'Night Owl',
        baseCompatibility: 94,
      ),
      TravellerProfile(
        id: 'p4',
        name: 'Kabir Malhotra',
        age: 29,
        gender: 'Man',
        occupation: 'Fintech Founder & Sailor',
        homeCity: 'Mumbai',
        countryFlag: '🇮🇳',
        bio:
            'Hosting a 6-person coastal villa crew in South Goa & Varkala. Join for surf mornings, houseboats in Alleppey, and sunset sundowners.',
        primaryIntent: ConnectionIntent.soloGroupSquad,
        intents: [
          ConnectionIntent.soloGroupSquad,
          ConnectionIntent.travelBuddy,
          ConnectionIntent.longTermPartner,
        ],
        travelStyles: [
          TravelStyle.islandHopper,
          TravelStyle.boutiqueLuxury,
          TravelStyle.roadTripper,
        ],
        nextDestination: 'Varkala Cliffs & Alleppey Backwaters',
        nextTripWindow: 'Nov 20 – Dec 01',
        budgetTier: r'$$',
        languages: ['English', 'Hindi', 'Punjabi'],
        bucketList: [
          'Private houseboat cruise in Kerala',
          'Yacht sailing off Mumbai harbour',
          'Coorg coffee estate retreat',
        ],
        prompts: [
          ProfilePrompt(
            question: 'Why I love solo-group trips...',
            answer:
                'You board in Mumbai as strangers and return from Kerala with lifelong friends.',
          ),
        ],
        imageUrl:
            'https://images.pexels.com/photos/2897507/pexels-photo-2897507.jpeg?auto=compress&cs=tinysrgb&w=900',
        galleryUrls: [
          'https://images.pexels.com/photos/18360995/pexels-photo-18360995.jpeg?auto=compress&cs=tinysrgb&w=900',
        ],
        isVerified: true,
        countriesVisited: 21,
        sleepSchedule: 'Flexible',
        baseCompatibility: 92,
      ),
      TravellerProfile(
        id: 'p5',
        name: 'Meera Iyer',
        age: 27,
        gender: 'Woman',
        occupation: 'Classical Dancer & UX Researcher',
        homeCity: 'Chennai / Bengaluru',
        countryFlag: '🇮🇳',
        bio:
            'Happiest walking through French Quarter cafés in Pondicherry or misty tea gardens in Munnar. Seeking a genuine long-term relationship built on shared curiosity.',
        primaryIntent: ConnectionIntent.longTermPartner,
        intents: [
          ConnectionIntent.longTermPartner,
          ConnectionIntent.travelBuddy,
        ],
        travelStyles: [
          TravelStyle.foodieCulture,
          TravelStyle.islandHopper,
          TravelStyle.digitalNomad,
        ],
        nextDestination: 'Pondicherry & Munnar Hills',
        nextTripWindow: 'Nov 22 – Dec 03',
        budgetTier: r'$$',
        languages: ['English', 'Tamil', 'Hindi'],
        bucketList: [
          'Sunrise kayak in Havelock mangroves',
          'Nilgiri Mountain Railway toy train',
          'Hampi boulder sunset session',
        ],
        prompts: [
          ProfilePrompt(
            question: 'Looking for a relationship that feels like...',
            answer:
                'Long coastal drives along ECR with Ilaiyaraaja and A.R. Rahman playing as the sun hits the Bay of Bengal.',
          ),
        ],
        imageUrl:
            'https://images.pexels.com/photos/16605844/pexels-photo-16605844.jpeg?auto=compress&cs=tinysrgb&w=900',
        galleryUrls: [
          'https://images.pexels.com/photos/15026763/pexels-photo-15026763.jpeg?auto=compress&cs=tinysrgb&w=900',
        ],
        isVerified: true,
        countriesVisited: 15,
        sleepSchedule: 'Early Bird',
        baseCompatibility: 93,
      ),
      TravellerProfile(
        id: 'p6',
        name: 'Vikram Rathore',
        age: 30,
        gender: 'Man',
        occupation: 'Wildlife Photographer',
        homeCity: 'Jaipur',
        countryFlag: '🇮🇳',
        bio:
            'Tracking tigers in Ranthambore and starry skies in Spiti. Looking for a fearless co-pilot who loves boutique jungle lodges and off-grid roadtrips.',
        primaryIntent: ConnectionIntent.travelBuddy,
        intents: [
          ConnectionIntent.travelBuddy,
          ConnectionIntent.longTermPartner,
        ],
        travelStyles: [
          TravelStyle.adventureTrek,
          TravelStyle.roadTripper,
          TravelStyle.boutiqueLuxury,
        ],
        nextDestination: 'Ranthambore & Jawai Leopard Hills',
        nextTripWindow: 'Dec 01 – Dec 10',
        budgetTier: r'$$$',
        languages: ['English', 'Hindi'],
        bucketList: [
          'Jawai granite hills leopard safari',
          'Kaziranga misty dawn expedition',
          'Zanskar frozen river trek',
        ],
        prompts: [
          ProfilePrompt(
            question: 'Green flag in a travel buddy...',
            answer:
                'Wakes up happily for a 5:30 AM safari drive and loves campfire conversations.',
          ),
        ],
        imageUrl:
            'https://images.unsplash.com/flagged/photo-1571367034809-ba7669187028?auto=format&fit=crop&w=900&q=80',
        galleryUrls: [
          'https://images.pexels.com/photos/938639/pexels-photo-938639.jpeg?auto=compress&cs=tinysrgb&w=900',
        ],
        isVerified: true,
        countriesVisited: 19,
        sleepSchedule: 'Early Bird',
        baseCompatibility: 90,
      ),
      TravellerProfile(
        id: 'p7',
        name: 'Diya Chatterjee',
        age: 24,
        gender: 'Woman',
        occupation: 'Indie Musician & Travel Writer',
        homeCity: 'Kolkata',
        countryFlag: '🇮🇳',
        bio:
            'Timber heritage cafés in Darjeeling andliving-root bridges in Meghalaya. Looking for a romantic partner or musical travel buddy.',
        primaryIntent: ConnectionIntent.longTermPartner,
        intents: [
          ConnectionIntent.longTermPartner,
          ConnectionIntent.shortTermDating,
        ],
        travelStyles: [
          TravelStyle.foodieCulture,
          TravelStyle.adventureTrek,
          TravelStyle.backpacker,
        ],
        nextDestination: 'Darjeeling, Sikkim & Shillong',
        nextTripWindow: 'Dec 04 – Dec 14',
        budgetTier: r'$$',
        languages: ['English', 'Bengali', 'Hindi'],
        bucketList: [
          'Kanchenjunga sunrise from Tiger Hill',
          'Dawki crystal river boat ride in Meghalaya',
          'Ziro Festival of Music in Arunachal',
        ],
        prompts: [
          ProfilePrompt(
            question: 'We’ll get along if...',
            answer:
                'You love mountain bookshops, warm momos in the clouds, and spontaneous acoustic sessions.',
          ),
        ],
        imageUrl:
            'https://images.pexels.com/photos/1684724/pexels-photo-1684724.jpeg?auto=compress&cs=tinysrgb&w=900',
        galleryUrls: [
          'https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&w=900&q=80',
        ],
        isVerified: true,
        countriesVisited: 11,
        sleepSchedule: 'Night Owl',
        baseCompatibility: 96,
      ),
    ],
    steppedCards: [
      (
        imageUrl:
            'https://images.pexels.com/photos/15026763/pexels-photo-15026763.jpeg?auto=compress&cs=tinysrgb&w=900',
        tag: 'Outdoors',
      ),
      (
        imageUrl:
            'https://images.pexels.com/photos/18360995/pexels-photo-18360995.jpeg?auto=compress&cs=tinysrgb&w=900',
        tag: 'Roadtrips',
      ),
      (
        imageUrl:
            'https://images.pexels.com/photos/16605844/pexels-photo-16605844.jpeg?auto=compress&cs=tinysrgb&w=900',
        tag: 'Island hopper',
      ),
    ],
    departureCirclePhotoUrl:
        'https://images.pexels.com/photos/18620592/pexels-photo-18620592.jpeg?auto=compress&cs=tinysrgb&w=1000',
    romanceVerifiedPortraitUrls: [
      'https://images.pexels.com/photos/16605844/pexels-photo-16605844.jpeg?auto=compress&cs=tinysrgb&w=500',
      'https://images.pexels.com/photos/18360995/pexels-photo-18360995.jpeg?auto=compress&cs=tinysrgb&w=500',
      'https://images.pexels.com/photos/2897507/pexels-photo-2897507.jpeg?auto=compress&cs=tinysrgb&w=500',
      'https://images.pexels.com/photos/1684724/pexels-photo-1684724.jpeg?auto=compress&cs=tinysrgb&w=500',
    ],
    romancePhoneImageUrl:
        'https://images.pexels.com/photos/15026763/pexels-photo-15026763.jpeg?auto=compress&cs=tinysrgb&w=800',
    romancePhoneLabel: 'Ananya, 26',
    coPilotCrewImageUrl:
        'https://images.pexels.com/photos/2174662/pexels-photo-2174662.jpeg?auto=compress&cs=tinysrgb&w=800',
    coPilotPhoneImageUrl:
        'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?auto=format&fit=crop&w=800&q=80',
    coPilotPhoneLabel: 'Kavya, 25',
    storyQuote:
        'We are both naturally spontaneous solo travellers, but when our Udaipur and Goa itineraries matched on Aviaj, it felt like there was no horizon we couldn’t explore.',
    storyAttribution: 'Ananya & Rohan, engaged in Udaipur 2026',
    storyCoupleImageUrl:
        'https://images.pexels.com/photos/18620592/pexels-photo-18620592.jpeg?auto=compress&cs=tinysrgb&w=1000',
    fannedPhoneImageUrls: [
      'https://images.pexels.com/photos/16605844/pexels-photo-16605844.jpeg?auto=compress&cs=tinysrgb&w=700',
      'https://images.pexels.com/photos/15026763/pexels-photo-15026763.jpeg?auto=compress&cs=tinysrgb&w=800',
      'https://images.pexels.com/photos/18360995/pexels-photo-18360995.jpeg?auto=compress&cs=tinysrgb&w=700',
    ],
  );

  // ===========================================================================
  // 2. MIDDLE EAST REGION PACK (🇦🇪 Authentic Middle Eastern Portraits & Routes)
  // ===========================================================================
  static const AviajRegionalContentPack _middleEastPack =
      AviajRegionalContentPack(
    region: AviajRegion.middleEast,
    profiles: [
      TravellerProfile(
        id: 'p1',
        name: 'Layla Al-Mansoor',
        age: 26,
        gender: 'Woman',
        occupation: 'Art Gallery Director',
        homeCity: 'Dubai',
        countryFlag: '🇦🇪',
        bio:
            'Desert stargazing in AlUla and coastal dhow cruises in Muscat. Looking for a warm, respectful long-term partner to explore the Middle East and Mediterranean together.',
        primaryIntent: ConnectionIntent.longTermPartner,
        intents: [
          ConnectionIntent.longTermPartner,
          ConnectionIntent.travelBuddy,
        ],
        travelStyles: [
          TravelStyle.boutiqueLuxury,
          TravelStyle.foodieCulture,
          TravelStyle.islandHopper,
        ],
        nextDestination: 'AlUla & Red Sea Coast',
        nextTripWindow: 'Nov 14 – Nov 23',
        budgetTier: r'$$$',
        languages: ['Arabic', 'English', 'French'],
        bucketList: [
          'Mirror concert hall in Maraya, AlUla',
          'Private dhow cruise in Musandam fjords',
          'Hot air balloon over Wadi Rum',
        ],
        prompts: [
          ProfilePrompt(
            question: 'My ideal first travel date is...',
            answer:
                'Arabic coffee at Alserkal Avenue followed by a sunset drive to Bab Al Shams desert dunes.',
          ),
        ],
        imageUrl:
            'https://images.pexels.com/photos/17505373/pexels-photo-17505373/free-photo-of-portrait-of-woman-in-hijab.jpeg?auto=compress&cs=tinysrgb&w=900',
        galleryUrls: [
          'https://images.pexels.com/photos/8995940/pexels-photo-8995940.jpeg?auto=compress&cs=tinysrgb&w=900',
        ],
        isVerified: true,
        countriesVisited: 26,
        sleepSchedule: 'Night Owl',
        baseCompatibility: 97,
      ),
      TravellerProfile(
        id: 'p2',
        name: 'Tariq Al-Harbi',
        age: 29,
        gender: 'Man',
        occupation: 'Clean-Tech Architect & Falconer',
        homeCity: 'Riyadh',
        countryFlag: '🇸🇦',
        bio:
            'Exploring Red Sea coral reefs and Jabal Akhdar canyon trails. Looking for an adventurous partner or travel co-pilot who loves desert roadtrips.',
        primaryIntent: ConnectionIntent.longTermPartner,
        intents: [
          ConnectionIntent.longTermPartner,
          ConnectionIntent.travelBuddy,
        ],
        travelStyles: [
          TravelStyle.adventureTrek,
          TravelStyle.roadTripper,
          TravelStyle.boutiqueLuxury,
        ],
        nextDestination: 'Jabal Akhdar & Muscat, Oman',
        nextTripWindow: 'Nov 18 – Nov 28',
        budgetTier: r'$$$',
        languages: ['Arabic', 'English'],
        bucketList: [
          'Edge of the World sunset SUV expedition',
          'Diving the Red Sea coral archipelagos',
          'Petra by candlelight',
        ],
        prompts: [
          ProfilePrompt(
            question: 'Together we could...',
            answer:
                'Camp under a billion desert stars in Wadi Rum with Bedouin tea and zero city noise.',
          ),
        ],
        imageUrl:
            'https://images.pexels.com/photos/10861771/pexels-photo-10861771.jpeg?auto=compress&cs=tinysrgb&w=900',
        galleryUrls: [
          'https://images.pexels.com/photos/33853465/pexels-photo-33853465/free-photo-of-portrait-of-man-in-traditional-middle-eastern-attire.jpeg?auto=compress&cs=tinysrgb&w=900',
        ],
        isVerified: true,
        countriesVisited: 24,
        sleepSchedule: 'Early Bird',
        baseCompatibility: 95,
      ),
      TravellerProfile(
        id: 'p3',
        name: 'Noor Haddad',
        age: 25,
        gender: 'Woman',
        occupation: 'Interior Designer & Photographer',
        homeCity: 'Abu Dhabi / Amman',
        countryFlag: '🇯🇴',
        bio:
            'From Saadiyat Island museums to rose-red canyons in Petra. Open to meaningful romance and curated group departures.',
        primaryIntent: ConnectionIntent.shortTermDating,
        intents: [
          ConnectionIntent.shortTermDating,
          ConnectionIntent.longTermPartner,
        ],
        travelStyles: [
          TravelStyle.foodieCulture,
          TravelStyle.boutiqueLuxury,
          TravelStyle.roadTripper,
        ],
        nextDestination: 'Petra & Aqaba Red Sea',
        nextTripWindow: 'Nov 20 – Nov 30',
        budgetTier: r'$$',
        languages: ['Arabic', 'English'],
        bucketList: [
          'Floating in the Dead Sea at sunrise',
          'Souq Waqif spice & art walk in Doha',
          'Byblos harbour sunset dinner',
        ],
        prompts: [
          ProfilePrompt(
            question: 'Way to win my heart on a trip...',
            answer:
                'Warm knafeh in Old Amman and spontaneous detours to scenic mountain viewpoints.',
          ),
        ],
        imageUrl:
            'https://images.pexels.com/photos/8995940/pexels-photo-8995940.jpeg?auto=compress&cs=tinysrgb&w=900',
        galleryUrls: [
          'https://images.pexels.com/photos/10617181/pexels-photo-10617181.jpeg?auto=compress&cs=tinysrgb&w=900',
        ],
        isVerified: true,
        countriesVisited: 19,
        sleepSchedule: 'Night Owl',
        baseCompatibility: 94,
      ),
      TravellerProfile(
        id: 'p4',
        name: 'Omar Al-Thani',
        age: 31,
        gender: 'Man',
        occupation: 'Aviation Strategist',
        homeCity: 'Doha',
        countryFlag: '🇶🇦',
        bio:
            'Organizing a 6-person desert & yacht expedition across Doha, Dubai Marina, and Salalah. Join our Departure Circle!',
        primaryIntent: ConnectionIntent.soloGroupSquad,
        intents: [
          ConnectionIntent.soloGroupSquad,
          ConnectionIntent.travelBuddy,
        ],
        travelStyles: [
          TravelStyle.islandHopper,
          TravelStyle.boutiqueLuxury,
          TravelStyle.roadTripper,
        ],
        nextDestination: 'Salalah & Muscat Coast',
        nextTripWindow: 'Dec 02 – Dec 11',
        budgetTier: r'$$$',
        languages: ['Arabic', 'English'],
        bucketList: [
          'Khor Al Adaid inland sea dune bashing',
          'Yacht week around The Pearl & Dubai',
          'Socotra island expedition',
        ],
        prompts: [
          ProfilePrompt(
            question: 'Ideal co-travel routine...',
            answer:
                'Morning sea kayak, afternoon museum hop, and grilled seafood by the marina.',
          ),
        ],
        imageUrl:
            'https://images.pexels.com/photos/33853465/pexels-photo-33853465/free-photo-of-portrait-of-man-in-traditional-middle-eastern-attire.jpeg?auto=compress&cs=tinysrgb&w=900',
        galleryUrls: [
          'https://images.pexels.com/photos/10861771/pexels-photo-10861771.jpeg?auto=compress&cs=tinysrgb&w=900',
        ],
        isVerified: true,
        countriesVisited: 32,
        sleepSchedule: 'Flexible',
        baseCompatibility: 91,
      ),
      TravellerProfile(
        id: 'p5',
        name: 'Yasmin Khoury',
        age: 27,
        gender: 'Woman',
        occupation: 'Culinary Storyteller',
        homeCity: 'Beirut / Dubai',
        countryFlag: '🇱🇧',
        bio:
            'Mediterranean coastal breezes and Levantine feasts. Seeking a romantic co-pilot who loves boutique stays and vibrant culture.',
        primaryIntent: ConnectionIntent.longTermPartner,
        intents: [
          ConnectionIntent.longTermPartner,
          ConnectionIntent.shortTermDating,
        ],
        travelStyles: [
          TravelStyle.foodieCulture,
          TravelStyle.islandHopper,
          TravelStyle.boutiqueLuxury,
        ],
        nextDestination: 'Batroun & Cyprus Coast',
        nextTripWindow: 'Dec 04 – Dec 14',
        budgetTier: r'$$',
        languages: ['Arabic', 'French', 'English'],
        bucketList: [
          'Cedars of God winter snow trek',
          'Nile dahabiya sail from Luxor to Aswan',
          'Chefchaouen blue alleys in Morocco',
        ],
        prompts: [
          ProfilePrompt(
            question: 'We’ll get along if...',
            answer:
                'You never skip mezze by the sea and love discovering historic souqs together.',
          ),
        ],
        imageUrl:
            'https://images.pexels.com/photos/10617181/pexels-photo-10617181.jpeg?auto=compress&cs=tinysrgb&w=900',
        galleryUrls: [
          'https://images.pexels.com/photos/17505373/pexels-photo-17505373/free-photo-of-portrait-of-woman-in-hijab.jpeg?auto=compress&cs=tinysrgb&w=900',
        ],
        isVerified: true,
        countriesVisited: 23,
        sleepSchedule: 'Night Owl',
        baseCompatibility: 96,
      ),
    ],
    steppedCards: [
      (
        imageUrl:
            'https://images.pexels.com/photos/17505373/pexels-photo-17505373/free-photo-of-portrait-of-woman-in-hijab.jpeg?auto=compress&cs=tinysrgb&w=900',
        tag: 'Outdoors',
      ),
      (
        imageUrl:
            'https://images.pexels.com/photos/10861771/pexels-photo-10861771.jpeg?auto=compress&cs=tinysrgb&w=900',
        tag: 'Roadtrips',
      ),
      (
        imageUrl:
            'https://images.pexels.com/photos/8995940/pexels-photo-8995940.jpeg?auto=compress&cs=tinysrgb&w=900',
        tag: 'Island hopper',
      ),
    ],
    departureCirclePhotoUrl:
        'https://images.pexels.com/photos/8575739/pexels-photo-8575739.jpeg?auto=compress&cs=tinysrgb&w=1000',
    romanceVerifiedPortraitUrls: [
      'https://images.pexels.com/photos/8995940/pexels-photo-8995940.jpeg?auto=compress&cs=tinysrgb&w=500',
      'https://images.pexels.com/photos/10861771/pexels-photo-10861771.jpeg?auto=compress&cs=tinysrgb&w=500',
      'https://images.pexels.com/photos/33853465/pexels-photo-33853465/free-photo-of-portrait-of-man-in-traditional-middle-eastern-attire.jpeg?auto=compress&cs=tinysrgb&w=500',
      'https://images.pexels.com/photos/10617181/pexels-photo-10617181.jpeg?auto=compress&cs=tinysrgb&w=500',
    ],
    romancePhoneImageUrl:
        'https://images.pexels.com/photos/17505373/pexels-photo-17505373/free-photo-of-portrait-of-woman-in-hijab.jpeg?auto=compress&cs=tinysrgb&w=800',
    romancePhoneLabel: 'Layla, 26',
    coPilotCrewImageUrl:
        'https://images.pexels.com/photos/4046512/pexels-photo-4046512.jpeg?auto=compress&cs=tinysrgb&w=800',
    coPilotPhoneImageUrl:
        'https://images.pexels.com/photos/8995940/pexels-photo-8995940.jpeg?auto=compress&cs=tinysrgb&w=800',
    coPilotPhoneLabel: 'Noor, 25',
    storyQuote:
        'We are both naturally spontaneous solo travellers, but when our Dubai and AlUla itineraries matched on Aviaj, it felt like there was no horizon we couldn’t explore.',
    storyAttribution: 'Layla & Tariq, engaged in AlUla 2026',
    storyCoupleImageUrl:
        'https://images.pexels.com/photos/8575739/pexels-photo-8575739.jpeg?auto=compress&cs=tinysrgb&w=1000',
    fannedPhoneImageUrls: [
      'https://images.pexels.com/photos/8995940/pexels-photo-8995940.jpeg?auto=compress&cs=tinysrgb&w=700',
      'https://images.pexels.com/photos/17505373/pexels-photo-17505373/free-photo-of-portrait-of-woman-in-hijab.jpeg?auto=compress&cs=tinysrgb&w=800',
      'https://images.pexels.com/photos/10861771/pexels-photo-10861771.jpeg?auto=compress&cs=tinysrgb&w=700',
    ],
  );

  // ===========================================================================
  // 3. AMERICAS REGION PACK (🇺🇸 Authentic American Portraits & Routes)
  // ===========================================================================
  static const AviajRegionalContentPack _americasPack =
      AviajRegionalContentPack(
    region: AviajRegion.americas,
    profiles: [
      TravellerProfile(
        id: 'p1',
        name: 'Madison Brooks',
        age: 27,
        gender: 'Woman',
        occupation: 'Creative Producer & Surfer',
        homeCity: 'New York / Los Angeles',
        countryFlag: '🇺🇸',
        bio:
            'Pacific Coast Highway convertible drives, red-rock sunrises in Sedona, and weekend flights to Maui. Looking for a long-term romantic co-pilot.',
        primaryIntent: ConnectionIntent.longTermPartner,
        intents: [
          ConnectionIntent.longTermPartner,
          ConnectionIntent.travelBuddy,
        ],
        travelStyles: [
          TravelStyle.roadTripper,
          TravelStyle.islandHopper,
          TravelStyle.foodieCulture,
        ],
        nextDestination: 'Big Sur & Maui, Hawaii',
        nextTripWindow: 'Nov 15 – Nov 26',
        budgetTier: r'$$',
        languages: ['English', 'Spanish'],
        bucketList: [
          'Roadtrip Highway 1 from Monterey to Big Sur',
          'Road to Hana waterfall swim in Maui',
          'Airstream glamping in Joshua Tree',
        ],
        prompts: [
          ProfilePrompt(
            question: 'My ideal first travel date is...',
            answer:
                'Tacos on a Malibu pier at sunset followed by a coastal drive with a great indie playlist.',
          ),
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?auto=format&fit=crop&w=900&q=80',
        galleryUrls: [
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=900&q=80',
        ],
        isVerified: true,
        countriesVisited: 21,
        sleepSchedule: 'Night Owl',
        baseCompatibility: 96,
      ),
      TravellerProfile(
        id: 'p2',
        name: 'Marcus Vance',
        age: 28,
        gender: 'Man',
        occupation: 'Music Tech Founder',
        homeCity: 'Atlanta / Miami',
        countryFlag: '🇺🇸',
        bio:
            'Jetting between Miami art weeks, Tulum beach villas, and Aspen ski runs. Open to a genuine romantic connection or spontaneous travel crew.',
        primaryIntent: ConnectionIntent.longTermPartner,
        intents: [
          ConnectionIntent.longTermPartner,
          ConnectionIntent.shortTermDating,
        ],
        travelStyles: [
          TravelStyle.boutiqueLuxury,
          TravelStyle.nightlifeSocial,
          TravelStyle.islandHopper,
        ],
        nextDestination: 'Miami Beach & Tulum',
        nextTripWindow: 'Nov 18 – Nov 28',
        budgetTier: r'$$$',
        languages: ['English'],
        bucketList: [
          'Private cenote dive in Tulum',
          'Catamaran charter in the Bahamas',
          'Powder skiing in Aspen Snowmass',
        ],
        prompts: [
          ProfilePrompt(
            question: 'Together we could...',
            answer:
                'Book a last-minute Friday flight to the Caribbean and work from a beachfront cabana on Monday.',
          ),
        ],
        imageUrl:
            'https://images.pexels.com/photos/936119/pexels-photo-936119.jpeg?auto=compress&cs=tinysrgb&w=900',
        galleryUrls: [
          'https://images.unsplash.com/photo-1566492031773-4f4e44671857?auto=format&fit=crop&w=900&q=80',
        ],
        isVerified: true,
        countriesVisited: 25,
        sleepSchedule: 'Night Owl',
        baseCompatibility: 95,
      ),
      TravellerProfile(
        id: 'p3',
        name: 'Chloe Miller',
        age: 25,
        gender: 'Woman',
        occupation: 'Brand Strategist & Yogi',
        homeCity: 'Austin',
        countryFlag: '🇺🇸',
        bio:
            'Live music in Austin, red-rock trails in Moab, and surf weeks in Costa Rica. Looking for a warm travel buddy or romantic spark.',
        primaryIntent: ConnectionIntent.shortTermDating,
        intents: [
          ConnectionIntent.shortTermDating,
          ConnectionIntent.travelBuddy,
        ],
        travelStyles: [
          TravelStyle.adventureTrek,
          TravelStyle.roadTripper,
          TravelStyle.foodieCulture,
        ],
        nextDestination: 'Sedona & Grand Canyon, AZ',
        nextTripWindow: 'Nov 20 – Nov 29',
        budgetTier: r'$$',
        languages: ['English', 'Spanish'],
        bucketList: [
          'Hot air balloon over Sedona red rocks',
          'Zion Narrows canyon hike',
          'Santa Teresa surf camp in Costa Rica',
        ],
        prompts: [
          ProfilePrompt(
            question: 'Green flag in a travel buddy...',
            answer:
                'Always down for a sunrise viewpoint hike and knows the best local coffee roasters.',
          ),
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=900&q=80',
        galleryUrls: [
          'https://images.unsplash.com/photo-1607746882042-944635dfe10e?auto=format&fit=crop&w=900&q=80',
        ],
        isVerified: true,
        countriesVisited: 17,
        sleepSchedule: 'Early Bird',
        baseCompatibility: 93,
      ),
      TravellerProfile(
        id: 'p4',
        name: 'Tyler Reed',
        age: 29,
        gender: 'Man',
        occupation: 'Aerospace Engineer & Skier',
        homeCity: 'Denver',
        countryFlag: '🇺🇸',
        bio:
            'Leading a 6-person mountain & lake lodge trip to Banff and Lake Tahoe. Come hike, paddleboard, and share cabin dinners!',
        primaryIntent: ConnectionIntent.soloGroupSquad,
        intents: [
          ConnectionIntent.soloGroupSquad,
          ConnectionIntent.travelBuddy,
        ],
        travelStyles: [
          TravelStyle.adventureTrek,
          TravelStyle.roadTripper,
          TravelStyle.backpacker,
        ],
        nextDestination: 'Banff & Lake Louise',
        nextTripWindow: 'Dec 01 – Dec 10',
        budgetTier: r'$$',
        languages: ['English'],
        bucketList: [
          'Canoeing turquoise Moraine Lake',
          'Yosemite Half Dome cables',
          'Patagonia overland trek',
        ],
        prompts: [
          ProfilePrompt(
            question: 'Why I love solo-group trips...',
            answer:
                'Nothing bonds a crew faster than a mountain roadtrip and campfire s’mores.',
          ),
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1566492031773-4f4e44671857?auto=format&fit=crop&w=900&q=80',
        galleryUrls: [
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=900&q=80',
        ],
        isVerified: true,
        countriesVisited: 20,
        sleepSchedule: 'Early Bird',
        baseCompatibility: 91,
      ),
      TravellerProfile(
        id: 'p5',
        name: 'Brianna Carter',
        age: 26,
        gender: 'Woman',
        occupation: 'Broadcast Journalist',
        homeCity: 'Chicago / Miami',
        countryFlag: '🇺🇸',
        bio:
            'Rooftop jazz in Chicago, sailing in Key West, and vineyard weekends in Napa Valley. Ready to meet my person.',
        primaryIntent: ConnectionIntent.longTermPartner,
        intents: [
          ConnectionIntent.longTermPartner,
          ConnectionIntent.shortTermDating,
        ],
        travelStyles: [
          TravelStyle.foodieCulture,
          TravelStyle.boutiqueLuxury,
          TravelStyle.islandHopper,
        ],
        nextDestination: 'Napa Valley & San Francisco',
        nextTripWindow: 'Dec 03 – Dec 12',
        budgetTier: r'$$',
        languages: ['English', 'French'],
        bucketList: [
          'Napa Valley wine train & vineyard picnic',
          'Key West sunset schooner sail',
          'Charleston historic carriage & food tour',
        ],
        prompts: [
          ProfilePrompt(
            question: 'We’ll get along if...',
            answer:
                'You treat airport lounges like part of the vacation and never check a bag.',
          ),
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1607746882042-944635dfe10e?auto=format&fit=crop&w=900&q=80',
        galleryUrls: [
          'https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?auto=format&fit=crop&w=900&q=80',
        ],
        isVerified: true,
        countriesVisited: 19,
        sleepSchedule: 'Night Owl',
        baseCompatibility: 95,
      ),
    ],
    steppedCards: [
      (
        imageUrl:
            'https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?auto=format&fit=crop&w=900&q=80',
        tag: 'Outdoors',
      ),
      (
        imageUrl:
            'https://images.pexels.com/photos/936119/pexels-photo-936119.jpeg?auto=compress&cs=tinysrgb&w=900',
        tag: 'Roadtrips',
      ),
      (
        imageUrl:
            'https://images.unsplash.com/photo-1607746882042-944635dfe10e?auto=format&fit=crop&w=900&q=80',
        tag: 'Island hopper',
      ),
    ],
    departureCirclePhotoUrl:
        'https://images.pexels.com/photos/254069/pexels-photo-254069.jpeg?auto=compress&cs=tinysrgb&w=1000',
    romanceVerifiedPortraitUrls: [
      'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=500&q=80',
      'https://images.pexels.com/photos/936119/pexels-photo-936119.jpeg?auto=compress&cs=tinysrgb&w=500',
      'https://images.unsplash.com/photo-1566492031773-4f4e44671857?auto=format&fit=crop&w=500&q=80',
      'https://images.unsplash.com/photo-1607746882042-944635dfe10e?auto=format&fit=crop&w=500&q=80',
    ],
    romancePhoneImageUrl:
        'https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?auto=format&fit=crop&w=800&q=80',
    romancePhoneLabel: 'Madison, 27',
    coPilotCrewImageUrl:
        'https://images.pexels.com/photos/984918/pexels-photo-984918.jpeg?auto=compress&cs=tinysrgb&w=800',
    coPilotPhoneImageUrl:
        'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=800&q=80',
    coPilotPhoneLabel: 'Chloe, 25',
    storyQuote:
        'We are both naturally spontaneous solo travellers, but when our Big Sur and Maui itineraries matched on Aviaj, it felt like there was no horizon we couldn’t explore.',
    storyAttribution: 'Madison & Marcus, engaged in Big Sur 2026',
    storyCoupleImageUrl:
        'https://images.pexels.com/photos/254069/pexels-photo-254069.jpeg?auto=compress&cs=tinysrgb&w=1000',
    fannedPhoneImageUrls: [
      'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=700&q=80',
      'https://images.unsplash.com/photo-1594744803329-e58b31de8bf5?auto=format&fit=crop&w=800&q=80',
      'https://images.pexels.com/photos/936119/pexels-photo-936119.jpeg?auto=compress&cs=tinysrgb&w=700',
    ],
  );

  // ===========================================================================
  // 4. EUROPE REGION PACK (🇪🇺 Authentic European Portraits & Routes)
  // ===========================================================================
  static const AviajRegionalContentPack _europePack = AviajRegionalContentPack(
    region: AviajRegion.europe,
    profiles: [
      TravellerProfile(
        id: 'p1',
        name: 'Elena Rostova',
        age: 27,
        gender: 'Woman',
        occupation: 'UX Designer & Travel Filmmaker',
        homeCity: 'Barcelona',
        countryFlag: '🇪🇸',
        bio:
            'Solo traveller ready to trade solo table-for-one dinners for shared Mediterranean sunsets. Seeking a meaningful long-term partner.',
        primaryIntent: ConnectionIntent.longTermPartner,
        intents: [
          ConnectionIntent.longTermPartner,
          ConnectionIntent.travelBuddy,
        ],
        travelStyles: [
          TravelStyle.foodieCulture,
          TravelStyle.boutiqueLuxury,
          TravelStyle.islandHopper,
        ],
        nextDestination: 'Amalfi Coast & Capri, Italy',
        nextTripWindow: 'Nov 12 – Nov 24',
        budgetTier: r'$$',
        languages: ['English', 'Spanish', 'Italian'],
        bucketList: [
          'Sunset vespa ride in Positano',
          'Sailing the Greek Cyclades',
          'Alpine train through Zermatt',
        ],
        prompts: [
          ProfilePrompt(
            question: 'My ideal first date abroad is...',
            answer:
                'Renting a vintage wooden boat along the Amalfi cliffs with fresh focaccia and zero itinerary.',
          ),
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=900&q=80',
        galleryUrls: [
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=900&q=80',
        ],
        isVerified: true,
        countriesVisited: 24,
        sleepSchedule: 'Night Owl',
        baseCompatibility: 96,
      ),
      TravellerProfile(
        id: 'p2',
        name: 'Liam O’Connor',
        age: 30,
        gender: 'Man',
        occupation: 'Renewable Energy Engineer',
        homeCity: 'Dublin',
        countryFlag: '🇮🇪',
        bio:
            'Organizing a 6-person solo group expedition through the Dolomites & Amalfi. Looking for adventurous souls and my forever hiking partner.',
        primaryIntent: ConnectionIntent.soloGroupSquad,
        intents: [
          ConnectionIntent.soloGroupSquad,
          ConnectionIntent.travelBuddy,
          ConnectionIntent.longTermPartner,
        ],
        travelStyles: [
          TravelStyle.adventureTrek,
          TravelStyle.roadTripper,
          TravelStyle.backpacker,
        ],
        nextDestination: 'Dolomites & Lake Como, Italy',
        nextTripWindow: 'Nov 18 – Nov 29',
        budgetTier: r'$$',
        languages: ['English', 'Gaelic'],
        bucketList: [
          'Seceda ridgeline hike in the Dolomites',
          'Campervan around Ring Road Iceland',
          'Sailing Croatia from Split to Hvar',
        ],
        prompts: [
          ProfilePrompt(
            question: 'Why I love solo-group trips...',
            answer:
                'You arrive at the airport as strangers and leave two weeks later with lifelong friends.',
          ),
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=900&q=80',
        galleryUrls: [
          'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=900&q=80',
        ],
        isVerified: true,
        countriesVisited: 31,
        sleepSchedule: 'Early Bird',
        baseCompatibility: 92,
      ),
      TravellerProfile(
        id: 'p3',
        name: 'Sofia Laurent',
        age: 29,
        gender: 'Woman',
        occupation: 'Marine Biologist & Scuba Instructor',
        homeCity: 'Nice',
        countryFlag: '🇫🇷',
        bio:
            'Happiest salt-haired and barefoot on a catamaran in the Cyclades. Looking for a long-term romantic partner.',
        primaryIntent: ConnectionIntent.longTermPartner,
        intents: [
          ConnectionIntent.longTermPartner,
          ConnectionIntent.shortTermDating,
        ],
        travelStyles: [
          TravelStyle.islandHopper,
          TravelStyle.adventureTrek,
          TravelStyle.foodieCulture,
        ],
        nextDestination: 'Paros & Milos, Greece',
        nextTripWindow: 'Nov 20 – Dec 01',
        budgetTier: r'$$',
        languages: ['French', 'English'],
        bucketList: [
          'Sailing across the Aegean Sea',
          'Northern Lights in Tromsø',
          'Madeira coastal cloud hike',
        ],
        prompts: [
          ProfilePrompt(
            question: 'Way to win my heart on a trip...',
            answer:
                'Wake up for a 6 AM sunrise swim with me, followed by warm croissants at a seaside bakery.',
          ),
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=900&q=80',
        galleryUrls: [
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=900&q=80',
        ],
        isVerified: true,
        countriesVisited: 28,
        sleepSchedule: 'Early Bird',
        baseCompatibility: 94,
      ),
      TravellerProfile(
        id: 'p4',
        name: 'Noah Lindqvist',
        age: 31,
        gender: 'Man',
        occupation: 'Indie SaaS Founder',
        homeCity: 'Stockholm',
        countryFlag: '🇸🇪',
        bio:
            'Working remotely across Europe and looking for travel buddies or a digital nomad villa crew in Lisbon and Madeira.',
        primaryIntent: ConnectionIntent.travelBuddy,
        intents: [
          ConnectionIntent.travelBuddy,
          ConnectionIntent.soloGroupSquad,
        ],
        travelStyles: [
          TravelStyle.digitalNomad,
          TravelStyle.roadTripper,
          TravelStyle.adventureTrek,
        ],
        nextDestination: 'Madeira & Lisbon, Portugal',
        nextTripWindow: 'Nov 14 – Dec 14',
        budgetTier: r'$$',
        languages: ['English', 'Swedish'],
        bucketList: [
          'Pico do Arieiro sunrise hike',
          'Surfing Nazare coast',
          'Trans-Alpine train journey',
        ],
        prompts: [
          ProfilePrompt(
            question: 'Ideal co-travel routine...',
            answer:
                'Deep focus work 9–2, coastal hike or surf 2–6, and tapas with the crew at night.',
          ),
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=900&q=80',
        galleryUrls: [
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=900&q=80',
        ],
        isVerified: true,
        countriesVisited: 22,
        sleepSchedule: 'Flexible',
        baseCompatibility: 90,
      ),
      TravellerProfile(
        id: 'p5',
        name: 'Camila Vega',
        age: 28,
        gender: 'Woman',
        occupation: 'Sommelier & Culinary Writer',
        homeCity: 'Madrid',
        countryFlag: '🇪🇸',
        bio:
            'Believer that you truly know someone after a coastal roadtrip and a shared bottle of Rioja. Looking for a romantic partner.',
        primaryIntent: ConnectionIntent.longTermPartner,
        intents: [
          ConnectionIntent.longTermPartner,
          ConnectionIntent.shortTermDating,
        ],
        travelStyles: [
          TravelStyle.foodieCulture,
          TravelStyle.roadTripper,
          TravelStyle.boutiqueLuxury,
        ],
        nextDestination: 'San Sebastián & Bordeaux',
        nextTripWindow: 'Dec 01 – Dec 12',
        budgetTier: r'$$',
        languages: ['Spanish', 'English', 'Italian'],
        bucketList: [
          'San Sebastián pintxos crawl',
          'Tuscany vineyard roadtrip',
          'Mallorca cala hopping',
        ],
        prompts: [
          ProfilePrompt(
            question: 'We’ll get along if...',
            answer:
                'You plan trips around where we’re eating next and love holding hands through cobblestoned towns.',
          ),
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=900&q=80',
        galleryUrls: [
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=900&q=80',
        ],
        isVerified: true,
        countriesVisited: 20,
        sleepSchedule: 'Night Owl',
        baseCompatibility: 95,
      ),
    ],
    steppedCards: [
      (
        imageUrl:
            'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=900&q=80',
        tag: 'Outdoors',
      ),
      (
        imageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=900&q=80',
        tag: 'Roadtrips',
      ),
      (
        imageUrl:
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=900&q=80',
        tag: 'Island hopper',
      ),
    ],
    departureCirclePhotoUrl:
        'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=1000&q=80',
    romanceVerifiedPortraitUrls: [
      'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=400&q=80',
    ],
    romancePhoneImageUrl:
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=700&q=80',
    romancePhoneLabel: 'Elena, 27',
    coPilotCrewImageUrl:
        'https://images.unsplash.com/photo-1539635278303-d4002c07eae3?auto=format&fit=crop&w=700&q=80',
    coPilotPhoneImageUrl:
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=700&q=80',
    coPilotPhoneLabel: 'Sofia, 29',
    storyQuote:
        'We are both naturally spontaneous solo travellers, but when our Amalfi and Positano itineraries matched on Aviaj, it felt like there was no horizon we couldn’t explore.',
    storyAttribution: 'Elena & Liam, engaged in Positano 2026',
    storyCoupleImageUrl:
        'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?auto=format&fit=crop&w=1000&q=80',
    fannedPhoneImageUrls: [
      'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=600&q=80',
      'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=600&q=80',
    ],
  );

  // ===========================================================================
  // 5. ASIA-PACIFIC REGION PACK (🇯🇵 Authentic APAC Portraits & Routes)
  // ===========================================================================
  static const AviajRegionalContentPack _asiaPacificPack =
      AviajRegionalContentPack(
    region: AviajRegion.asiaPacific,
    profiles: [
      TravellerProfile(
        id: 'p1',
        name: 'Maya Lin',
        age: 26,
        gender: 'Woman',
        occupation: 'Architectural Illustrator',
        homeCity: 'Singapore / Tokyo',
        countryFlag: '🇸🇬',
        bio:
            'Heading to Kyoto for autumn foliage and hidden jazz kissas! Open to a romantic spark on the road or a long-term partner.',
        primaryIntent: ConnectionIntent.longTermPartner,
        intents: [
          ConnectionIntent.longTermPartner,
          ConnectionIntent.shortTermDating,
          ConnectionIntent.travelBuddy,
        ],
        travelStyles: [
          TravelStyle.foodieCulture,
          TravelStyle.digitalNomad,
          TravelStyle.nightlifeSocial,
        ],
        nextDestination: 'Kyoto & Osaka, Japan',
        nextTripWindow: 'Nov 18 – Dec 02',
        budgetTier: r'$$',
        languages: ['English', 'Mandarin', 'Japanese'],
        bucketList: [
          'Kyoto autumn temple illumination date',
          'Shimanami Kaido island cycling',
          'Uluwatu cliffside surf week in Bali',
        ],
        prompts: [
          ProfilePrompt(
            question: 'Together we could...',
            answer:
                'Hunt down secret vinyl listening bars in Tokyo and take film photos at golden hour.',
          ),
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=900&q=80',
        galleryUrls: [
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=900&q=80',
        ],
        isVerified: true,
        countriesVisited: 18,
        sleepSchedule: 'Night Owl',
        baseCompatibility: 96,
      ),
      TravellerProfile(
        id: 'p2',
        name: 'Kenji Takahashi',
        age: 29,
        gender: 'Man',
        occupation: 'Industrial Designer & Photographer',
        homeCity: 'Tokyo',
        countryFlag: '🇯🇵',
        bio:
            'Splitting time between Shibuya studios, Hokkaido powder runs, and Bali surf breaks. Looking for a warm travel partner.',
        primaryIntent: ConnectionIntent.longTermPartner,
        intents: [
          ConnectionIntent.longTermPartner,
          ConnectionIntent.travelBuddy,
        ],
        travelStyles: [
          TravelStyle.foodieCulture,
          TravelStyle.islandHopper,
          TravelStyle.adventureTrek,
        ],
        nextDestination: 'Hokkaido & Niseko, Japan',
        nextTripWindow: 'Nov 22 – Dec 05',
        budgetTier: r'$$',
        languages: ['Japanese', 'English'],
        bucketList: [
          'Private outdoor onsen in Hakone',
          'Jeju Island coastal roadtrip',
          'Raja Ampat liveaboard dive',
        ],
        prompts: [
          ProfilePrompt(
            question: 'My ideal first travel date is...',
            answer:
                'Ramen in a tiny 8-seat alley shop in Shinjuku followed by a night walk through Meiji Shrine.',
          ),
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=900&q=80',
        galleryUrls: [
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=900&q=80',
        ],
        isVerified: true,
        countriesVisited: 21,
        sleepSchedule: 'Night Owl',
        baseCompatibility: 94,
      ),
      TravellerProfile(
        id: 'p3',
        name: 'Sora Kim',
        age: 25,
        gender: 'Woman',
        occupation: 'Film Colorist',
        homeCity: 'Seoul',
        countryFlag: '🇰🇷',
        bio:
            'Cafe hopping in Seongsu, coastal drives around Jeju Island, and sunset villas in Canggu.',
        primaryIntent: ConnectionIntent.shortTermDating,
        intents: [
          ConnectionIntent.shortTermDating,
          ConnectionIntent.longTermPartner,
        ],
        travelStyles: [
          TravelStyle.foodieCulture,
          TravelStyle.boutiqueLuxury,
          TravelStyle.islandHopper,
        ],
        nextDestination: 'Jeju Island & Busan',
        nextTripWindow: 'Nov 25 – Dec 06',
        budgetTier: r'$$',
        languages: ['Korean', 'English'],
        bucketList: [
          'Hallasan volcano sunrise hike in Jeju',
          'Nusa Penida catamaran day in Bali',
          'Lantern release in Chiang Mai',
        ],
        prompts: [
          ProfilePrompt(
            question: 'Way to win my heart on a trip...',
            answer:
                'Taking candid 35mm film snapshots and sharing street food at night markets.',
          ),
        ],
        imageUrl:
            'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=900&q=80',
        galleryUrls: [
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=900&q=80',
        ],
        isVerified: true,
        countriesVisited: 16,
        sleepSchedule: 'Night Owl',
        baseCompatibility: 93,
      ),
    ],
    steppedCards: [
      (
        imageUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=900&q=80',
        tag: 'Outdoors',
      ),
      (
        imageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=900&q=80',
        tag: 'Roadtrips',
      ),
      (
        imageUrl:
            'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=900&q=80',
        tag: 'Island hopper',
      ),
    ],
    departureCirclePhotoUrl:
        'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=1000&q=80',
    romanceVerifiedPortraitUrls: [
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=400&q=80',
    ],
    romancePhoneImageUrl:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=800&q=80',
    romancePhoneLabel: 'Maya, 26',
    coPilotCrewImageUrl:
        'https://images.unsplash.com/photo-1539635278303-d4002c07eae3?auto=format&fit=crop&w=700&q=80',
    coPilotPhoneImageUrl:
        'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=700&q=80',
    coPilotPhoneLabel: 'Sora, 25',
    storyQuote:
        'We are both naturally spontaneous solo travellers, but when our Kyoto and Bali itineraries matched on Aviaj, it felt like there was no horizon we couldn’t explore.',
    storyAttribution: 'Maya & Kenji, engaged in Kyoto 2026',
    storyCoupleImageUrl:
        'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?auto=format&fit=crop&w=1000&q=80',
    fannedPhoneImageUrls: [
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=700&q=80',
      'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=700&q=80',
    ],
  );
}

