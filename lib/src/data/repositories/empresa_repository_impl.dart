import 'package:app_aryoria/src/data/datasources/remote/services/empresa_service.dart';
import 'package:app_aryoria/src/data/models/common/base_response.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_paginated.dart';
import 'package:app_aryoria/src/data/models/login/auth_response.dart';
import 'package:app_aryoria/src/domain/repositories/auth_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Repo
import 'package:app_aryoria/src/domain/repositories/empresa_repository.dart';

// Models
import 'package:app_aryoria/src/data/models/empresa/empresa_request.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_response.dart';

class EmpresaRepositoryImpl implements EmpresaRepository {
  final EmpresaService empresaService;
  final AuthRepository authRepository;

  EmpresaRepositoryImpl({
    required this.empresaService,
    required this.authRepository,
  });

  @override
  Future<Resource<EmpresaResponse>> createEmpresa(
    EmpresaRequest request,
  ) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return empresaService.createEmpresa(token: token, request: request);
  }

  @override
  Future<Resource<EmpresaPaginatedResponse>> getEmpresas({
    int page = 1,
    int limit = 10,
    String search = '',
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return empresaService.getEmpresas(
      token: token,
      page: page,
      limit: limit,
      search: search,
    );
  }

  @override
  Future<Resource<EmpresaResponse>> getEmpresaById(int idEmpresa) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return empresaService.getEmpresaById(token: token, idEmpresa: idEmpresa);
  }

  @override
  Future<Resource<EmpresaResponse>> updateEmpresa({
    required int idEmpresa,
    required EmpresaRequest request,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return empresaService.updateEmpresa(
      token: token,
      idEmpresa: idEmpresa,
      request: request,
    );
  }

  @override
  Future<Resource<BaseResponse>> deleteEmpresa(int idEmpresa) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return empresaService.deleteEmpresa(token: token, idEmpresa: idEmpresa);
  }

  @override
  Future<Resource<AuthResponse>> selectEmpresa(
    int idEmpresa,
  ) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe sesión.");
    }

    final response = await empresaService.selectEmpresa(
      token: token,
      idEmpresa: idEmpresa,
    );

    if (response is Success<AuthResponse>) {
      try {
        await authRepository.saveUserSession(response.data);
      } catch (_) {
        return ErrorData("No fue posible guardar la sesión.");
      }
    }

    return response;
  }
}
