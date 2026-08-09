import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_paginated.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_query_params.dart';
import 'package:app_aryoria/src/domain/repositories/movimiento_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetMovimientosUseCase {
  MovimientoRepository movimientoRepository;
  GetMovimientosUseCase(this.movimientoRepository);

  Future<Resource<ApiResponse<MovimientoPaginated>>> run({
    required int idEmpresa,
    required MovimientoQueryParams queryParams,
  }) => movimientoRepository.getMovimientos(
    idEmpresa: idEmpresa,
    queryParams: queryParams,
  );
}
