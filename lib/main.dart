
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_tfg/screens/ForgotPasswordScreen.dart';
import 'package:flutter_app_tfg/screens/UserPageScreen.dart';
import 'package:flutter_app_tfg/services/MyNavigator.dart';
import 'package:flutter_app_tfg/services/Firebase/FirestoreAccess.dart';
import 'package:flutter_app_tfg/services/Firebase/MyAuthController.dart';
import 'package:flutter_app_tfg/services/Firebase/FirebaseFunctionsCaller.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_tfg/screens/BluetoothDevicesListScreen.dart';
import 'package:flutter_app_tfg/screens/SignUpScreen.dart';
import 'package:flutter_app_tfg/screens/LoginScreen.dart';
import 'package:flutter_app_tfg/screens/StatusScreen.dart';
import 'package:flutter_app_tfg/services/Notifications.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// DotEnv dotenv = DotEnv() is automatically called during import.
// If you want to load multiple dotenv files or name your dotenv object differently, you can do the following and import the singleton into the relavant files:
// DotEnv another_dotenv = DotEnv()



void main() async {


//cargamos variables de entorno
  //await dotenv.load(fileName: ".env");


  //iniciamos conexion con servicios firebase y notificaciones
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterConfig.loadEnvVariables();

  //Request several permissions at once
  Map<Permission,PermissionStatus> statuses = await [
    Permission.location,
    Permission.notification,
    Permission.bluetooth,
    Permission.locationAlways,
    Permission.bluetoothConnect,
    Permission.bluetoothScan,
    Permission.accessNotificationPolicy,
    Permission.notification,
  ].request();



  await initNotifications();

  await  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Initialize singletons
  MyAuthController.forAuth(auth: FirebaseAuth.instance);
  FirestoreAccess.forFirestore(firestore: FirebaseFirestore.instance);
  FirebaseFunctionsCaller.forFunctions(functions: FirebaseFunctions.instanceFor(region: 'europe-west3'));
  MyNavigator();

  //To initialize all pages
  const BottomAppBar();

  runApp( const MyApp());
}


class MyApp extends StatelessWidget{

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.



  @override
  Widget build(BuildContext context){

    return MaterialApp(
      key: const Key("app"),
      title: 'Flutter TFG App',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
          scaffoldBackgroundColor: Colors.black

      ),
      //home:  LoginScreen(authForAllApp: authForAllApp), -> no es necesaria cuando tenemos routes
      initialRoute: "/status",
      routes:{
        //'/home' : (context) => const HomeScreen(),
        '/status' : (context) => const StatusScreen(),
        '/login' : (context) =>  const LoginScreen(),
        '/signUp' : (context) =>  const SignUpScreen(),
        '/ble' : (context) =>  const BluetoothDevicesListScreen(),
        '/profile' : (context) =>  const UserPageScreen(),
        '/profileSettings' : (context) =>  const UserPageScreen(),
        "/forgot" : (context) =>  const ForgotPasswordScreen(),

      },



    );
  }

}




