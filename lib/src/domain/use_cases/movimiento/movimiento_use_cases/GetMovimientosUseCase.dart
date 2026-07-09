import 'package:app_aryoria/src/domain/repositories/movimiento_repository.dart';

class GetMovimientosUseCase {
  MovimientoRepository movimientoRepository;
  GetMovimientosUseCase(this.movimientoRepository);

  run({
    int page = 1,
    int limit = 10,
    String search = '',
    required int idEmpresa,
  }) => movimientoRepository.getMovimientos(
    page: page,
    limit: limit,
    search: search,
    idEmpresa: idEmpresa,
  );
}
