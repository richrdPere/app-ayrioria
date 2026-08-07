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
  Future<Resource<SubcategoriaPaginated>> getSubcategoriasPaginated({
    required String token,
    required int idEmpresa,
    required Map<String, dynamic> queryParams,
  }) async {
    try {
      final Map<String, dynamic> params = {
        ...queryParams,
        'id_empresa': idEmpresa,
      };

      // Eliminamos parámetros null o vacíos.
      params.removeWhere(
        (key, value) =>
            value == null || (value is String && value.trim().isEmpty),
      );

      final uri = Uri.parse(API_GET_SUBCATEGORIAS_PAGINADO).replace(
        queryParameters: params.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );

      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final data = body['data'];

        if (data is! Map) {
          return ErrorData<SubcategoriaPaginated>(
            'La respuesta del servidor no contiene datos válidos.',
          );
        }

        final paginated = SubcategoriaPaginated.fromJson(
          Map<String, dynamic>.from(data),
        );

        return Success<SubcategoriaPaginated>(paginated);
      }

      return HttpServiceHelper.buildError<SubcategoriaPaginated>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<SubcategoriaPaginated>(
        'No se pudo obtener las subcategorías: $error',
      );
    }
  }

  // *****************************************************************************
  // 2.- Obtener subcategorias por categoria
  // *****************************************************************************
  Future<Resource<List<SubcategoriaData>>> getSubcategoriasByCategoria({
    required String token,
    required int idEmpresa,
    required int idCategoria,
  }) async {
    try {
      final uri = Uri.parse(
        '$API_GET_SUBATEGORIA_BY_CATEGORIA/$idCategoria',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final data = body['data'];

        if (data is! List) {
          return ErrorData<List<SubcategoriaData>>(
            'La respuesta del servidor no contiene una lista válida de subcategorías.',
          );
        }

        final subcategorias = data
            .map(
              (item) =>
                  SubcategoriaData.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();

        return Success<List<SubcategoriaData>>(subcategorias);
      }

      return HttpServiceHelper.buildError<List<SubcategoriaData>>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<List<SubcategoriaData>>(
        'No se pudieron obtener las subcategorías: $error',
      );
    }
  }

  // *****************************************************************************
  // 3.- Obtener subcategorias por tipo
  // *****************************************************************************
  Future<Resource<List<SubcategoriaData>>> getSubcategoriasByTipo({
    required String token,
    required int idEmpresa,
    required String tipo,
  }) async {
    try {
      final tipoNormalizado = tipo.trim().toUpperCase();

      if (tipoNormalizado != 'INGRESO' && tipoNormalizado != 'EGRESO') {
        return ErrorData<List<SubcategoriaData>>(
          'El tipo debe ser INGRESO o EGRESO.',
        );
      }

      final uri = Uri.parse(
        '$API_GET_SUBCATEGORIA_BY_TIPO/$tipoNormalizado',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final data = body['data'];

        if (data is! List) {
          return ErrorData<List<SubcategoriaData>>(
            'La respuesta del servidor no contiene una lista válida de subcategorías.',
          );
        }

        final subcategorias = data
            .map(
              (item) =>
                  SubcategoriaData.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();

        return Success<List<SubcategoriaData>>(subcategorias);
      }

      return HttpServiceHelper.buildError<List<SubcategoriaData>>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<List<SubcategoriaData>>(
        'No se pudieron obtener las subcategorías por tipo: $error',
      );
    }
  }

  // *****************************************************************************
  // 4.- Obtener subcategoria por ID
  // *****************************************************************************
  Future<Resource<SubcategoriaData>> getSubcategoriaById({
    required String token,
    required int idEmpresa,
    required int idSubcategoria,
  }) async {
    try {
      final uri = Uri.parse(
        '$API_GET_SUBCATEGORIA_BY_ID/$idSubcategoria',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final data = body['data'];

        if (data is! Map) {
          return ErrorData<SubcategoriaData>(
            'La subcategoría obtenida no es válida.',
          );
        }

        final subcategoria = SubcategoriaData.fromJson(
          Map<String, dynamic>.from(data),
        );

        return Success<SubcategoriaData>(subcategoria);
      }

      return HttpServiceHelper.buildError<SubcategoriaData>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<SubcategoriaData>(
        'No se pudo obtener la subcategoría: $error',
      );
    }
  }

  // *****************************************************************************
  // 5.- Crear subcategoria
  // *****************************************************************************
  Future<Resource<SubcategoriaData>> createSubcategoria({
    required String token,
    required int idEmpresa,
    required CreateSubcategoriaRequest request,
  }) async {
    try {
      final uri = Uri.parse(API_CRETATE_SUBCATEGORIA);

      final Map<String, dynamic> payload = {
        ...request.toJson(),
        'id_empresa': idEmpresa,
      };

      final response = await http.post(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode(payload),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final data = body['data'];

        if (data is! Map) {
          return ErrorData<SubcategoriaData>(
            'La subcategoría creada no es válida.',
          );
        }

        final subcategoria = SubcategoriaData.fromJson(
          Map<String, dynamic>.from(data),
        );

        return Success<SubcategoriaData>(subcategoria);
      }

      return HttpServiceHelper.buildError<SubcategoriaData>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<SubcategoriaData>(
        'No se pudo crear la subcategoría: $error',
      );
    }
  }

  // *****************************************************************************
  // 6.- Actualizar subcategoria
  // *****************************************************************************
  Future<Resource<SubcategoriaData>> updateSubcategoria({
    required String token,
    required int idEmpresa,
    required int idSubcategoria,
    required UpdateSubcategoriaRequest request,
  }) async {
    try {
      final uri = Uri.parse('$API_UPDATE_SUBCATEGORIA/$idSubcategoria');

      final Map<String, dynamic> payload = {
        ...request.toJson(),
        'id_empresa': idEmpresa,
      };

      final response = await http.put(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode(payload),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final data = body['data'];

        if (data is! Map) {
          return ErrorData<SubcategoriaData>(
            'La subcategoría actualizada no es válida.',
          );
        }

        final subcategoria = SubcategoriaData.fromJson(
          Map<String, dynamic>.from(data),
        );

        return Success<SubcategoriaData>(subcategoria);
      }

      return HttpServiceHelper.buildError<SubcategoriaData>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<SubcategoriaData>(
        'No se pudo actualizar la subcategoría: $error',
      );
    }
  }

  // *****************************************************************************
  // 7.- Cambiar estado de la subcategoria
  // *****************************************************************************
  Future<Resource<SubcategoriaData>> changeSubcategoriaEstado({
    required String token,
    required int idEmpresa,
    required int idSubcategoria,
    required bool estado,
  }) async {
    try {
      final uri = Uri.parse('$API_UPDATE_ESTADO_SUBCATEGORIA/$idSubcategoria');

      final Map<String, dynamic> payload = {
        'id_empresa': idEmpresa,
        'estado': estado,
      };

      final response = await http.patch(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode(payload),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final data = body['data'];

        if (data is! Map) {
          return ErrorData<SubcategoriaData>(
            'La respuesta del cambio de estado no es válida.',
          );
        }

        final subcategoria = SubcategoriaData.fromJson(
          Map<String, dynamic>.from(data),
        );

        return Success<SubcategoriaData>(subcategoria);
      }

      return HttpServiceHelper.buildError<SubcategoriaData>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<SubcategoriaData>(
        'No se pudo cambiar el estado de la subcategoría: $error',
      );
    }
  }

  // *****************************************************************************
  // 8.- Eliminar subcategoria por ID
  // *****************************************************************************
  Future<Resource<String>> deleteSubcategoria({
    required String token,
    required int idEmpresa,
    required int idSubcategoria,
  }) async {
    try {
      final uri = Uri.parse('$API_DELETE_SUBCATEGORIA/$idSubcategoria');

      final response = await http.delete(
        uri,
        headers: HttpServiceHelper.getHeaders(
          token,
          extraHeaders: {'id_empresa': idEmpresa.toString()},
        ),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final message = body['message']?.toString().trim();

        return Success<String>(
          message != null && message.isNotEmpty
              ? message
              : 'Subcategoría eliminada correctamente.',
        );
      }

      return HttpServiceHelper.buildError<String>(body, response.statusCode);
    } catch (error) {
      return ErrorData<String>('No se pudo eliminar la subcategoría: $error');
    }
  }
}
