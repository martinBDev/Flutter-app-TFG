

import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/services/Firebase/MyAuthController.dart';
import 'package:flutter_app_tfg/widgets/IndividualComponents/BottomNavBar.dart';
import 'package:flutter_app_tfg/widgets/buttons/FormButton.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/Entities/Response.dart';
import '../services/Notifications.dart';
import '../widgets/IndividualComponents/MyFormField.dart';

class ForgotPasswordScreen extends StatefulWidget{

  const ForgotPasswordScreen({Key? key}) : super(key: key);


  @override
  State<ForgotPasswordScreen> createState() => ForgotPasswordScreenState();


}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen>{

  ///Controller for email field
  TextEditingController emailController = TextEditingController();


  ///Error string to show if there is an error
  String errorStr  = "";


  ///Click on reset button
  ///Ask MyAuthController to send email to restore password
  Future<void> clickOnReset() async {
    if(emailController.text.isNotEmpty){


      //Send email to restore password
     Response res = await MyAuthController().sendRestorePasswordEmail(emailController.text);

      if(res.success){
        setState(() {
          errorStr = "";
        });
        launchNotificationInApp( AppLocalizations.of(context)!.restoreEmailNotify,  context);
        return;
      }else{
        setState(() {
          errorStr = res.message;
        });
      }
    }

    setState(() {
      errorStr = AppLocalizations.of(context)!.invalidEmail;
    });


  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.resetPasswordTitle),
      ),
      body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                  child: SizedBox(
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                          semanticsLabel: AppLocalizations.of(context)!.resetPasswordTitle,
                            AppLocalizations.of(context)!.restorePassword,
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                              semanticsLabel: AppLocalizations.of(context)!.resetPasswordTitle,
                            AppLocalizations.of(context)!.enterYourEmail,
                            style: GoogleFonts.inter(
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 35),
                          MyFormField(
                            key: const Key('restore_email'),
                            editingController: emailController,
                            labelText: 'Email', obscureText: false,),
                          const SizedBox(height: 12),
                          Text(
                            semanticsLabel: errorStr,
                            errorStr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 10),
                          FormButton(
                              key: const Key('forgot_button'),
                              text: AppLocalizations.of(context)!.resetPassword,
                              onPressed: clickOnReset),
                          const SizedBox(height: 30),

                        ],
                      )
                  )
              ),
            ),
          )
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}