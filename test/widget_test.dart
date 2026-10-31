import 'package:aviaj/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
      'Aviaj solid-color single-love travel brand renders Tinder/Bumble features and App Store / Google Play badges',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const AviajApp());
    await tester.pumpAndSettle();

    // Brand header and Tinder+Bumble hero tagline should be visible
    expect(find.text('aviaj'), findsOneWidget);
    expect(find.textContaining('Never Travel Single Unless You Want To'),
        findsOneWidget);

    // App Store & Google Play Store download badges should be visible
    expect(find.text('App Store'), findsWidgets);
    expect(find.text('Google Play'), findsWidgets);

    // Relationship & travel intent filter chips should be rendered
    expect(find.text('Travel Buddy'), findsWidgets);
    expect(find.text('Short-Term Dating'), findsWidgets);
    expect(find.text('Long-Term Partner'), findsWidgets);
    expect(find.text('Solo Group Squad'), findsWidgets);
  });
}
