import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_data.dart';
import '../data/regional_data.dart';
import '../models/models.dart';

class AviajState extends ChangeNotifier {
  static const String _likedIdsKey = 'aviaj_liked_ids';
  static const String _superLikedIdsKey = 'aviaj_super_liked_ids';
  static const String _passedIdsKey = 'aviaj_passed_ids';
  static const String _joinedTripsKey = 'aviaj_joined_trips';
  static const String _darkModeKey = 'aviaj_dark_mode';
  static const String _userProfileKey = 'aviaj_user_profile';
  static const String _customMessagesKey = 'aviaj_custom_messages';

  AviajRegion _activeRegion = AviajRegionalCatalog.detectVisitorRegion();
  TravellerProfile _currentUser = AviajMockData.initialCurrentUser;
  late final List<TravellerProfile> _allProfiles = List<TravellerProfile>.from(
    AviajRegionalCatalog.packFor(_activeRegion).profiles,
  );
  final List<GroupTrip> _trips = List<GroupTrip>.from(AviajMockData.trips);
  final List<MatchConversation> _conversations =
      AviajMockData.initialConversations();

  final Set<String> _likedProfileIds = {'p1', 'p2', 'p4'};
  final Set<String> _superLikedProfileIds = {'p1'};
  final Set<String> _passedProfileIds = {};
  final List<String> _swipeHistory = [];

  // Active filter state
  ConnectionIntent? _selectedIntentFilter;
  TravelStyle? _selectedStyleFilter;
  String _searchQuery = '';
  bool _isDarkMode = false;
  int _activeTabIndex = 0;
  String? _selectedConversationProfileId = 'p1';

  AviajState() {
    _loadPersistedState();
  }

  AviajRegion get activeRegion => _activeRegion;
  AviajRegionalContentPack get regionalPack =>
      AviajRegionalCatalog.packFor(_activeRegion);
  TravellerProfile get currentUser => _currentUser;
  List<TravellerProfile> get allProfiles => List.unmodifiable(_allProfiles);
  List<GroupTrip> get trips => List.unmodifiable(_trips);
  List<MatchConversation> get conversations =>
      List.unmodifiable(_conversations);
  Set<String> get likedProfileIds => Set.unmodifiable(_likedProfileIds);
  Set<String> get superLikedProfileIds =>
      Set.unmodifiable(_superLikedProfileIds);
  Set<String> get passedProfileIds => Set.unmodifiable(_passedProfileIds);

  ConnectionIntent? get selectedIntentFilter => _selectedIntentFilter;
  TravelStyle? get selectedStyleFilter => _selectedStyleFilter;
  String get searchQuery => _searchQuery;
  bool get isDarkMode => _isDarkMode;
  int get activeTabIndex => _activeTabIndex;
  String? get selectedConversationProfileId => _selectedConversationProfileId;
  bool get canUndoSwipe => _swipeHistory.isNotEmpty;

  Future<void> _loadPersistedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final liked = prefs.getStringList(_likedIdsKey);
      if (liked != null) {
        _likedProfileIds
          ..clear()
          ..addAll(liked);
      }

      final superLiked = prefs.getStringList(_superLikedIdsKey);
      if (superLiked != null) {
        _superLikedProfileIds
          ..clear()
          ..addAll(superLiked);
      }

      final passed = prefs.getStringList(_passedIdsKey);
      if (passed != null) {
        _passedProfileIds
          ..clear()
          ..addAll(passed);
      }

      final joinedTrips = prefs.getStringList(_joinedTripsKey);
      if (joinedTrips != null) {
        for (int i = 0; i < _trips.length; i++) {
          final trip = _trips[i];
          final currentIds = Set<String>.from(trip.participantProfileIds);
          if (joinedTrips.contains(trip.id)) {
            currentIds.add('me');
          } else {
            currentIds.remove('me');
          }
          _trips[i] = trip.copyWith(participantProfileIds: currentIds.toList());
        }
      }

      _isDarkMode = prefs.getBool(_darkModeKey) ?? false;

      final savedUserJson = prefs.getString(_userProfileKey);
      if (savedUserJson != null) {
        final map = jsonDecode(savedUserJson) as Map<String, dynamic>;
        _currentUser = _currentUser.copyWith(
          name: map['name'] as String?,
          age: map['age'] as int?,
          occupation: map['occupation'] as String?,
          homeCity: map['homeCity'] as String?,
          bio: map['bio'] as String?,
          nextDestination: map['nextDestination'] as String?,
          nextTripWindow: map['nextTripWindow'] as String?,
          budgetTier: map['budgetTier'] as String?,
          primaryIntent: map['primaryIntent'] != null
              ? ConnectionIntent.values[map['primaryIntent'] as int]
              : null,
        );
      }

      final customMsgJson = prefs.getString(_customMessagesKey);
      if (customMsgJson != null) {
        final decoded = jsonDecode(customMsgJson) as Map<String, dynamic>;
        for (final entry in decoded.entries) {
          final profileId = entry.key;
          final msgList = (entry.value as List<dynamic>)
              .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList();
          final idx =
              _conversations.indexWhere((c) => c.profileId == profileId);
          if (idx != -1) {
            _conversations[idx] =
                _conversations[idx].copyWith(messages: msgList);
          } else {
            final profile = getProfileById(profileId);
            if (profile != null) {
              _conversations.insert(
                0,
                MatchConversation(
                  profileId: profileId,
                  matchedAt: DateTime.now(),
                  matchedIntent: profile.primaryIntent,
                  isSuperBoardingPass:
                      _superLikedProfileIds.contains(profileId),
                  messages: msgList,
                ),
              );
            }
          }
        }
      }
      notifyListeners();
    } catch (_) {
      // Ignore storage errors in restricted environments
    }
  }

  Future<void> _persistState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_likedIdsKey, _likedProfileIds.toList());
      await prefs.setStringList(
          _superLikedIdsKey, _superLikedProfileIds.toList());
      await prefs.setStringList(_passedIdsKey, _passedProfileIds.toList());
      final joinedTripIds = _trips
          .where((t) => t.participantProfileIds.contains('me'))
          .map((t) => t.id)
          .toList();
      await prefs.setStringList(_joinedTripsKey, joinedTripIds);
      await prefs.setBool(_darkModeKey, _isDarkMode);

      final userMap = {
        'name': _currentUser.name,
        'age': _currentUser.age,
        'occupation': _currentUser.occupation,
        'homeCity': _currentUser.homeCity,
        'bio': _currentUser.bio,
        'nextDestination': _currentUser.nextDestination,
        'nextTripWindow': _currentUser.nextTripWindow,
        'budgetTier': _currentUser.budgetTier,
        'primaryIntent': _currentUser.primaryIntent.index,
      };
      await prefs.setString(_userProfileKey, jsonEncode(userMap));

      final msgMap = <String, dynamic>{};
      for (final conv in _conversations) {
        msgMap[conv.profileId] = conv.messages.map((m) => m.toJson()).toList();
      }
      await prefs.setString(_customMessagesKey, jsonEncode(msgMap));
    } catch (_) {}
  }

  void setActiveTab(int index) {
    _activeTabIndex = index;
    notifyListeners();
  }

  void setRegion(AviajRegion region) {
    if (_activeRegion == region) return;
    _activeRegion = region;
    _allProfiles
      ..clear()
      ..addAll(AviajRegionalCatalog.packFor(region).profiles);
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _persistState();
    notifyListeners();
  }

  void setIntentFilter(ConnectionIntent? intent) {
    _selectedIntentFilter = intent;
    notifyListeners();
  }

  void setStyleFilter(TravelStyle? style) {
    _selectedStyleFilter = style;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearFilters() {
    _selectedIntentFilter = null;
    _selectedStyleFilter = null;
    _searchQuery = '';
    notifyListeners();
  }

  TravellerProfile? getProfileById(String id) {
    if (id == 'me') return _currentUser;
    for (final p in _allProfiles) {
      if (p.id == id) return p;
    }
    return null;
  }

  /// Calculates dynamic compatibility score between currentUser and another traveller.
  int calculateCompatibility(TravellerProfile other) {
    int score = other.baseCompatibility;
    if (other.intents.contains(_currentUser.primaryIntent)) {
      score += 3;
    }
    final sharedStyles = other.travelStyles
        .where((s) => _currentUser.travelStyles.contains(s))
        .length;
    score += sharedStyles;
    return score.clamp(78, 99);
  }

  /// Filtered profiles for the Explorer Grid & Swipe Deck.
  List<TravellerProfile> get filteredProfiles {
    return _allProfiles.where((profile) {
      if (_selectedIntentFilter != null &&
          !profile.intents.contains(_selectedIntentFilter)) {
        return false;
      }
      if (_selectedStyleFilter != null &&
          !profile.travelStyles.contains(_selectedStyleFilter)) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = profile.name.toLowerCase().contains(q);
        final matchesDest = profile.nextDestination.toLowerCase().contains(q);
        final matchesCity = profile.homeCity.toLowerCase().contains(q);
        final matchesBio = profile.bio.toLowerCase().contains(q);
        if (!matchesName && !matchesDest && !matchesCity && !matchesBio) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  /// Profiles that haven't been swiped yet in the current deck session.
  List<TravellerProfile> get unswipedProfiles {
    return filteredProfiles
        .where((p) =>
            !_passedProfileIds.contains(p.id) &&
            !_likedProfileIds.contains(p.id))
        .toList();
  }

  /// Filtered group trips based on intent, travel style, and search query.
  List<GroupTrip> get filteredTrips {
    return _trips.where((trip) {
      if (_selectedIntentFilter != null &&
          trip.vibeIntent != _selectedIntentFilter) {
        return false;
      }
      if (_selectedStyleFilter != null &&
          !trip.styles.contains(_selectedStyleFilter)) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = trip.title.toLowerCase().contains(q);
        final matchesDest = trip.destination.toLowerCase().contains(q);
        final matchesCountry = trip.country.toLowerCase().contains(q);
        if (!matchesTitle && !matchesDest && !matchesCountry) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  /// Likes or sends a Golden Boarding Pass (super-like) to a traveller and creates/opens a match.
  MatchConversation likeProfile(
    String profileId, {
    bool isSuperBoardingPass = false,
    String? customIcebreaker,
  }) {
    _passedProfileIds.remove(profileId);
    _likedProfileIds.add(profileId);
    if (isSuperBoardingPass) {
      _superLikedProfileIds.add(profileId);
    }
    _swipeHistory.add(profileId);

    final profile = getProfileById(profileId) ?? _allProfiles.first;
    final existingIdx =
        _conversations.indexWhere((c) => c.profileId == profileId);

    MatchConversation conversation;
    if (existingIdx != -1) {
      conversation = _conversations[existingIdx].copyWith(
        isSuperBoardingPass: isSuperBoardingPass ||
            _conversations[existingIdx].isSuperBoardingPass,
      );
      if (customIcebreaker != null && customIcebreaker.trim().isNotEmpty) {
        final updatedMessages = [
          ...conversation.messages,
          ChatMessage(
            id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
            senderId: 'me',
            text: customIcebreaker.trim(),
            timestamp: DateTime.now(),
          ),
        ];
        conversation = conversation.copyWith(messages: updatedMessages);
      }
      _conversations[existingIdx] = conversation;
    } else {
      final initialMessages = <ChatMessage>[
        ChatMessage(
          id: 'welcome_${DateTime.now().millisecondsSinceEpoch}',
          senderId: profileId,
          text:
              'Hey ${_currentUser.name.split(' ').first}! Excited we matched on Aviaj for ${profile.primaryIntent.label.toLowerCase()} ✨ Have you finalized your dates for ${profile.nextDestination}?',
          timestamp: DateTime.now(),
        ),
      ];
      if (customIcebreaker != null && customIcebreaker.trim().isNotEmpty) {
        initialMessages.add(
          ChatMessage(
            id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
            senderId: 'me',
            text: customIcebreaker.trim(),
            timestamp: DateTime.now(),
          ),
        );
      }
      conversation = MatchConversation(
        profileId: profileId,
        matchedAt: DateTime.now(),
        matchedIntent: profile.primaryIntent,
        isSuperBoardingPass: isSuperBoardingPass,
        messages: initialMessages,
      );
      _conversations.insert(0, conversation);
    }

    _selectedConversationProfileId = profileId;
    _persistState();
    notifyListeners();
    return conversation;
  }

  void passProfile(String profileId) {
    _passedProfileIds.add(profileId);
    _swipeHistory.add(profileId);
    _persistState();
    notifyListeners();
  }

  void undoLastSwipe() {
    if (_swipeHistory.isEmpty) return;
    final lastId = _swipeHistory.removeLast();
    _passedProfileIds.remove(lastId);
    _likedProfileIds.remove(lastId);
    _superLikedProfileIds.remove(lastId);
    _persistState();
    notifyListeners();
  }

  void resetAllSwipes() {
    _passedProfileIds.clear();
    _likedProfileIds
      ..clear()
      ..addAll(['p1', 'p2', 'p4']);
    _superLikedProfileIds
      ..clear()
      ..add('p1');
    _swipeHistory.clear();
    _persistState();
    notifyListeners();
  }

  void selectConversation(String profileId) {
    _selectedConversationProfileId = profileId;
    notifyListeners();
  }

  void sendMessage(
    String profileId,
    String text, {
    bool isDateProposal = false,
    String? proposalTitle,
    String? proposalLocation,
    String? proposalWhen,
  }) {
    if (text.trim().isEmpty && !isDateProposal) return;
    final idx = _conversations.indexWhere((c) => c.profileId == profileId);
    if (idx == -1) return;

    final newMessage = ChatMessage(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'me',
      text: text.trim(),
      timestamp: DateTime.now(),
      isDateProposal: isDateProposal,
      proposalTitle: proposalTitle,
      proposalLocation: proposalLocation,
      proposalWhen: proposalWhen,
    );

    final updated = [
      ..._conversations[idx].messages,
      newMessage,
    ];

    // Add a warm contextual reply so the chat feels alive
    final partner = getProfileById(profileId);
    if (partner != null) {
      final replyText = isDateProposal
          ? 'Count me in for "$proposalTitle" at $proposalLocation! Let’s lock in our boarding passes 🥂✈️'
          : 'Love that! Let’s sync our calendars for ${partner.nextDestination}—would be amazing to experience it together.';
      updated.add(
        ChatMessage(
          id: 'r_${DateTime.now().millisecondsSinceEpoch}',
          senderId: profileId,
          text: replyText,
          timestamp: DateTime.now().add(const Duration(seconds: 1)),
        ),
      );
    }

    _conversations[idx] = _conversations[idx].copyWith(messages: updated);
    _persistState();
    notifyListeners();
  }

  bool isUserJoinedTrip(String tripId) {
    final trip = _trips.firstWhere(
      (t) => t.id == tripId,
      orElse: () => _trips.first,
    );
    return trip.participantProfileIds.contains('me');
  }

  void toggleJoinTrip(String tripId) {
    final idx = _trips.indexWhere((t) => t.id == tripId);
    if (idx == -1) return;
    final trip = _trips[idx];
    final updatedParticipants = List<String>.from(trip.participantProfileIds);
    if (updatedParticipants.contains('me')) {
      updatedParticipants.remove('me');
    } else if (updatedParticipants.length < trip.maxParticipants) {
      updatedParticipants.add('me');
    }
    _trips[idx] = trip.copyWith(participantProfileIds: updatedParticipants);
    _persistState();
    notifyListeners();
  }

  void createNewTrip({
    required String title,
    required String destination,
    required String country,
    required String dateRange,
    required int durationDays,
    required ConnectionIntent vibeIntent,
    required String groupFormat,
    required int estimatedCostUsd,
    required int maxParticipants,
    required String summary,
    required List<String> highlights,
    required List<TravelStyle> styles,
  }) {
    final newTrip = GroupTrip(
      id: 'trip_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      destination: destination,
      country: country,
      dateRange: dateRange,
      durationDays: durationDays,
      vibeIntent: vibeIntent,
      groupFormat: groupFormat,
      estimatedCostUsd: estimatedCostUsd,
      maxParticipants: maxParticipants,
      participantProfileIds: const ['me'],
      hostProfileId: 'me',
      summary: summary,
      highlights: highlights,
      itinerary: [
        TripDayPlan(
          day: 1,
          title: 'Arrival & Welcome Sunset Meetup in $destination',
          description:
              'Meet your co-pilots, check into our accommodation, and kick off the adventure.',
        ),
        TripDayPlan(
          day: (durationDays / 2).ceil().clamp(2, 30),
          title: 'Signature Adventure & Local Hidden Gems',
          description:
              'Full day exploring $destination together with curated local experiences.',
        ),
      ],
      imageUrl:
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1000&q=80',
      styles: styles.isEmpty ? [TravelStyle.adventureTrek] : styles,
    );
    _trips.insert(0, newTrip);
    _persistState();
    notifyListeners();
  }

  void updateCurrentUser({
    required String name,
    required int age,
    required String occupation,
    required String homeCity,
    required String bio,
    required String nextDestination,
    required String nextTripWindow,
    required String budgetTier,
    required ConnectionIntent primaryIntent,
    required List<ConnectionIntent> intents,
    required List<TravelStyle> travelStyles,
    required List<String> bucketList,
  }) {
    _currentUser = _currentUser.copyWith(
      name: name,
      age: age,
      occupation: occupation,
      homeCity: homeCity,
      bio: bio,
      nextDestination: nextDestination,
      nextTripWindow: nextTripWindow,
      budgetTier: budgetTier,
      primaryIntent: primaryIntent,
      intents: intents,
      travelStyles: travelStyles,
      bucketList: bucketList,
    );
    _persistState();
    notifyListeners();
  }
}

