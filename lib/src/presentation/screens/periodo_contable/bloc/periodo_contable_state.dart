import 'package:equatable/equatable.dart';

import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_data.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class PeriodoContableState extends Equatable {
  /// Lista acumulada de períodos contables.
  final List<PeriodoContableData> periodos;

  /// Período obtenido mediante búsqueda por ID.
  final PeriodoContableData? periodoSelected;

  /// Respuesta del listado.
  final Resource? response;

  /// Respuesta para crear, editar, eliminar o cambiar estado.
  final Resource? actionResponse;

  /// Respuesta al obtener el detalle por ID.
  final Resource? detailResponse;

  /// Página cargada actualmente.
  final int page;

  /// Límite de registros por página.
  final int limit;

  /// Total de páginas devuelto por el backend.
  final int totalPages;

  /// Indica si todavía existen más páginas.
  final bool hasMore;

  /// Indica si se está cargando una página adicional.
  final bool isLoadingMore;

  /// Periodo contable activo

  const PeriodoContableState({
    this.periodos = const [],
    this.periodoSelected,
    this.response,
    this.actionResponse,
    this.detailResponse,
    this.page = 1,
    this.limit = 10,
    this.totalPages = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  // ==========================================================
  // PERÍODO CONTABLE ACTIVO
  // ==========================================================

  /// Retorna el primer período cuyo estado sea ABIERTO.
  ///
  /// Si no existe ningún período abierto, retorna null.
  PeriodoContableData? get periodoActivo {
    for (final periodo in periodos) {
      if (periodo.estado.trim().toUpperCase() == 'ABIERTO') {
        return periodo;
      }
    }

    return null;
  }

  /// Retorna el ID del período activo.
  ///
  /// Si no existe un período abierto, retorna null.
  int? get idPeriodoActivo => periodoActivo?.idPeriodo;

  /// Indica si existe un período contable abierto.
  bool get tienePeriodoActivo => periodoActivo != null;

  PeriodoContableState copyWith({
    List<PeriodoContableData>? periodos,
    PeriodoContableData? periodoSelected,
    bool clearPeriodoSelected = false,
    Resource? response,
    Resource? actionResponse,
    bool clearActionResponse = false,
    Resource? detailResponse,
    bool clearDetailResponse = false,
    int? page,
    int? limit,
    int? totalPages,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PeriodoContableState(
      periodos: periodos ?? this.periodos,
      periodoSelected: clearPeriodoSelected
          ? null
          : periodoSelected ?? this.periodoSelected,
      response: response ?? this.response,
      actionResponse: clearActionResponse
          ? null
          : actionResponse ?? this.actionResponse,
      detailResponse: clearDetailResponse
          ? null
          : detailResponse ?? this.detailResponse,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    periodos,
    periodoSelected,
    response,
    actionResponse,
    detailResponse,
    page,
    limit,
    totalPages,
    hasMore,
    isLoadingMore,
  ];
}
