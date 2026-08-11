
import 'package:app_aryoria/src/domain/use_cases/index_uses_cases.dart';

class MovimientoUsesCases {
  CreateMovimientoUseCase createMovimiento;
  DeleteMovimientoUseCase deleteMovimiento;
  GetMovimientoByIdUseCase getMovimientoById;
  GetMovimientosUseCase getMovimientos;
  UpdateMovimientoUseCase updateMovimiento;

  MovimientoUsesCases({
    required this.createMovimiento,
    required this.deleteMovimiento,
    required this.getMovimientoById,
    required this.getMovimientos,
    required this.updateMovimiento,
  });
}
