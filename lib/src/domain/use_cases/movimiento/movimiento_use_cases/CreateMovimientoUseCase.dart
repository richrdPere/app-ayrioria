import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_create_request.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/domain/repositories/movimiento_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class CreateMovimientoUseCase {
  MovimientoRepository movimientoRepository;
  CreateMovimientoUseCase(this.movimientoRepository);

  Future<Resource<ApiResponse<MovimientoData>>> run(
    MovimientoCreateRequest req,
  ) => movimientoRepository.createMovimiento(req);
}
