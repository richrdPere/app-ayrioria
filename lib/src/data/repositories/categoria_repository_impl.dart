import 'package:app_aryoria/src/data/datasources/remote/services/categoria_service.dart';
import 'package:app_aryoria/src/domain/repositories/categoria_repostory.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Repo
import 'package:app_aryoria/src/domain/repositories/auth_repository.dart';

// Models
import 'package:app_aryoria/src/data/models/categoria/categoria_paginated.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_request.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_response.dart';

class CategoriaRepositoryImpl implements CategoriaRepository {
  final CategoriaService categoriaService;
  final AuthRepository authRepository;

  CategoriaRepositoryImpl({
    required this.categoriaService,
    required this.authRepository,
  });

  @override
  Future<Resource<CategoriaResponse>> createCategoria(
    CategoriaRequest request,
  ) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return categoriaService.createCategoria(token: token, request: request);
  }

  @override
  Future<Resource<CategoriaResponse>> deleteCategoria(int idCategoria) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return categoriaService.deleteCategoria(
      token: token,
      idCategoria: idCategoria,
    );
  }

  @override
  Future<Resource<CategoriaResponse>> getCategoriaById(int idCategoria) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return categoriaService.getCategoriaById(
      token: token,
      idCategoria: idCategoria,
    );
  }

  @override
  Future<Resource<CategoriaPaginatedResponse>> getCategorias({
    int page = 1,
    int limit = 10,
    required int idCategoria,
    String search = '',
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return categoriaService.getCategorias(
      token: token,
      idCategoria: idCategoria,
      page: page,
      limit: limit,
      search: search,
    );
  }

  @override
  Future<Resource<CategoriaPaginatedResponse>> getCategoriasByTipo({
    required String tipo,
    int page = 1,
    int limit = 10,
    String search = '',
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return categoriaService.getCategoriasByTipo(
      token: token,
      tipo: tipo,
      page: page,
      limit: limit,
      search: search,
    );
  }

  @override
  Future<Resource<CategoriaResponse>> updateCategoria({
    required int idCategoria,
    required CategoriaRequest request,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return categoriaService.updateCategoria(
      token: token,
      idCategoria: idCategoria,
      request: request,
    );
  }
}
