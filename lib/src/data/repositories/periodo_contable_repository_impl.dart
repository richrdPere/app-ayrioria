// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_data.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_paginated.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_query_params.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_request.dart';

// Services
import 'package:app_aryoria/src/data/datasources/remote/services/periodo_contable_service.dart';

// Repositories
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class PeriodoContableRepositoryImpl implements PeriodoContableRepository {
  final PeriodoContableService periodoService;
  final AuthRepository authRepository;

  PeriodoContableRepositoryImpl({
    required this.periodoService,
    required this.authRepository,
  });

  // *********************************************************
  // 1.- Crear Periodo Contable
  // *********************************************************
  @override
  Future<Resource<ApiResponse<PeriodoContableData>>> createPeriodoContable(
    PeriodoContableRequest request,
  ) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return await periodoService.createPeriodoContable(
      token: token,
      request: request,
    );
  }

  // *********************************************************
  // 2.- OBTENER PERÍODOS CONTABLES PAGINADOS
  // *********************************************************
  @override
  Future<Resource<ApiResponse<PeriodoContablePaginated>>> getPeriodosContables({
    required int idEmpresa,
    required PeriodosContablesParams queryParams,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return await periodoService.getPeriodosContables(
      token: token,
      idEmpresa: idEmpresa,
      queryParams: queryParams,
    );
  }

  // *********************************************************
  // 3.- Obtener Periodo Contable por Id
  // *********************************************************
  @override
  Future<Resource<ApiResponse<PeriodoContableData>>> getPeriodoContableById({
    required int idPeriodo,
    required int idEmpresa,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return await periodoService.getPeriodoContableById(
      token: token,
      idPeriodo: idPeriodo,
      idEmpresa: idEmpresa,
    );
  }

  // *********************************************************
  // 4.- Actualizar Periodo Contable
  // *********************************************************
  @override
  Future<Resource<ApiResponse<PeriodoContableData>>> updatePeriodoContable({
    required int idPeriodo,
    required int idEmpresa,
    required PeriodoContableRequest request,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return await periodoService.updatePeriodoContable(
      token: token,
      idPeriodo: idPeriodo,
      idEmpresa: idEmpresa,
      request: request,
    );
  }

  // *********************************************************
  // 5.- Eliminar Periodo Contable
  // *********************************************************
  @override
  Future<Resource<ApiResponse<void>>> deletePeriodoContable({
    required int idPeriodo,
    required int idEmpresa,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return await periodoService.deletePeriodoContable(
      token: token,
      idPeriodo: idPeriodo,
      idEmpresa: idEmpresa,
    );
  }

  // *********************************************************
  // 6.- Cambiar Estado de Periodo Contable
  // *********************************************************
  @override
  Future<Resource<ApiResponse<PeriodoContableData>>>
  changeEstadoPeriodoContable({
    required int idPeriodo,
    required int idEmpresa,
    required String estado,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    final normalizedEstado = estado.trim().toUpperCase();

    if (!_isValidEstado(normalizedEstado)) {
      return ErrorData<ApiResponse<PeriodoContableData>>(
        'El estado del período contable no es válido.',
      );
    }

    return await periodoService.changeEstadoPeriodoContable(
      token: token,
      idPeriodo: idPeriodo,
      idEmpresa: idEmpresa,
      estado: normalizedEstado,
    );
  }

  bool _isValidEstado(String estado) {
    return const {'ABIERTO', 'CERRADO', 'BLOQUEADO'}.contains(estado);
  }
}
