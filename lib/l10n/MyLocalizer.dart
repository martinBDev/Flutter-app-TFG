
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class MyLocalizer {


  ///Receives a [code] and returns the corresponding message in the current language
  ///If the code is not found, returns null
  ///Use the [context] to get the current language
  static String? translate(String code, BuildContext context){

    Map<String, String> codesToMessage = {
      "user-must-log" : AppLocalizations.of(context)!.userMustLogError,
      "find-center-error" : AppLocalizations.of(context)!.findCenterError,
      "find-center-success" : AppLocalizations.of(context)!.findCenterSuccess,
      "save-metrics-error" : AppLocalizations.of(context)!.saveMetricsError,
      "save-metrics-success" : AppLocalizations.of(context)!.saveMetricsSuccess,
      "repeat-password" : AppLocalizations.of(context)!.repeatPassword,
      "email-already-in-use": AppLocalizations.of(context)!.emailAlreadyInUse,
      "invalid-email": AppLocalizations.of(context)!.invalidEmail,
      "weak-password": AppLocalizations.of(context)!.weakPassword,
      "create-account-success" : AppLocalizations.of(context)!.createAccountSuccess,
      "user-disabled" : AppLocalizations.of(context)!.userDisabled,
      "user-not-found" : AppLocalizations.of(context)!.userNotFound,
      "wrong-password" : AppLocalizations.of(context)!.wrongPassword,
      "email-not-verified" : AppLocalizations.of(context)!.emailNotVerified,
      "sign-in-success" : AppLocalizations.of(context)!.signInSuccess,
      "to-many-requests" : AppLocalizations.of(context)!.tooManyRequests,
      "PRESSURE" : AppLocalizations.of(context)!.pressure.toUpperCase(),
      "02" : AppLocalizations.of(context)!.o2level.toUpperCase(),
      "BPM" : AppLocalizations.of(context)!.bpm.toUpperCase(),
      "SUGAR" : AppLocalizations.of(context)!.sugar.toUpperCase(),
      "generate-alert-error" : AppLocalizations.of(context)!.generateAlertError,
      "generate-alert-success" : AppLocalizations.of(context)!.findCenterSuccess,

    };

    return codesToMessage[code];
  }


}