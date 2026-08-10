import 'package:equatable/equatable.dart';

import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_data.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class PeriodoContableState extends Equatable {
  /// Lista de períodos contables.
  final List<PeriodoContableData> periodos;

  /// Período obtenido mediante búsqueda por ID.
  final PeriodoContableData? periodoSelected;

  /// Respuesta del listado.
  final Resource? response;

  /// Respuesta para crear, editar, eliminar o cambiar estado.
  final Resource? actionResponse;

  /// Respuesta al obtener el detalle por ID.
  final Resource? detailResponse;

  // ==========================================================
  // PAGINACIÓN
  // ==========================================================

  /// Página cargada actualmente.
  final int page;

  /// Cantidad de registros solicitados por página.
  final int limit;

  /// Total de registros encontrados.
  final int total;

  /// Total de páginas devuelto por el backend.
  final int totalPages;

  /// Indica si existe una página siguiente.
  final bool hasNextPage;

  /// Indica si existe una página anterior.
  final bool hasPreviousPage;

  /// Indica si se está cargando una página adicional.
  final bool isLoadingMore;

  const PeriodoContableState({
    this.periodos = const [],
    this.periodoSelected,
    this.response,
    this.actionResponse,
    this.detailResponse,
    this.page = 1,
    this.limit = 10,
    this.total = 0,
    this.totalPages = 0,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
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

  // ==========================================================
  // HELPERS PAGINACIÓN
  // ==========================================================
  bool get isFirstPage => page <= 1;
  bool get isLastPage => !hasNextPage;
  bool get tienePeriodos => periodos.isNotEmpty;
  bool get isEmpty => periodos.isEmpty;

  // ==========================================================
  // COPY WITH
  // ==========================================================

  PeriodoContableState copyWith({
    List<PeriodoContableData>? periodos,

    PeriodoContableData? periodoSelected,
    bool clearPeriodoSelected = false,

    Resource? response,
    bool clearResponse = false,

    Resource? actionResponse,
    bool clearActionResponse = false,

    Resource? detailResponse,
    bool clearDetailResponse = false,

    int? page,
    int? limit,
    int? total,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    bool? isLoadingMore,
  }) {
    return PeriodoContableState(
      periodos: periodos ?? this.periodos,
      periodoSelected: clearPeriodoSelected
          ? null
          : periodoSelected ?? this.periodoSelected,
      response: clearResponse ? null : response ?? this.response,
      actionResponse: clearActionResponse
          ? null
          : actionResponse ?? this.actionResponse,
      detailResponse: clearDetailResponse
          ? null
          : detailResponse ?? this.detailResponse,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  // ==========================================================
  // EQUATABLE
  // ==========================================================
  @override
  List<Object?> get props => [
    periodos,
    periodoSelected,
    response,
    actionResponse,
    detailResponse,
    page,
    limit,
    total,
    totalPages,
    hasNextPage,
    hasPreviousPage,
    isLoadingMore,
  ];
}
