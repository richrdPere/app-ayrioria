import 'package:app_aryoria/src/data/models/categoria/categoria_paginated.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_request.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_response.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

abstract class CategoriaRepository {
  /// Crear categoria
  Future<Resource<CategoriaResponse>> createCategoria(CategoriaRequest request);

  /// Listar categorias del usuario autenticado
  Future<Resource<CategoriaPaginatedResponse>> getCategorias({
    int page = 1,
    int limit = 10,
    required int idCategoria,
    String search = '',
  });

  /// Obtener categoria por Id
  Future<Resource<CategoriaResponse>> getCategoriaById(int idCategoria);

  /// Obtener categoria por Tipo
  Future<Resource<CategoriaPaginatedResponse>> getCategoriasByTipo({
    required String tipo,
    int page = 1,
    int limit = 10,
    String search = '',
  });

  /// Actualizar categoria
  Future<Resource<CategoriaResponse>> updateCategoria({
    required int idCategoria,
    required CategoriaRequest request,
  });

  /// Eliminar categoria
  Future<Resource<CategoriaResponse>> deleteCategoria(int idCategoria);
}
