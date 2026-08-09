// ignore_for_file: non_constant_identifier_names, unnecessary_this

// Environment
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app_aryoria/src/config/constants/environment.dart'
    as url_backend;
import 'package:http/http.dart' as http;

// Helpers
import 'package:app_aryoria/src/data/datasources/remote/services/helpers/http_Service_helper.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_create_request.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_paginated.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_query_params.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_update_request.dart';

class MovimientoService {
  // APIS
  String get API_BASE => '${url_backend.Environment.mainUrl}/movimientos';

  String get API_REGISTER_MOVIMIENTO => '$API_BASE/crear';
  String get API_GET_MOVIMIENTOS_PAGINATED => '$API_BASE/paginated';
  String get API_GET_MOVIMIENTO_BY_ID => '$API_BASE/detalle/';
  String get API_UPDATE_MOVIMIENTO => '$API_BASE/editar/';
  String get API_DELETE_MOVIMIENTO => '$API_BASE/eliminar/';

  // *********************************************************
  // 1.- Crear Movimiento
  // *********************************************************
  Future<Resource<ApiResponse<MovimientoData>>> createMovimiento({
    required String token,
    required MovimientoCreateRequest request,
  }) async {
    try {
      // 1.- URL Base
      Uri url = Uri.parse(API_REGISTER_MOVIMIENTO);

      // 2.- Response
      final response = await http.post(
        url,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode(request.toJson()),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<MovimientoData>.fromJson(
          body,
          (rawData) =>
              MovimientoData.fromJson(Map<String, dynamic>.from(rawData)),
        );

        return Success<ApiResponse<MovimientoData>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<MovimientoData>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      debugPrint("ERROR CREAR EMPRESA: $e");
      return ErrorData<ApiResponse<MovimientoData>>(
        'No se pudo crear el movimiento: $e',
      );
    }
  }

  // *********************************************************
  // 2.- Obtener Movimientos + Paginado
  // *********************************************************
  Future<Resource<ApiResponse<MovimientoPaginated>>> getMovimientos({
    required String token,
    required int idEmpresa,
    required MovimientoQueryParams queryParams,
  }) async {
    try {
      // 1.- URL Base
      final Map<String, dynamic> params = {
        ...queryParams.toQueryParams(),
        'id_empresa': idEmpresa,
      };

      final uri = Uri.parse(API_GET_MOVIMIENTOS_PAGINATED).replace(
        queryParameters: params.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      // 2.- Response
      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<MovimientoPaginated>.fromJson(body, (
          rawData,
        ) {
          return MovimientoPaginated.fromJson(
            Map<String, dynamic>.from(rawData),
          );
        });

        return Success<ApiResponse<MovimientoPaginated>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<MovimientoPaginated>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      debugPrint('ERROR GET MOVIMIENTOS: $e');
      return ErrorData<ApiResponse<MovimientoPaginated>>(
        'No se pudieron obtener los movimientos: $e',
      );
    }
  }

  // *********************************************************
  // 3.- Obtener Movimiento por ID
  // *********************************************************
  Future<Resource<ApiResponse<MovimientoData>>> getMovimientoById({
    required String token,
    required int idEmpresa,
    required int idMovimiento,
  }) async {
    try {
      // 1.- URL
      final uri = Uri.parse(
        '$API_GET_MOVIMIENTO_BY_ID$idMovimiento',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      // 2.- Response
      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<MovimientoData>.fromJson(body, (
          rawData,
        ) {
          return MovimientoData.fromJson(Map<String, dynamic>.from(rawData));
        });

        return Success<ApiResponse<MovimientoData>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<MovimientoData>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      debugPrint('ERROR GET MOVIMIENTO BY ID: $e');
      return ErrorData<ApiResponse<MovimientoData>>(
        'No se pudo obtener el movimiento: $e',
      );
    }
  }

  // *********************************************************
  // 4.- Actualizar Movimiento
  // *********************************************************
  Future<Resource<ApiResponse<MovimientoData>>> updateMovimiento({
    required String token,
    required int idMovimiento,
    required int idEmpresa,
    required MovimientoUpdateRequest request,
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse(
        '$API_UPDATE_MOVIMIENTO$idMovimiento',
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
        final apiResponse = ApiResponse<MovimientoData>.fromJson(
          body,
          (rawData) =>
              MovimientoData.fromJson(Map<String, dynamic>.from(rawData)),
        );

        return Success<ApiResponse<MovimientoData>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<MovimientoData>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      debugPrint('ERROR UPDATE MOVIMIENTO: $e');
      return ErrorData<ApiResponse<MovimientoData>>(
        'No se pudo actualizar el movimiento: $e',
      );
    }
  }

  // *********************************************************
  // 5.- Eliminar Movimiento
  // *********************************************************
  Future<Resource<ApiResponse<void>>> deleteMovimiento({
    required String token,
    required int idMovimiento,
    required int idEmpresa,
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse('$API_DELETE_MOVIMIENTO$idMovimiento');

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
      debugPrint('ERROR DELETE MOVIMIENTO: $e');
      return ErrorData<ApiResponse<void>>(
        'No se pudo eliminar el movimiento: $e',
      );
    }
  }
}
