
import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/screens/ForgotPasswordScreen.dart';
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



  testWidgets('Finds the form fields', (WidgetTester tester) async {

    const statusKey = Key("forgot_password_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget( makeTestableWidget(child: const ForgotPasswordScreen(key: statusKey,)));


    expect(find.byKey(Key("restore_email")), findsOneWidget);


  });


  testWidgets('Finds the button', (WidgetTester tester) async {

    const statusKey = Key("forgot_password_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget( makeTestableWidget(child: const ForgotPasswordScreen(key: statusKey,)));

    expect(find.byKey(Key("forgot_button")), findsOneWidget);


  });

  testWidgets('Finds the text inside the button', (WidgetTester tester) async {

    const statusKey = Key("forgot_password_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget( makeTestableWidget(child: const ForgotPasswordScreen(key: statusKey,)));


    expect(find.text("Send email to restore password"), findsOneWidget);


  });

  testWidgets('Finds the title', (WidgetTester tester) async {

    const statusKey = Key("forgot_password_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget( makeTestableWidget(child: const ForgotPasswordScreen(key: statusKey,)));


    expect(find.text("Restore your password"), findsOneWidget);


  });



}