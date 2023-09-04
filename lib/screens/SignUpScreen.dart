import 'package:flutter/material.dart';
import 'package:flutter_app_tfg/services/Firebase/MyAuthController.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/Entities/Response.dart';
import '../l10n/MyLocalizer.dart';
import '../services/Notifications.dart';
import '../widgets/IndividualComponents/BottomNavBar.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/IndividualComponents/MyFormField.dart';
import '../services/MyNavigator.dart';
import '../widgets/buttons/FormButton.dart';

class SignUpScreen extends StatefulWidget{

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => SignUpScreenState();



}



class SignUpScreenState extends State<SignUpScreen>{

  ///Execute function when click on CreateAccount button
  Future<void> clickCreateAccount() async {

    ///If any controller has empty text, show error
    if(nameController.text.isEmpty
        || surnameController.text.isEmpty
        || emailController.text.isEmpty
        || passwordController.text.isEmpty
        || passwordRepeatController.text.isEmpty
        || phoneController.text.isEmpty){
      setState(() => errorStr = AppLocalizations.of(context)!.signup_error_empty);
      return;
    }


    ///If password and repeat password are not the same, show error
    if(passwordController.text != passwordRepeatController.text){
      setState(() => errorStr = AppLocalizations.of(context)!.repeatPassword);
      return;
    }


    ///If phone number is not a number, show error
    if(int.tryParse(phoneController.text) == null || phoneController.text.length != 9){
      setState(() => errorStr = AppLocalizations.of(context)!.signup_error_phone);
      return;
    }

    ///If password is weak, show error
    if(!MyAuthController().checkPassord(passwordController.text)){
      setState(() => errorStr = AppLocalizations.of(context)!.weakPassword);
      return;
    }

    ///Ask MyAuthController to create account
    Response response = await MyAuthController().createAccount(
        email: emailController.text,
        name: nameController.text,
        surname: surnameController.text,
        password: passwordController.text,
        passwordRepeat: passwordRepeatController.text,
        phone: phoneController.text);

    ///If response is not success, show error
    if(!response.success){
      setState(() =>
      errorStr =
          MyLocalizer.translate(response.message, context)
              ?? response.message);
    }else{
      errorStr = "";
      MyNavigator().navigateTo( "/profile", context);
      launchNotificationInApp(AppLocalizations.of(context)!.verificationEmailSent, context);


    }
  }

  ///Controllers for each field
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordRepeatController = TextEditingController();
  final phoneController = TextEditingController();


  String errorStr  = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.signupTitle),
      ),
      body: Center(
          child: SingleChildScrollView(
            child: Center(
                  child: SizedBox(
                      width: 300,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 50),
                          Text(
                              semanticsLabel: AppLocalizations.of(context)!.signup_text1,
                            AppLocalizations.of(context)!.signup_text1,
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                              semanticsLabel: AppLocalizations.of(context)!.signup_text2,
                            AppLocalizations.of(context)!.signup_text2,
                            style: GoogleFonts.inter(
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 35),
                          MyFormField(
                            key: const Key("name_field"),
                              editingController: nameController,
                              labelText: AppLocalizations.of(context)!.name,
                              obscureText: false),
                          const SizedBox(height: 20),
                          MyFormField(
                              key: const Key("surname_field"),
                              editingController: surnameController,
                              labelText: AppLocalizations.of(context)!.surname,
                              obscureText: false),
                          const SizedBox(height: 20),
                          MyFormField(
                              key: const Key("email_field"),
                              editingController: emailController,
                              labelText: AppLocalizations.of(context)!.signup_form1,
                              obscureText: false),
                          const SizedBox(height: 20),
                          MyFormField(
                              key: const Key("password_field"),
                              editingController: passwordController,
                              labelText: AppLocalizations.of(context)!.signup_form2,
                              obscureText: true),
                          const SizedBox(height: 20),
                          MyFormField(
                              key: const Key("password_repeat_field"),
                              editingController: passwordRepeatController,
                              labelText: AppLocalizations.of(context)!.signup_form3,
                              obscureText: true),
                          const SizedBox(height: 20),
                          MyFormField(
                              key: const Key("phone_field"),
                              editingController: phoneController,
                              labelText: AppLocalizations.of(context)!.signup_form4,
                              obscureText: false),
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
                              key: const Key("signup_button"),
                              text: AppLocalizations.of(context)!.confirm,
                              onPressed: clickCreateAccount),
                          FormButton(
                              key: const Key("goto_login_button"),
                              text: AppLocalizations.of(context)!.login,
                              onPressed: () async {
                                MyNavigator().navigateTo("/login", context);
                              })

                        ],
                      )
                  )
              ),
          )
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

}