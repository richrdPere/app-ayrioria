// ignore_for_file: non_constant_identifier_names, unnecessary_this

// Environment
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:app_aryoria/src/config/constants/environment.dart'
    as url_backend;

// Helpers
import 'package:app_aryoria/src/data/datasources/remote/services/helpers/http_Service_helper.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_data.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_paginated.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_request.dart';
import 'package:app_aryoria/src/data/models/login/login_data_model.dart';

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
  Future<Resource<ApiResponse<EmpresaData>>> createEmpresa({
    required String token,
    required EmpresaRequest request,
  }) async {
    try {
      // 1.- URL Base
      Uri url = Uri.parse(API_CREATE_EMPRESA);

      // 2.- Response
      final response = await http.post(
        url,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode(request.toJson()),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<EmpresaData>.fromJson(
          body,
          (rawData) => EmpresaData.fromJson(Map<String, dynamic>.from(rawData)),
        );

        return Success<ApiResponse<EmpresaData>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<EmpresaData>>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<ApiResponse<EmpresaData>>(
        'No se pudo crear la empresa: $error',
      );
    }
  }

  // *********************************************************
  // 2.- Obtener Empresa + Paginado
  // *********************************************************
  Future<Resource<ApiResponse<EmpresaPaginated>>> getEmpresas({
    required String token,
    int page = 1,
    int limit = 10,
    String search = '',
  }) async {
    try {
      // 1.- URL Base
      final queryParameters = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (search.trim().isNotEmpty) 'search': search.trim(),
      };

      final url = Uri.parse(
        API_GET_EMPRESAS_PAGINATED,
      ).replace(queryParameters: queryParameters);

      // 2.- Response
      final response = await http.get(
        url,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<EmpresaPaginated>.fromJson(body, (
          rawData,
        ) {
          return EmpresaPaginated.fromJson(Map<String, dynamic>.from(rawData));
        });

        return Success<ApiResponse<EmpresaPaginated>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<EmpresaPaginated>>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<ApiResponse<EmpresaPaginated>>(
        'No se pudieron obtener las EMPRESAS: $error',
      );
    }
  }

  // *********************************************************
  // 3.- Obtener Empresa por Id
  // *********************************************************
  Future<Resource<ApiResponse<EmpresaData>>> getEmpresaById({
    required int idEmpresa,
    required String token,
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse(
        '$API_GET_EMPRESA_BY_ID$idEmpresa',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      // 2.- Response
      final response = await http.get(
        url,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<EmpresaData>.fromJson(body, (rawData) {
          return EmpresaData.fromJson(Map<String, dynamic>.from(rawData));
        });

        return Success<ApiResponse<EmpresaData>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<EmpresaData>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      return ErrorData<ApiResponse<EmpresaData>>(
        'No se pudo obtener la empresa: $e',
      );
    }
  }

  // *********************************************************
  // 4.- Actualizar Empresa
  // *********************************************************
  Future<Resource<ApiResponse<EmpresaData>>> updateEmpresa({
    required int idEmpresa,
    required EmpresaRequest request,
    required String token,
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse('$API_UPDATE_EMPRESA$idEmpresa');

      // 2.- Response
      final response = await http.put(
        url,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode(request.toJson()),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<EmpresaData>.fromJson(
          body,
          (rawData) => EmpresaData.fromJson(Map<String, dynamic>.from(rawData)),
        );

        return Success<ApiResponse<EmpresaData>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<EmpresaData>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      return ErrorData<ApiResponse<EmpresaData>>(
        'No se pudo actualizar la empresa: $e',
      );
    }
  }

  // *********************************************************
  // 5.- Eliminar Empresa
  // *********************************************************
  Future<Resource<ApiResponse<void>>> deleteEmpresa({
    required int idEmpresa,
    required String token,
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse('$API_DELETE_EMPRESA$idEmpresa');

      // 2.- Response
      final response = await http.delete(
        url,
        headers: HttpServiceHelper.getHeaders(
          token,
          extraHeaders: {'id_empresa': idEmpresa.toString()},
        ),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<void>.fromJson(body, null);

        return Success<ApiResponse<void>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<void>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      return ErrorData<ApiResponse<void>>('No se pudo eliminar la empresa: $e');
    }
  }

  // *********************************************************
  // 6.- Seleccionar Empresa
  // *********************************************************
  Future<Resource<ApiResponse<LoginDataModel>>> selectEmpresa({
    required String token,
    required int idEmpresa,
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse(API_SELECT_EMPRESA);

      final payload = {'id_empresa': idEmpresa};

      // 2.- Response
      final response = await http.post(
        url,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode(payload),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<LoginDataModel>.fromJson(
          body,
          (rawData) =>
              LoginDataModel.fromJson(Map<String, dynamic>.from(rawData)),
        );

        return Success<ApiResponse<LoginDataModel>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<LoginDataModel>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      return ErrorData<ApiResponse<LoginDataModel>>(
        'No se pudo seleccionar la empresa: $e',
      );
    }
  }
}
