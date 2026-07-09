import 'package:app_aryoria/src/domain/repositories/movimiento_repository.dart';

class GetMovimientoByIdUseCase {
  MovimientoRepository movimientoRepository;
  GetMovimientoByIdUseCase(this.movimientoRepository);

  run(int idMovimiento) => movimientoRepository.getMovimientoById(idMovimiento);
}
