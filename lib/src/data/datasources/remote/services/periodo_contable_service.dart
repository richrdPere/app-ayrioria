// ignore_for_file: non_constant_identifier_names, unnecessary_this

// Environment
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:app_aryoria/src/config/constants/environment.dart'
    as url_backend;

// Helpers
import 'package:app_aryoria/src/data/datasources/remote/services/helpers/http_Service_helper.dart';

// Models
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_paginated.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_request.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_response.dart';

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
  Future<Resource<PeriodoContableResponse>> createPeriodoContable({
    required String token,
    required PeriodoContableRequest request,
  }) async {
    try {
      final url = Uri.parse(API_CREATE_PERIODO_C);

      final response = await http.post(
        url,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode(request.toJson()),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        return Success<PeriodoContableResponse>(
          PeriodoContableResponse.fromJson(body),
        );
      }

      return HttpServiceHelper.buildError<PeriodoContableResponse>(
        body,
        response.statusCode,
      );
    } catch (error) {
      debugPrint('ERROR CREAR PERIODO CONTABLE: $error');

      return ErrorData<PeriodoContableResponse>(
        'No se pudo crear el período contable.',
      );
    }
  }

  // *********************************************************
  // 2.- OBTENER PERÍODOS CONTABLES PAGINADOS
  // *********************************************************
  Future<Resource<PeriodoContablePaginatedResponse>> getPeriodosContables({
    required String token,
    required int idEmpresa,
    required Map<String, dynamic> queryParams,
  }) async {
    try {
      final Map<String, dynamic> params = {
        ...queryParams,
        'id_empresa': idEmpresa,
      };

      final Uri url = Uri.parse(API_GET_PERIODO_C_PAGINATED).replace(
        queryParameters: params.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      debugPrint('URL LISTAR PERIODOS: $url');
      debugPrint('ID EMPRESA SERVICE: $idEmpresa');
      debugPrint('QUERY PARAMS PERIODOS: $params');

      final response = await http.get(
        url,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      debugPrint('RESPONSE LISTAR PERIODOS: $body');

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        return Success(PeriodoContablePaginatedResponse.fromJson(body));
      }

      return HttpServiceHelper.buildError<PeriodoContablePaginatedResponse>(
        body,
        response.statusCode,
      );
    } catch (error) {
      debugPrint('ERROR LISTAR PERIODOS: $error');

      return ErrorData('No se pudieron obtener los períodos contables.');
    }
  }

  // *********************************************************
  // 3.- Obtener Periodo Contable por Id
  // *********************************************************
  Future<Resource<PeriodoContableResponse>> getPeriodoContableById({
    required String token,
    required int idPeriodo,
    required int idEmpresa,
  }) async {
    try {
      final url = Uri.parse(
        '$API_GET_PERIODO_C_BY_ID$idPeriodo',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      final response = await http.get(
        url,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        return Success(PeriodoContableResponse.fromJson(body));
      }

      return HttpServiceHelper.buildError<PeriodoContableResponse>(
        body,
        response.statusCode,
      );
    } catch (error) {
      debugPrint('ERROR DETALLE PERIODO: $error');

      return ErrorData('No se pudo obtener el período contable.');
    }
  }

  // *********************************************************
  // 4.- Actualizar Periodo Contable
  // *********************************************************
  Future<Resource<PeriodoContableResponse>> updatePeriodoContable({
    required String token,
    required int idPeriodo,
    required int idEmpresa,
    required PeriodoContableRequest request,
  }) async {
    try {
      final url = Uri.parse(
        '$API_UPDATE_PERIODO_C$idPeriodo',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      final response = await http.put(
        url,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode(request.toJson()),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        return Success(PeriodoContableResponse.fromJson(body));
      }

      return HttpServiceHelper.buildError<PeriodoContableResponse>(
        body,
        response.statusCode,
      );
    } catch (error) {
      debugPrint('ERROR ACTUALIZAR PERIODO: $error');

      return ErrorData('No se pudo actualizar el período.');
    }
  }

  // *********************************************************
  // 5.- Eliminar Periodo Contable
  // *********************************************************
  Future<Resource<PeriodoContableResponse>> deletePeriodoContable({
    required String token,
    required int idPeriodo,
    required int idEmpresa,
  }) async {
    try {
      final url = Uri.parse(
        '$API_DELETE_PERIODO_C$idPeriodo',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      final response = await http.delete(
        url,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        return Success(PeriodoContableResponse.fromJson(body));
      }

      return HttpServiceHelper.buildError<PeriodoContableResponse>(
        body,
        response.statusCode,
      );
    } catch (error) {
      debugPrint('ERROR ELIMINAR PERIODO: $error');

      return ErrorData('No se pudo eliminar el período.');
    }
  }

  // *********************************************************
  // 6.- Cambiar Estado de Periodo Contable
  // *********************************************************
  Future<Resource<PeriodoContableResponse>> changeEstadoPeriodoContable({
    required String token,
    required int idPeriodo,
    required int idEmpresa,
    required String estado,
  }) async {
    try {
      final url = Uri.parse(
        '$API_CHANGE_ESTADO_PERIODO_C$idPeriodo',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      final response = await http.patch(
        url,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode({'estado': estado}),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        return Success(PeriodoContableResponse.fromJson(body));
      }

      return HttpServiceHelper.buildError<PeriodoContableResponse>(
        body,
        response.statusCode,
      );
    } catch (error) {
      debugPrint('ERROR CAMBIAR ESTADO PERIODO: $error');

      return ErrorData('No se pudo cambiar el estado del período.');
    }
  }
}
