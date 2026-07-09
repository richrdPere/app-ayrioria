import 'package:app_aryoria/src/data/models/movimientos/movimiento_request.dart';
import 'package:app_aryoria/src/domain/repositories/movimiento_repository.dart';

class UpdateMovimientoUseCase {
  MovimientoRepository movimientoRepository;
  UpdateMovimientoUseCase(this.movimientoRepository);

  run({required int idMovimiento, required MovimientoRequest request}) =>
      movimientoRepository.updateMovimiento(
        idMovimiento: idMovimiento,
        request: request,
      );
}
