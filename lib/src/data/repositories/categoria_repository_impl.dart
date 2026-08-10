import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Services
import 'package:app_aryoria/src/data/datasources/remote/services/categoria_service.dart';

// Repo
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_request.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_query_params.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_paginated.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';

class CategoriaRepositoryImpl implements CategoriaRepository {
  final CategoriaService categoriaService;
  final AuthRepository authRepository;

  CategoriaRepositoryImpl({
    required this.categoriaService,
    required this.authRepository,
  });

  // *********************************************************
  // 1.- Crear Categoría
  // *********************************************************
  @override
  Future<Resource<ApiResponse<CategoriaData>>> createCategoria(
    CategoriaRequest request,
  ) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return categoriaService.createCategoria(token: token, request: request);
  }

  // *********************************************************
  // 2.- Obtener Categorías Paginadas
  // *********************************************************
  @override
  Future<Resource<ApiResponse<CategoriaPaginated>>> getCategorias({
    required int idEmpresa,
    required CategoriasParams queryParams,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return categoriaService.getCategorias(
      token: token,
      idEmpresa: idEmpresa,
      queryParams: queryParams,
    );
  }

  // *********************************************************
  // 3.- Obtener Categoría por Id
  // *********************************************************
  @override
  Future<Resource<ApiResponse<CategoriaData>>> getCategoriaById({
    required int idCategoria,
    required int idEmpresa,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return categoriaService.getCategoriaById(
      token: token,
      idCategoria: idCategoria,
      idEmpresa: idEmpresa,
    );
  }

  // *********************************************************
  // 4.- Obtener Categorías por Tipo
  // *********************************************************
  @override
  Future<Resource<ApiResponse<List<CategoriaData>>>> getCategoriasByTipo({
    required String tipo,
    required int idEmpresa,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return categoriaService.getCategoriasByTipo(
      token: token,
      tipo: tipo,
      idEmpresa: idEmpresa,
    );
  }

  // *********************************************************
  // 5.- Actualizar Categoría
  // *********************************************************
  @override
  Future<Resource<ApiResponse<CategoriaData>>> updateCategoria({
    required int idCategoria,
    required int idEmpresa,
    required CategoriaRequest request,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return categoriaService.updateCategoria(
      token: token,
      idCategoria: idCategoria,
      idEmpresa: idEmpresa,
      request: request,
    );
  }

  // *********************************************************
  // 6.- Eliminar Categoría
  // *********************************************************
  @override
  Future<Resource<ApiResponse<void>>> deleteCategoria({
    required int idCategoria,
    required int idEmpresa,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return categoriaService.deleteCategoria(
      token: token,
      idCategoria: idCategoria,
      idEmpresa: idEmpresa,
    );
  }
}
