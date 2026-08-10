// ignore_for_file: non_constant_identifier_names, unnecessary_this

// Environment
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:app_aryoria/src/config/constants/environment.dart'
    as url_backend;

// Helpers
import 'package:app_aryoria/src/data/datasources/remote/services/helpers/http_Service_helper.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_data.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_paginated.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_query_params.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_request.dart';

class PeriodoContableService {
  // APIS
  String get API_BASE => '${url_backend.Environment.mainUrl}/periodo-contable';

  String get API_CREATE_PERIODO_C => '$API_BASE/crear';
  String get API_GET_PERIODO_C_PAGINATED => '$API_BASE/paginated';
  String get API_GET_PERIODO_C_BY_ID => '$API_BASE/detalle/';
  String get API_UPDATE_PERIODO_C => '$API_BASE/editar/';
  String get API_DELETE_PERIODO_C => '$API_BASE/eliminar/';
  String get API_CHANGE_ESTADO_PERIODO_C => '$API_BASE/estado/';

  // *********************************************************
  // 1.- Crear Periodo Contable
  // *********************************************************
  Future<Resource<ApiResponse<PeriodoContableData>>> createPeriodoContable({
    required String token,
    required PeriodoContableRequest request,
  }) async {
    try {
      // 1.- URL Base
      final url = Uri.parse(API_CREATE_PERIODO_C);

      // 2.- Response
      final response = await http.post(
        url,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode(request.toJson()),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<PeriodoContableData>.fromJson(
          body,
          (rawData) =>
              PeriodoContableData.fromJson(Map<String, dynamic>.from(rawData)),
        );

        return Success<ApiResponse<PeriodoContableData>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<PeriodoContableData>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      debugPrint('ERROR CREAR PERIODO CONTABLE: $e');

      return ErrorData<ApiResponse<PeriodoContableData>>(
        'No se pudo crear el periodo contable: $e',
      );
    }
  }

  // *********************************************************
  // 2.- OBTENER PERÍODOS CONTABLES PAGINADOS
  // *********************************************************
  Future<Resource<ApiResponse<PeriodoContablePaginated>>> getPeriodosContables({
    required String token,
    required int idEmpresa,
    required PeriodosContablesParams queryParams,
  }) async {
    try {
      final Map<String, dynamic> params = {
        ...queryParams.toQueryParams(),
        'id_empresa': idEmpresa,
      };

      final Uri url = Uri.parse(API_GET_PERIODO_C_PAGINATED).replace(
        queryParameters: params.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      // 2.- Response
      final response = await http.get(
        url,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<PeriodoContablePaginated>.fromJson(
          body,
          (rawData) {
            return PeriodoContablePaginated.fromJson(
              Map<String, dynamic>.from(rawData),
            );
          },
        );

        return Success<ApiResponse<PeriodoContablePaginated>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<
        ApiResponse<PeriodoContablePaginated>
      >(body, response.statusCode);
    } catch (e) {
      debugPrint('ERROR LISTAR PERIODOS: $e');

      return ErrorData<ApiResponse<PeriodoContablePaginated>>(
        'No se pudieron obtener los periodos contables: $e',
      );
    }
  }

  // *********************************************************
  // 3.- Obtener Periodo Contable por Id
  // *********************************************************
  Future<Resource<ApiResponse<PeriodoContableData>>> getPeriodoContableById({
    required String token,
    required int idPeriodo,
    required int idEmpresa,
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse(
        '$API_GET_PERIODO_C_BY_ID$idPeriodo',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      // 2.- Response
      final response = await http.get(
        url,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<PeriodoContableData>.fromJson(body, (
          rawData,
        ) {
          return PeriodoContableData.fromJson(
            Map<String, dynamic>.from(rawData),
          );
        });

        return Success<ApiResponse<PeriodoContableData>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<PeriodoContableData>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      debugPrint('ERROR DETALLE PERIODO: $e');

      return ErrorData<ApiResponse<PeriodoContableData>>(
        'No se pudo obtener el periodo contable: $e',
      );
    }
  }

  // *********************************************************
  // 4.- Actualizar Periodo Contable
  // *********************************************************
  Future<Resource<ApiResponse<PeriodoContableData>>> updatePeriodoContable({
    required String token,
    required int idPeriodo,
    required int idEmpresa,
    required PeriodoContableRequest request,
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse(
        '$API_UPDATE_PERIODO_C$idPeriodo',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      // 2.- Response
      final response = await http.put(
        url,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode(request.toJson()),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<PeriodoContableData>.fromJson(
          body,
          (rawData) =>
              PeriodoContableData.fromJson(Map<String, dynamic>.from(rawData)),
        );

        return Success<ApiResponse<PeriodoContableData>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<PeriodoContableData>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      debugPrint('ERROR ACTUALIZAR PERIODO: $e');

      return ErrorData<ApiResponse<PeriodoContableData>>(
        'No se pudo actualizar el periodo contable: $e',
      );
    }
  }

  // *********************************************************
  // 5.- Eliminar Periodo Contable
  // *********************************************************
  Future<Resource<ApiResponse<void>>> deletePeriodoContable({
    required String token,
    required int idPeriodo,
    required int idEmpresa,
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse(
        '$API_DELETE_PERIODO_C$idPeriodo',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

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
      debugPrint('ERROR ELIMINAR PERIODO: $e');

      return ErrorData<ApiResponse<void>>(
        'No se pudo eliminar el periodo contable: $e',
      );
    }
  }

  // *********************************************************
  // 6.- Cambiar Estado de Periodo Contable
  // *********************************************************
  Future<Resource<ApiResponse<PeriodoContableData>>>
  changeEstadoPeriodoContable({
    required String token,
    required int idPeriodo,
    required int idEmpresa,
    required String estado,
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse(
        '$API_CHANGE_ESTADO_PERIODO_C$idPeriodo',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      // 2.- Response
      final response = await http.patch(
        url,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode({'estado': estado}),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<PeriodoContableData>.fromJson(
          body,
          (rawData) =>
              PeriodoContableData.fromJson(Map<String, dynamic>.from(rawData)),
        );

        return Success<ApiResponse<PeriodoContableData>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<PeriodoContableData>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      debugPrint('ERROR CAMBIAR ESTADO PERIODO: $e');

      return ErrorData<ApiResponse<PeriodoContableData>>(
        'No se pudo cambiar el estado del periodo contable: $e',
      );
    }
  }
}
