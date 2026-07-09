// ignore_for_file: non_constant_identifier_names, unnecessary_this

// Environment
import 'dart:convert';
import 'package:app_aryoria/src/data/models/common/base_response.dart';
import 'package:app_aryoria/src/data/models/login/auth_response.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:app_aryoria/src/config/constants/environment.dart'
    as url_backend;

// Models
import 'package:app_aryoria/src/data/models/empresa/empresa_response.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_request.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_paginated.dart';

class EmpresaService {
  // APIS
  String get API_BASE => url_backend.Environment.mainUrl + '/empresas';

  String get API_CREATE_EMPRESA => '$API_BASE/crear';
  String get API_GET_EMPRESAS_PAGINATED => '$API_BASE/paginated';
  String get API_GET_EMPRESA_BY_ID => '$API_BASE/detalle/';
  String get API_UPDATE_EMPRESA => '$API_BASE/editar/';
  String get API_DELETE_EMPRESA => '$API_BASE/eliminar/';
  String get API_SELECT_EMPRESA => '$API_BASE/seleccionar';

  // *********************************************************
  // 1.- Crear Empresa
  // *********************************************************
  Future<Resource<EmpresaResponse>> createEmpresa({
    required String token,
    required EmpresaRequest request,
  }) async {
    try {
      // 1.- URL Base
      Uri url = Uri.parse(API_CREATE_EMPRESA);

      // 2.- Headers
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // 3.- Body
      final body = jsonEncode(request.toJson());

      // 4.- Response
      final resp = await http.post(url, headers: headers, body: body);
      final Map<String, dynamic> data = jsonDecode(resp.body);

      // 5.- Response
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final empresaResponse = EmpresaResponse.fromJson(data);

        return Success(empresaResponse);
      } else {
        return ErrorData(data["message"] ?? "Error al crear la empresa.");
      }
    } catch (e) {
      debugPrint("ERROR CREAR EMPRESA: $e");
      return ErrorData('No fue posible conectarse con el servidor.');
    }
  }

  // *********************************************************
  // 2.- Obtener Empresa + Paginado
  // *********************************************************
  Future<Resource<EmpresaPaginatedResponse>> getEmpresas({
    required String token,
    int page = 1,
    int limit = 10,
    String search = '',
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse(
        '$API_GET_EMPRESAS_PAGINATED'
        '?page=$page&limit=$limit&search=${Uri.encodeQueryComponent(search)}',
      );

      // 2.- Headers
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // 3.- Request
      final resp = await http.get(url, headers: headers);

      final Map<String, dynamic> data = jsonDecode(resp.body);

      // 4.- Response
      if (resp.statusCode == 200) {
        final response = EmpresaPaginatedResponse.fromJson(data);

        return Success(response);
      } else {
        return ErrorData(
          data['message'] ?? 'No fue posible obtener las empresas.',
        );
      }
    } catch (e) {
      debugPrint('ERROR GET EMPRESAS: $e');

      return ErrorData('No fue posible conectarse con el servidor.');
    }
  }

  // *********************************************************
  // 3.- Obtener Empresa por Id
  // *********************************************************
  Future<Resource<EmpresaResponse>> getEmpresaById({
    required int idEmpresa,
    required String token,
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse('$API_GET_EMPRESA_BY_ID$idEmpresa');

      // 2.- Headers
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // 3.- Request
      final resp = await http.get(url, headers: headers);

      final Map<String, dynamic> data = jsonDecode(resp.body);

      // 4.- Response
      if (resp.statusCode == 200) {
        final empresaResponse = EmpresaResponse.fromJson(data);

        return Success(empresaResponse);
      } else {
        return ErrorData(
          data["message"] ?? "No fue posible obtener la empresa.",
        );
      }
    } catch (e) {
      debugPrint("ERROR OBTENER EMPRESA: $e");

      return ErrorData("No fue posible conectarse con el servidor.");
    }
  }

  // *********************************************************
  // 4.- Actualizar Empresa
  // *********************************************************
  Future<Resource<EmpresaResponse>> updateEmpresa({
    required int idEmpresa,
    required EmpresaRequest request,
    required String token,
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse('$API_UPDATE_EMPRESA$idEmpresa');

      // 2.- Headers
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // 3.- Body
      final body = jsonEncode(request.toJson());

      // 4.- Request
      final resp = await http.put(url, headers: headers, body: body);

      final Map<String, dynamic> data = jsonDecode(resp.body);

      // 5.- Response
      if (resp.statusCode == 200) {
        return Success(EmpresaResponse.fromJson(data));
      }

      return ErrorData(
        data["message"] ?? "No fue posible actualizar la empresa.",
      );
    } catch (e) {
      debugPrint("ERROR ACTUALIZAR EMPRESA: $e");

      return ErrorData("No fue posible conectarse con el servidor.");
    }
  }

  // *********************************************************
  // 5.- Eliminar Empresa
  // *********************************************************
  Future<Resource<BaseResponse>> deleteEmpresa({
    required int idEmpresa,
    required String token,
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse('$API_DELETE_EMPRESA$idEmpresa');

      // 2.- Headers
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // 3.- Request
      final resp = await http.delete(url, headers: headers);

      final Map<String, dynamic> data = jsonDecode(resp.body);

      // 4.- Response
      if (resp.statusCode == 200) {
        return Success(BaseResponse.fromJson(data));
      }

      return ErrorData(
        data["message"] ?? "No fue posible eliminar la empresa.",
      );
    } catch (e) {
      debugPrint("ERROR ELIMINAR EMPRESA: $e");

      return ErrorData("No fue posible conectarse con el servidor.");
    }
  }

  // *********************************************************
  // 6.- Seleccionar Empresa
  // *********************************************************
  Future<Resource<AuthResponse>> selectEmpresa({
    required String token,
    required int idEmpresa,
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse(API_SELECT_EMPRESA);

      // 2.- Headers
      final headers = <String, String>{
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      // 3.- Body
      final body = jsonEncode({"id_empresa": idEmpresa});

      // 4.- Request
      final resp = await http.post(url, headers: headers, body: body);

      final Map<String, dynamic> data = jsonDecode(resp.body);

      // 5.- Response
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        return Success(AuthResponse.fromJson(data));
      } else {
        return ErrorData(
          data["message"] ?? "No fue posible seleccionar la empresa.",
        );
      }
    } catch (e) {
      debugPrint("ERROR SELECT EMPRESA: $e");

      return ErrorData("No fue posible conectarse con el servidor.");
    }
  }
}
