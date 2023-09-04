
import 'package:flutter_app_tfg/services/Firebase/FirestoreAccess.dart';

import 'mocks/db_access_test.mocks.dart';
import 'mocks/auth_test.mocks.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_tfg/services/Entities/HeartReading.dart';
import 'package:flutter_app_tfg/services/Firebase/MyAuthController.dart';
import 'package:geolocator/geolocator.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';


class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot<Map<String,dynamic>>{}


//Annotations fot build runner
@GenerateMocks([ FirebaseFirestore, QuerySnapshot, Query ,
  DocumentSnapshot, CollectionReference<Map<String, dynamic>>,
  DocumentReference])
//To create mocks: flutter pub run  build_runner build --delete-conflicting-outputs
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockCollectionReference<Map<String,dynamic>> mockCollectionReference;
  late MockDocumentReference<Map<String,dynamic>> mockDocumentReference;
  late MockQuerySnapshot<Map<String,dynamic>> mockQuerySnapshot;
  late MockQuery<Map<String,dynamic>> mockQuery;

  mockFirebaseFirestore = MockFirebaseFirestore();
  mockCollectionReference = MockCollectionReference();

  mockDocumentReference = MockDocumentReference();
  mockQuerySnapshot = MockQuerySnapshot();

  mockQuery = MockQuery();

  late MockFirebaseAuth mockFirebaseAuth;
  late MockUser mockFirebaseUser;
  mockFirebaseAuth = MockFirebaseAuth();
  mockFirebaseUser = MockUser();


  FirestoreAccess firestoreAccess =
      FirestoreAccess.forFirestore(firestore: mockFirebaseFirestore);
  MyAuthController myAuth = MyAuthController.forAuth(auth: mockFirebaseAuth);


  final Map<String, dynamic> data =
    {
      "bpm": 80,
      "o2": 90,
      "sugar": 100,
      "pressure": 120,
      "timestamp": Timestamp.now(),
      "location": {
        "longitude": 0.0,
        "latitude": 0.0,
      }
    };




  late MockQueryDocumentSnapshot mockQueryDocumentSnapshot;
  mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();


  //There will be 3 documents read from the database
  final List<MockQueryDocumentSnapshot> docs = [
    mockQueryDocumentSnapshot,
    mockQueryDocumentSnapshot,
    mockQueryDocumentSnapshot
  ];


  test('getAllMetricsIn30Days success ', () async {
    //Create a mock of the data
    DateTime thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    DateTime minimalDate = DateTime(
      thirtyDaysAgo.year,
      thirtyDaysAgo.month,
      thirtyDaysAgo.day,
    );

    when(mockFirebaseFirestore.collection('metrics')).thenReturn(mockCollectionReference);
    when(mockCollectionReference
        .where('ownerUID',
        isEqualTo: '123',
        isNotEqualTo: null,
        isLessThan: null,
        isLessThanOrEqualTo: null,
        isGreaterThan: null,
        isGreaterThanOrEqualTo: null,
        arrayContains: null,
        arrayContainsAny: null,
        whereIn: null,
        whereNotIn: null,
        isNull: null)).thenReturn(mockQuery);

    when(mockQuery
        .where('timestamp',
        isEqualTo: null,
        isNotEqualTo: null,
        isLessThan: null,
        isLessThanOrEqualTo: null,
        isGreaterThan: anyNamed('isGreaterThan'),
        isGreaterThanOrEqualTo: null,
        arrayContains: null,
        arrayContainsAny: null,
        whereIn: null,
        whereNotIn: null,
        isNull: null)).thenReturn(mockQuery);



    when(mockQuery
        .orderBy('timestamp', descending: true)).thenReturn(mockQuery);
    when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
    when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
    when(mockQuerySnapshot.docs).thenReturn(docs);

    when(mockQueryDocumentSnapshot["bpm"]).thenReturn(data["bpm"]);
    when(mockQueryDocumentSnapshot["o2"]).thenReturn(data["o2"]);
    when(mockQueryDocumentSnapshot["sugar"]).thenReturn(data["sugar"]);
    when(mockQueryDocumentSnapshot["pressure"]).thenReturn(data["pressure"]);
    when(mockQueryDocumentSnapshot["timestamp"]).thenReturn(data["timestamp"]);
    when(mockQueryDocumentSnapshot["location"]).thenReturn(data["location"]);


    when(mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);
    when(mockFirebaseUser.uid).thenReturn('123');

   when(mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);
   when(mockFirebaseUser.uid).thenReturn('123');
    //Call the method
    List<HeartReading> meditions = (await firestoreAccess.getAllMetricsIn30Days()) as List<HeartReading>;

    //Check the result
    expect(meditions.length, 3);

  });





  test('getAllMetricsIn30Days return no data ', () async {
    //Create a mock of the data
    DateTime thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    DateTime minimalDate = DateTime(
      thirtyDaysAgo.year,
      thirtyDaysAgo.month,
      thirtyDaysAgo.day,
    );

    when(mockFirebaseFirestore.collection('metrics')).thenReturn(mockCollectionReference);
    when(mockCollectionReference
        .where('ownerUID',
        isEqualTo: '123',
        isNotEqualTo: null,
        isLessThan: null,
        isLessThanOrEqualTo: null,
        isGreaterThan: null,
        isGreaterThanOrEqualTo: null,
        arrayContains: null,
        arrayContainsAny: null,
        whereIn: null,
        whereNotIn: null,
        isNull: null)).thenReturn(mockQuery);

    when(mockQuery
        .where('timestamp',
        isEqualTo: null,
        isNotEqualTo: null,
        isLessThan: null,
        isLessThanOrEqualTo: null,
        isGreaterThan: anyNamed('isGreaterThan'),
        isGreaterThanOrEqualTo: null,
        arrayContains: null,
        arrayContainsAny: null,
        whereIn: null,
        whereNotIn: null,
        isNull: null)).thenReturn(mockQuery);



    when(mockQuery
        .orderBy('timestamp', descending: true)).thenReturn(mockQuery);
    when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
    when(mockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
    when(mockQuerySnapshot.docs).thenReturn([]);

    when(mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);
    when(mockFirebaseUser.uid).thenReturn('123');

    when(mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);
    when(mockFirebaseUser.uid).thenReturn('123');
    //Call the method
    List<HeartReading> meditions = (await firestoreAccess.getAllMetricsIn30Days()) as List<HeartReading>;

    //Check the result
    expect(meditions.length, 0);

  });


  test('getAllMetricsIn30Days fails with exception -> return no data ', () async {
    //Create a mock of the data
    DateTime thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    DateTime minimalDate = DateTime(
      thirtyDaysAgo.year,
      thirtyDaysAgo.month,
      thirtyDaysAgo.day,
    );

    when(mockFirebaseFirestore.collection('metrics'))
        .thenAnswer((_)=>throw FirebaseException(plugin: 'test'));

    //Call the method
    List<HeartReading> meditions = (await firestoreAccess.getAllMetricsIn30Days()) as List<HeartReading>;

    //Check the result
    expect(meditions.length, 0);

  });


}
