

import 'package:cloud_firestore/cloud_firestore.dart';
import '../Entities/HeartReading.dart';
import 'package:flutter_app_tfg/services/Firebase/MyAuthController.dart';
import 'package:geolocator/geolocator.dart';

 class FirestoreAccess{

   ///Instance of the firestore [_firestore]
   late FirebaseFirestore _firestore;

   ///Implement singleton
   FirestoreAccess._privateConstructor();
    static FirestoreAccess? _instance;

    factory FirestoreAccess.forFirestore({required FirebaseFirestore firestore}){
      _instance ??= FirestoreAccess._privateConstructor();
      _instance!._firestore = firestore;
      return _instance!;
    }

   factory FirestoreAccess(){
     if(_instance == null){
       _instance = FirestoreAccess._privateConstructor();
       _instance!._firestore = FirebaseFirestore.instance;
     }
     return _instance!;
   }


    ///Get list of all metrics in the last 30 days
   Future<List<HeartReading>> getAllMetricsIn30Days() async {


     //Get all metrics in the last 30 days
     DateTime thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
     DateTime minimalDate = DateTime(
       thirtyDaysAgo.year,
       thirtyDaysAgo.month,
       thirtyDaysAgo.day,
     );

     try{

       final data = await _firestore
           .collection('metrics')
           .where('ownerUID', isEqualTo: MyAuthController().getUserId())
           .where("timestamp", isGreaterThan: minimalDate)
           .orderBy('timestamp', descending: true)
           .get();

       List<HeartReading> meditions = [];

       for (var element in data.docs) {
         meditions.add(
           //Create a HeartMedition object from the data
             HeartReading(
                 element["bpm"],
                 element["o2"],
                 element["sugar"],
                 element["pressure"],
                 element["timestamp"],
                 Position(
                     longitude: element["location"]["longitude"],
                     latitude: element["location"]["latitude"],
                     timestamp: DateTime.fromMillisecondsSinceEpoch(element["timestamp"].millisecondsSinceEpoch),
                     accuracy: 0,
                     altitude: 0,
                     heading: 0,
                     speed: 0,
                     speedAccuracy: 0))
         );

       }

       return meditions;

     } on FirebaseException catch (e){
       return [];
     }




   }




}