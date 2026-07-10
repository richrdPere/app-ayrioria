// ignore_for_file: non_constant_identifier_names, unnecessary_this

// Environment
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:app_aryoria/src/config/constants/environment.dart'
    as url_backend;

// Models
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_paginated.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_request.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_response.dart';

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
  Future<Resource<CategoriaResponse>> createCategoria({
    required String token,
    required CategoriaRequest request,
  }) async {
    try {
      final url = Uri.parse(API_CREATE_CATEGORIA);

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = jsonEncode(request.toJson());

      final resp = await http.post(url, headers: headers, body: body);
      final Map<String, dynamic> data = jsonDecode(resp.body);

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final response = CategoriaResponse.fromJson(data);
        return Success(response);
      } else {
        return ErrorData(data["message"] ?? "Error al crear la categoría.");
      }
    } catch (e) {
      debugPrint("ERROR CREAR CATEGORIA: $e");
      return ErrorData('No fue posible conectarse con el servidor.');
    }
  }

  // *********************************************************
  // 2.- Obtener Categorías Paginadas
  // *********************************************************
  Future<Resource<CategoriaPaginatedResponse>> getCategorias({
    required String token,
    required int idEmpresa,
    int page = 1,
    int limit = 10,
    String search = '',
    String? tipo,
    bool? estado,
  }) async {
    try {
      final queryParameters = <String, String>{
        'id_empresa': idEmpresa.toString(),
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search.trim().isNotEmpty) {
        queryParameters['search'] = search.trim();
      }

      if (tipo != null && tipo.trim().isNotEmpty) {
        queryParameters['tipo'] = tipo.trim().toUpperCase();
      }

      if (estado != null) {
        queryParameters['estado'] = estado.toString();
      }

      final baseUri = Uri.parse(API_GET_CATEGORIAS_PAGINATED);

      final url = baseUri.replace(queryParameters: queryParameters);

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final resp = await http.get(url, headers: headers);
      final Map<String, dynamic> data = jsonDecode(resp.body);

      debugPrint(resp.body);

      if (resp.statusCode == 200) {
        final response = CategoriaPaginatedResponse.fromJson(data);

        return Success(response);
      }

      return ErrorData(
        data['message'] ?? 'No fue posible obtener las categorías.',
      );
    } catch (e) {
      debugPrint('ERROR GET CATEGORIAS: $e');

      return ErrorData('No fue posible conectarse con el servidor.');
    }
  }

  // *********************************************************
  // 3.- Obtener Categoría por Id
  // *********************************************************
  Future<Resource<CategoriaResponse>> getCategoriaById({
    required int idCategoria,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$API_GET_CATEGORIA_BY_ID$idCategoria');

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final resp = await http.get(url, headers: headers);
      final Map<String, dynamic> data = jsonDecode(resp.body);

      if (resp.statusCode == 200) {
        final response = CategoriaResponse.fromJson(data);
        return Success(response);
      } else {
        return ErrorData(
          data["message"] ?? "No fue posible obtener la categoría.",
        );
      }
    } catch (e) {
      debugPrint("ERROR OBTENER CATEGORIA: $e");
      return ErrorData("No fue posible conectarse con el servidor.");
    }
  }

  // *********************************************************
  // 4.- Obtener Categorías por Tipo
  // *********************************************************
  Future<Resource<CategoriaPaginatedResponse>> getCategoriasByTipo({
    required String token,
    required String tipo,
    int page = 1,
    int limit = 10,
    String search = '',
  }) async {
    try {
      final url = Uri.parse(
        '$API_GET_CATEGORIA_BY_TIPO$tipo'
        '?page=$page&limit=$limit&search=${Uri.encodeQueryComponent(search)}',
      );

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final resp = await http.get(url, headers: headers);
      final Map<String, dynamic> data = jsonDecode(resp.body);

      if (resp.statusCode == 200) {
        final response = CategoriaPaginatedResponse.fromJson(data);
        return Success(response);
      } else {
        return ErrorData(
          data["message"] ?? "No fue posible obtener las categorías por tipo.",
        );
      }
    } catch (e) {
      debugPrint("ERROR GET CATEGORIAS POR TIPO: $e");
      return ErrorData("No fue posible conectarse con el servidor.");
    }
  }

  // *********************************************************
  // 5.- Actualizar Categoría
  // *********************************************************
  Future<Resource<CategoriaResponse>> updateCategoria({
    required int idCategoria,
    required String token,
    required CategoriaRequest request,
  }) async {
    try {
      final url = Uri.parse('$API_UPDATE_CATEGORIA$idCategoria');

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = jsonEncode(request.toJson());

      final resp = await http.put(url, headers: headers, body: body);
      final Map<String, dynamic> data = jsonDecode(resp.body);

      if (resp.statusCode == 200) {
        final response = CategoriaResponse.fromJson(data);
        return Success(response);
      } else {
        return ErrorData(
          data["message"] ?? "No fue posible actualizar la categoría.",
        );
      }
    } catch (e) {
      debugPrint("ERROR ACTUALIZAR CATEGORIA: $e");
      return ErrorData("No fue posible conectarse con el servidor.");
    }
  }

  // *********************************************************
  // 6.- Eliminar Categoría
  // *********************************************************
  Future<Resource<CategoriaResponse>> deleteCategoria({
    required int idCategoria,
    required String token,
  }) async {
    try {
      final url = Uri.parse('$API_DELETE_CATEGORIA$idCategoria');

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final resp = await http.delete(url, headers: headers);
      final Map<String, dynamic> data = jsonDecode(resp.body);

      if (resp.statusCode == 200) {
        final response = CategoriaResponse.fromJson(data);
        return Success<CategoriaResponse>(response);
      } else {
        return ErrorData(
          data["message"] ?? "No fue posible eliminar la categoría.",
        );
      }
    } catch (e) {
      debugPrint("ERROR ELIMINAR CATEGORIA: $e");
      return ErrorData("No fue posible conectarse con el servidor.");
    }
  }
}
