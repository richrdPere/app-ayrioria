import 'package:equatable/equatable.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_request.dart';

abstract class MovimientoEvent extends Equatable {
  const MovimientoEvent();

  @override
  List<Object?> get props => [];
}

// Obtener movimientos
class GetMovimientosEvent extends MovimientoEvent {
  final int idEmpresa;
  final int page;
  final int limit;
  final String search;

  const GetMovimientosEvent({
    required this.idEmpresa,
    this.page = 1,
    this.limit = 10,
    this.search = '',
  });

  @override
  List<Object?> get props => [idEmpresa, page, limit, search];
}

// Refrescar movimiento
class RefreshMovimientosEvent extends MovimientoEvent {
  final int idEmpresa;
  final String search;

  const RefreshMovimientosEvent({required this.idEmpresa, this.search = ''});

  @override
  List<Object?> get props => [idEmpresa, search];
}

//Buscar movimiento
class SearchMovimientosEvent extends MovimientoEvent {
  final int idEmpresa;
  final String search;

  const SearchMovimientosEvent({required this.idEmpresa, required this.search});

  @override
  List<Object?> get props => [idEmpresa, search];
}

// Crear movimiento
class CreateMovimientoEvent extends MovimientoEvent {
  final MovimientoRequest request;

  const CreateMovimientoEvent(this.request);

  @override
  List<Object?> get props => [request];
}

// Actualizar movimiento
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

// Eliminar movimiento
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

// Movimientos por Id
class GetMovimientoByIdEvent extends MovimientoEvent {
  final int idMovimiento;

  const GetMovimientoByIdEvent(this.idMovimiento);

  @override
  List<Object?> get props => [idMovimiento];
}
