
import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/screens/SignUpScreen.dart';
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


  testWidgets('Finds the 6 form fields', (WidgetTester tester) async {

    const statusKey = Key("signup_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget( makeTestableWidget(child: const SignUpScreen(key: statusKey,)));


    expect(find.byKey(Key("password_field")), findsOneWidget);
    expect(find.byKey(Key("name_field")), findsOneWidget);
    expect(find.byKey(Key("surname_field")), findsOneWidget);
    expect(find.byKey(Key("email_field")), findsOneWidget);
    expect(find.byKey(Key("password_repeat_field")), findsOneWidget);
    expect(find.byKey(Key("phone_field")), findsOneWidget);


  });


  testWidgets('Finds the two buttons', (WidgetTester tester) async {

    const statusKey = Key("signup_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget( makeTestableWidget(child: const SignUpScreen(key: statusKey,)));

    expect(find.byKey(Key("signup_button")), findsOneWidget);
    expect(find.byKey(Key("goto_login_button")), findsOneWidget);


  });

  testWidgets('Finds the text inside each button', (WidgetTester tester) async {

    const statusKey = Key("signup_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget( makeTestableWidget(child: const SignUpScreen(key: statusKey,)));


    expect(find.text("Confirm"), findsOneWidget);
    expect(find.text("Log In"), findsOneWidget);


  });

  testWidgets('Finds the title', (WidgetTester tester) async {

    const statusKey = Key("signup_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget( makeTestableWidget(child: const SignUpScreen(key: statusKey,)));


    expect(find.text("Nice to meet you!"), findsOneWidget);


  });



}