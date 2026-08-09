import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/domain/repositories/movimiento_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetMovimientoByIdUseCase {
  MovimientoRepository movimientoRepository;
  GetMovimientoByIdUseCase(this.movimientoRepository);

  Future<Resource<ApiResponse<MovimientoData>>> run({
    required int idEmpresa,
    required int idMovimiento,
  }) => movimientoRepository.getMovimientoById(
    idMovimiento: idMovimiento,
    idEmpresa: idEmpresa,
  );
}
