import 'package:equatable/equatable.dart';

// Models
import 'package:app_aryoria/src/data/models/movimientos/movimiento_create_request.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_query_params.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_update_request.dart';

abstract class MovimientoEvent extends Equatable {
  const MovimientoEvent();

  @override
  List<Object?> get props => [];
}

// ==========================================================
// OBTENER MOVIMIENTOS
// ==========================================================
class GetMovimientosEvent extends MovimientoEvent {
  final int idEmpresa;
  final MovimientoQueryParams queryParams;

  const GetMovimientosEvent({
    required this.idEmpresa,
    required this.queryParams,
  });

  @override
  List<Object?> get props => [idEmpresa, queryParams];
}

// ==========================================================
// REFRESCAR MOVIMIENTOS
// ==========================================================
class RefreshMovimientosEvent extends MovimientoEvent {
  final int idEmpresa;
  final MovimientoQueryParams queryParams;

  const RefreshMovimientosEvent({
    required this.idEmpresa,
    required this.queryParams,
  });

  @override
  List<Object?> get props => [idEmpresa, queryParams];
}

// ==========================================================
// BUSCAR MOVIMIENTOS
// ==========================================================
class SearchMovimientosEvent extends MovimientoEvent {
  final int idEmpresa;
  final MovimientoQueryParams queryParams;

  const SearchMovimientosEvent({
    required this.idEmpresa,
    required this.queryParams,
  });

  @override
  List<Object?> get props => [idEmpresa, queryParams];
}

// ==========================================================
// CREAR MOVIMIENTO
// ==========================================================
class CreateMovimientoEvent extends MovimientoEvent {
  final MovimientoCreateRequest request;

  const CreateMovimientoEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

// ==========================================================
// ACTUALIZAR MOVIMIENTO
// ==========================================================
class UpdateMovimientoEvent extends MovimientoEvent {
  final int idMovimiento;
  final int idEmpresa;
  final MovimientoUpdateRequest request;

  const UpdateMovimientoEvent({
    required this.idMovimiento,
    required this.idEmpresa,
    required this.request,
  });

  @override
  List<Object?> get props => [idMovimiento, idEmpresa, request];
}

// ==========================================================
// ELIMINAR MOVIMIENTO
// ==========================================================
class DeleteMovimientoEvent extends MovimientoEvent {
  final int idMovimiento;
  final int idEmpresa;

  const DeleteMovimientoEvent({
    required this.idMovimiento,
    required this.idEmpresa,
  });

  @override
  List<Object?> get props => [idMovimiento, idEmpresa];
}

// ==========================================================
// OBTENER MOVIMIENTO POR ID
// ==========================================================
class GetMovimientoByIdEvent extends MovimientoEvent {
  final int idMovimiento;
  final int idEmpresa;

  const GetMovimientoByIdEvent({
    required this.idMovimiento,
    required this.idEmpresa,
  });

  @override
  List<Object?> get props => [idMovimiento, idEmpresa];
}

// ==========================================================
// LIMPIAR RESPUESTA DE ACCIÓN
// ==========================================================
class ClearMovimientoActionResponseEvent extends MovimientoEvent {
  const ClearMovimientoActionResponseEvent();
}

// ==========================================================
// LIMPIAR RESPUESTA DE DETALLE
// ==========================================================
class ClearMovimientoDetailResponseEvent extends MovimientoEvent {
  const ClearMovimientoDetailResponseEvent();
}

// ==========================================================
// LIMPIAR MOVIMIENTOS
// ==========================================================
class ClearMovimientosEvent extends MovimientoEvent {
  const ClearMovimientosEvent();
}
