import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_paginated.dart';

import 'package:app_aryoria/src/domain/use_cases/movimiento/MovimientoUsesCases.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

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
    // ==========================================================
    // LOADING
    // ==========================================================

    emit(
      state.copyWith(
        idEmpresa: event.idEmpresa,
        queryParams: event.queryParams,
        isLoading: true,
        clearMovimientoResponse: true,
      ),
    );

    // ==========================================================
    // REQUEST
    // ==========================================================
    final response = await movimientoUsesCases.getMovimientos.run(
      idEmpresa: event.idEmpresa,
      queryParams: event.queryParams,
    );

    // ==========================================================
    // SUCCESS
    // ==========================================================
    if (response is Success<ApiResponse<MovimientoPaginated>>) {
      final paginated = response.data.data;

      // ========================================================
      // DATA NULL
      // ========================================================
      if (paginated == null) {
        emit(
          state.copyWith(
            movimientoResponse: response,

            movimientos: const [],

            total: 0,
            totalPages: 0,
            hasNextPage: false,
            hasPreviousPage: false,

            isLoading: false,
          ),
        );

        return;
      }

      final pagination = paginated.pagination;

      // ========================================================
      // QUERY REAL DEVUELTA POR EL BACKEND
      // ========================================================
      final updatedParams = event.queryParams.copyWith(
        page: pagination.page,
        limit: pagination.limit,
      );

      // ========================================================
      // ACTUALIZAR STATE
      // ========================================================
      emit(
        state.copyWith(
          movimientoResponse: response,
          movimientos: paginated.items,
          queryParams: updatedParams,
          total: pagination.total,
          totalPages: pagination.totalPages,
          hasNextPage: pagination.hasNextPage,
          hasPreviousPage: pagination.hasPreviousPage,
          isLoading: false,
        ),
      );

      return;
    }

    // ==========================================================
    // ERROR
    // ==========================================================

    emit(
      state.copyWith(
        movimientoResponse:
            response as Resource<ApiResponse<MovimientoPaginated>>?,

        movimientos: const [],

        isLoading: false,
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
        queryParams: event.queryParams.copyWith(page: 1),
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
        queryParams: event.queryParams.copyWith(page: 1),
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
    emit(
      state.copyWith(
        actionResponse: const Loading<ApiResponse<MovimientoData>>(),
      ),
    );

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
    emit(
      state.copyWith(
        actionResponse: const Loading<ApiResponse<MovimientoData>>(),
      ),
    );

    final response = await movimientoUsesCases.updateMovimiento.run(
      idMovimiento: event.idMovimiento,
      idEmpresa: event.idEmpresa,
      request: event.request,
    );

    emit(state.copyWith(actionResponse: response));

    // Actualizar también el movimiento seleccionado
    if (response is Success<ApiResponse<MovimientoData>>) {
      final movimiento = response.data.data;

      if (movimiento != null) {
        emit(state.copyWith(movimientoSelected: movimiento));
      }
    }
  }

  // ==========================================================
  // ELIMINAR MOVIMIENTO
  // ==========================================================
  Future<void> _onDeleteMovimiento(
    DeleteMovimientoEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(state.copyWith(actionResponse: const Loading<ApiResponse<void>>()));

    final response = await movimientoUsesCases.deleteMovimiento.run(
      idMovimiento: event.idMovimiento,
      idEmpresa: event.idEmpresa,
    );

    emit(state.copyWith(actionResponse: response));

    if (response is Success<ApiResponse<void>>) {
      // ======================================================
      // OPCIÓN 1:
      // eliminar localmente para evitar otra llamada HTTP
      // ======================================================

      final updatedList = state.movimientos
          .where((movimiento) => movimiento.idMovimiento != event.idMovimiento)
          .toList();

      final int updatedTotal = state.total > 0 ? state.total - 1 : 0;

      emit(
        state.copyWith(
          movimientos: updatedList,
          total: updatedTotal,
          movimientoSelected:
              state.movimientoSelected?.idMovimiento == event.idMovimiento
              ? null
              : state.movimientoSelected,
          clearMovimientoSelected:
              state.movimientoSelected?.idMovimiento == event.idMovimiento,
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
    emit(
      state.copyWith(
        detailResponse: const Loading<ApiResponse<MovimientoData>>(),
        clearMovimientoSelected: true,
      ),
    );

    final response = await movimientoUsesCases.getMovimientoById.run(
      idEmpresa: event.idEmpresa,
      idMovimiento: event.idMovimiento,
    );

    if (response is Success<ApiResponse<MovimientoData>>) {
      final movimiento = response.data.data;

      emit(
        state.copyWith(
          detailResponse: response,
          movimientoSelected: movimiento,
        ),
      );

      return;
    }

    emit(
      state.copyWith(detailResponse: response, clearMovimientoSelected: true),
    );
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
    emit(
      state.copyWith(clearDetailResponse: true, clearMovimientoSelected: true),
    );
  }

  // ==========================================================
  // LIMPIAR ESTADO
  // ==========================================================
  void _onClearMovimientos(
    ClearMovimientosEvent event,
    Emitter<MovimientoState> emit,
  ) {
    emit(const MovimientoState());
  }
}
