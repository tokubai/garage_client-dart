library garage_client_dart;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:garage_client_dart/error/garage_error.dart';
import 'package:garage_client_dart/request_body.dart';
import 'package:garage_client_dart/user_authenticator.dart';

class GarageClient {
  UserAuthenticator _userAuthenticator;

  final _client = HttpClient();

  GarageClient(this._userAuthenticator);

  Future<dynamic> post(String path, RequestBody requestBody) async {
    var completer = Completer<dynamic>();

    await _userAuthenticator.getAuthTokenIfNeeded();

    var request = await _client.postUrl(Uri.parse(path));

    print("uri: ${request.uri.toString()}");

    requestBody.headers
        .forEach((name, value) => request.headers.set(name, value));

    await _userAuthenticator.requestPreparing(request);

    request.headers.forEach((key, value) => print("$key : $value"));

    request.add(utf8.encode(requestBody.parameter));

    completer.complete(_execute(request));
    return completer.future;
  }

  Future<dynamic> get(String path, Parameter parameter) async {
    var completer = Completer<dynamic>();

    await _userAuthenticator.getAuthTokenIfNeeded();

    var request = await _client.getUrl(Uri.parse("$path?${parameter.build()}"));

    print("uri: ${request.uri.toString()}");

    await _userAuthenticator.requestPreparing(request);

    request.headers.forEach((key, value) => print("$key : $value"));

    completer.complete(_execute(request));
    return completer.future;
  }

  Future<dynamic> _execute(HttpClientRequest request) async {
    HttpClientResponse response = await request.close();

    String jsonStr = await purseToJson(response);
    var statusCode = response.statusCode;
    print("statusCode: $statusCode");

    if (statusCode < 200 || statusCode >= 300) {
      throw GarageError(response);
    }

    _userAuthenticator.authenticationIfNeeded(response);

    return json.decode(jsonStr);
  }

  static Future<String> purseToJson(HttpClientResponse response) async {
    var json = "";
    await for (var contents
        in response.transform(utf8.decoder).transform(const LineSplitter())) {
      print(contents);
      json += contents;
    }
    return json;
  }
}
