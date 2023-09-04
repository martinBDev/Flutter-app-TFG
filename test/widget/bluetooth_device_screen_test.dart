
import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/screens/BluetoothDevicesListScreen.dart';
import 'package:flutter_app_tfg/widgets/IndividualComponents/BluetoothDeviceToList.dart';
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



  testWidgets('Finds scan button', (WidgetTester tester) async {

    const statusKey = Key("bluetooth_devices_list_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget(
        makeTestableWidget(
            child: const BluetoothDevicesListScreen(key: statusKey,)));


    expect(find.byKey(Key("scan_button")), findsOneWidget);


  });


  testWidgets('No devices listed', (WidgetTester tester) async {


    const statusKey = Key("bluetooth_devices_list_screen");
    // Build our app and trigger a frame.
    await tester.pumpWidget(
        makeTestableWidget(
            child: const BluetoothDevicesListScreen(key: statusKey,)));


    expect(find.byType(BluetoothDeviceToList), findsNothing);


  });




}