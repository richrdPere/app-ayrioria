import 'package:equatable/equatable.dart';

import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_query_params.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_request.dart';

abstract class PeriodoContableEvent extends Equatable {
  const PeriodoContableEvent();

  @override
  List<Object?> get props => [];
}

// ==========================================================
// LISTAR PERÍODOS CONTABLES
// ==========================================================
class GetPeriodosContablesEvent extends PeriodoContableEvent {
  final int idEmpresa;
  final PeriodosContablesParams queryParams;
  final bool refresh;

  const GetPeriodosContablesEvent({
    required this.idEmpresa,
    required this.queryParams,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [idEmpresa, queryParams, refresh];
}

// ==========================================================
// OBTENER PERÍODO POR ID
// ==========================================================
class GetPeriodoContableByIdEvent extends PeriodoContableEvent {
  final int idPeriodo;
  final int idEmpresa;

  const GetPeriodoContableByIdEvent({
    required this.idPeriodo,
    required this.idEmpresa,
  });

  @override
  List<Object?> get props => [idPeriodo, idEmpresa];
}

// ==========================================================
// CREAR PERÍODO CONTABLE
// ==========================================================
class CreatePeriodoContableEvent extends PeriodoContableEvent {
  final PeriodoContableRequest request;

  const CreatePeriodoContableEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

// ==========================================================
// ACTUALIZAR PERÍODO CONTABLE
// ==========================================================
class UpdatePeriodoContableEvent extends PeriodoContableEvent {
  final int idPeriodo;
  final int idEmpresa;
  final PeriodoContableRequest request;

  const UpdatePeriodoContableEvent({
    required this.idPeriodo,
    required this.idEmpresa,
    required this.request,
  });

  @override
  List<Object?> get props => [idPeriodo, idEmpresa, request];
}

// ==========================================================
// ELIMINAR PERÍODO CONTABLE
// ==========================================================
class DeletePeriodoContableEvent extends PeriodoContableEvent {
  final int idPeriodo;
  final int idEmpresa;

  const DeletePeriodoContableEvent({
    required this.idPeriodo,
    required this.idEmpresa,
  });

  @override
  List<Object?> get props => [idPeriodo, idEmpresa];
}

// ==========================================================
// CAMBIAR ESTADO DEL PERÍODO
// ==========================================================
class ChangeEstadoPeriodoContableEvent extends PeriodoContableEvent {
  final int idPeriodo;
  final int idEmpresa;
  final String estado;

  const ChangeEstadoPeriodoContableEvent({
    required this.idPeriodo,
    required this.idEmpresa,
    required this.estado,
  });

  @override
  List<Object?> get props => [idPeriodo, idEmpresa, estado];
}

// ==========================================================
// LIMPIAR RESPUESTAS
// ==========================================================
class ClearPeriodoContableActionResponseEvent extends PeriodoContableEvent {
  const ClearPeriodoContableActionResponseEvent();
}

class ClearPeriodoContableSelectedEvent extends PeriodoContableEvent {
  const ClearPeriodoContableSelectedEvent();
}
