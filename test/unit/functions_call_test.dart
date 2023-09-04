
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_app_tfg/services/Entities/Metrics/BpmMetric.dart';
import 'package:flutter_app_tfg/services/Entities/Metrics/GenericMetric.dart';
import 'package:flutter_app_tfg/services/Entities/Metrics/O2Metric.dart';
import 'package:flutter_app_tfg/services/Entities/Metrics/PressureMetric.dart';
import 'package:flutter_app_tfg/services/Entities/Metrics/SugarMetric.dart';
import 'package:flutter_app_tfg/services/Entities/Response.dart';
import 'package:flutter_app_tfg/services/Firebase/MyAuthController.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_app_tfg/services/Firebase/FirebaseFunctionsCaller.dart';

import 'mocks/auth_test.mocks.dart';
import 'mocks/functions_call_test.mocks.dart';

class MockHttpsCallableResult extends Mock implements HttpsCallableResult {}


//Annotations fot build runner
@GenerateMocks([FirebaseFunctions, HttpsCallable,
  MyAuthController, Geolocator, FirebaseFunctionsCaller])
//To create mocks: flutter pub run  build_runner build --delete-conflicting-outputs

void main() {

  TestWidgetsFlutterBinding.ensureInitialized();



  late MockFirebaseFunctions mockFirebaseFunctions;
  late MockHttpsCallable mockHttpsCallable;
  late MockHttpsCallableResult mockHttpsCallableResult;
  late MyAuthController myAuth;
  late FirebaseFunctionsCaller firebaseFunctionsCaller;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockUser;

  mockFirebaseFunctions = MockFirebaseFunctions();
  mockHttpsCallable = MockHttpsCallable();
  mockHttpsCallableResult = MockHttpsCallableResult();
  mockFirebaseAuth = MockFirebaseAuth();
  myAuth = MyAuthController.forAuth(auth: mockFirebaseAuth);
  mockUser = MockUser();

  firebaseFunctionsCaller =
      FirebaseFunctionsCaller.forFunctions(functions: mockFirebaseFunctions);


  MockFirebaseFunctionsCaller mockFirebaseFunctionsCaller =
  MockFirebaseFunctionsCaller();

  final nearestLocation = {
    'hitMetadata': {
      'distance': 0.006156711684356172,
      'bearing': -7.45926522391955
    },
    'pos': {
      'geohash': 'ezez4u822d',
      'geopoint': {'_longitude': -5.8753, '_latitude': 43.4327}
    },
    'name': 'Casa',
    'id': '123',
    'email': 'email@gmail.com'
  };

  final Position pos = Position(
      longitude: 11.1,
      latitude: 12.1,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  //For general user use
  when(myAuth.getUserId()).thenReturn("123");
  when(myAuth.isUserLoggedIn()).thenReturn(true);
  when(mockFirebaseAuth.currentUser).thenAnswer((realInvocation) => mockUser);
  when(mockUser.uid).thenAnswer((realInvocation) => "123");

  group("Tests for findNearestHealthCenter", () {
    test('findNearestHealthCenter finds a center', () async {
      when(mockFirebaseFunctions
              .httpsCallable('findNearestLocation-findNearestLocation'))
          .thenReturn(mockHttpsCallable);
      when(mockHttpsCallable.call({
        'latitude': pos.latitude,
        'longitude': pos.longitude,
      })).thenAnswer((_) => Future.value(mockHttpsCallableResult));

      when(mockHttpsCallableResult.data).thenReturn(nearestLocation);

      final result = await firebaseFunctionsCaller.findNearestHealthCenter(pos);

      expect(result, "123");
    });

    test('findNearestHealthCenter does not find a center', () async {
      when(mockFirebaseFunctions
              .httpsCallable('findNearestLocation-findNearestLocation'))
          .thenReturn(mockHttpsCallable);
      when(mockHttpsCallable.call({
        'latitude': pos.latitude,
        'longitude': pos.longitude,
      })).thenAnswer((_) => Future.value(mockHttpsCallableResult));

      when(mockHttpsCallableResult.data).thenReturn(null);

      final result = await firebaseFunctionsCaller.findNearestHealthCenter(pos);

      expect(result, "");
    });

    test('findNearestHealthCenter throws an exception for any unknown reason',
        () async {
      when(mockFirebaseFunctions
              .httpsCallable('findNearestLocation-findNearestLocation'))
          .thenReturn(mockHttpsCallable);
      when(mockHttpsCallable.call({
        'latitude': pos.latitude,
        'longitude': pos.longitude,
      })).thenAnswer((_) =>
          throw FirebaseFunctionsException(message: 'any error', code: '1'));

      final result = await firebaseFunctionsCaller.findNearestHealthCenter(pos);

      expect(result, "");
    });
  });

  List<GenericMetric> metrics = [
    BpmMetric(1, false),
    O2Metric(1, false),
    PressureMetric(1, false),
    SugarMetric(1, false)
  ];

  group("Tests for saveMetrics", ()
  {



    test('saveMetrics saves metrics correctly', () async {
      when(mockFirebaseFunctions
          .httpsCallable('saveMetrics'))
          .thenReturn(mockHttpsCallable);
      when(mockHttpsCallable.call({
        'bpm': 1,
        'o2': 1,
        'pressure': 1,
        'sugar': 1,
        'ownerUID': '123',
        'location': {
          'longitude': pos.longitude,
          'latitude': pos.latitude,
        }
      })).thenAnswer((realInvocation) => Future.value( mockHttpsCallableResult));


      when(mockHttpsCallableResult.data).thenReturn(true);
      
      Response res = await firebaseFunctionsCaller.saveMetrics(metrics,pos);

      //If tests gets here without errors, it means it passed
      expect(res.success, true);


    });

    test('saveMetrics throws exception', () async {
      when(mockFirebaseFunctions
          .httpsCallable('saveMetrics'))
          .thenReturn(mockHttpsCallable);
      when(mockHttpsCallable.call({
        'bpm': 1,
        'o2': 1,
        'pressure': 1,
        'sugar': 1,
        'ownerUID': '123',
        'location': {
          'longitude': pos.longitude,
          'latitude': pos.latitude,
        }
      })).thenThrow(FirebaseFunctionsException(message: 'any error', code: '1'));



      when(mockHttpsCallableResult.data).thenReturn(true);

      Response res = await firebaseFunctionsCaller.saveMetrics(metrics,pos);
      expect(res.success, false);


    });

    
    
  });

  group("createUserDoc tests", () {


    test('createUserDoc throws exception, return false', () async {
      when(mockFirebaseFunctions
          .httpsCallable('createUserDoc-createUserDoc'))
          .thenReturn(mockHttpsCallable);
      when(mockHttpsCallable.call({
        'uid': "123",
        'name' : "name",
        'email' : "email",
        'surname' : "surname",
        'phone' : "phone",
      })).thenThrow(FirebaseFunctionsException(message: 'any error', code: '1'));


      Response res = await firebaseFunctionsCaller.createUserDoc("123","email","name","surname","phone");
      expect(res.success, false);


    });


    test('createUserDoc adds the document, returns true', () async {
      when(mockFirebaseFunctions
          .httpsCallable('createUserDoc-createUserDoc'))
          .thenReturn(mockHttpsCallable);
      when(mockHttpsCallable.call({
        'uid': "123",
        'name' : "name",
        'email' : "email",
        'surname' : "surname",
        'phone' : "phone",
      })).thenAnswer((realInvocation) => Future.value( mockHttpsCallableResult));

      Response res = await firebaseFunctionsCaller.createUserDoc("123","email","name","surname","phone");
      expect(res.success, true);


    });


  });


  group("generateAlert tests", ()  {


    setUp(() => {
    //The function also calls findNearestHealthCenter

    //Call to generate alert
    when(mockFirebaseFunctions
        .httpsCallable('sendEmail-sendEmail'))
        .thenReturn(mockHttpsCallable),

         when( mockFirebaseFunctionsCaller.findNearestHealthCenter(pos))
        .thenAnswer((realInvocation) => Future.value("123")),

        when(mockFirebaseFunctions
        .httpsCallable('findNearestLocation-findNearestLocation'))
        .thenReturn(mockHttpsCallable),

        when(mockHttpsCallable.call({
        'latitude': pos.latitude,
        'longitude': pos.longitude,
        })).thenAnswer((_) => Future.value(mockHttpsCallableResult)),

        when(mockHttpsCallableResult.data).thenReturn(nearestLocation),


    });




    test('generateAlert generates correctly the alert', () async {

      when(mockHttpsCallable.call({
        'bpm': 1,
        'o2': 1,
        'pressure': 1,
        'sugar': 1,
        "nearestCenter": "123",
        'location': {
          'longitude': pos.longitude,
          'latitude': pos.latitude,
        }
      })).thenAnswer((realInvocation) => Future.value( mockHttpsCallableResult));

      //Response
      Response res = await firebaseFunctionsCaller.generateAlert(metrics,pos);

      expect(res.success, true);


    });



    test('generateAlert throws exception on serverless function', () async {

      when(mockHttpsCallable.call({
        'bpm': 1,
        'o2': 1,
        'pressure': 1,
        'sugar': 1,
        "nearestCenter": "123",
        'location': {
          'longitude': pos.longitude,
          'latitude': pos.latitude,
        }
      })).thenThrow(FirebaseFunctionsException(message: "error", code: "code"));


      //Response
      Response res = await firebaseFunctionsCaller.generateAlert(metrics,pos);
      expect(res.success, false);
      expect(res.message, "generate-alert-error");

    });





    test('generateAlert not generating alert, no near center', () async {

      when(mockHttpsCallable.call({
        'bpm': 1,
        'o2': 1,
        'pressure': 1,
        'sugar': 1,
        "nearestCenter": '123',
        'location': {
          'longitude': pos.longitude,
          'latitude': pos.latitude,
        }
      })).thenThrow(FirebaseFunctionsException(message: "error", code: "code"));

      when( mockFirebaseFunctionsCaller.findNearestHealthCenter(pos))
          .thenAnswer((realInvocation) => Future.value(''));

      //Response
      Response res = await firebaseFunctionsCaller.generateAlert(metrics,pos);
      expect(res.success, false);

    });





    test('generateAlert not generating alert, user not logged in', () async {
      when(myAuth.isUserLoggedIn()).thenReturn(false);
      when(mockFirebaseAuth.currentUser).thenReturn(null);

      //Response
      Response res = await firebaseFunctionsCaller.generateAlert(metrics,pos);
      expect(res.success, false);
      expect(res.message, "user-must-log");

    });

  });

}


