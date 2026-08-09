import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_create_request.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_paginated.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_query_params.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_update_request.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

abstract class MovimientoRepository {
  /// 1.- Crear movimiento
  Future<Resource<ApiResponse<MovimientoData>>> createMovimiento(
    MovimientoCreateRequest request,
  );

  /// 2.- Listar movimientos del usuario autenticado
  Future<Resource<ApiResponse<MovimientoPaginated>>> getMovimientos({
    required int idEmpresa,
    required MovimientoQueryParams queryParams,
  });

  /// 3.- Obtener movimiento por Id
  Future<Resource<ApiResponse<MovimientoData>>> getMovimientoById({
    required int idEmpresa,
    required int idMovimiento,
  });

  /// 4.- Actualizar movimiento
  Future<Resource<ApiResponse<MovimientoData>>> updateMovimiento({
    required int idMovimiento,
    required int idEmpresa,
    required MovimientoUpdateRequest request,
  });

  /// 5.- Eliminar movimiento
  Future<Resource<ApiResponse<void>>> deleteMovimiento({
    required int idMovimiento,
    required int idEmpresa,
  });
}
