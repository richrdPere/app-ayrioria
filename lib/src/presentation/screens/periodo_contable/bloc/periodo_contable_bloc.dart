import 'package:flutter_bloc/flutter_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_data.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_paginated.dart';

// Uses Cases
import 'package:app_aryoria/src/domain/use_cases/index_uses_cases.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Bloc
import 'periodo_contable_event.dart';
import 'periodo_contable_state.dart';

class PeriodoContableBloc
    extends Bloc<PeriodoContableEvent, PeriodoContableState> {
  final PeriodoContableUsesCases periodoContableUsesCases;

  PeriodoContableBloc(this.periodoContableUsesCases)
    : super(const PeriodoContableState()) {
    on<GetPeriodosContablesEvent>(_onGetPeriodosContables);
    on<GetPeriodoContableByIdEvent>(_onGetPeriodoContableById);
    on<CreatePeriodoContableEvent>(_onCreatePeriodoContable);
    on<UpdatePeriodoContableEvent>(_onUpdatePeriodoContable);
    on<DeletePeriodoContableEvent>(_onDeletePeriodoContable);
    on<ChangeEstadoPeriodoContableEvent>(_onChangeEstadoPeriodoContable);
    on<ClearPeriodoContableActionResponseEvent>(_onClearActionResponse);
    on<ClearPeriodoContableSelectedEvent>(_onClearPeriodoSelected);
  }

  // ==========================================================
  // 1. LISTAR PERÍODOS CONTABLES
  // ==========================================================
  Future<void> _onGetPeriodosContables(
    GetPeriodosContablesEvent event,
    Emitter<PeriodoContableState> emit,
  ) async {
    final bool isFirstPage = event.queryParams.page == 1;

    // ========================================================
    // LOADING
    // ========================================================
    if (isFirstPage || event.refresh) {
      emit(
        state.copyWith(
          response: Loading(),
          periodos: const [],
          page: 1,
          total: 0,
          totalPages: 0,
          hasNextPage: false,
          hasPreviousPage: false,
          isLoadingMore: false,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingMore: true));
    }

    // ========================================================
    // CONSULTA
    // ========================================================
    final Resource<ApiResponse<PeriodoContablePaginated>> response =
        await periodoContableUsesCases.getPeriodoC.run(
          idEmpresa: event.idEmpresa,
          queryParams: event.queryParams,
        );

    // ========================================================
    // SUCCESS
    // ========================================================
    if (response is Success<ApiResponse<PeriodoContablePaginated>>) {
      final ApiResponse<PeriodoContablePaginated> apiResponse = response.data;

      final PeriodoContablePaginated? paginated = apiResponse.data;

      if (paginated == null) {
        emit(
          state.copyWith(
            response: response,
            periodos: const [],
            total: 0,
            totalPages: 0,
            hasNextPage: false,
            hasPreviousPage: false,
            isLoadingMore: false,
          ),
        );

        return;
      }

      final pagination = paginated.pagination;

      emit(
        state.copyWith(
          response: response,

          // IMPORTANTE:
          // Se reemplaza la página actual, no se acumula.
          periodos: paginated.items,

          page: pagination.page,
          limit: pagination.limit,
          total: pagination.total,
          totalPages: pagination.totalPages,
          hasNextPage: pagination.hasNextPage,
          hasPreviousPage: pagination.hasPreviousPage,
          isLoadingMore: false,
        ),
      );

      return;
    }

    // ========================================================
    // ERROR
    // ========================================================
    emit(state.copyWith(response: response, isLoadingMore: false));
  }

  // ==========================================================
  // 2. OBTENER PERÍODO POR ID
  // ==========================================================
  Future<void> _onGetPeriodoContableById(
    GetPeriodoContableByIdEvent event,
    Emitter<PeriodoContableState> emit,
  ) async {
    emit(state.copyWith(detailResponse: Loading(), clearPeriodoSelected: true));

    final Resource<ApiResponse<PeriodoContableData>> response =
        await periodoContableUsesCases.getPeriodoCById.run(
          idPeriodo: event.idPeriodo,
          idEmpresa: event.idEmpresa,
        );

    if (response is Success<ApiResponse<PeriodoContableData>>) {
      final PeriodoContableData? periodo = response.data.data;

      emit(
        state.copyWith(
          detailResponse: response,
          periodoSelected: periodo,
          clearPeriodoSelected: periodo == null,
        ),
      );

      return;
    }

    emit(state.copyWith(detailResponse: response, clearPeriodoSelected: true));
  }

  // ==========================================================
  // 3. CREAR PERÍODO CONTABLE
  // ==========================================================
  Future<void> _onCreatePeriodoContable(
    CreatePeriodoContableEvent event,
    Emitter<PeriodoContableState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading()));

    final Resource<ApiResponse<PeriodoContableData>> response =
        await periodoContableUsesCases.createPeriodoC.run(event.request);

    if (response is Success<ApiResponse<PeriodoContableData>>) {
      final PeriodoContableData? periodoCreado = response.data.data;

      if (periodoCreado != null) {
        /*
         * Solo insertamos localmente si estamos en la primera página.
         *
         * Si estamos en página 2, 3, etc., insertar el nuevo período
         * rompería la representación de la página devuelta por backend.
         */
        if (state.page == 1) {
          final List<PeriodoContableData> periodosActualizados = [
            periodoCreado,
            ...state.periodos.where(
              (periodo) => periodo.idPeriodo != periodoCreado.idPeriodo,
            ),
          ];

          // Respetamos el límite actual de la página.
          final List<PeriodoContableData> periodosLimitados =
              periodosActualizados.length > state.limit
              ? periodosActualizados.take(state.limit).toList()
              : periodosActualizados;

          final int nuevoTotal = state.total + 1;
          final int nuevosTotalPages = state.limit > 0
              ? (nuevoTotal / state.limit).ceil()
              : 0;

          emit(
            state.copyWith(
              actionResponse: response,
              periodos: periodosLimitados,
              total: nuevoTotal,
              totalPages: nuevosTotalPages,
              hasNextPage: state.page < nuevosTotalPages,
            ),
          );

          return;
        }
      }

      emit(state.copyWith(actionResponse: response));

      return;
    }

    emit(state.copyWith(actionResponse: response));
  }

  // ==========================================================
  // 4. ACTUALIZAR PERÍODO CONTABLE
  // ==========================================================
  Future<void> _onUpdatePeriodoContable(
    UpdatePeriodoContableEvent event,
    Emitter<PeriodoContableState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading()));

    final Resource<ApiResponse<PeriodoContableData>> response =
        await periodoContableUsesCases.updatePeriodoC.run(
          idPeriodo: event.idPeriodo,
          idEmpresa: event.idEmpresa,
          request: event.request,
        );

    if (response is Success<ApiResponse<PeriodoContableData>>) {
      final PeriodoContableData? periodoActualizado = response.data.data;

      if (periodoActualizado != null) {
        final List<PeriodoContableData> periodosActualizados = state.periodos
            .map((periodo) {
              if (periodo.idPeriodo == periodoActualizado.idPeriodo) {
                return periodoActualizado;
              }

              return periodo;
            })
            .toList();

        final bool isSelected =
            state.periodoSelected?.idPeriodo == periodoActualizado.idPeriodo;

        emit(
          state.copyWith(
            actionResponse: response,
            periodos: periodosActualizados,
            periodoSelected: isSelected ? periodoActualizado : null,
          ),
        );

        return;
      }
    }

    emit(state.copyWith(actionResponse: response));
  }

  // ==========================================================
  // 5. ELIMINAR PERÍODO CONTABLE
  // ==========================================================
  Future<void> _onDeletePeriodoContable(
    DeletePeriodoContableEvent event,
    Emitter<PeriodoContableState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading()));

    final Resource<ApiResponse<void>> response = await periodoContableUsesCases
        .deletePeriodoC
        .run(idPeriodo: event.idPeriodo, idEmpresa: event.idEmpresa);

    if (response is Success<ApiResponse<void>>) {
      final List<PeriodoContableData> periodosActualizados = state.periodos
          .where((periodo) {
            return periodo.idPeriodo != event.idPeriodo;
          })
          .toList();

      final bool selectedWasDeleted =
          state.periodoSelected?.idPeriodo == event.idPeriodo;

      final int nuevoTotal = state.total > 0 ? state.total - 1 : 0;

      final int nuevosTotalPages = state.limit > 0
          ? (nuevoTotal / state.limit).ceil()
          : 0;

      emit(
        state.copyWith(
          actionResponse: response,
          periodos: periodosActualizados,
          total: nuevoTotal,
          totalPages: nuevosTotalPages,
          hasNextPage: state.page < nuevosTotalPages,
          hasPreviousPage: state.page > 1,
          clearPeriodoSelected: selectedWasDeleted,
        ),
      );

      return;
    }

    emit(state.copyWith(actionResponse: response));
  }

  // ==========================================================
  // 6. CAMBIAR ESTADO DEL PERÍODO
  // ==========================================================
  Future<void> _onChangeEstadoPeriodoContable(
    ChangeEstadoPeriodoContableEvent event,
    Emitter<PeriodoContableState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading()));

    final Resource<ApiResponse<PeriodoContableData>> response =
        await periodoContableUsesCases.changeEstadoPeriodoC.run(
          idPeriodo: event.idPeriodo,
          idEmpresa: event.idEmpresa,
          estado: event.estado,
        );

    if (response is Success<ApiResponse<PeriodoContableData>>) {
      final PeriodoContableData? periodoActualizado = response.data.data;

      if (periodoActualizado == null) {
        emit(state.copyWith(actionResponse: response));

        return;
      }

      final List<PeriodoContableData> periodosActualizados = state.periodos.map(
        (periodo) {
          if (periodo.idPeriodo == periodoActualizado.idPeriodo) {
            return periodoActualizado;
          }

          return periodo;
        },
      ).toList();

      final bool isSelected =
          state.periodoSelected?.idPeriodo == periodoActualizado.idPeriodo;

      emit(
        state.copyWith(
          actionResponse: response,
          periodos: periodosActualizados,
          periodoSelected: isSelected ? periodoActualizado : null,
        ),
      );

      return;
    }

    emit(state.copyWith(actionResponse: response));
  }

  // ==========================================================
  // LIMPIAR RESPUESTA DE ACCIÓN
  // ==========================================================
  void _onClearActionResponse(
    ClearPeriodoContableActionResponseEvent event,
    Emitter<PeriodoContableState> emit,
  ) {
    emit(state.copyWith(clearActionResponse: true));
  }

  // ==========================================================
  // LIMPIAR PERÍODO SELECCIONADO
  // ==========================================================
  void _onClearPeriodoSelected(
    ClearPeriodoContableSelectedEvent event,
    Emitter<PeriodoContableState> emit,
  ) {
    emit(state.copyWith(clearPeriodoSelected: true, clearDetailResponse: true));
  }
}
