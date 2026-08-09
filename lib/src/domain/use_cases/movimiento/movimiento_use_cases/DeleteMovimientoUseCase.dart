import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/domain/repositories/movimiento_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class DeleteMovimientoUseCase {
  MovimientoRepository movimientoRepository;
  DeleteMovimientoUseCase(this.movimientoRepository);

  Future<Resource<ApiResponse<void>>> run({
    required int idMovimiento,
    required int idEmpresa,
  }) => movimientoRepository.deleteMovimiento(
    idMovimiento: idMovimiento,
    idEmpresa: idEmpresa,
  );
}
