import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_paginated.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_query_params.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Models
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_create_req.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_data.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_update_req.dart';

abstract class SubcategoriaRepository {
  /// 1.- Obtener subcategorias paginadas
  Future<Resource<ApiResponse<SubcategoriaPaginated>>>
  getSubcategoriasPaginated({
    required int idEmpresa,
    required SubcategoriasParams queryParams,
  });

  /// 2.- Obtener subcategorias por categoria
  Future<Resource<ApiResponse<List<SubcategoriaData>>>>
  getSubcategoriasByCategoria({
    required int idEmpresa,
    required int idCategoria,
  });

  /// 3.- Obtener subcategorias por tipo
  Future<Resource<ApiResponse<List<SubcategoriaData>>>> getSubcategoriasByTipo({
    required int idEmpresa,
    required String tipo,
  });

  // 4.- Obtener subcategoria por ID
  Future<Resource<ApiResponse<SubcategoriaData>>> getSubcategoriaById({
    required int idEmpresa,
    required int idSubcategoria,
  });

  /// 5.- Crear subcategoria
  Future<Resource<ApiResponse<SubcategoriaData>>> createSubcategoria({
    required int idEmpresa,
    required SubcategoriaCreateRequest request,
  });

  /// 6.- Actualizar subcategoria
  Future<Resource<ApiResponse<SubcategoriaData>>> updateSubcategoria({
    required int idEmpresa,
    required int idSubcategoria,
    required SubcategoriaUpdateRequest request,
  });

  /// 7.- Cambiar estado
  Future<Resource<ApiResponse<SubcategoriaData>>> changeSubcategoriaEstado({
    required int idEmpresa,
    required int idSubcategoria,
    required bool estado,
  });

  /// 8.- Eliminar subcategoria
  Future<Resource<ApiResponse<void>>> deleteSubcategoria({
    required int idEmpresa,
    required int idSubcategoria,
  });
}
