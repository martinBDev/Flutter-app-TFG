
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_app_tfg/services/Entities/Metrics/GenericMetric.dart';
import '../Entities/Response.dart';
import 'package:geolocator/geolocator.dart';

import 'MyAuthController.dart';


class FirebaseFunctionsCaller {


  ///Instance of FirebaseFunctions [_functions]
  late final FirebaseFunctions _functions;


  ///Implement singleton
  FirebaseFunctionsCaller._privateConstructor();
  static FirebaseFunctionsCaller? _instance;

  factory FirebaseFunctionsCaller(){
    if(_instance == null){
      _instance = FirebaseFunctionsCaller._privateConstructor();
      _instance!._functions = FirebaseFunctions.instanceFor(region: 'europe-west3');
    }
    return _instance!;
  }

  factory FirebaseFunctionsCaller.forFunctions({required FirebaseFunctions functions}){
    if(_instance == null){
      _instance = FirebaseFunctionsCaller._privateConstructor();
      _instance!._functions = functions;
    }
    return _instance!;
  }




  ///Ask firebase functions to calculate nearest hospital based on user [position]
  Future<String> findNearestHealthCenter(Position position) async{


    try{
      final result = await _functions.httpsCallable('findNearestLocation-findNearestLocation').call({
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
      print(result.data);
      if(result.data == null){
        return '';
      }
      return result.data ["id"];
    } on FirebaseFunctionsException catch(e){
      print(e.code);
      print(e.message);
      print(e.details);
      return '';

    }



  }

  ///Send [metrics] to firebase through cloud functions, also add [pos] to the request
  Future<Response> saveMetrics(List<GenericMetric> metrics, Position pos) async {



    try {
      if(!MyAuthController().isUserLoggedIn()){
        return Response(false, "user-must-log");
      }


      String uid = MyAuthController().getUserId();

      Map<String, dynamic> metricsJson = _convertToMap(metrics);


      metricsJson.addEntries(
        {
          MapEntry('ownerUID', uid),
          MapEntry('location', {
            'longitude': pos.longitude,
            'latitude': pos.latitude,
          }),
        }
      );


      await _functions.httpsCallable('saveMetrics').call(metricsJson);

      return Response(true, "save-metrics-success");
    } on FirebaseFunctionsException catch (e) {

      print(e.code);
      print(e.message);
      print(e.details);

      return Response(false, "save-metrics-error");
    }
  }

  ///Create a user document when a new user signs up through cloud functions.
  ///[uId] is the user id, [email] is the user email, [name] is the user name,
  ///[surname] is the user surname and [phone] is the user phone
  Future<Response> createUserDoc(String uId, String email, String name,
      String surname, String phone) async {
    try {
      await _functions.httpsCallable('createUserDoc-createUserDoc').call(<String, dynamic>{
        'uid': uId,
        'name' : name,
        'email' : email,
        'surname' : surname,
        'phone' : phone,
      });
      return Response(true, "create-user-success");
    } on FirebaseFunctionsException catch (e) {
      print(e.code);
      print(e.message);
      print(e.details);
      return Response(false, "create-user-error");
    }
  }


  ///Send an alert based on [metrics] to firebase through cloud functions, also add [pos] to the request
  Future<Response> generateAlert(List<GenericMetric> metrics, Position pos) async {

    try {
      if(!MyAuthController().isUserLoggedIn()){
        return Response(false, "user-must-log");
      }

      final nearestCenterId = await findNearestHealthCenter(pos);

      if(nearestCenterId == ''){
        return Response(false, "find-center-error");
      }

      Map<String, dynamic> alertJson = _convertToMap(metrics);

      alertJson.addEntries(
          {
            MapEntry('nearestCenter',nearestCenterId),
            MapEntry('location', {
              'longitude': pos.longitude,
              'latitude': pos.latitude,
            }),
          }
      );

      await _functions.httpsCallable('sendEmail-sendEmail').call(alertJson);

      return Response(true, "generate-alert-success");

    } on FirebaseFunctionsException catch (e) {
      print(e.code);
      print(e.message);
      print(e.details);
      return Response(false, "generate-alert-error");
    }

  }




  ///Convert a list of [metrics] to a map
  Map<String, dynamic> _convertToMap(List<GenericMetric> metrics){
    Map<String, dynamic> metricsJson = {};
    //Get metrics from the list
    for (var element in metrics) {
      //Add metrics to Json
      metricsJson.addEntries({
        MapEntry(element.name, element.value)
      });

    }
    return metricsJson;
  }

}