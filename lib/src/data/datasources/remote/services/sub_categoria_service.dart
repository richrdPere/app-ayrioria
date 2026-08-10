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
import 'package:app_aryoria/src/data/models/sub_categoria/create_sub_categoria_req.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_paginado.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/update_sub_categoria_req.dart';

class SubcategoriaService {
  String get API_BASE => '${url_backend.Environment.mainUrl}/subcategorias';

  String get API_GET_SUBCATEGORIAS_PAGINADO => '$API_BASE/paginado';
  String get API_GET_SUBATEGORIA_BY_CATEGORIA => '$API_BASE/categoria';
  String get API_GET_SUBCATEGORIA_BY_ID => '$API_BASE/view';
  String get API_GET_SUBCATEGORIA_BY_TIPO => '$API_BASE/tipo';
  String get API_CRETATE_SUBCATEGORIA => '$API_BASE/create';
  String get API_UPDATE_SUBCATEGORIA => '$API_BASE/update';
  String get API_UPDATE_ESTADO_SUBCATEGORIA => '$API_BASE/estado';
  String get API_DELETE_SUBCATEGORIA => '$API_BASE/delete';

  // *********************************************************
  // 1.- Obtener subcategorias + Paginado
  // *********************************************************
  Future<Resource<ApiResponse<SubcategoriaPaginated>>>
  getSubcategoriasPaginated({
    required String token,
    required int idEmpresa,
    required Map<String, dynamic> queryParams,
  }) async {
    try {
      // 1.- URL Base
      final Map<String, dynamic> params = {
        ...queryParams,
        'id_empresa': idEmpresa,
      };

      params.removeWhere(
        (key, value) =>
            value == null || (value is String && value.trim().isEmpty),
      );

      final uri = Uri.parse(API_GET_SUBCATEGORIAS_PAGINADO).replace(
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
        final apiResponse = ApiResponse<SubcategoriaPaginated>.fromJson(body, (
          rawData,
        ) {
          return SubcategoriaPaginated.fromJson(
            Map<String, dynamic>.from(rawData),
          );
        });

        return Success<ApiResponse<SubcategoriaPaginated>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<SubcategoriaPaginated>>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<ApiResponse<SubcategoriaPaginated>>(
        'No se pudieron obtener las subcategorías: $error',
      );
    }
  }

  // *****************************************************************************
  // 2.- Obtener subcategorias por categoria
  // *****************************************************************************
  Future<Resource<ApiResponse<List<SubcategoriaData>>>>
  getSubcategoriasByCategoria({
    required String token,
    required int idEmpresa,
    required int idCategoria,
  }) async {
    try {
      // 1.- URL Base
      final uri = Uri.parse(
        '$API_GET_SUBATEGORIA_BY_CATEGORIA/$idCategoria',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      // 2.- Response
      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<List<SubcategoriaData>>.fromJson(body, (
          rawData,
        ) {
          if (rawData is! List) {
            return <SubcategoriaData>[];
          }

          return rawData
              .map(
                (item) =>
                    SubcategoriaData.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();
        });

        return Success<ApiResponse<List<SubcategoriaData>>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<List<SubcategoriaData>>>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<ApiResponse<List<SubcategoriaData>>>(
        'No se pudieron obtener las subcategorías: $error',
      );
    }
  }

  // *****************************************************************************
  // 3.- Obtener subcategorias por tipo
  // *****************************************************************************
  Future<Resource<ApiResponse<List<SubcategoriaData>>>> getSubcategoriasByTipo({
    required String token,
    required int idEmpresa,
    required String tipo,
  }) async {
    try {
      // 1.- Normalizar tipo
      final tipoNormalizado = tipo.trim().toUpperCase();

      if (tipoNormalizado != 'INGRESO' && tipoNormalizado != 'EGRESO') {
        return ErrorData<ApiResponse<List<SubcategoriaData>>>(
          'El tipo debe ser INGRESO o EGRESO.',
        );
      }

      // 2.- URL Base
      final uri = Uri.parse(
        '$API_GET_SUBCATEGORIA_BY_TIPO/$tipoNormalizado',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      // 3.- Response
      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 4.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<List<SubcategoriaData>>.fromJson(body, (
          rawData,
        ) {
          if (rawData is! List) {
            return <SubcategoriaData>[];
          }

          return rawData
              .map(
                (item) =>
                    SubcategoriaData.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();
        });

        return Success<ApiResponse<List<SubcategoriaData>>>(apiResponse);
      }

      // 5.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<List<SubcategoriaData>>>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<ApiResponse<List<SubcategoriaData>>>(
        'No se pudieron obtener las subcategorías por tipo: $error',
      );
    }
  }

  // *****************************************************************************
  // 4.- Obtener subcategoria por ID
  // *****************************************************************************
  Future<Resource<ApiResponse<SubcategoriaData>>> getSubcategoriaById({
    required String token,
    required int idEmpresa,
    required int idSubcategoria,
  }) async {
    try {
      // 1.- URL
      final uri = Uri.parse(
        '$API_GET_SUBCATEGORIA_BY_ID/$idSubcategoria',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      // 2.- Response
      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<SubcategoriaData>.fromJson(body, (
          rawData,
        ) {
          return SubcategoriaData.fromJson(Map<String, dynamic>.from(rawData));
        });

        return Success<ApiResponse<SubcategoriaData>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<SubcategoriaData>>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<ApiResponse<SubcategoriaData>>(
        'No se pudo obtener la subcategoría: $error',
      );
    }
  }

  // *****************************************************************************
  // 5.- Crear subcategoria
  // *****************************************************************************
  Future<Resource<ApiResponse<SubcategoriaData>>> createSubcategoria({
    required String token,
    required int idEmpresa,
    required CreateSubcategoriaRequest request,
  }) async {
    try {
      final uri = Uri.parse(API_CRETATE_SUBCATEGORIA);

      final payload = {...request.toJson(), 'id_empresa': idEmpresa};

      final response = await http.post(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode(payload),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<SubcategoriaData>.fromJson(
          body,
          (rawData) =>
              SubcategoriaData.fromJson(Map<String, dynamic>.from(rawData)),
        );

        return Success<ApiResponse<SubcategoriaData>>(apiResponse);
      }

      return HttpServiceHelper.buildError<ApiResponse<SubcategoriaData>>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<ApiResponse<SubcategoriaData>>(
        'No se pudo crear la subcategoría: $error',
      );
    }
  }

  // *****************************************************************************
  // 6.- Actualizar subcategoria
  // *****************************************************************************
  Future<Resource<ApiResponse<SubcategoriaData>>> updateSubcategoria({
    required String token,
    required int idEmpresa,
    required int idSubcategoria,
    required UpdateSubcategoriaRequest request,
  }) async {
    try {
      // 1.- URL
      final uri = Uri.parse('$API_UPDATE_SUBCATEGORIA/$idSubcategoria');

      final payload = {...request.toJson(), 'id_empresa': idEmpresa};

      // 2.- Response
      final response = await http.put(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode(payload),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<SubcategoriaData>.fromJson(
          body,
          (rawData) =>
              SubcategoriaData.fromJson(Map<String, dynamic>.from(rawData)),
        );

        return Success<ApiResponse<SubcategoriaData>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<SubcategoriaData>>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<ApiResponse<SubcategoriaData>>(
        'No se pudo actualizar la subcategoría: $error',
      );
    }
  }

  // *****************************************************************************
  // 7.- Cambiar estado de la subcategoria
  // *****************************************************************************
  Future<Resource<ApiResponse<SubcategoriaData>>> changeSubcategoriaEstado({
    required String token,
    required int idEmpresa,
    required int idSubcategoria,
    required bool estado,
  }) async {
    try {
      // 1.- URL
      final uri = Uri.parse('$API_UPDATE_ESTADO_SUBCATEGORIA/$idSubcategoria');

      final payload = {'id_empresa': idEmpresa, 'estado': estado};

      // 2.- Response
      final response = await http.patch(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode(payload),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<SubcategoriaData>.fromJson(
          body,
          (rawData) =>
              SubcategoriaData.fromJson(Map<String, dynamic>.from(rawData)),
        );

        return Success<ApiResponse<SubcategoriaData>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<SubcategoriaData>>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<ApiResponse<SubcategoriaData>>(
        'No se pudo cambiar el estado de la subcategoría: $error',
      );
    }
  }

  // *****************************************************************************
  // 8.- Eliminar subcategoria por ID
  // *****************************************************************************
  Future<Resource<ApiResponse<void>>> deleteSubcategoria({
    required String token,
    required int idEmpresa,
    required int idSubcategoria,
  }) async {
    try {
      // 1.- URL
      final uri = Uri.parse('$API_DELETE_SUBCATEGORIA/$idSubcategoria');

      // 2.- Response
      final response = await http.delete(
        uri,
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
    } catch (error) {
      return ErrorData<ApiResponse<void>>(
        'No se pudo eliminar la subcategoría: $error',
      );
    }
  }
}
