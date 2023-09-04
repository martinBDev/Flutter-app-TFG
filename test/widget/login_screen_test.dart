// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/screens/LoginScreen.dart';
import 'package:flutter_test/flutter_test.dart';

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


  testWidgets('Finds 2 form fields', (WidgetTester tester) async {

    const statusKey = Key("login_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget( makeTestableWidget(child: const LoginScreen(key: statusKey,)));


    expect(find.byKey(Key("pass_login")), findsOneWidget);
    expect(find.byKey(Key("email_login")), findsOneWidget);


  });


  testWidgets('Finds the three buttons', (WidgetTester tester) async {

    const statusKey = Key("login_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget( makeTestableWidget(child: const LoginScreen(key: statusKey,)));


    expect(find.byKey(Key("login_button")), findsOneWidget);
    expect(find.byKey(Key("goto_signup_button")), findsOneWidget);
    expect(find.byKey(Key("goto_forgot_button")), findsOneWidget);


  });

  testWidgets('Finds the text inside each button', (WidgetTester tester) async {

    const statusKey = Key("login_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget( makeTestableWidget(child: const LoginScreen(key: statusKey,)));


    expect(find.text("Sign Up"), findsOneWidget);
    expect(find.text("Log In"), findsOneWidget);
    expect(find.text("I forgot my password"), findsOneWidget);


  });

  testWidgets('Finds the title', (WidgetTester tester) async {

    const statusKey = Key("login_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget( makeTestableWidget(child: const LoginScreen(key: statusKey,)));


    expect(find.text("Welcome back!"), findsOneWidget);


  });



}