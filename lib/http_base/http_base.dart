import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:plates_forward/http_base/constants.dart';

class HttpBase {

  /// Create Http client
  var client = http.Client();

  /// Constructor
  HttpBase();

  ///GET
  Future<dynamic> get({required String api, Map<String, String>? header}) async {
    var url = Uri.parse(UrlConstants.baseUrl + api);
    var response = await client.get(url,headers: header);
    return response;
  }

  ///POST
  Future<dynamic> post({required String api,required String body, Map<String, String>? header}) async {
    var url = Uri.parse(UrlConstants.baseUrl + api);
    //var payload = json.encode(body);
    var response = await client.post(url,headers: header,body: body);
    return response;
  }
}