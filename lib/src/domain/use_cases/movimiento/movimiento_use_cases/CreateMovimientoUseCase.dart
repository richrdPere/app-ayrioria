import 'package:app_aryoria/src/data/models/movimientos/movimiento_request.dart';
import 'package:app_aryoria/src/domain/repositories/movimiento_repository.dart';

class CreateMovimientoUseCase {
  MovimientoRepository movimientoRepository;
  CreateMovimientoUseCase(this.movimientoRepository);

  run(MovimientoRequest req) => movimientoRepository.createMovimiento(req);
}
