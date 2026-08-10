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
import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_paginated.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_query_params.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_request.dart';

class CategoriaService {
  // APIS
  String get API_BASE => '${url_backend.Environment.mainUrl}/categorias';

  String get API_CREATE_CATEGORIA => '$API_BASE/crear';
  String get API_GET_CATEGORIAS_PAGINATED => '$API_BASE/paginated';
  String get API_GET_CATEGORIA_BY_ID => '$API_BASE/detalle/';
  String get API_GET_CATEGORIA_BY_TIPO => '$API_BASE/tipo/';
  String get API_UPDATE_CATEGORIA => '$API_BASE/editar/';
  String get API_DELETE_CATEGORIA => '$API_BASE/eliminar/';

  // *********************************************************
  // 1.- Crear Categoría
  // *********************************************************
  Future<Resource<ApiResponse<CategoriaData>>> createCategoria({
    required String token,
    required CategoriaRequest request,
  }) async {
    try {
      // 1.- URL Base
      final url = Uri.parse(API_CREATE_CATEGORIA);

      // 2.- Response
      final response = await http.post(
        url,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode(request.toJson()),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<CategoriaData>.fromJson(
          body,
          (rawData) =>
              CategoriaData.fromJson(Map<String, dynamic>.from(rawData)),
        );

        return Success<ApiResponse<CategoriaData>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<CategoriaData>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      debugPrint("ERROR CREAR CATEGORIA: $e");
      return ErrorData<ApiResponse<CategoriaData>>(
        'No se pudo crear la categoria: $e',
      );
    }
  }

  // *********************************************************
  // 2.- Obtener Categorías Paginadas
  // *********************************************************
  Future<Resource<ApiResponse<CategoriaPaginated>>> getCategorias({
    required String token,
    required int idEmpresa,
    required CategoriasParams queryParams,
  }) async {
    try {
      // 1.- URL Base
      final Map<String, dynamic> params = {
        ...queryParams.toQueryParams(),
        'id_empresa': idEmpresa,
      };

      final url = Uri.parse(API_GET_CATEGORIAS_PAGINATED).replace(
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
        final apiResponse = ApiResponse<CategoriaPaginated>.fromJson(body, (
          rawData,
        ) {
          return CategoriaPaginated.fromJson(
            Map<String, dynamic>.from(rawData),
          );
        });

        return Success<ApiResponse<CategoriaPaginated>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<CategoriaPaginated>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      debugPrint('ERROR GET CATEGORIAS: $e');
      return ErrorData<ApiResponse<CategoriaPaginated>>(
        'No se pudieron obtener las categorias: $e',
      );
    }
  }

  // *********************************************************
  // 3.- Obtener Categoría por Id
  // *********************************************************
  Future<Resource<ApiResponse<CategoriaData>>> getCategoriaById({
    required int idCategoria,
    required int idEmpresa,
    required String token,
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse(
        '$API_GET_CATEGORIA_BY_ID$idCategoria',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      // 2.- Response
      final response = await http.get(
        url,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<CategoriaData>.fromJson(body, (
          rawData,
        ) {
          return CategoriaData.fromJson(Map<String, dynamic>.from(rawData));
        });

        return Success<ApiResponse<CategoriaData>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<CategoriaData>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      debugPrint("ERROR OBTENER CATEGORIA: $e");
      return ErrorData<ApiResponse<CategoriaData>>(
        'No se pudo obtener la categoria: $e',
      );
    }
  }

  // *********************************************************
  // 4.- Obtener Categorías por Tipo
  // *********************************************************
  Future<Resource<ApiResponse<List<CategoriaData>>>> getCategoriasByTipo({
    required String token,
    required String tipo,
    required int idEmpresa,
  }) async {
    try {
      // 1.- Normalizar tipo
      final tipoNormalizado = tipo.trim().toUpperCase();

      if (tipoNormalizado != 'INGRESO' && tipoNormalizado != 'EGRESO') {
        return ErrorData<ApiResponse<List<CategoriaData>>>(
          'El tipo debe ser INGRESO o EGRESO.',
        );
      }

      // 2.- URL Base
      final uri = Uri.parse(
        '$API_GET_CATEGORIA_BY_TIPO$tipoNormalizado',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      // 3.- Response
      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 4.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<List<CategoriaData>>.fromJson(body, (
          rawData,
        ) {
          if (rawData is! List) {
            return <CategoriaData>[];
          }

          return rawData
              .map(
                (item) =>
                    CategoriaData.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();
        });

        return Success<ApiResponse<List<CategoriaData>>>(apiResponse);
      }

      // 5.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<List<CategoriaData>>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      debugPrint("ERROR GET CATEGORIAS POR TIPO: $e");
      return ErrorData<ApiResponse<List<CategoriaData>>>(
        'No se pudieron obtener las categorias por tipo: $e',
      );
    }
  }

  // *********************************************************
  // 5.- Actualizar Categoría
  // *********************************************************
  Future<Resource<ApiResponse<CategoriaData>>> updateCategoria({
    required int idCategoria,
    required int idEmpresa,
    required CategoriaRequest request,
    required String token,
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse(
        '$API_UPDATE_CATEGORIA$idCategoria',
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
        final apiResponse = ApiResponse<CategoriaData>.fromJson(
          body,
          (rawData) =>
              CategoriaData.fromJson(Map<String, dynamic>.from(rawData)),
        );

        return Success<ApiResponse<CategoriaData>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<CategoriaData>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      debugPrint("ERROR ACTUALIZAR CATEGORIA: $e");
      return ErrorData<ApiResponse<CategoriaData>>(
        'No se pudo actualizar la categoria: $e',
      );
    }
  }

  // *********************************************************
  // 6.- Eliminar Categoría
  // *********************************************************
  Future<Resource<ApiResponse<void>>> deleteCategoria({
    required int idCategoria,
    required int idEmpresa,
    required String token,
  }) async {
    try {
      // 1.- URL
      final url = Uri.parse(
        '$API_DELETE_CATEGORIA$idCategoria',
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
      debugPrint("ERROR ELIMINAR CATEGORIA: $e");
      return ErrorData<ApiResponse<void>>(
        'No se pudo eliminar la categoria: $e',
      );
    }
  }
}
