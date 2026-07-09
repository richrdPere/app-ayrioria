import 'package:app_aryoria/src/data/datasources/remote/services/movimiento_service.dart';

// Repo
import 'package:app_aryoria/src/domain/repositories/movimiento_repository.dart';
import 'package:app_aryoria/src/domain/repositories/auth_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Models
import 'package:app_aryoria/src/data/models/movimientos/movimiento_paginated.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_request.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_response.dart';

class MovimientoRepositoryImpl implements MovimientoRepository {
  final MovimientoService movimientoService;
  final AuthRepository authRepository;

  MovimientoRepositoryImpl({
    required this.movimientoService,
    required this.authRepository,
  });

  @override
  Future<Resource<MovimientoResponse>> createMovimiento(
    MovimientoRequest request,
  ) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return movimientoService.createMovimiento(token: token, request: request);
  }

  @override
  Future<Resource<MovimientoResponse>> deleteMovimiento(
    int idMovimiento,
  ) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return movimientoService.deleteMovimiento(
      token: token,
      idMovimiento: idMovimiento,
    );
  }

  @override
  Future<Resource<MovimientoResponse>> getMovimientoById(
    int idMovimiento,
  ) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return movimientoService.getMovimientoById(
      token: token,
      idMovimiento: idMovimiento,
    );
  }

  @override
  Future<Resource<MovimientoPaginatedResponse>> getMovimientos({
    int page = 1,
    int limit = 10,
    required int idEmpresa,
    String search = '',
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return movimientoService.getMovimientos(
      token: token,
      idEmpresa: idEmpresa,
      page: page,
      limit: limit,
      search: search,
    );
  }

  @override
  Future<Resource<MovimientoResponse>> updateMovimiento({
    required int idMovimiento,
    required MovimientoRequest request,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return movimientoService.updateMovimiento(
      token: token,
      idMovimiento: idMovimiento,
      request: request,
    );
  }
}
