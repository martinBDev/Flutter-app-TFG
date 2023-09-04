// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/screens/StatusScreen.dart';
import 'package:flutter_app_tfg/services/HeartDataController.dart';
import 'package:flutter_app_tfg/widgets/IndividualComponents/BottomNavBar.dart';
import 'package:flutter_app_tfg/widgets/waves/BpmCircle.dart';
import 'package:flutter_app_tfg/widgets/waves/CellBlock.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app_tfg/main.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//This function is used to make the widget testable for multiple locales
Widget makeTestableWidget({ required Widget child }) {
  return MediaQuery(
    data: const MediaQueryData(),
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

//All expected text is in English, so the test is only done for that locale
//This is because the app was tested manually in spanish

void main() {
  testWidgets('Finds at least 2 CellBlock widgets', (WidgetTester tester) async {
    
    const statusKey = Key("status_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget( makeTestableWidget(child: StatusScreen(key: statusKey,)));

    //Finds CellBlock widgets
    expect(find.byKey(statusKey), findsOneWidget);
    expect(find.byType(CellBlock), findsAtLeastNWidgets(2));


  });

  testWidgets("Finds the wave circle widget", (WidgetTester tester) async {
    const statusKey = Key("status_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget( makeTestableWidget(child: StatusScreen(key: statusKey,)));

    //Finds the wave circle widget
    expect(find.byType(BpmCircle), findsOneWidget);
  });

  testWidgets("Finds the bottom navigation bar widget", (WidgetTester tester) async {
    const statusKey = Key("status_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget( makeTestableWidget(child: StatusScreen(key: statusKey,)));

    //Finds the bottom navigation bar widget
    expect(find.byType(BottomNavBar), findsOneWidget);
  });

  testWidgets("Check the text in the blocks is the initially expected", (WidgetTester tester) async{
    const statusKey = Key("status_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget( makeTestableWidget(child: StatusScreen(key: statusKey,)));

    //Finds the bottom navigation bar widget
    expect(find.text("0 BPM"), findsOneWidget);
    expect(find.text("Pressure: 0 mmHg"), findsOneWidget);
    expect(find.text("O2 level: 0 %"), findsOneWidget);
    //Text containing a 0
    const pattern = "0";
    expect(find.textContaining(pattern), findsAtLeastNWidgets(3));

  });


  testWidgets("Check the text in the blocks change", (WidgetTester tester) async{
    const statusKey = Key("status_screen");
    // Build our app and trigger a frame.

    HeartDataController().setBpm(100);
    await tester.pumpWidget( makeTestableWidget(child: StatusScreen(key: statusKey,)));

    //Finds the bottom navigation bar widget
    expect(find.text("100 BPM"), findsOneWidget);

  });

}
