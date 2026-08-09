import 'package:app_aryoria/src/data/datasources/remote/services/movimiento_service.dart';

// Repo
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_create_request.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_paginated.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_query_params.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_update_request.dart';

class MovimientoRepositoryImpl implements MovimientoRepository {
  final MovimientoService movimientoService;
  final AuthRepository authRepository;

  MovimientoRepositoryImpl({
    required this.movimientoService,
    required this.authRepository,
  });

  // *********************************************************
  // 1.- Crear Movimiento
  // *********************************************************
  @override
  Future<Resource<ApiResponse<MovimientoData>>> createMovimiento(
    MovimientoCreateRequest request,
  ) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return movimientoService.createMovimiento(token: token, request: request);
  }

  // *********************************************************
  // 2.- Obtener Movimientos + Paginado
  // *********************************************************
  @override
  Future<Resource<ApiResponse<MovimientoPaginated>>> getMovimientos({
    required int idEmpresa,
    required MovimientoQueryParams queryParams,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return movimientoService.getMovimientos(
      token: token,
      idEmpresa: idEmpresa,
      queryParams: queryParams,
    );
  }

  // *********************************************************
  // 3.- Obtener Movimiento por ID
  // *********************************************************
  @override
  Future<Resource<ApiResponse<MovimientoData>>> getMovimientoById({
    required int idEmpresa,
    required int idMovimiento,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return movimientoService.getMovimientoById(
      token: token,
      idMovimiento: idMovimiento,
      idEmpresa: idEmpresa,
    );
  }

  // *********************************************************
  // 4.- Actualizar Movimiento
  // *********************************************************
  @override
  Future<Resource<ApiResponse<MovimientoData>>> updateMovimiento({
    required int idMovimiento,
    required int idEmpresa,
    required MovimientoUpdateRequest request,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return movimientoService.updateMovimiento(
      token: token,
      idMovimiento: idMovimiento,
      request: request,
      idEmpresa: idEmpresa,
    );
  }

  // *********************************************************
  // 5.- Eliminar Movimiento
  // *********************************************************
  @override
  Future<Resource<ApiResponse<void>>> deleteMovimiento({
    required int idMovimiento,
    required int idEmpresa,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return movimientoService.deleteMovimiento(
      token: token,
      idMovimiento: idMovimiento,
      idEmpresa: idEmpresa,
    );
  }
}
