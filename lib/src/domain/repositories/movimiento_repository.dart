import 'package:app_aryoria/src/domain/utils/Resource.dart';

import 'package:app_aryoria/src/data/models/movimientos/movimiento_paginated.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_request.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_response.dart';

abstract class MovimientoRepository {
  /// Crear movimiento
  Future<Resource<MovimientoResponse>> createMovimiento(
    MovimientoRequest request,
  );

  /// Listar movimientos del usuario autenticado
  Future<Resource<MovimientoPaginatedResponse>> getMovimientos({
    int page = 1,
    int limit = 10,
    String search = '',
    required int idEmpresa,
    required int idPeriodo,
  });

  /// Obtener movimiento por Id
  Future<Resource<MovimientoResponse>> getMovimientoById(int idMovimiento);

  /// Actualizar movimiento
  Future<Resource<MovimientoResponse>> updateMovimiento({
    required int idMovimiento,
    required MovimientoRequest request,
  });

  /// Eliminar movimiento
  Future<Resource<MovimientoResponse>> deleteMovimiento(int idMovimiento);
}
