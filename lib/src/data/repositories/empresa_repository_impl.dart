// Service
import 'package:app_aryoria/src/data/datasources/remote/services/empresa_service.dart';

// Repo
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';

// Models
import 'package:app_aryoria/src/data/models/empresa/empresa_request.dart';
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_data.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_paginated.dart';
import 'package:app_aryoria/src/data/models/login/auth_response.dart';
import 'package:app_aryoria/src/data/models/login/login_data_model.dart';

class EmpresaRepositoryImpl implements EmpresaRepository {
  final EmpresaService empresaService;
  final AuthRepository authRepository;

  EmpresaRepositoryImpl({
    required this.empresaService,
    required this.authRepository,
  });

  // *********************************************************
  // 1.- Crear Empresa
  // *********************************************************
  @override
  Future<Resource<ApiResponse<EmpresaData>>> createEmpresa(
    EmpresaRequest request,
  ) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return empresaService.createEmpresa(token: token, request: request);
  }

  // *********************************************************
  // 2.- Obtener Empresa + Paginado
  // *********************************************************
  @override
  Future<Resource<ApiResponse<EmpresaPaginated>>> getEmpresas({
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

  // *********************************************************
  // 3.- Obtener Empresa por Id
  // *********************************************************
  @override
  Future<Resource<ApiResponse<EmpresaData>>> getEmpresaById(
    int idEmpresa,
  ) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return empresaService.getEmpresaById(token: token, idEmpresa: idEmpresa);
  }

  // *********************************************************
  // 4.- Actualizar Empresa
  // *********************************************************
  @override
  Future<Resource<ApiResponse<EmpresaData>>> updateEmpresa({
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

  // *********************************************************
  // 5.- Eliminar Empresa
  // *********************************************************
  @override
  Future<Resource<ApiResponse<void>>> deleteEmpresa(int idEmpresa) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return empresaService.deleteEmpresa(token: token, idEmpresa: idEmpresa);
  }

  // *********************************************************
  // 6.- Seleccionar Empresa
  // *********************************************************
  @override
  Future<Resource<ApiResponse<LoginDataModel>>> selectEmpresa(
    int idEmpresa,
  ) async {
    // 1. OBTENER TOKEN
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe sesión.");
    }

    // 2. SELECCIONAR EMPRESA
    final response = await empresaService.selectEmpresa(
      token: token,
      idEmpresa: idEmpresa,
    );

    // 3. GUARDAR NUEVA SESIÓN
    if (response is Success<ApiResponse<LoginDataModel>>) {
      final apiResponse = response.data;
      final loginData = apiResponse.data;

      if (loginData == null) {
        return ErrorData<ApiResponse<LoginDataModel>>(
          "El servidor no devolvió los datos de sesión.",
        );
      }

      try {
        final authResponse = AuthResponse(
          success: apiResponse.success,
          message: apiResponse.message,
          data: loginData,
        );

        await authRepository.saveUserSession(authResponse);
      } catch (e) {
        return ErrorData<ApiResponse<LoginDataModel>>(
          "No fue posible guardar la sesión.",
          error: e.toString(),
        );
      }
    }

    return response;
  }
}
