import 'package:app_aryoria/src/domain/use_cases/movimiento/movimiento_use_cases/CreateMovimientoUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/movimiento/movimiento_use_cases/DeleteMovimientoUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/movimiento/movimiento_use_cases/GetMovimientoByIdUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/movimiento/movimiento_use_cases/GetMovimientosUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/movimiento/movimiento_use_cases/UpdateMovimientoUseCase.dart';

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
