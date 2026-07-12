import 'package:equatable/equatable.dart';

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
  final int page;
  final int limit;
  final String? search;
  final String? estado;
  final bool refresh;

  const GetPeriodosContablesEvent({
    required this.idEmpresa,
    this.page = 1,
    this.limit = 10,
    this.search,
    this.estado,
    this.refresh = false,
  });

  @override
  List<Object?> get props => [idEmpresa, page, limit, search, estado, refresh];
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
  final int idEmpresa;
  final String nombre;
  final int anio;
  final int mes;
  final String fechaInicio;
  final String fechaFin;
  final double saldoInicial;
  final String? observacion;

  const CreatePeriodoContableEvent({
    required this.idEmpresa,
    required this.nombre,
    required this.anio,
    required this.mes,
    required this.fechaInicio,
    required this.fechaFin,
    required this.saldoInicial,
    this.observacion,
  });

  @override
  List<Object?> get props => [
    idEmpresa,
    nombre,
    anio,
    mes,
    fechaInicio,
    fechaFin,
    saldoInicial,
    observacion,
  ];
}

// ==========================================================
// ACTUALIZAR PERÍODO CONTABLE
// ==========================================================
class UpdatePeriodoContableEvent extends PeriodoContableEvent {
  final int idPeriodo;
  final int idEmpresa;
  final String nombre;
  final int anio;
  final int mes;
  final String fechaInicio;
  final String fechaFin;
  final double saldoInicial;
  final String? observacion;

  const UpdatePeriodoContableEvent({
    required this.idPeriodo,
    required this.idEmpresa,
    required this.nombre,
    required this.anio,
    required this.mes,
    required this.fechaInicio,
    required this.fechaFin,
    required this.saldoInicial,
    this.observacion,
  });

  @override
  List<Object?> get props => [
    idPeriodo,
    idEmpresa,
    nombre,
    anio,
    mes,
    fechaInicio,
    fechaFin,
    saldoInicial,
    observacion,
  ];
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
// Por ejemplo: ABIERTO o CERRADO
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
