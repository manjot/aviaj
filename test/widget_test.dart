import 'package:aviaj/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
      'Aviaj web renders Bumble.com-style solid-color landing page with App Store & Google Play badges',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const AviajApp(forceMobileAppMode: false));
    await tester.pumpAndSettle();

    // Brand header and Bumble-style hero headline should be visible
    expect(find.text('aviaj'), findsWidgets);
    expect(
      find.textContaining('Make the first move on your next horizon'),
      findsOneWidget,
    );

    // App Store & Google Play Store download badges should be visible
    expect(find.text('App Store'), findsWidgets);
    expect(find.text('Google Play'), findsWidgets);
  });

  testWidgets('Aviaj mobile app renders full functionality on iOS & Android',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const AviajApp(forceMobileAppMode: true));
    await tester.pumpAndSettle();

    // Relationship & travel intent filter chips should be rendered in mobile app
    expect(find.text('Travel Buddy'), findsWidgets);
    expect(find.text('Short-Term Dating'), findsWidgets);
    expect(find.text('Long-Term Partner'), findsWidgets);
    expect(find.text('Solo Group Squad'), findsWidgets);
  });
}
