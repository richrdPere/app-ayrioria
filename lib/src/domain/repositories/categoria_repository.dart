import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_request.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_query_params.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_paginated.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

abstract class CategoriaRepository {
  /// 1.- Crear categoria
  Future<Resource<ApiResponse<CategoriaData>>> createCategoria(
    CategoriaRequest request,
  );

  /// 2.- Listar categorias del usuario autenticado
  Future<Resource<ApiResponse<CategoriaPaginated>>> getCategorias({
    required int idEmpresa,
    required CategoriasParams queryParams,
  });

  /// 3.- Obtener categoria por Id
  Future<Resource<ApiResponse<CategoriaData>>> getCategoriaById({
    required int idCategoria,
    required int idEmpresa,
  });

  /// 4.- Obtener categoria por Tipo
  Future<Resource<ApiResponse<List<CategoriaData>>>> getCategoriasByTipo({
    required String tipo,
    required int idEmpresa,
  });

  /// 5.- Actualizar categoria
  Future<Resource<ApiResponse<CategoriaData>>> updateCategoria({
    required int idCategoria,
    required int idEmpresa,
    required CategoriaRequest request,
  });

  /// 6.- Eliminar categoria
  Future<Resource<ApiResponse<void>>> deleteCategoria({
    required int idCategoria,
    required int idEmpresa,
  });
}
