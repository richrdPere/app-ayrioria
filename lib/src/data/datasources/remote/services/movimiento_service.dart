// ignore_for_file: non_constant_identifier_names, unnecessary_this

// Environment
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app_aryoria/src/config/constants/environment.dart'
    as url_backend;
import 'package:http/http.dart' as http;

// Models
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_paginated.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_request.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_response.dart';

class MovimientoService {
  // APIS
  String get API_BASE => url_backend.Environment.mainUrl + '/movimientos';

  String get API_REGISTER_MOVIMIENTO => '$API_BASE/crear';
  String get API_GET_MOVIMIENTOS_PAGINATED => '$API_BASE/paginated';
  String get API_GET_MOVIMIENTO_BY_ID => '$API_BASE/detalle/';
  String get API_UPDATE_MOVIMIENTO => '$API_BASE/editar/';
  String get API_DELETE_MOVIMIENTO => '$API_BASE/eliminar/';

  Map<String, String> _headers(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // *********************************************************
  // 1.- Crear Movimiento
  // *********************************************************
  Future<Resource<MovimientoResponse>> createMovimiento({
    required String token,
    required MovimientoRequest request,
  }) async {
    try {
      // 1.- URL Base
      Uri url = Uri.parse(API_REGISTER_MOVIMIENTO);

      // 2.- Headers
      final resp = await http.post(
        url,
        headers: _headers(token),
        body: jsonEncode(request.toJson()),
      );

      // 3.- Response
      final Map<String, dynamic> data = jsonDecode(resp.body);

      // 4.- Response
      if (resp.statusCode == 200 || resp.statusCode == 201) {
        return Success(MovimientoResponse.fromJson(data));
      }

      return ErrorData(data["message"] ?? "Error al crear el movimiento.");
    } catch (e) {
      debugPrint("ERROR CREAR EMPRESA: $e");
      return ErrorData('No fue posible conectarse con el servidor.');
    }
  }

  // *********************************************************
  // 2.- Obtener Movimientos + Paginado
  // *********************************************************
  Future<Resource<MovimientoPaginatedResponse>> getMovimientos({
    required String token,
    required int idEmpresa,
    required int idPeriodo,
    int page = 1,
    int limit = 10,
    String search = '',
  }) async {
    try {
      final queryParams = <String, String>{
        'id_empresa': idEmpresa.toString(),
        'id_periodo': idPeriodo.toString(),
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }

      final url = Uri.parse(
        API_GET_MOVIMIENTOS_PAGINATED,
      ).replace(queryParameters: queryParams);

      final resp = await http.get(url, headers: _headers(token));
      final Map<String, dynamic> data = jsonDecode(resp.body);

      debugPrint("MOVIMIENTOS: $data");

      if (resp.statusCode == 200) {
        return Success(MovimientoPaginatedResponse.fromJson(data));
      }

      return ErrorData(
        data['message'] ?? 'No fue posible obtener los movimientos.',
      );
    } catch (e) {
      debugPrint('ERROR GET MOVIMIENTOS: $e');
      return ErrorData('No fue posible conectarse con el servidor.');
    }
  }

  // *********************************************************
  // 3.- Obtener Movimiento por ID
  // *********************************************************
  Future<Resource<MovimientoResponse>> getMovimientoById({
    required String token,
    required int idMovimiento,
  }) async {
    try {
      final url = Uri.parse('$API_GET_MOVIMIENTO_BY_ID$idMovimiento');

      final resp = await http.get(url, headers: _headers(token));
      final Map<String, dynamic> data = jsonDecode(resp.body);

      if (resp.statusCode == 200) {
        return Success(MovimientoResponse.fromJson(data));
      }

      return ErrorData(
        data['message'] ?? 'No fue posible obtener el movimiento.',
      );
    } catch (e) {
      debugPrint('ERROR GET MOVIMIENTO BY ID: $e');
      return ErrorData('No fue posible conectarse con el servidor.');
    }
  }

  // *********************************************************
  // 4.- Actualizar Movimiento
  // *********************************************************
  Future<Resource<MovimientoResponse>> updateMovimiento({
    required String token,
    required int idMovimiento,
    required MovimientoRequest request,
  }) async {
    try {
      final url = Uri.parse('$API_UPDATE_MOVIMIENTO$idMovimiento');

      final resp = await http.put(
        url,
        headers: _headers(token),
        body: jsonEncode(request.toJson()),
      );

      final Map<String, dynamic> data = jsonDecode(resp.body);

      if (resp.statusCode == 200) {
        return Success(MovimientoResponse.fromJson(data));
      }

      return ErrorData(data['message'] ?? 'Error al actualizar el movimiento.');
    } catch (e) {
      debugPrint('ERROR UPDATE MOVIMIENTO: $e');
      return ErrorData('No fue posible conectarse con el servidor.');
    }
  }

  // *********************************************************
  // 5.- Eliminar Movimiento
  // *********************************************************
  Future<Resource<MovimientoResponse>> deleteMovimiento({
    required String token,
    required int idMovimiento,
  }) async {
    try {
      final url = Uri.parse('$API_DELETE_MOVIMIENTO$idMovimiento');

      final resp = await http.delete(url, headers: _headers(token));
      final Map<String, dynamic> data = jsonDecode(resp.body);

      if (resp.statusCode == 200) {
        return Success(MovimientoResponse.fromJson(data));
      }

      return ErrorData(data['message'] ?? 'Error al eliminar el movimiento.');
    } catch (e) {
      debugPrint('ERROR DELETE MOVIMIENTO: $e');
      return ErrorData('No fue posible conectarse con el servidor.');
    }
  }
}
