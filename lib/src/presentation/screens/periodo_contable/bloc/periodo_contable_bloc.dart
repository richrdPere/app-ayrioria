import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_request.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Models
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
    final bool isFirstPage = event.page == 1;
    final bool shouldClearList = isFirstPage || event.refresh;

    // Evitar solicitudes duplicadas al cargar más páginas.
    if (!shouldClearList && (state.isLoadingMore || !state.hasMore)) {
      return;
    }

    if (shouldClearList) {
      emit(
        state.copyWith(
          response: Loading(),
          periodos: const [],
          page: 1,
          totalPages: 1,
          hasMore: true,
          isLoadingMore: false,
        ),
      );
    } else {
      emit(state.copyWith(isLoadingMore: true));
    }

    // ========================================================
    // CONSTRUIR QUERY PARAMS
    // ========================================================
    final Map<String, dynamic> queryParams = {
      'page': event.page,
      'limit': event.limit,
    };

    // Solo se envían los filtros cuando contienen un valor válido.
    final String? search = event.search?.trim();

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final String? estado = event.estado?.trim();

    if (estado != null && estado.isNotEmpty) {
      queryParams['estado'] = estado;
    }

    final Resource<PeriodoContablePaginatedResponse> response =
        await periodoContableUsesCases.getPeriodoC.run(
          idEmpresa: event.idEmpresa,
          queryParams: queryParams,
        );

    if (response is Success<PeriodoContablePaginatedResponse>) {
      final PeriodoContablePaginatedResponse paginated = response.data;

      final List<PeriodoContableData> nuevosPeriodos = paginated.data;

      final List<PeriodoContableData> periodosActualizados = shouldClearList
          ? nuevosPeriodos
          : _mergePeriodos(actuales: state.periodos, nuevos: nuevosPeriodos);

      final bool hasMore =
          paginated.pagination.page < paginated.pagination.totalPages;

      emit(
        state.copyWith(
          response: response,
          periodos: periodosActualizados,
          page: paginated.pagination.page,
          limit: event.limit,
          totalPages: paginated.pagination.totalPages,
          hasMore: hasMore,
          isLoadingMore: false,
        ),
      );

      return;
    }

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

    final Resource<PeriodoContableResponse> response =
        await periodoContableUsesCases.getPeriodoCById.run(
          idPeriodo: event.idPeriodo,
          idEmpresa: event.idEmpresa,
        );

    if (response is Success<PeriodoContableResponse>) {
      emit(
        state.copyWith(
          detailResponse: response,
          periodoSelected: response.data.data,
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

    final PeriodoContableRequest request = PeriodoContableRequest(
      idEmpresa: event.idEmpresa,
      nombre: event.nombre,
      anio: event.anio,
      mes: event.mes,
      fechaInicio: event.fechaInicio,
      fechaFin: event.fechaFin,
      saldoInicial: event.saldoInicial,
      observacion: event.observacion,
    );

    final Resource<PeriodoContableResponse> response =
        await periodoContableUsesCases.createPeriodoC.run(request);

    if (response is Success<PeriodoContableResponse>) {
      final PeriodoContableResponse periodoResponse = response.data;

      final PeriodoContableData? periodoCreado = periodoResponse.data;

      if (periodoCreado != null) {
        final List<PeriodoContableData> nuevosPeriodos =
            List<PeriodoContableData>.from(state.periodos);

        nuevosPeriodos.insert(0, periodoCreado);

        emit(
          state.copyWith(actionResponse: response, periodos: nuevosPeriodos),
        );

        return;
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

    final PeriodoContableRequest request = PeriodoContableRequest(
      idEmpresa: event.idEmpresa,
      nombre: event.nombre,
      anio: event.anio,
      mes: event.mes,
      fechaInicio: event.fechaInicio,
      fechaFin: event.fechaFin,
      saldoInicial: event.saldoInicial,
      observacion: event.observacion,
    );

    final Resource<PeriodoContableResponse> response =
        await periodoContableUsesCases.updatePeriodoC.run(
          idPeriodo: event.idPeriodo,
          idEmpresa: event.idEmpresa,
          request: request,
        );

    if (response is Success<PeriodoContableResponse>) {
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

        emit(
          state.copyWith(
            actionResponse: response,
            periodos: periodosActualizados,
            periodoSelected: periodoActualizado,
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

    final Resource response = await periodoContableUsesCases.deletePeriodoC.run(
      idPeriodo: event.idPeriodo,
      idEmpresa: event.idEmpresa,
    );

    if (response is Success) {
      final periodosActualizados = state.periodos.where((periodo) {
        return periodo.idPeriodo != event.idPeriodo;
      }).toList();

      final bool selectedWasDeleted =
          state.periodoSelected?.idPeriodo == event.idPeriodo;

      emit(
        state.copyWith(
          actionResponse: response,
          periodos: periodosActualizados,
          clearPeriodoSelected: selectedWasDeleted,
        ),
      );

      return;
    }

    emit(state.copyWith(actionResponse: response));
  }

  // ==========================================================
  // 6. CAMBIAR ESTADO: ABRIR O CERRAR PERÍODO
  // ==========================================================
  Future<void> _onChangeEstadoPeriodoContable(
    ChangeEstadoPeriodoContableEvent event,
    Emitter<PeriodoContableState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading()));

    final Resource<PeriodoContableResponse> response =
        await periodoContableUsesCases.changeEstadoPeriodoC.run(
          idPeriodo: event.idPeriodo,
          idEmpresa: event.idEmpresa,
          estado: event.estado,
        );

    if (response is Success<PeriodoContableResponse>) {
      final PeriodoContableData? periodoActualizado = response.data.data;

      if (periodoActualizado == null) {
        emit(state.copyWith(actionResponse: response));

        return;
      }

      final List<PeriodoContableData> periodosActualizados = state.periodos.map(
        (periodo) {
          return periodo.idPeriodo == periodoActualizado.idPeriodo
              ? periodoActualizado
              : periodo;
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

  // ==========================================================
  // EVITAR DUPLICADOS EN LA PAGINACIÓN
  // ==========================================================
  List<PeriodoContableData> _mergePeriodos({
    required List<PeriodoContableData> actuales,
    required List<PeriodoContableData> nuevos,
  }) {
    final Map<int, PeriodoContableData> periodosMap = {};

    for (final periodo in actuales) {
      periodosMap[periodo.idPeriodo] = periodo;
    }

    for (final periodo in nuevos) {
      periodosMap[periodo.idPeriodo] = periodo;
    }

    return periodosMap.values.toList();
  }
}
