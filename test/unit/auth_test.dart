import 'package:flutter_app_tfg/services/Entities/Response.dart';
import 'package:flutter_app_tfg/services/Firebase/MyAuthController.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'mocks/auth_test.mocks.dart';


//Annotations fot build runner
@GenerateMocks([FirebaseAuth, User, UserCredential])
//To create mocks: flutter pub run  build_runner build --delete-conflicting-outputs
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();


  late MyAuthController myAuth;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;
  late MockUserCredential mockUserCredential;
  mockFirebaseAuth = MockFirebaseAuth();
  mockUser = MockUser();
  mockUserCredential = MockUserCredential();
  myAuth = MyAuthController.forAuth(auth: mockFirebaseAuth);



  test('isUserLoggedIn returns true when user is logged in', () {
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    expect(myAuth.isUserLoggedIn(), isTrue);
  });

  test('isUserLoggedIn returns false when user is not logged in', () async {
    when(mockFirebaseAuth.currentUser).thenReturn(null);

    expect(myAuth.isUserLoggedIn(), isFalse);
  });

  test('getUserName returns email when user is logged in', () {
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(mockUser.email).thenReturn('test@test.com');
    expect(myAuth.getUserName(), 'test@test.com');
  });

  test('getUserName returns None when user is not logged in', () {
    when(mockFirebaseAuth.currentUser).thenReturn(null);
    expect(myAuth.getUserName(), 'None');
  });

  test('createAccount success ', () async {

    when(mockFirebaseAuth
        .createUserWithEmailAndPassword(email: 'test@test.com', password: 'password'))
        .thenAnswer((_) => Future.value(mockUserCredential));

    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.emailVerified).thenReturn(true);

    Response response = await myAuth.createAccount(
      email: 'test@test.com',
      name: 'Johny',
      surname:'Test',
      password: 'password',
      passwordRepeat: 'password',
      phone: '123456789',
    );

    expect(response.success, true);
    expect(response.message, 'create-account-success');

  });

  test('createAccount fails: password too weak ', () async {

    when(mockFirebaseAuth
        .createUserWithEmailAndPassword(email: 'test@test.com', password: 'password'))
        .thenAnswer((_) => throw FirebaseAuthException(code: 'weak-password', message: "Password too weak"));

    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.emailVerified).thenReturn(true);

    Response response = await myAuth.createAccount(
      email: 'test@test.com',
      name: 'Johny',
      surname:'Test',
      password: 'password',
      passwordRepeat: 'password',
      phone: '123',
    );

    expect(response.success, false);
    expect(response.message, 'weak-password');

  });


  test('createAccount fails: email in use', () async {
    when(mockFirebaseAuth
        .createUserWithEmailAndPassword(email: 'test@test.com', password: 'password'))
        .thenAnswer((_) =>
    throw FirebaseAuthException(code: 'email-already-in-use', message: "Email already i use"));

    Response response = await myAuth.createAccount(
      email: 'test@test.com',
      name: 'Johny',
      surname:'Test',
      password: 'password',
      passwordRepeat: 'password',
      phone: '123456789',
    );

    expect(response.success, false);
    expect(response.message, 'email-already-in-use');


  });

  test('createAccount fails: invalid email format', () async {
    when(mockFirebaseAuth
        .createUserWithEmailAndPassword(email: 'test@test.com', password: 'password'))
        .thenAnswer((_) =>
    throw FirebaseAuthException(code: 'invalid-email', message: "Email invalid format"));

    Response response = await myAuth.createAccount(
      email: 'test@test.com',
      name: 'Johny',
      surname:'Test',
      password: 'password',
      passwordRepeat: 'password',
      phone: '123456789',
    );

    expect(response.success, false);
    expect(response.message, 'invalid-email');


  });


  test('signIn success: user exists and is verified', () async {
    when(mockFirebaseAuth
        .signInWithEmailAndPassword(email: 'test@test.com', password: 'password'))
        .thenAnswer((realInvocation) => Future.value(mockUserCredential));

    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(mockUser.emailVerified).thenReturn(true);
    when(mockUser.displayName).thenReturn('test@test.com');

    Response response = await myAuth.signIn(email: 'test@test.com', password: 'password');

    expect(response.success, true);
    expect(response.message, 'sign-in-success');

  });

  test('signIn fails: user exists but is not verified', () async {
    when(mockFirebaseAuth
        .signInWithEmailAndPassword(
        email: 'test@test.com', password: 'password'))
        .thenAnswer((realInvocation) => Future.value(mockUserCredential));

    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(mockUser.emailVerified).thenReturn(false);
    when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) => Future.value());

    Response response = await myAuth.signIn(email: 'test@test.com', password: 'password');

    expect(response.success, false);
    expect(response.message, 'email-not-verified');

  });


  test('signIn fails: user does not exists', () async {
    when(mockFirebaseAuth
        .signInWithEmailAndPassword(
        email: 'test@test.com', password: 'password'))
        .thenAnswer((realInvocation) => throw FirebaseAuthException(code: 'user-not-found', message: "There is no user with such email"));

    Response response = await myAuth.signIn(email: 'test@test.com', password: 'password');

    expect(response.success, false);
    expect(response.message, 'user-not-found');

  });

  test('signIn fails: incorrect password', () async {
    when(mockFirebaseAuth
        .signInWithEmailAndPassword(
        email: 'test@test.com', password: 'password'))
        .thenAnswer((realInvocation) => throw FirebaseAuthException(code: 'wrong-password', message: "There is no user with such email"));

    Response response = await myAuth.signIn(email: 'test@test.com', password: 'password');

    expect(response.success, false);
    expect(response.message, 'wrong-password');

  });


  test('signOut success', () async {
    when(mockFirebaseAuth
        .signInWithEmailAndPassword(email: 'test@test.com', password: 'password'))
        .thenAnswer((realInvocation) => Future.value(mockUserCredential));

    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(mockUser.emailVerified).thenReturn(true);
    when(mockUser.displayName).thenReturn('test@test.com');

    //First we log in
    await myAuth.signIn(email: 'test@test.com', password: 'password');

//Then we log out
    when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) => Future.value());
    Response response = await myAuth.signOut();

    expect(response.success, true);
    expect(response.message, 'Logout successful');

  });


  test('signOut fails', () async {

    //Then we log out
    when(mockFirebaseAuth.signOut())
        .thenAnswer((realInvocation) =>
    throw FirebaseAuthException(code: 'user-not-logged', message: "There is no user"));
    Response response = await myAuth.signOut();

    expect(response.success, false);
    expect(response.message, 'user-not-logged');

  });



  // Similar tests can be written for createAccount, signIn and signOut methods
  // Ensure to handle all the edge cases and possible return values
}