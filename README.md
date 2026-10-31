# Aviaj ✈️❤️ — Solo & Group Travel Buddy, Short-Term & Long-Term Dating App

**Aviaj** is a responsive Flutter Web & Mobile application built for solo and group travellers who want to connect with a **Platonic Travel Buddy**, **Short-Term Vacation Romance**, **Long-Term Life & Travel Partner**, or a **Solo Group Adventure Squad** before they even board.

---

## ✨ Key Features

- **4 Explicit Relationship & Travel Intents (`ConnectionIntent`)**:
  - 🧭 **Travel Buddy** — Platonic co-explorer to split villas, 4x4 rentals, and adventures.
  - 🔥 **Short-Term Dating** — Spontaneous vacation chemistry, rooftop cocktails, and sunset dates.
  - ❤️ **Long-Term Partner** — Serious relationship with a fellow explorer who shares your wanderlust.
  - 👥 **Solo Group Squad** — Join 3–8 verified solo travellers heading to the same destination.
- **Dual-Mode Discovery (`DiscoverScreen`)**:
  - **Interactive Swipe Deck**: Drag/swipe or tap to Pass, Match, send a **Golden Boarding Pass** (Super-Like with an instant note), or Undo your last swipe.
  - **Responsive Web Explorer Grid**: Browse all active travellers side-by-side on desktop/tablet, compare dynamic compatibility scores, and filter by destination or relationship goal.
- **Solo & Group Trips Board (`TripsScreen`)**:
  - Browse curated and community-hosted trips (e.g., *Amalfi & Capri Sunset Romance Villa*, *Kyoto Autumn Foliage & Izakaya Hop*, *Patagonia Glaciers Solo Squad*, *Uluwatu Singles Surf & Dating Week*, *Madeira Co-Living*).
  - Inspect day-by-day itineraries, see verified travellers already on board, reserve/leave a spot, or publish your own trip via **Host a Trip / Find Co-Pilot**.
- **Compass Matchmaker (`MatchmakerScreen`)**:
  - Interactive relationship & travel compatibility engine that ranks your top co-pilots based on relationship horizon, travel style, budget tier, and daily rhythm—complete with one-click **First Travel Date Invites**.
- **Departure Lounge Chat (`MessagesScreen`)**:
  - Split-pane desktop web chat & mobile match carousel with travel icebreaker chips and interactive **Boarding Date Proposal Cards**.
- **Verified Aviaj Passport (`ProfileScreen`)**:
  - Edit your primary relationship goal, active travel styles, upcoming destination radar, and bio with automatic local persistence via `shared_preferences`.

---

## 🚀 Getting Started

### Run on Web (Chrome)
```bash
flutter pub get
flutter run -d chrome
```

### Build Production Web Bundle
```bash
flutter build web --release
```

### Run Tests & Static Analysis
```bash
flutter analyze
flutter test
```
