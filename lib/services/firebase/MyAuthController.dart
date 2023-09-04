
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_tfg/services/Firebase/FirebaseFunctionsCaller.dart';
import '../Entities/Response.dart';

class MyAuthController{

  ///Instance of FirebaseAuth [_auth]
  late final FirebaseAuth _auth;

  ///Implement singleton
  MyAuthController._privateConstructor();
  static MyAuthController? _instance;

  factory MyAuthController.forAuth({required FirebaseAuth auth}){
    if(_instance == null){
      _instance = MyAuthController._privateConstructor();
      _instance!._auth = auth;
    }
    return _instance!;

  }


  factory MyAuthController(){
    if(_instance == null){
      _instance = MyAuthController._privateConstructor();
      _instance!._auth = FirebaseAuth.instance;
    }
    return _instance!;
  }


  ///Return a stream of the current user
  Stream<User?> get user => _auth.authStateChanges();


  ///Return true if user is logged in
  bool isUserLoggedIn(){
   return _auth.currentUser != null;
  }

  ///Return the current user name
  String getUserName(){
    return _auth.currentUser?.email??"None";
  }

  ///Return the current user id
  String getUserId(){
    return _auth.currentUser?.uid??"None";
  }


  ///Send restore password to the email [email]
  Future<Response> sendRestorePasswordEmail(String email) async {

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());

      return Response(true, "Email sent");
    }on FirebaseAuthException catch(e){
      return Response(false, e.code);
    }catch(e){
      rethrow;
    }
  }

  ///Create account with the following parameters:
  ///[email], [name], [surname], [password], [passwordRepeat], [phone]
  Future<Response> createAccount(
      {required String email,
        required String name,
        required String surname,
        required String password,
        required String passwordRepeat,
        required String phone}) async {



    try {
      UserCredential newUser = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      User? user = newUser.user;

      bool created = false;
      if(user != null && !user.emailVerified){
          int tries = 4;
          while(!created && tries > 0){

              Response result = await FirebaseFunctionsCaller().createUserDoc(
                  _auth.currentUser!.uid,
                  _auth.currentUser!.email??"default",
                  name,
                  surname,
                  phone
              );

              created = result.success;

              if(created){
                user.sendEmailVerification();
              }else{
                tries--;
              }


            }

          if(tries == 0){
            user.delete();
            return Response(false, "create-account-error");
          }

      }


      return Response(true, "create-account-success");
    }on FirebaseAuthException catch(e){
      return Response(false, e.code);
    }catch(e){
      rethrow;
    }
  }




  ///Sign in with the following parameters:
  ///[email], [password]
  Future<Response> signIn(
      {required String email,required String password}) async {


    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if( !_auth.currentUser!.emailVerified){
        _auth.signOut();
        return Response(false, "email-not-verified");
      }

      return Response(true, "sign-in-success");
    }on FirebaseAuthException catch(e){
      return Response(false, e.code);
    }catch(e){
      rethrow;
    }

  }

  ///Check if the password [password] is valid
  ///The password must have at least 10 characters,
  ///one uppercase, one lowercase, one number and one special character
  bool checkPassord(String password){
    RegExp regExp = new RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{10,}$");
    return regExp.hasMatch(password);

  }


  ///Sign out
  Future<Response> signOut() async {


    try {
      await _auth.signOut();

      return Response(true, "Logout successful");
    }on FirebaseAuthException catch(e){
      return Response(false, e.code);
    }catch(e){
      rethrow;
    }

  }
}


