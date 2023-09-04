
import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/services/Firebase/MyAuthController.dart';
import 'package:flutter_app_tfg/l10n/MyLocalizer.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/IndividualComponents/BottomNavBar.dart';
import '../services/Entities/Response.dart';
import '../widgets/IndividualComponents/MyFormField.dart';
import '../services/MyNavigator.dart';
import '../widgets/buttons/FormButton.dart';

class  LoginScreen extends StatefulWidget{


  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();

}


class LoginScreenState extends State<LoginScreen>{


  ///Controller for email field
  final TextEditingController emailController = TextEditingController();

  ///Controller for password field
  final TextEditingController passwordController = TextEditingController();

  ///Error string to show if there is an error
  String errorStr  = "";


  ///Function to call when click on login button
  ///Ask MyAuthController to create account
  ///If there is an error, show it
  ///If not, go to profile screen
  Future<void> clickLogin() async {

    if(passwordController.text.isEmpty || emailController.text.isEmpty){
      setState(() => errorStr = AppLocalizations.of(context)!.signup_error_empty);
      return;
    }

    //Create account on click, and display error if happened
    Response response = await MyAuthController().signIn(
        email: emailController.text,
        password: passwordController.text);

    if(!response.success){ //Si no hay error: null

      setState(() =>
      errorStr =
          MyLocalizer.translate(response.message, context)
              ?? response.message);
    }else{
      errorStr = "";
      MyNavigator().navigateTo( "/profile", context);
    }

  }




  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
            semanticsLabel: AppLocalizations.of(context)!.loginTitle,
            AppLocalizations.of(context)!.loginTitle),
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
                          semanticsLabel:AppLocalizations.of(context)!.welcomeBack,
                          AppLocalizations.of(context)!.welcomeBack,
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            semanticsLabel: AppLocalizations.of(context)!.welcomeBackText,
                            AppLocalizations.of(context)!.welcomeBackText,
                            style: GoogleFonts.inter(
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 35),
                          MyFormField(
                            key: const Key("email_login"),
                            editingController: emailController,
                            labelText: AppLocalizations.of(context)!.signup_form1,
                            obscureText: false,),
                          const SizedBox(height: 20),
                          MyFormField(
                              key: const Key("pass_login"),
                              editingController: passwordController,
                              labelText: AppLocalizations.of(context)!.signup_form2,
                              obscureText: true),
                          const SizedBox(height: 12),
                          Text(
                            semanticsLabel: errorStr,
                            errorStr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 20),
                          FormButton(
                            key: const Key("login_button"),
                            onPressed: clickLogin,
                            text: AppLocalizations.of(context)!.login,),
                          FormButton(
                              key: const Key("goto_signup_button"),
                              onPressed: () async {
                                MyNavigator().navigateTo("/signUp", context);
                              },
                              text: AppLocalizations.of(context)!.signup),
                         FormButton(
                            key: const Key("goto_forgot_button"),
                             onPressed: () async {
                              Navigator.pushNamed(context, "/forgot");
                            },
                             text: AppLocalizations.of(context)!.forgotPassword)

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