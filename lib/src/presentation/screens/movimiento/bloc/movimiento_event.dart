import 'package:equatable/equatable.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_request.dart';

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
  final int idPeriodo;
  final int page;
  final int limit;
  final String search;

  const GetMovimientosEvent({
    required this.idEmpresa,
    required this.idPeriodo,
    this.page = 1,
    this.limit = 10,
    this.search = '',
  });

  @override
  List<Object?> get props => [idEmpresa, idPeriodo, page, limit, search];
}

// ==========================================================
// REFRESCAR MOVIMIENTOS
// ==========================================================
class RefreshMovimientosEvent extends MovimientoEvent {
  final int idEmpresa;
  final int idPeriodo;
  final String search;

  const RefreshMovimientosEvent({
    required this.idEmpresa,
    required this.idPeriodo,
    this.search = '',
  });

  @override
  List<Object?> get props => [idEmpresa, idPeriodo, search];
}

// ==========================================================
// BUSCAR MOVIMIENTOS
// ==========================================================
class SearchMovimientosEvent extends MovimientoEvent {
  final int idEmpresa;
  final int idPeriodo;
  final String search;

  const SearchMovimientosEvent({
    required this.idEmpresa,
    required this.idPeriodo,
    required this.search,
  });

  @override
  List<Object?> get props => [idEmpresa, idPeriodo, search];
}

// ==========================================================
// CREAR MOVIMIENTO
// ==========================================================
class CreateMovimientoEvent extends MovimientoEvent {
  final MovimientoRequest request;

  const CreateMovimientoEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

// ==========================================================
// ACTUALIZAR MOVIMIENTO
// ==========================================================
class UpdateMovimientoEvent extends MovimientoEvent {
  final int idMovimiento;
  final MovimientoRequest request;

  const UpdateMovimientoEvent({
    required this.idMovimiento,
    required this.request,
  });

  @override
  List<Object?> get props => [idMovimiento, request];
}

// ==========================================================
// ELIMINAR MOVIMIENTO
// ==========================================================
class DeleteMovimientoEvent extends MovimientoEvent {
  final int idMovimiento;
  final int idEmpresa;
  final int idPeriodo;

  const DeleteMovimientoEvent({
    required this.idMovimiento,
    required this.idEmpresa,
    required this.idPeriodo,
  });

  @override
  List<Object?> get props => [idMovimiento, idEmpresa, idPeriodo];
}

// ==========================================================
// OBTENER MOVIMIENTO POR ID
// ==========================================================
class GetMovimientoByIdEvent extends MovimientoEvent {
  final int idMovimiento;

  const GetMovimientoByIdEvent({required this.idMovimiento});

  @override
  List<Object?> get props => [idMovimiento];
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
