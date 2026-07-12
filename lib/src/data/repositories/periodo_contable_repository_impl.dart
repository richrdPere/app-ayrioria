import 'package:flutter/foundation.dart';

// Models
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_paginated.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_request.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_response.dart';

// Services
import 'package:app_aryoria/src/data/datasources/remote/services/periodo_contable_service.dart';

// Repositories
import 'package:app_aryoria/src/domain/repositories/auth_repository.dart';
import 'package:app_aryoria/src/domain/repositories/periodo_contable_repository.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class PeriodoContableRepositoryImpl implements PeriodoContableRepository {
  final PeriodoContableService periodoService;
  final AuthRepository authRepository;

  PeriodoContableRepositoryImpl({
    required this.periodoService,
    required this.authRepository,
  });

  // OBTENER TOKEN DE LA SESIÓN
  Future<String?> _getToken() async {
    try {
      final token = await authRepository.getToken();

      if (token == null || token.isEmpty) {
        return null;
      }

      return token;
    } catch (error) {
      debugPrint('ERROR OBTENIENDO TOKEN DE SESIÓN: $error');

      return null;
    }
  }

  ErrorData<T> _sessionError<T>() {
    return ErrorData<T>(
      'No existe una sesión válida. Inicie sesión nuevamente.',
    );
  }

  /// 1. CREAR PERÍODO CONTABLE
  @override
  Future<Resource<PeriodoContableResponse>> createPeriodoContable(
    PeriodoContableRequest request,
  ) async {
    try {
      final token = await _getToken();

      if (token == null) {
        return _sessionError<PeriodoContableResponse>();
      }

      return await periodoService.createPeriodoContable(
        token: token,
        request: request,
      );
    } catch (error) {
      debugPrint('ERROR REPOSITORY CREAR PERIODO: $error');

      return ErrorData<PeriodoContableResponse>(
        'No se pudo crear el período contable.',
      );
    }
  }

  /// 2. LISTAR PERÍODOS CONTABLES
  @override
  Future<Resource<PeriodoContablePaginatedResponse>> getPeriodosContables({
    required int idEmpresa,
    required Map<String, dynamic> queryParams,
  }) async {
    try {
      final token = await _getToken();

      if (token == null) {
        return _sessionError<PeriodoContablePaginatedResponse>();
      }

      return await periodoService.getPeriodosContables(
        token: token,
        idEmpresa: idEmpresa,
        queryParams: queryParams,
      );
    } catch (error) {
      debugPrint('ERROR REPOSITORY LISTAR PERIODOS: $error');

      return ErrorData<PeriodoContablePaginatedResponse>(
        'No se pudieron obtener los períodos contables.',
      );
    }
  }

  /// 3. OBTENER PERÍODO POR ID
  @override
  Future<Resource<PeriodoContableResponse>> getPeriodoContableById({
    required int idPeriodo,
    required int idEmpresa,
  }) async {
    try {
      final token = await _getToken();

      if (token == null) {
        return _sessionError<PeriodoContableResponse>();
      }

      return await periodoService.getPeriodoContableById(
        token: token,
        idPeriodo: idPeriodo,
        idEmpresa: idEmpresa,
      );
    } catch (error) {
      debugPrint('ERROR REPOSITORY DETALLE PERIODO: $error');

      return ErrorData<PeriodoContableResponse>(
        'No se pudo obtener el período contable.',
      );
    }
  }

  /// 4. ACTUALIZAR PERÍODO CONTABLE
  @override
  Future<Resource<PeriodoContableResponse>> updatePeriodoContable({
    required int idPeriodo,
    required int idEmpresa,
    required PeriodoContableRequest request,
  }) async {
    try {
      final token = await _getToken();

      if (token == null) {
        return _sessionError<PeriodoContableResponse>();
      }

      return await periodoService.updatePeriodoContable(
        token: token,
        idPeriodo: idPeriodo,
        idEmpresa: idEmpresa,
        request: request,
      );
    } catch (error) {
      debugPrint('ERROR REPOSITORY ACTUALIZAR PERIODO: $error');

      return ErrorData<PeriodoContableResponse>(
        'No se pudo actualizar el período contable.',
      );
    }
  }

  /// 5. ELIMINAR PERÍODO CONTABLE
  @override
  Future<Resource<PeriodoContableResponse>> deletePeriodoContable({
    required int idPeriodo,
    required int idEmpresa,
  }) async {
    try {
      final token = await _getToken();

      if (token == null) {
        return _sessionError<PeriodoContableResponse>();
      }

      return await periodoService.deletePeriodoContable(
        token: token,
        idPeriodo: idPeriodo,
        idEmpresa: idEmpresa,
      );
    } catch (error) {
      debugPrint('ERROR REPOSITORY ELIMINAR PERIODO: $error');

      return ErrorData<PeriodoContableResponse>(
        'No se pudo eliminar el período contable.',
      );
    }
  }

  /// 6. CAMBIAR ESTADO DEL PERÍODO
  @override
  Future<Resource<PeriodoContableResponse>> changeEstadoPeriodoContable({
    required int idPeriodo,
    required int idEmpresa,
    required String estado,
  }) async {
    try {
      final token = await _getToken();

      if (token == null) {
        return _sessionError<PeriodoContableResponse>();
      }

      final normalizedEstado = estado.trim().toUpperCase();

      if (!_isValidEstado(normalizedEstado)) {
        return ErrorData<PeriodoContableResponse>(
          'El estado del período contable no es válido.',
        );
      }

      return await periodoService.changeEstadoPeriodoContable(
        token: token,
        idPeriodo: idPeriodo,
        idEmpresa: idEmpresa,
        estado: normalizedEstado,
      );
    } catch (error) {
      debugPrint('ERROR REPOSITORY CAMBIAR ESTADO PERIODO: $error');

      return ErrorData<PeriodoContableResponse>(
        'No se pudo cambiar el estado del período contable.',
      );
    }
  }

  bool _isValidEstado(String estado) {
    return const {'ABIERTO', 'CERRADO', 'BLOQUEADO'}.contains(estado);
  }
}
