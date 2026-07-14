import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_aryoria/src/domain/use_cases/movimiento/MovimientoUsesCases.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_paginated.dart';

import 'movimiento_event.dart';
import 'movimiento_state.dart';

class MovimientoBloc extends Bloc<MovimientoEvent, MovimientoState> {
  final MovimientoUsesCases movimientoUsesCases;

  MovimientoBloc(this.movimientoUsesCases) : super(const MovimientoState()) {
    on<GetMovimientosEvent>(_onGetMovimientos);
    on<RefreshMovimientosEvent>(_onRefreshMovimientos);
    on<SearchMovimientosEvent>(_onSearchMovimientos);
    on<CreateMovimientoEvent>(_onCreateMovimiento);
    on<UpdateMovimientoEvent>(_onUpdateMovimiento);
    on<DeleteMovimientoEvent>(_onDeleteMovimiento);
    on<GetMovimientoByIdEvent>(_onGetMovimientoById);
    on<ClearMovimientoActionResponseEvent>(_onClearMovimientoActionResponse);
    on<ClearMovimientoDetailResponseEvent>(_onClearMovimientoDetailResponse);
    on<ClearMovimientosEvent>(_onClearMovimientos);
  }

  // ==========================================================
  // OBTENER MOVIMIENTOS
  // ==========================================================
  Future<void> _onGetMovimientos(
    GetMovimientosEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    final bool isFirstPage = event.page == 1;

    emit(
      state.copyWith(
        idEmpresa: event.idEmpresa,
        idPeriodo: event.idPeriodo,
        isLoading: isFirstPage,
        isLoadingMore: !isFirstPage,
        search: event.search,
        page: event.page,
        clearMovimientoResponse: isFirstPage,
      ),
    );

    final response = await movimientoUsesCases.getMovimientos.run(
      idEmpresa: event.idEmpresa,
      idPeriodo: event.idPeriodo,
      page: event.page,
      limit: event.limit,
      search: event.search,
    );

    if (response is Success<MovimientoPaginatedResponse>) {
      final paginated = response.data;
      final pagination = paginated.pagination;

      final newList = isFirstPage
          ? paginated.data
          : [...state.movimientos, ...paginated.data];

      emit(
        state.copyWith(
          movimientoResponse: response,
          movimientos: newList,
          page: pagination.page,
          limit: pagination.limit,
          total: pagination.total,
          totalPages: pagination.totalPages,
          hasMore: pagination.page < pagination.totalPages,
          isLoading: false,
          isLoadingMore: false,
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        movimientoResponse: response,
        movimientos: isFirstPage ? [] : state.movimientos,
        isLoading: false,
        isLoadingMore: false,
        hasMore: false,
      ),
    );
  }

  // ==========================================================
  // REFRESCAR MOVIMIENTOS
  // ==========================================================
  void _onRefreshMovimientos(
    RefreshMovimientosEvent event,
    Emitter<MovimientoState> emit,
  ) {
    add(
      GetMovimientosEvent(
        idEmpresa: event.idEmpresa,
        idPeriodo: event.idPeriodo,
        page: 1,
        limit: state.limit,
        search: event.search,
      ),
    );
  }

  // ==========================================================
  // BUSCAR MOVIMIENTOS
  // ==========================================================
  void _onSearchMovimientos(
    SearchMovimientosEvent event,
    Emitter<MovimientoState> emit,
  ) {
    add(
      GetMovimientosEvent(
        idEmpresa: event.idEmpresa,
        idPeriodo: event.idPeriodo,
        page: 1,
        limit: state.limit,
        search: event.search,
      ),
    );
  }

  // ==========================================================
  // CREAR MOVIMIENTO
  // ==========================================================
  Future<void> _onCreateMovimiento(
    CreateMovimientoEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading()));

    final response = await movimientoUsesCases.createMovimiento.run(
      event.request,
    );

    emit(state.copyWith(actionResponse: response));
  }

  // ==========================================================
  // ACTUALIZAR MOVIMIENTO
  // ==========================================================
  Future<void> _onUpdateMovimiento(
    UpdateMovimientoEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading()));

    final response = await movimientoUsesCases.updateMovimiento.run(
      idMovimiento: event.idMovimiento,
      request: event.request,
    );

    emit(state.copyWith(actionResponse: response));
  }

  // ==========================================================
  // ELIMINAR MOVIMIENTO
  // ==========================================================
  Future<void> _onDeleteMovimiento(
    DeleteMovimientoEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading()));

    final response = await movimientoUsesCases.deleteMovimiento.run(
      event.idMovimiento,
    );

    emit(state.copyWith(actionResponse: response));

    if (response is Success) {
      add(
        GetMovimientosEvent(
          idEmpresa: event.idEmpresa,
          idPeriodo: event.idPeriodo,
          page: 1,
          limit: state.limit,
          search: state.search,
        ),
      );
    }
  }

  // ==========================================================
  // OBTENER MOVIMIENTO POR ID
  // ==========================================================
  Future<void> _onGetMovimientoById(
    GetMovimientoByIdEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(state.copyWith(detailResponse: Loading()));

    final response = await movimientoUsesCases.getMovimientoById.run(
      event.idMovimiento,
    );

    emit(state.copyWith(detailResponse: response));
  }

  // ==========================================================
  // LIMPIAR RESPUESTA DE ACCIÓN
  // ==========================================================
  void _onClearMovimientoActionResponse(
    ClearMovimientoActionResponseEvent event,
    Emitter<MovimientoState> emit,
  ) {
    emit(state.copyWith(clearActionResponse: true));
  }

  // ==========================================================
  // LIMPIAR RESPUESTA DE DETALLE
  // ==========================================================
  void _onClearMovimientoDetailResponse(
    ClearMovimientoDetailResponseEvent event,
    Emitter<MovimientoState> emit,
  ) {
    emit(state.copyWith(clearDetailResponse: true));
  }

  // ==========================================================
  // LIMPIAR ESTADO DE MOVIMIENTOS
  // ==========================================================
  void _onClearMovimientos(
    ClearMovimientosEvent event,
    Emitter<MovimientoState> emit,
  ) {
    emit(const MovimientoState());
  }
}
