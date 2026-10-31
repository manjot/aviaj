import 'package:aviaj/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Aviaj travel and dating app renders core tabs and intent filters',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const AviajApp());
    await tester.pumpAndSettle();

    // Brand header and hero tagline should be visible
    expect(find.text('AVIAJ'), findsOneWidget);
    expect(find.textContaining('Never Travel Solo Unless You Want To'),
        findsOneWidget);

    // Relationship & travel intent filter chips should be rendered
    expect(find.text('Travel Buddy'), findsWidgets);
    expect(find.text('Short-Term Dating'), findsWidgets);
    expect(find.text('Long-Term Partner'), findsWidgets);
    expect(find.text('Solo Group Squad'), findsWidgets);
  });
}
