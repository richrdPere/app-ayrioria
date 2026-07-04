// ignore_for_file: non_constant_identifier_names, unnecessary_this

import 'dart:convert';
import 'package:app_aryoria/src/data/models/login/auth_response.dart';
import 'package:app_aryoria/src/data/models/register/register_request.dart';
import 'package:app_aryoria/src/data/models/register/register_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Environment
import 'package:app_aryoria/src/config/constants/environment.dart'
    as url_backend;

// Models
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class AuthService with ChangeNotifier {
  // APIS
  String get API_BASE => url_backend.Environment.mainUrl;
  String get API_LOGIN => '$API_BASE/auth/login';
  String get API_REGISTER => '$API_BASE/auth/register';

  // *********************************************************
  // 1.- Login
  // *********************************************************
  Future<Resource<AuthResponse>> login(String username, String password) async {
    try {
      // 1.- URL Base
      Uri url = Uri.parse(API_LOGIN);
      // Uri url = Uri.parse('$baseUrlPrueba/sereno/login_Sereno');

      // 2.- Headers
      Map<String, String> headers = {'Content-Type': 'application/json'};

      // 3.- Body
      String body = json.encode({'username': username, 'password': password});

      // 4.- Response
      final resp = await http.post(url, headers: headers, body: body);
      final Map<String, dynamic> data = json.decode(resp.body);

      // print("AQUI ESTA");
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(data);

        return Success(authResponse);
      } else {
        return ErrorData(data['message']);
      }
    } catch (e) {
      debugPrint('ERROR LOGIN: $e');
      return ErrorData('No fue posible conectarse con el servidor.');
    }
  }

  // *********************************************************
  // 2.- Register
  // *********************************************************
  Future<Resource<RegisterResponse>> register(RegisterRequest request) async {
    try {
      // 1.- URL
      final Uri url = Uri.parse(API_REGISTER);

      // 2.- Headers
      final headers = {'Content-Type': 'application/json'};

      // 3.- Body
      final body = jsonEncode(request.toJson());

      debugPrint("REGISTER BODY:");
      debugPrint(body);

      // 4.- Request
      final response = await http.post(url, headers: headers, body: body);

      final Map<String, dynamic> data = jsonDecode(response.body);

      // 5.- Response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final registerResponse = RegisterResponse.fromJson(data);

        return Success(registerResponse);
      } else {
        return ErrorData(
          data["message"] ?? "No fue posible registrar el usuario.",
        );
      }
    } catch (e) {
      debugPrint("ERROR REGISTER: $e");

      return ErrorData("No fue posible conectarse con el servidor.");
    }
  }
}
