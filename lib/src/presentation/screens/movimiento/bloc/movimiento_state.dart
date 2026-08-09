import 'package:equatable/equatable.dart';

import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_paginated.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_query_params.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

class MovimientoState extends Equatable {
  // ==========================================================
  // RESPUESTAS
  // ==========================================================

  /// Respuesta del listado paginado.
  final Resource<ApiResponse<MovimientoPaginated>>? movimientoResponse;

  /// Respuesta de crear / actualizar / eliminar.
  ///
  /// Para eliminar el backend devuelve ApiResponse<void>,
  /// pero para simplificar el Bloc mantenemos Resource dinámico.
  final Resource? actionResponse;

  /// Respuesta del detalle de un movimiento.
  final Resource<ApiResponse<MovimientoData>>? detailResponse;

  // ==========================================================
  // DATOS
  // ==========================================================

  final List<MovimientoData> movimientos;

  /// Movimiento cargado para detalle o edición.
  final MovimientoData? movimientoSelected;

  // ==========================================================
  // CONTEXTO
  // ==========================================================

  final int? idEmpresa;

  /// Filtros, búsqueda y paginación actuales.
  final MovimientoQueryParams queryParams;

  // ==========================================================
  // PAGINACIÓN
  // ==========================================================

  final int total;
  final int totalPages;

  final bool hasMore;

  // ==========================================================
  // LOADING
  // ==========================================================
  final bool isLoading;
  final bool isLoadingMore;

  const MovimientoState({
    this.movimientoResponse,
    this.actionResponse,
    this.detailResponse,

    this.movimientos = const [],
    this.movimientoSelected,

    this.idEmpresa,

    this.queryParams = const MovimientoQueryParams(),

    this.total = 0,
    this.totalPages = 0,

    this.hasMore = true,

    this.isLoading = false,
    this.isLoadingMore = false,
  });


  // HELPERS
  int get page => queryParams.page;
  int get limit => queryParams.limit;
  int? get idPeriodo => queryParams.idPeriodo;
  int? get idCategoria => queryParams.idCategoria;
  int? get idSubcategoria => queryParams.idSubcategoria;
  int? get idCuenta => queryParams.idCuenta;
  String get search => queryParams.search ?? '';
  String? get tipo => queryParams.tipo;
  String? get estado => queryParams.estado;
  String? get fechaInicio => queryParams.fechaInicio;
  String? get fechaFin => queryParams.fechaFin;
  bool get hasMovimientos => movimientos.isNotEmpty;
  bool get hasSearch =>
      queryParams.search != null && queryParams.search!.trim().isNotEmpty;

  // ==========================================================
  // COPY WITH
  // ==========================================================

  MovimientoState copyWith({
    Resource<ApiResponse<MovimientoPaginated>>? movimientoResponse,
    Resource? actionResponse,
    Resource<ApiResponse<MovimientoData>>? detailResponse,

    List<MovimientoData>? movimientos,
    MovimientoData? movimientoSelected,

    int? idEmpresa,
    MovimientoQueryParams? queryParams,

    int? total,
    int? totalPages,

    bool? hasMore,

    bool? isLoading,
    bool? isLoadingMore,

    bool clearMovimientoResponse = false,
    bool clearActionResponse = false,
    bool clearDetailResponse = false,

    bool clearMovimientoSelected = false,
    bool clearIdEmpresa = false,
  }) {
    return MovimientoState(
      movimientoResponse: clearMovimientoResponse
          ? null
          : movimientoResponse ?? this.movimientoResponse,

      actionResponse: clearActionResponse
          ? null
          : actionResponse ?? this.actionResponse,

      detailResponse: clearDetailResponse
          ? null
          : detailResponse ?? this.detailResponse,

      movimientos: movimientos ?? this.movimientos,

      movimientoSelected: clearMovimientoSelected
          ? null
          : movimientoSelected ?? this.movimientoSelected,
      idEmpresa: clearIdEmpresa ? null : idEmpresa ?? this.idEmpresa,
      queryParams: queryParams ?? this.queryParams,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }


  // EQUATABLE
  @override
  List<Object?> get props => [
    movimientoResponse,
    actionResponse,
    detailResponse,

    movimientos,
    movimientoSelected,

    idEmpresa,
    queryParams,

    total,
    totalPages,

    hasMore,

    isLoading,
    isLoadingMore,
  ];
}
