import 'package:flutter_bloc/flutter_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_paginated.dart';

// Uses Cases
import 'package:app_aryoria/src/domain/use_cases/categoria/CategoriaUsesCases.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Bloc
import 'categoria_event.dart';
import 'categoria_state.dart';

class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final CategoriaUsesCases categoriaUsesCases;

  CategoriaBloc(this.categoriaUsesCases) : super(const CategoriaState()) {
    on<CreateCategoriaEvent>(_onCreateCategoria);
    on<GetCategoriasEvent>(_onGetCategorias);
    on<GetCategoriaByIdEvent>(_onGetCategoriaById);
    on<GetCategoriasByTipoEvent>(_onGetCategoriasByTipo);
    on<UpdateCategoriaEvent>(_onUpdateCategoria);
    on<DeleteCategoriaEvent>(_onDeleteCategoria);

    on<ClearCategoriaActionResponseEvent>(_onClearActionResponse);

    on<ClearCategoriaSelectedEvent>(_onClearCategoriaSelected);

    on<ResetCategoriaStateEvent>(_onResetCategoriaState);
  }

  // ==========================================================
  // 1. CREAR CATEGORÍA
  // ==========================================================
  Future<void> _onCreateCategoria(
    CreateCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading()));

    final Resource<ApiResponse<CategoriaData>> response =
        await categoriaUsesCases.createCategoria.run(event.request);

    if (response is Success<ApiResponse<CategoriaData>>) {
      final CategoriaData? categoriaCreada = response.data.data;

      if (categoriaCreada != null) {
        if (state.page == 1) {
          final List<CategoriaData> categoriasActualizadas = [
            categoriaCreada,
            ...state.categorias.where(
              (categoria) =>
                  categoria.idCategoria != categoriaCreada.idCategoria,
            ),
          ];

          final List<CategoriaData> categoriasLimitadas =
              categoriasActualizadas.length > state.limit
              ? categoriasActualizadas.take(state.limit).toList()
              : categoriasActualizadas;

          final int nuevoTotal = state.total + 1;

          final int nuevosTotalPages = state.limit > 0
              ? (nuevoTotal / state.limit).ceil()
              : 0;

          emit(
            state.copyWith(
              actionResponse: response,
              categorias: categoriasLimitadas,
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
  // 2. LISTAR CATEGORÍAS PAGINADAS
  // ==========================================================
  Future<void> _onGetCategorias(
    GetCategoriasEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    final bool isFirstPage = event.queryParams.page == 1;

    // ========================================================
    // LOADING
    // ========================================================
    if (isFirstPage || event.refresh) {
      emit(
        state.copyWith(
          response: Loading(),
          categorias: const [],
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
    final Resource<ApiResponse<CategoriaPaginated>> response =
        await categoriaUsesCases.getCategorias.run(
          idEmpresa: event.idEmpresa,
          queryParams: event.queryParams,
        );

    // ========================================================
    // SUCCESS
    // ========================================================
    if (response is Success<ApiResponse<CategoriaPaginated>>) {
      final CategoriaPaginated? paginated = response.data.data;

      if (paginated == null) {
        emit(
          state.copyWith(
            response: response,
            categorias: const [],
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

          // Se reemplaza la página actual.
          categorias: paginated.items,

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
  // 3. OBTENER CATEGORÍA POR ID
  // ==========================================================
  Future<void> _onGetCategoriaById(
    GetCategoriaByIdEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    emit(
      state.copyWith(detailResponse: Loading(), clearCategoriaSelected: true),
    );

    final Resource<ApiResponse<CategoriaData>> response =
        await categoriaUsesCases.getCategoriaById.run(
          idCategoria: event.idCategoria,
          idEmpresa: event.idEmpresa,
        );

    if (response is Success<ApiResponse<CategoriaData>>) {
      final CategoriaData? categoria = response.data.data;

      emit(
        state.copyWith(
          detailResponse: response,
          categoriaSelected: categoria,
          clearCategoriaSelected: categoria == null,
        ),
      );

      return;
    }

    emit(
      state.copyWith(detailResponse: response, clearCategoriaSelected: true),
    );
  }

  // ==========================================================
  // 4. OBTENER CATEGORÍAS POR TIPO
  // ==========================================================
  Future<void> _onGetCategoriasByTipo(
    GetCategoriasByTipoEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    emit(state.copyWith(tipoResponse: Loading(), clearCategoriasByTipo: true));

    final Resource<ApiResponse<List<CategoriaData>>> response =
        await categoriaUsesCases.getCategoriaByTipo.run(
          tipo: event.tipo,
          idEmpresa: event.idEmpresa,
        );

    if (response is Success<ApiResponse<List<CategoriaData>>>) {
      final List<CategoriaData> categorias =
          response.data.data ?? <CategoriaData>[];

      emit(
        state.copyWith(tipoResponse: response, categoriasByTipo: categorias),
      );

      return;
    }

    emit(state.copyWith(tipoResponse: response, clearCategoriasByTipo: true));
  }

  // ==========================================================
  // 5. ACTUALIZAR CATEGORÍA
  // ==========================================================
  Future<void> _onUpdateCategoria(
    UpdateCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading()));

    final Resource<ApiResponse<CategoriaData>> response =
        await categoriaUsesCases.updateCategoria.run(
          idCategoria: event.idCategoria,
          idEmpresa: event.idEmpresa,
          request: event.request,
        );

    if (response is Success<ApiResponse<CategoriaData>>) {
      final CategoriaData? categoriaActualizada = response.data.data;

      if (categoriaActualizada != null) {
        final List<CategoriaData> categoriasActualizadas = state.categorias.map(
          (categoria) {
            if (categoria.idCategoria == categoriaActualizada.idCategoria) {
              return categoriaActualizada;
            }

            return categoria;
          },
        ).toList();

        final bool isSelected =
            state.categoriaSelected?.idCategoria ==
            categoriaActualizada.idCategoria;

        emit(
          state.copyWith(
            actionResponse: response,
            categorias: categoriasActualizadas,
            categoriaSelected: isSelected ? categoriaActualizada : null,
          ),
        );

        return;
      }
    }

    emit(state.copyWith(actionResponse: response));
  }

  // ==========================================================
  // 6. ELIMINAR CATEGORÍA
  // ==========================================================
  Future<void> _onDeleteCategoria(
    DeleteCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading()));

    final Resource<ApiResponse<void>> response = await categoriaUsesCases
        .deleteCategoria
        .run(idCategoria: event.idCategoria, idEmpresa: event.idEmpresa);

    if (response is Success<ApiResponse<void>>) {
      final List<CategoriaData> categoriasActualizadas = state.categorias
          .where((categoria) => categoria.idCategoria != event.idCategoria)
          .toList();

      final bool selectedWasDeleted =
          state.categoriaSelected?.idCategoria == event.idCategoria;

      final int nuevoTotal = state.total > 0 ? state.total - 1 : 0;

      final int nuevosTotalPages = state.limit > 0
          ? (nuevoTotal / state.limit).ceil()
          : 0;

      emit(
        state.copyWith(
          actionResponse: response,
          categorias: categoriasActualizadas,
          total: nuevoTotal,
          totalPages: nuevosTotalPages,
          hasNextPage: state.page < nuevosTotalPages,
          hasPreviousPage: state.page > 1,
          clearCategoriaSelected: selectedWasDeleted,
        ),
      );

      return;
    }

    emit(state.copyWith(actionResponse: response));
  }

  // ==========================================================
  // 7. LIMPIAR RESPUESTA DE ACCIÓN
  // ==========================================================
  void _onClearActionResponse(
    ClearCategoriaActionResponseEvent event,
    Emitter<CategoriaState> emit,
  ) {
    emit(state.copyWith(clearActionResponse: true));
  }

  // ==========================================================
  // 8. LIMPIAR CATEGORÍA SELECCIONADA
  // ==========================================================
  void _onClearCategoriaSelected(
    ClearCategoriaSelectedEvent event,
    Emitter<CategoriaState> emit,
  ) {
    emit(
      state.copyWith(clearCategoriaSelected: true, clearDetailResponse: true),
    );
  }

  // ==========================================================
  // 9. RESET GENERAL
  // ==========================================================
  void _onResetCategoriaState(
    ResetCategoriaStateEvent event,
    Emitter<CategoriaState> emit,
  ) {
    emit(const CategoriaState());
  }
}
