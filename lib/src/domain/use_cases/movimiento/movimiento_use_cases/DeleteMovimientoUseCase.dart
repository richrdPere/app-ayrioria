import 'package:app_aryoria/src/domain/repositories/movimiento_repository.dart';

class DeleteMovimientoUseCase {
  MovimientoRepository movimientoRepository;
  DeleteMovimientoUseCase(this.movimientoRepository);

  run(int idMovimiento) => movimientoRepository.deleteMovimiento(idMovimiento);
}
