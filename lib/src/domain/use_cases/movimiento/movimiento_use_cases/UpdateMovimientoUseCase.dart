import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_update_request.dart';
import 'package:app_aryoria/src/domain/repositories/movimiento_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class UpdateMovimientoUseCase {
  MovimientoRepository movimientoRepository;
  UpdateMovimientoUseCase(this.movimientoRepository);

  Future<Resource<ApiResponse<MovimientoData>>> run({
    required int idMovimiento,
    required int idEmpresa,
    required MovimientoUpdateRequest request,
  }) => movimientoRepository.updateMovimiento(
    idMovimiento: idMovimiento,
    idEmpresa: idEmpresa,
    request: request,
  );
}
