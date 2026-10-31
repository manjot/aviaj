import 'package:flutter/material.dart';

/// Relationship and travel connection intent options in Aviaj.
enum ConnectionIntent {
  travelBuddy,
  shortTermDating,
  longTermPartner,
  soloGroupSquad,
}

extension ConnectionIntentX on ConnectionIntent {
  String get label {
    switch (this) {
      case ConnectionIntent.travelBuddy:
        return 'Travel Buddy';
      case ConnectionIntent.shortTermDating:
        return 'Short-Term Dating';
      case ConnectionIntent.longTermPartner:
        return 'Long-Term Partner';
      case ConnectionIntent.soloGroupSquad:
        return 'Solo Group Squad';
    }
  }

  String get shortTagline {
    switch (this) {
      case ConnectionIntent.travelBuddy:
        return 'Platonic co-explorer • split costs & adventures';
      case ConnectionIntent.shortTermDating:
        return 'Vacation romance • spontaneous chemistry & sunset dates';
      case ConnectionIntent.longTermPartner:
        return 'Serious relationship • lifelong co-pilot & partner';
      case ConnectionIntent.soloGroupSquad:
        return 'Small group (3–8 solos) • shared itinerary & memories';
    }
  }

  IconData get icon {
    switch (this) {
      case ConnectionIntent.travelBuddy:
        return Icons.explore_rounded;
      case ConnectionIntent.shortTermDating:
        return Icons.local_fire_department_rounded;
      case ConnectionIntent.longTermPartner:
        return Icons.favorite_rounded;
      case ConnectionIntent.soloGroupSquad:
        return Icons.groups_rounded;
    }
  }

  Color get color {
    switch (this) {
      case ConnectionIntent.travelBuddy:
        return const Color(0xFF0EA5E9); // Sky Blue
      case ConnectionIntent.shortTermDating:
        return const Color(0xFFF97316); // Sunset Orange
      case ConnectionIntent.longTermPartner:
        return const Color(0xFFE11D48); // Rose Crimson
      case ConnectionIntent.soloGroupSquad:
        return const Color(0xFF10B981); // Emerald Teal
    }
  }
}

/// Travel style tags for matching compatible travellers.
enum TravelStyle {
  backpacker,
  boutiqueLuxury,
  digitalNomad,
  adventureTrek,
  foodieCulture,
  roadTripper,
  islandHopper,
  nightlifeSocial,
}

extension TravelStyleX on TravelStyle {
  String get label {
    switch (this) {
      case TravelStyle.backpacker:
        return 'Backpacker';
      case TravelStyle.boutiqueLuxury:
        return 'Boutique & Luxury';
      case TravelStyle.digitalNomad:
        return 'Digital Nomad';
      case TravelStyle.adventureTrek:
        return 'Adventure & Trek';
      case TravelStyle.foodieCulture:
        return 'Foodie & Culture';
      case TravelStyle.roadTripper:
        return 'Road Tripper';
      case TravelStyle.islandHopper:
        return 'Island Hopper';
      case TravelStyle.nightlifeSocial:
        return 'Nightlife & Festivals';
    }
  }

  IconData get icon {
    switch (this) {
      case TravelStyle.backpacker:
        return Icons.hiking_rounded;
      case TravelStyle.boutiqueLuxury:
        return Icons.diamond_outlined;
      case TravelStyle.digitalNomad:
        return Icons.laptop_mac_rounded;
      case TravelStyle.adventureTrek:
        return Icons.terrain_rounded;
      case TravelStyle.foodieCulture:
        return Icons.restaurant_menu_rounded;
      case TravelStyle.roadTripper:
        return Icons.directions_car_filled_rounded;
      case TravelStyle.islandHopper:
        return Icons.sailing_rounded;
      case TravelStyle.nightlifeSocial:
        return Icons.nightlife_rounded;
    }
  }
}

class ProfilePrompt {
  final String question;
  final String answer;

  const ProfilePrompt({
    required this.question,
    required this.answer,
  });

  Map<String, dynamic> toJson() => {
        'question': question,
        'answer': answer,
      };

  factory ProfilePrompt.fromJson(Map<String, dynamic> json) => ProfilePrompt(
        question: json['question'] as String? ?? '',
        answer: json['answer'] as String? ?? '',
      );
}

class TravellerProfile {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String occupation;
  final String homeCity;
  final String countryFlag;
  final String bio;
  final ConnectionIntent primaryIntent;
  final List<ConnectionIntent> intents;
  final List<TravelStyle> travelStyles;
  final String nextDestination;
  final String nextTripWindow;
  final String budgetTier; // '$', '$$', '$$$'
  final List<String> languages;
  final List<String> bucketList;
  final List<ProfilePrompt> prompts;
  final String imageUrl;
  final List<String> galleryUrls;
  final bool isVerified;
  final int countriesVisited;
  final String sleepSchedule; // 'Early Bird', 'Night Owl', 'Flexible'
  final int baseCompatibility;

  const TravellerProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.occupation,
    required this.homeCity,
    required this.countryFlag,
    required this.bio,
    required this.primaryIntent,
    required this.intents,
    required this.travelStyles,
    required this.nextDestination,
    required this.nextTripWindow,
    required this.budgetTier,
    required this.languages,
    required this.bucketList,
    required this.prompts,
    required this.imageUrl,
    required this.galleryUrls,
    this.isVerified = true,
    this.countriesVisited = 12,
    this.sleepSchedule = 'Flexible',
    this.baseCompatibility = 90,
  });

  TravellerProfile copyWith({
    String? name,
    int? age,
    String? gender,
    String? occupation,
    String? homeCity,
    String? countryFlag,
    String? bio,
    ConnectionIntent? primaryIntent,
    List<ConnectionIntent>? intents,
    List<TravelStyle>? travelStyles,
    String? nextDestination,
    String? nextTripWindow,
    String? budgetTier,
    List<String>? languages,
    List<String>? bucketList,
    List<ProfilePrompt>? prompts,
    String? imageUrl,
    List<String>? galleryUrls,
    bool? isVerified,
    int? countriesVisited,
    String? sleepSchedule,
  }) {
    return TravellerProfile(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      occupation: occupation ?? this.occupation,
      homeCity: homeCity ?? this.homeCity,
      countryFlag: countryFlag ?? this.countryFlag,
      bio: bio ?? this.bio,
      primaryIntent: primaryIntent ?? this.primaryIntent,
      intents: intents ?? this.intents,
      travelStyles: travelStyles ?? this.travelStyles,
      nextDestination: nextDestination ?? this.nextDestination,
      nextTripWindow: nextTripWindow ?? this.nextTripWindow,
      budgetTier: budgetTier ?? this.budgetTier,
      languages: languages ?? this.languages,
      bucketList: bucketList ?? this.bucketList,
      prompts: prompts ?? this.prompts,
      imageUrl: imageUrl ?? this.imageUrl,
      galleryUrls: galleryUrls ?? this.galleryUrls,
      isVerified: isVerified ?? this.isVerified,
      countriesVisited: countriesVisited ?? this.countriesVisited,
      sleepSchedule: sleepSchedule ?? this.sleepSchedule,
      baseCompatibility: baseCompatibility,
    );
  }
}

class TripDayPlan {
  final int day;
  final String title;
  final String description;

  const TripDayPlan({
    required this.day,
    required this.title,
    required this.description,
  });
}

class GroupTrip {
  final String id;
  final String title;
  final String destination;
  final String country;
  final String dateRange;
  final int durationDays;
  final ConnectionIntent vibeIntent;
  final String groupFormat; // '1-on-1 Partner / Date', 'Small Solo Squad (4-8)', 'Singles Retreat'
  final int estimatedCostUsd;
  final int maxParticipants;
  final List<String> participantProfileIds;
  final String hostProfileId;
  final String summary;
  final List<String> highlights;
  final List<TripDayPlan> itinerary;
  final String imageUrl;
  final List<TravelStyle> styles;

  const GroupTrip({
    required this.id,
    required this.title,
    required this.destination,
    required this.country,
    required this.dateRange,
    required this.durationDays,
    required this.vibeIntent,
    required this.groupFormat,
    required this.estimatedCostUsd,
    required this.maxParticipants,
    required this.participantProfileIds,
    required this.hostProfileId,
    required this.summary,
    required this.highlights,
    required this.itinerary,
    required this.imageUrl,
    required this.styles,
  });

  int get spotsRemaining =>
      (maxParticipants - participantProfileIds.length).clamp(0, maxParticipants);

  GroupTrip copyWith({
    List<String>? participantProfileIds,
  }) {
    return GroupTrip(
      id: id,
      title: title,
      destination: destination,
      country: country,
      dateRange: dateRange,
      durationDays: durationDays,
      vibeIntent: vibeIntent,
      groupFormat: groupFormat,
      estimatedCostUsd: estimatedCostUsd,
      maxParticipants: maxParticipants,
      participantProfileIds:
          participantProfileIds ?? this.participantProfileIds,
      hostProfileId: hostProfileId,
      summary: summary,
      highlights: highlights,
      itinerary: itinerary,
      imageUrl: imageUrl,
      styles: styles,
    );
  }
}

class ChatMessage {
  final String id;
  final String senderId; // 'me' or profileId
  final String text;
  final DateTime timestamp;
  final bool isDateProposal;
  final String? proposalTitle;
  final String? proposalLocation;
  final String? proposalWhen;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.isDateProposal = false,
    this.proposalTitle,
    this.proposalLocation,
    this.proposalWhen,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        'isDateProposal': isDateProposal,
        'proposalTitle': proposalTitle,
        'proposalLocation': proposalLocation,
        'proposalWhen': proposalWhen,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        senderId: json['senderId'] as String,
        text: json['text'] as String,
        timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
            DateTime.now(),
        isDateProposal: json['isDateProposal'] as bool? ?? false,
        proposalTitle: json['proposalTitle'] as String?,
        proposalLocation: json['proposalLocation'] as String?,
        proposalWhen: json['proposalWhen'] as String?,
      );
}

class MatchConversation {
  final String profileId;
  final DateTime matchedAt;
  final ConnectionIntent matchedIntent;
  final bool isSuperBoardingPass;
  final List<ChatMessage> messages;

  const MatchConversation({
    required this.profileId,
    required this.matchedAt,
    required this.matchedIntent,
    this.isSuperBoardingPass = false,
    required this.messages,
  });

  ChatMessage? get lastMessage => messages.isNotEmpty ? messages.last : null;

  MatchConversation copyWith({
    List<ChatMessage>? messages,
    ConnectionIntent? matchedIntent,
    bool? isSuperBoardingPass,
  }) {
    return MatchConversation(
      profileId: profileId,
      matchedAt: matchedAt,
      matchedIntent: matchedIntent ?? this.matchedIntent,
      isSuperBoardingPass: isSuperBoardingPass ?? this.isSuperBoardingPass,
      messages: messages ?? this.messages,
    );
  }
}

