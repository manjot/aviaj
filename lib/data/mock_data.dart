import '../models/models.dart';

class AviajMockData {
  static const TravellerProfile initialCurrentUser = TravellerProfile(
    id: 'me',
    name: 'Aarav Mehta',
    age: 28,
    gender: 'Man',
    occupation: 'Product Architect & Photographer',
    homeCity: 'Mumbai / Remote',
    countryFlag: '🇮🇳',
    bio:
        'Chasing golden hour coastlines, specialty coffee bars, and genuine connections. Looking for a warm travel partner to explore Mediterranean islands or Japan—whether that starts as an unforgettable trip or turns into a lifelong co-pilot.',
    primaryIntent: ConnectionIntent.longTermPartner,
    intents: [
      ConnectionIntent.longTermPartner,
      ConnectionIntent.shortTermDating,
      ConnectionIntent.travelBuddy,
      ConnectionIntent.soloGroupSquad,
    ],
    travelStyles: [
      TravelStyle.foodieCulture,
      TravelStyle.islandHopper,
      TravelStyle.digitalNomad,
      TravelStyle.adventureTrek,
    ],
    nextDestination: 'Kyoto & Amalfi Coast',
    nextTripWindow: 'Nov 15 – Dec 05',
    budgetTier: r'$$',
    languages: ['English', 'Hindi', 'Spanish (Basic)'],
    bucketList: [
      'Northern Lights in Tromsø',
      'Sailing the Greek Cyclades',
      'Kyoto Bamboo Forest at Dawn',
      'Roadtrip along Big Sur',
    ],
    prompts: [
      ProfilePrompt(
        question: 'My ideal first travel date is...',
        answer:
            'Getting lost in a night market, sharing street food, and ending up on a rooftop overlooking the harbor.',
      ),
      ProfilePrompt(
        question: 'What I value most in a travel & life partner...',
        answer:
            'Curiosity, kindness when flights get delayed, and laughing at spontaneous detours.',
      ),
    ],
    imageUrl:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=900&q=80',
    galleryUrls: [
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=900&q=80',
    ],
    isVerified: true,
    countriesVisited: 19,
    sleepSchedule: 'Flexible',
    baseCompatibility: 100,
  );

  static const List<TravellerProfile> profiles = [
    TravellerProfile(
      id: 'p1',
      name: 'Elena Rostova',
      age: 27,
      gender: 'Woman',
      occupation: 'UX Designer & Travel Filmmaker',
      homeCity: 'Barcelona',
      countryFlag: '🇪🇸',
      bio:
          'Solo traveller ready to trade solo table-for-one dinners for shared sunsets. Seeking a meaningful long-term relationship with someone whose passport is always within reach.',
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
        'Ramen hopping in Tokyo',
        'Cappadocia hot air balloons',
      ],
      prompts: [
        ProfilePrompt(
          question: 'My ideal first date abroad is...',
          answer:
              'Renting a vintage boat along the Amalfi cliffs with fresh focaccia,local wine, and zero itinerary.',
        ),
        ProfilePrompt(
          question: 'Looking for a relationship that feels like...',
          answer:
              'Booked window + aisle seats hoping the middle stays empty, and still wanting to sit right next to you.',
        ),
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=900&q=80',
      galleryUrls: [
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=900&q=80',
        'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=900&q=80',
      ],
      isVerified: true,
      countriesVisited: 24,
      sleepSchedule: 'Night Owl',
      baseCompatibility: 96,
    ),
    TravellerProfile(
      id: 'p2',
      name: 'Maya Lin',
      age: 26,
      gender: 'Woman',
      occupation: 'Architectural Illustrator',
      homeCity: 'Singapore',
      countryFlag: '🇸🇬',
      bio:
          'Heading to Kyoto for autumn leaves and hidden jazz kissas! Open to a romantic short-term spark on the road or a long-term partner if the vibe is undeniable.',
      primaryIntent: ConnectionIntent.shortTermDating,
      intents: [
        ConnectionIntent.shortTermDating,
        ConnectionIntent.longTermPartner,
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
      languages: ['English', 'Mandarin', 'Japanese (Basic)'],
      bucketList: [
        'Kyoto autumn temple illumination date',
        'Shimanami Kaido cycling',
        'Northern Thailand lantern festival',
      ],
      prompts: [
        ProfilePrompt(
          question: 'Two truths and a travel lie...',
          answer:
              'I sketched the Louvre for 9 hours straight, I once missed a ferry because of tiramisu, I hate window seats.',
        ),
        ProfilePrompt(
          question: 'Together we could...',
          answer:
              'Hunt down secret speakeasies in Osaka and take film photos of each other at golden hour.',
        ),
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=900&q=80',
      galleryUrls: [
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=900&q=80',
      ],
      isVerified: true,
      countriesVisited: 17,
      sleepSchedule: 'Night Owl',
      baseCompatibility: 94,
    ),
    TravellerProfile(
      id: 'p3',
      name: 'Liam O’Connor',
      age: 30,
      gender: 'Man',
      occupation: 'Renewable Energy Engineer',
      homeCity: 'Dublin',
      countryFlag: '🇮🇪',
      bio:
          'Organizing a 6-person solo group expedition through Patagonia & looking for adventurous souls (plus always open to meeting my forever hiking partner!).',
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
      nextDestination: 'Torres del Paine, Patagonia',
      nextTripWindow: 'Dec 04 – Dec 16',
      budgetTier: r'$$',
      languages: ['English', 'Gaelic'],
      bucketList: [
        'W-Trek in Patagonia',
        'Campervan around Ring Road Iceland',
        'Inca Trail to Machu Picchu',
      ],
      prompts: [
        ProfilePrompt(
          question: 'Why I love solo-group trips...',
          answer:
              'You arrive at the airport as strangers and leave two weeks later with inside jokes and lifelong friends.',
        ),
        ProfilePrompt(
          question: 'Green flag in a travel buddy...',
          answer:
              'Brings extra trail mix and never panics when the trail map flips upside down.',
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
      baseCompatibility: 89,
    ),
    TravellerProfile(
      id: 'p4',
      name: 'Sofia Laurent',
      age: 29,
      gender: 'Woman',
      occupation: 'Marine Biologist & Scuba Instructor',
      homeCity: 'Nice',
      countryFlag: '🇫🇷',
      bio:
          'Happiest salt-haired and barefoot on a catamaran. Looking for a long-term romantic partner who wants to build a life full of ocean horizons and slow mornings.',
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
      languages: ['French', 'English', 'Portuguese'],
      bucketList: [
        'Diving Raja Ampat together',
        'Sailing across the Aegean Sea',
        'Eco-lodge in Costa Rica',
      ],
      prompts: [
        ProfilePrompt(
          question: 'Way to win my heart on a trip...',
          answer:
              'Wake up for a 6 AM sunrise swim with me, followed by warm croissants at a seaside bakery.',
        ),
        ProfilePrompt(
          question: 'My relationship non-negotiable...',
          answer:
              'Emotional honesty, affectionate energy, and at least two adventures abroad every year.',
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
      baseCompatibility: 93,
    ),
    TravellerProfile(
      id: 'p5',
      name: 'Zara Al-Mansoor',
      age: 27,
      gender: 'Woman',
      occupation: 'Creative Director & DJ',
      homeCity: 'Dubai / London',
      countryFlag: '🇦🇪',
      bio:
          'Beach clubs by day, rooftop conversations by midnight. Flying to Bali next week—seeking a charismatic date for sunset cocktails or a spontaneous island hopper partner.',
      primaryIntent: ConnectionIntent.shortTermDating,
      intents: [
        ConnectionIntent.shortTermDating,
        ConnectionIntent.soloGroupSquad,
      ],
      travelStyles: [
        TravelStyle.boutiqueLuxury,
        TravelStyle.nightlifeSocial,
        TravelStyle.islandHopper,
      ],
      nextDestination: 'Uluwatu & Canggu, Bali',
      nextTripWindow: 'Nov 10 – Nov 25',
      budgetTier: r'$$$',
      languages: ['English', 'Arabic', 'French'],
      bucketList: [
        'Private cliffside villa in Uluwatu',
        'Desert stargazing in AlUla',
        'Tulum beach festival week',
      ],
      prompts: [
        ProfilePrompt(
          question: 'Best vacation romance vibe...',
          answer:
              'Spontaneous scooter rides in Uluwatu, cliffside acoustic sessions, and zero pressure—just electric chemistry.',
        ),
        ProfilePrompt(
          question: 'I’ll cover the first round if...',
          answer: 'You can beat me at pool or recommend a song I don’t know.',
        ),
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?auto=format&fit=crop&w=900&q=80',
      galleryUrls: [
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=900&q=80',
      ],
      isVerified: true,
      countriesVisited: 35,
      sleepSchedule: 'Night Owl',
      baseCompatibility: 88,
    ),
    TravellerProfile(
      id: 'p6',
      name: 'Noah Lindqvist',
      age: 31,
      gender: 'Man',
      occupation: 'Indie SaaS Founder',
      homeCity: 'Stockholm',
      countryFlag: '🇸🇪',
      bio:
          'Working remotely across time zones and looking for reliable travel buddies or a digital nomad squad in Lisbon and Madeira to share villas, surf sessions, and coworking.',
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
      languages: ['English', 'Swedish', 'German'],
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
        ProfilePrompt(
          question: 'Split-cost superpower...',
          answer:
              'I find the best cliff-view Airbnbs with fiber Wi-Fi and an espresso machine.',
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
      baseCompatibility: 86,
    ),
    TravellerProfile(
      id: 'p7',
      name: 'Camila Vega',
      age: 28,
      gender: 'Woman',
      occupation: 'Sommelier & Culinary Writer',
      homeCity: 'Buenos Aires',
      countryFlag: '🇦🇷',
      bio:
          'Believer that you truly know someone after a 6-hour roadtrip and a shared bottle of Malbec. Looking for a romantic partner or 1-on-1 travel buddy for South America & Europe.',
      primaryIntent: ConnectionIntent.longTermPartner,
      intents: [
        ConnectionIntent.longTermPartner,
        ConnectionIntent.shortTermDating,
        ConnectionIntent.travelBuddy,
      ],
      travelStyles: [
        TravelStyle.foodieCulture,
        TravelStyle.roadTripper,
        TravelStyle.boutiqueLuxury,
      ],
      nextDestination: 'Mendoza & Atacama Desert',
      nextTripWindow: 'Dec 01 – Dec 12',
      budgetTier: r'$$',
      languages: ['Spanish', 'English', 'Italian'],
      bucketList: [
        'Vineyard horseback riding in Mendoza',
        'Stargazing in Valle de la Luna',
        'San Sebastián pintxos crawl',
      ],
      prompts: [
        ProfilePrompt(
          question: 'We’ll get along if...',
          answer:
              'You plan trips around where we’re eating next and love holding hands through cobblestoned towns.',
        ),
        ProfilePrompt(
          question: 'What short-term vs long-term means to me...',
          answer:
              'Every great long-term love story starts with one unforgettable trip together.',
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
  ];

  static const List<GroupTrip> trips = [
    GroupTrip(
      id: 't1',
      title: 'Amalfi & Capri Sunset Romance & Coastal Villa',
      destination: 'Positano & Capri',
      country: 'Italy 🇮🇹',
      dateRange: 'Nov 14 – Nov 21, 2026',
      durationDays: 7,
      vibeIntent: ConnectionIntent.longTermPartner,
      groupFormat: 'Singles & Couples-Hopeful Villa (Max 6)',
      estimatedCostUsd: 1650,
      maxParticipants: 6,
      participantProfileIds: ['p1', 'p4', 'p7'],
      hostProfileId: 'p1',
      summary:
          'Designed for relationship-minded solo travellers who want chemistry without awkwardness. Share a cliffside lemon-grove villa, private boat days to Capri, and candlelit cooking nights.',
      highlights: [
        'Private Wooden Gozzo Boat around Capri & Faraglioni',
        'Path of the Gods coastal hike + vineyard lunch',
        'Couples-style cooking class in Ravello',
        'Balanced gender ratio of verified solo travellers',
      ],
      itinerary: [
        TripDayPlan(
          day: 1,
          title: 'Arrival in Naples & Sunset Aperitivo in Sorrento',
          description:
              'Private transfer to our cliffside villa, welcome limoncello spritz, and icebreaker dinner.',
        ),
        TripDayPlan(
          day: 3,
          title: 'Private Yacht Charter to Capri & Blue Grotto',
          description:
              'Full day sailing hidden coves, swimming in turquoise grottoes, and sunset docking in Positano.',
        ),
        TripDayPlan(
          day: 5,
          title: 'Path of the Gods Hike & Ravello Jazz Night',
          description:
              'Morning panoramic coastal trek followed by an intimate terrace dinner in Ravello.',
        ),
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1533105079780-92b9be482077?auto=format&fit=crop&w=1000&q=80',
      styles: [
        TravelStyle.foodieCulture,
        TravelStyle.islandHopper,
        TravelStyle.boutiqueLuxury,
      ],
    ),
    GroupTrip(
      id: 't2',
      title: 'Kyoto Autumn Foliage & Midnight Izakaya Hop',
      destination: 'Kyoto & Osaka',
      country: 'Japan 🇯🇵',
      dateRange: 'Nov 18 – Nov 27, 2026',
      durationDays: 9,
      vibeIntent: ConnectionIntent.shortTermDating,
      groupFormat: '1-on-1 Co-Pilot or Small Crew (Max 4)',
      estimatedCostUsd: 1890,
      maxParticipants: 4,
      participantProfileIds: ['p2', 'me'],
      hostProfileId: 'p2',
      summary:
          'Explore crimson maple temples at dawn, hidden vinyl bars in Pontocho Alley, and neon street-food dates in Dotonbori. Ideal for solo travellers open to romance & spontaneous adventure.',
      highlights: [
        'Private evening access to illuminated Kiyomizu-dera',
        'Pontocho Alley speakeasy & cocktail date crawl',
        'Day trip to Nara & Arashiyama bamboo grove',
        '1 night in a traditional Hakone Ryokan with private onsen',
      ],
      itinerary: [
        TripDayPlan(
          day: 1,
          title: 'Check-in Machiya Townhouse & Gion Lantern Walk',
          description:
              'Meet in central Kyoto, stroll historic wooden alleys, and share yakitori over sake.',
        ),
        TripDayPlan(
          day: 4,
          title: 'Arashiyama Dawn & Sagano Scenic Romantic Train',
          description:
              'Beat the crowds at the bamboo forest and ride the vintage train along Hozu Gorge.',
        ),
        TripDayPlan(
          day: 7,
          title: 'Osaka Neon Food Tour & Vinyl Listening Bar',
          description:
              'Bullet train to Osaka for takoyaki, rooftop views, and late-night jazz.',
        ),
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?auto=format&fit=crop&w=1000&q=80',
      styles: [
        TravelStyle.foodieCulture,
        TravelStyle.nightlifeSocial,
        TravelStyle.digitalNomad,
      ],
    ),
    GroupTrip(
      id: 't3',
      title: 'Patagonia Glaciers & Fitz Roy Solo Squad Trek',
      destination: 'El Chaltén & Torres del Paine',
      country: 'Chile & Argentina 🇨🇱',
      dateRange: 'Dec 04 – Dec 15, 2026',
      durationDays: 11,
      vibeIntent: ConnectionIntent.soloGroupSquad,
      groupFormat: 'Solo Group Adventure Squad (Max 8)',
      estimatedCostUsd: 2150,
      maxParticipants: 8,
      participantProfileIds: ['p3', 'p6', 'p4'],
      hostProfileId: 'p3',
      summary:
          'Zero single supplements! Join 8 active solo travellers to split 4x4 rentals, hike Laguna de los Tres at sunrise, and toast glacier whiskey on Perito Moreno.',
      highlights: [
        'Full W-Trek highlights & Base Las Torres sunrise',
        'Perito Moreno Glacier kayaking & trekking',
        'Shared Patagonia estancias & Argentine asado nights',
        'Shared 4x4 overland roadtrip across the steppe',
      ],
      itinerary: [
        TripDayPlan(
          day: 1,
          title: 'El Calafate Meetup & Glacier Welcome Dinner',
          description:
              'Gear check, route briefing, and craft beer with the whole solo squad.',
        ),
        TripDayPlan(
          day: 4,
          title: 'Mount Fitz Roy & Laguna de los Tres Summit',
          description:
              'Iconic alpine trek with turquoise glacial lagoons and campfire stories.',
        ),
        TripDayPlan(
          day: 8,
          title: 'Cross into Chile: Torres del Paine National Park',
          description:
              'Scenic overland drive with guanacos, condors, and lakeside refugio stay.',
        ),
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=1000&q=80',
      styles: [
        TravelStyle.adventureTrek,
        TravelStyle.roadTripper,
        TravelStyle.backpacker,
      ],
    ),
    GroupTrip(
      id: 't4',
      title: 'Uluwatu Cliff Villa: Singles Surf, Sunset & Dating Week',
      destination: 'Uluwatu & Nusa Lembongan',
      country: 'Indonesia 🇮🇩',
      dateRange: 'Nov 12 – Nov 19, 2026',
      durationDays: 7,
      vibeIntent: ConnectionIntent.shortTermDating,
      groupFormat: 'Singles Villa Experience (Max 8)',
      estimatedCostUsd: 1290,
      maxParticipants: 8,
      participantProfileIds: ['p5', 'p2'],
      hostProfileId: 'p5',
      summary:
          'A curated tropical week for single solo travellers looking for fun vacation chemistry, surf mornings, private catamaran parties to Nusa Penida, and sunset beach clubs.',
      highlights: [
        'Luxury 8-suite infinity pool cliff villa in Uluwatu',
        'Private catamaran day to Manta Bay & Crystal Bay',
        'VIP sunset table at Savaya & Single Fin',
        'Paired surf lessons & beachfront bonfire dinner',
      ],
      itinerary: [
        TripDayPlan(
          day: 1,
          title: 'Villa Poolside Welcome & Sunset Cliff Cocktails',
          description:
              'Settle into your suite and watch the Indian Ocean sunset with the group.',
        ),
        TripDayPlan(
          day: 3,
          title: 'Nusa Lembongan Private Catamaran & Snorkeling',
          description:
              'Sail across the Badung Strait with deck music, paddleboards, and reef diving.',
        ),
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=1000&q=80',
      styles: [
        TravelStyle.islandHopper,
        TravelStyle.nightlifeSocial,
        TravelStyle.boutiqueLuxury,
      ],
    ),
    GroupTrip(
      id: 't5',
      title: 'Madeira Co-Living & Coastal Roadtrip Buddy Pass',
      destination: 'Funchal & Ponta do Sol',
      country: 'Portugal 🇵🇹',
      dateRange: 'Nov 16 – Nov 30, 2026',
      durationDays: 14,
      vibeIntent: ConnectionIntent.travelBuddy,
      groupFormat: 'Co-Working & Travel Buddy Pod (Max 6)',
      estimatedCostUsd: 1180,
      maxParticipants: 6,
      participantProfileIds: ['p6', 'p3'],
      hostProfileId: 'p6',
      summary:
          'Split an oceanfront villa and two convertible SUVs in the Hawaii of Europe. Work remotely on weekdays, hike above the clouds at Pico Ruivo, and explore natural lava pools.',
      highlights: [
        'High-speed fiber oceanfront villa in Ponta do Sol',
        'Fanal Forest mystical mist photography morning',
        'Porto Moniz volcanic natural swimming pools',
        'Shared rental cars included in cost split',
      ],
      itinerary: [
        TripDayPlan(
          day: 1,
          title: 'Ponta do Sol Villa Check-in & Poncha Toast',
          description:
              'Pick up workspaces, assign rooms, and watch sunset from the banana plantations.',
        ),
        TripDayPlan(
          day: 6,
          title: 'Pico do Arieiro to Pico Ruivo Cloud Ridge Hike',
          description:
              'Unforgettable sunrise hike above a sea of clouds with the whole crew.',
        ),
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1555881400-74d7acaacd8b?auto=format&fit=crop&w=1000&q=80',
      styles: [
        TravelStyle.digitalNomad,
        TravelStyle.roadTripper,
        TravelStyle.adventureTrek,
      ],
    ),
  ];

  static List<MatchConversation> initialConversations() {
    final now = DateTime.now();
    return [
      MatchConversation(
        profileId: 'p1',
        matchedAt: now.subtract(const Duration(hours: 5)),
        matchedIntent: ConnectionIntent.longTermPartner,
        isSuperBoardingPass: true,
        messages: [
          ChatMessage(
            id: 'm1',
            senderId: 'p1',
            text:
                'Hey Aarav! Saw that Amalfi Coast is on your November radar too 🇮🇹✨ Are you leaning more toward Positano or staying on Capri?',
            timestamp: now.subtract(const Duration(hours: 4, minutes: 20)),
          ),
          ChatMessage(
            id: 'm2',
            senderId: 'me',
            text:
                'Hi Elena! Positano as a base and taking a wooden boat out to Capri sounds hard to beat. Love your film photography prompt by the way!',
            timestamp: now.subtract(const Duration(hours: 3, minutes: 50)),
          ),
          ChatMessage(
            id: 'm3',
            senderId: 'p1',
            text:
                'Let’s make it happen! I’m hosting the cliffside villa week Nov 14–21, or we could grab an early sunset aperitivo in Sorrento first 🍷',
            timestamp: now.subtract(const Duration(hours: 1, minutes: 15)),
            isDateProposal: true,
            proposalTitle: 'Sunset Aperitivo & Harbor Walk',
            proposalLocation: 'Marina Grande, Sorrento 🇮🇹',
            proposalWhen: 'Nov 14 • 5:30 PM Golden Hour',
          ),
        ],
      ),
      MatchConversation(
        profileId: 'p2',
        matchedAt: now.subtract(const Duration(days: 1)),
        matchedIntent: ConnectionIntent.shortTermDating,
        isSuperBoardingPass: false,
        messages: [
          ChatMessage(
            id: 'm4',
            senderId: 'p2',
            text:
                'Kyoto in late November is going to be magic 🍁 Ready to test which of us finds the best hidden jazz bar in Pontocho?',
            timestamp: now.subtract(const Duration(hours: 18)),
          ),
        ],
      ),
      MatchConversation(
        profileId: 'p4',
        matchedAt: now.subtract(const Duration(days: 2)),
        matchedIntent: ConnectionIntent.longTermPartner,
        isSuperBoardingPass: false,
        messages: [
          ChatMessage(
            id: 'm5',
            senderId: 'p4',
            text:
                'Your bucket list has Sailing the Cyclades! I’m skipper-certified if you bring the playlist and morning coffee ☕⛵',
            timestamp: now.subtract(const Duration(days: 1, hours: 6)),
          ),
        ],
      ),
    ];
  }

  static const List<String> travelIcebreakers = [
    'Window seat for the views or aisle seat for the freedom? ✈️',
    'What’s your spontaneous first-date move in a new city? 🍸',
    'If we booked a ticket tonight for 5 days, where are we landing? 🌍',
    'Luxury boutique hotel or cliffside campervan under the stars? ✨',
    'What’s the biggest green flag in a romantic travel partner? ❤️',
  ];
}

