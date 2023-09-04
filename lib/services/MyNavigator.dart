
import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/screens/ForgotPasswordScreen.dart';
import 'package:flutter_app_tfg/screens/SignUpScreen.dart';
import '../screens/BluetoothDevicesListScreen.dart';
import '../screens/LoginScreen.dart';
import '../screens/StatusScreen.dart';
import '../screens/UserPageScreen.dart';
class MyNavigator {

  ///Singleton instance
  static final MyNavigator _singleton = MyNavigator._internal();

  factory MyNavigator() {
    return _singleton;
  }

  MyNavigator._internal();

  ///Map of routes to screens.
  final Map<String, Widget> _routesToWidgets = {
    "/ble": Semantics(
      label: "Bluetooth devices list screen",
      child: const BluetoothDevicesListScreen(),
    ),
    "/profile" : Semantics(
      label: "User profile screen",
      child: const UserPageScreen(),
    ),
    "/login" : Semantics(
      label: "User login screen",
      child: const LoginScreen(),
    ),
    "/status" : Semantics(
      label: "Status screen",
      child: const StatusScreen(),
    ),
    "/signUp" : Semantics(
      label: "User sign up screen",
      child: const SignUpScreen(),
    ),
    "/forgot" : Semantics(
      label: "Forgot password screen",
      child: const ForgotPasswordScreen(),
    ),
  };


///Navigate to [route] and remove all previous routes.
  void navigateTo(String route, BuildContext context){
    Widget? targetPage = _routesToWidgets[route];
    if(targetPage == null){
      throw Exception("Route $route not found");
    }

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return targetPage;
        },
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      ModalRoute.withName(route),
    );
  }

}