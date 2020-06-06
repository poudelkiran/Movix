import 'dart:async';
import 'dart:convert' show json;
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:movix/Model/base_model.dart';
import 'package:movix/Utilities/Constant/constants.dart';

/// Request class for api request.
class Request {

  /// connectivity to check the internet connection
  // final Connectivity _connectivity = new Connectivity();

  //Constructor
  Request._privateConstructor();

  //Instance
  static final Request instance = Request._privateConstructor();

  /// Fetch object of given type from the given url.
  Future<NetworkingResult> fetchObject<T extends BaseModel>(String url, T obj) async {
    final hasInternet = await hasInternetConnectivity();
    if (!hasInternet) {
      return NetworkingResult(
          false, Constant.noInternet, null,);
    } else {
      final results = await request(url);
        dynamic resultObject = results;
        final status = resultObject["success"] ?? true;
        //If the status is false, return from here, else go and decode the result.
        if (!status) {
          return NetworkingResult(
              false, resultObject["status_message"], null);
        }
        /// If the result is of type list, get list from json.
        if (resultObject is List) {
          final value =
              resultObject.map<T>((json) => obj.fromJson(json)).toList();
          return NetworkingResult(
              true, null, value);
        } 
        /// If the result is of single object, get object from json
        else {
          final value = obj.fromJson(resultObject);
          return NetworkingResult(
              true, null, value);
        }
    }
  }

  /// Now call the api with the given url.
  Future<Map> request(String url) async {
    http.Response results;
    results = await http.get(url);
    final jsonObject = json.decode(results.body);
    return jsonObject;
  }

  Future<bool> hasInternetConnectivity() async {
  bool result = await DataConnectionChecker().hasConnection;
  return result;
  }

  /// Check if there is internet connection or not
//   Future<bool> hasInternetConnection() async {
// //The test to actually see if there is a connection
//     final connectionStatus = await _connectivity.checkConnectivity();
//     switch (connectionStatus) {
//       case ConnectivityResult.wifi:
//       case ConnectivityResult.mobile:
//         return true;
//         break;
//       default:
//         return false;
//         break;
//     }
//   }
}

/// Result from the network.
class NetworkingResult<T> {
  bool success;
  String error;
  T result;

  NetworkingResult(this.success, this.error, this.result);
}