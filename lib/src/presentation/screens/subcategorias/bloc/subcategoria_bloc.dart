import 'package:flutter_bloc/flutter_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_data.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_paginated.dart';

// Uses Cases
import 'package:app_aryoria/src/domain/use_cases/sub_categoria/SubcategoriaUsesCases.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Bloc
import 'subcategoria_event.dart';
import 'subcategoria_state.dart';

class SubcategoriaBloc extends Bloc<SubcategoriaEvent, SubcategoriaState> {
  final SubcategoriaUsesCases subcategoriaUsesCases;

  SubcategoriaBloc(this.subcategoriaUsesCases)
    : super(const SubcategoriaState()) {
    // ========================================================
    // LISTADO
    // ========================================================
    on<GetSubcategoriasPaginatedEvent>(_onGetSubcategoriasPaginated);

    // ========================================================
    // LISTAS AUXILIARES
    // ========================================================
    on<GetSubcategoriasByCategoriaEvent>(_onGetSubcategoriasByCategoria);

    on<GetSubcategoriasByTipoEvent>(_onGetSubcategoriasByTipo);

    // ========================================================
    // DETALLE
    // ========================================================
    on<GetSubcategoriaByIdEvent>(_onGetSubcategoriaById);

    // ========================================================
    // ACCIONES
    // ========================================================
    on<CreateSubcategoriaEvent>(_onCreateSubcategoria);

    on<UpdateSubcategoriaEvent>(_onUpdateSubcategoria);

    on<ChangeSubcategoriaEstadoEvent>(_onChangeSubcategoriaEstado);

    on<DeleteSubcategoriaEvent>(_onDeleteSubcategoria);

    // ========================================================
    // CLEAR
    // ========================================================
    on<ClearSubcategoriaActionResponseEvent>(_onClearActionResponse);

    on<ClearSubcategoriaDetailEvent>(_onClearDetail);

    on<ClearSubcategoriaAuxiliaryListsEvent>(_onClearAuxiliaryLists);

    // ========================================================
    // RESET
    // ========================================================
    on<ResetSubcategoriaStateEvent>(_onResetState);
  }

  // ==========================================================
  // 1. OBTENER SUBCATEGORÍAS PAGINADAS
  // ==========================================================
  Future<void> _onGetSubcategoriasPaginated(
    GetSubcategoriasPaginatedEvent event,
    Emitter<SubcategoriaState> emit,
  ) async {
    final bool isFirstPage = event.queryParams.page == 1;

    // ========================================================
    // LOADING
    // ========================================================
    if (isFirstPage || event.refresh) {
      emit(
        state.copyWith(
          response: Loading(),
          subcategorias: const [],
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
    final Resource<ApiResponse<SubcategoriaPaginated>> response =
        await subcategoriaUsesCases.getSubcategoriasPaginated.run(
          idEmpresa: event.idEmpresa,
          queryParams: event.queryParams,
        );

    // ========================================================
    // SUCCESS
    // ========================================================
    if (response is Success<ApiResponse<SubcategoriaPaginated>>) {
      final SubcategoriaPaginated? paginated = response.data.data;

      if (paginated == null) {
        emit(
          state.copyWith(
            response: response,
            subcategorias: const [],
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

          // Como estamos usando paginación tradicional,
          // reemplazamos la página actual.
          subcategorias: paginated.items,

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
  // 2. OBTENER SUBCATEGORÍAS POR CATEGORÍA
  // ==========================================================
  Future<void> _onGetSubcategoriasByCategoria(
    GetSubcategoriasByCategoriaEvent event,
    Emitter<SubcategoriaState> emit,
  ) async {
    emit(
      state.copyWith(
        byCategoriaResponse: Loading(),
        clearSubcategoriasByCategoria: true,
      ),
    );

    final Resource<ApiResponse<List<SubcategoriaData>>> response =
        await subcategoriaUsesCases.getSubcategoriaByCategoria.run(
          idEmpresa: event.idEmpresa,
          idCategoria: event.idCategoria,
        );

    if (response is Success<ApiResponse<List<SubcategoriaData>>>) {
      final List<SubcategoriaData> items =
          response.data.data ?? <SubcategoriaData>[];

      emit(
        state.copyWith(
          byCategoriaResponse: response,
          subcategoriasByCategoria: items,
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        byCategoriaResponse: response,
        clearSubcategoriasByCategoria: true,
      ),
    );
  }

  // ==========================================================
  // 3. OBTENER SUBCATEGORÍAS POR TIPO
  // ==========================================================
  Future<void> _onGetSubcategoriasByTipo(
    GetSubcategoriasByTipoEvent event,
    Emitter<SubcategoriaState> emit,
  ) async {
    emit(
      state.copyWith(byTipoResponse: Loading(), clearSubcategoriasByTipo: true),
    );

    final Resource<ApiResponse<List<SubcategoriaData>>> response =
        await subcategoriaUsesCases.getSubcategoriasByTipo.run(
          idEmpresa: event.idEmpresa,
          tipo: event.tipo,
        );

    if (response is Success<ApiResponse<List<SubcategoriaData>>>) {
      final List<SubcategoriaData> items =
          response.data.data ?? <SubcategoriaData>[];

      emit(
        state.copyWith(byTipoResponse: response, subcategoriasByTipo: items),
      );

      return;
    }

    emit(
      state.copyWith(byTipoResponse: response, clearSubcategoriasByTipo: true),
    );
  }

  // ==========================================================
  // 4. OBTENER SUBCATEGORÍA POR ID
  // ==========================================================
  Future<void> _onGetSubcategoriaById(
    GetSubcategoriaByIdEvent event,
    Emitter<SubcategoriaState> emit,
  ) async {
    emit(
      state.copyWith(
        detailResponse: Loading(),
        clearSubcategoriaSelected: true,
      ),
    );

    final Resource<ApiResponse<SubcategoriaData>> response =
        await subcategoriaUsesCases.getSubcategoriaById.run(
          idEmpresa: event.idEmpresa,
          idSubcategoria: event.idSubcategoria,
        );

    if (response is Success<ApiResponse<SubcategoriaData>>) {
      final SubcategoriaData? subcategoria = response.data.data;

      emit(
        state.copyWith(
          detailResponse: response,
          subcategoriaSelected: subcategoria,
          clearSubcategoriaSelected: subcategoria == null,
        ),
      );

      return;
    }

    emit(
      state.copyWith(detailResponse: response, clearSubcategoriaSelected: true),
    );
  }

  // ==========================================================
  // 5. CREAR SUBCATEGORÍA
  // ==========================================================
  Future<void> _onCreateSubcategoria(
    CreateSubcategoriaEvent event,
    Emitter<SubcategoriaState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading()));

    final Resource<ApiResponse<SubcategoriaData>> response =
        await subcategoriaUsesCases.createSubcategoria.run(
          idEmpresa: event.idEmpresa,
          request: event.request,
        );

    if (response is Success<ApiResponse<SubcategoriaData>>) {
      final SubcategoriaData? creada = response.data.data;

      if (creada != null && state.page == 1) {
        final List<SubcategoriaData> actualizadas = [
          creada,
          ...state.subcategorias.where(
            (item) => item.idSubcategoria != creada.idSubcategoria,
          ),
        ];

        final List<SubcategoriaData> limitadas =
            actualizadas.length > state.limit
            ? actualizadas.take(state.limit).toList()
            : actualizadas;

        final int nuevoTotal = state.total + 1;

        final int nuevosTotalPages = state.limit > 0
            ? (nuevoTotal / state.limit).ceil()
            : 0;

        emit(
          state.copyWith(
            actionResponse: response,
            subcategorias: limitadas,
            total: nuevoTotal,
            totalPages: nuevosTotalPages,
            hasNextPage: state.page < nuevosTotalPages,
            hasPreviousPage: state.page > 1,
          ),
        );

        return;
      }
    }

    emit(state.copyWith(actionResponse: response));
  }

  // ==========================================================
  // 6. ACTUALIZAR SUBCATEGORÍA
  // ==========================================================
  Future<void> _onUpdateSubcategoria(
    UpdateSubcategoriaEvent event,
    Emitter<SubcategoriaState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading()));

    final Resource<ApiResponse<SubcategoriaData>> response =
        await subcategoriaUsesCases.updateSubcategoria.run(
          idEmpresa: event.idEmpresa,
          idSubcategoria: event.idSubcategoria,
          request: event.request,
        );

    if (response is Success<ApiResponse<SubcategoriaData>>) {
      final SubcategoriaData? actualizada = response.data.data;

      if (actualizada != null) {
        final List<SubcategoriaData> subcategoriasActualizadas = state
            .subcategorias
            .map((item) {
              if (item.idSubcategoria == actualizada.idSubcategoria) {
                return actualizada;
              }

              return item;
            })
            .toList();

        final List<SubcategoriaData> byCategoriaActualizadas = state
            .subcategoriasByCategoria
            .map((item) {
              if (item.idSubcategoria == actualizada.idSubcategoria) {
                return actualizada;
              }

              return item;
            })
            .toList();

        final List<SubcategoriaData> byTipoActualizadas = state
            .subcategoriasByTipo
            .map((item) {
              if (item.idSubcategoria == actualizada.idSubcategoria) {
                return actualizada;
              }

              return item;
            })
            .toList();

        final bool isSelected =
            state.subcategoriaSelected?.idSubcategoria ==
            actualizada.idSubcategoria;

        emit(
          state.copyWith(
            actionResponse: response,
            subcategorias: subcategoriasActualizadas,
            subcategoriasByCategoria: byCategoriaActualizadas,
            subcategoriasByTipo: byTipoActualizadas,
            subcategoriaSelected: isSelected ? actualizada : null,
          ),
        );

        return;
      }
    }

    emit(state.copyWith(actionResponse: response));
  }

  // ==========================================================
  // 7. CAMBIAR ESTADO
  // ==========================================================
  Future<void> _onChangeSubcategoriaEstado(
    ChangeSubcategoriaEstadoEvent event,
    Emitter<SubcategoriaState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading()));

    final Resource<ApiResponse<SubcategoriaData>> response =
        await subcategoriaUsesCases.changeSubcategoriaEstado.run(
          idEmpresa: event.idEmpresa,
          idSubcategoria: event.idSubcategoria,
          estado: event.estado,
        );

    if (response is Success<ApiResponse<SubcategoriaData>>) {
      final SubcategoriaData? actualizada = response.data.data;

      if (actualizada != null) {
        final List<SubcategoriaData> subcategoriasActualizadas = state
            .subcategorias
            .map((item) {
              if (item.idSubcategoria == actualizada.idSubcategoria) {
                return actualizada;
              }

              return item;
            })
            .toList();

        final List<SubcategoriaData> byCategoriaActualizadas = state
            .subcategoriasByCategoria
            .map((item) {
              if (item.idSubcategoria == actualizada.idSubcategoria) {
                return actualizada;
              }

              return item;
            })
            .toList();

        final List<SubcategoriaData> byTipoActualizadas = state
            .subcategoriasByTipo
            .map((item) {
              if (item.idSubcategoria == actualizada.idSubcategoria) {
                return actualizada;
              }

              return item;
            })
            .toList();

        final bool isSelected =
            state.subcategoriaSelected?.idSubcategoria ==
            actualizada.idSubcategoria;

        emit(
          state.copyWith(
            actionResponse: response,
            subcategorias: subcategoriasActualizadas,
            subcategoriasByCategoria: byCategoriaActualizadas,
            subcategoriasByTipo: byTipoActualizadas,
            subcategoriaSelected: isSelected ? actualizada : null,
          ),
        );

        return;
      }
    }

    emit(state.copyWith(actionResponse: response));
  }

  // ==========================================================
  // 8. ELIMINAR SUBCATEGORÍA
  // ==========================================================
  Future<void> _onDeleteSubcategoria(
    DeleteSubcategoriaEvent event,
    Emitter<SubcategoriaState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading()));

    final Resource<ApiResponse<void>> response = await subcategoriaUsesCases
        .deleteSubcategoria
        .run(idEmpresa: event.idEmpresa, idSubcategoria: event.idSubcategoria);

    if (response is Success<ApiResponse<void>>) {
      final List<SubcategoriaData> subcategoriasActualizadas = state
          .subcategorias
          .where((item) => item.idSubcategoria != event.idSubcategoria)
          .toList();

      final List<SubcategoriaData> byCategoriaActualizadas = state
          .subcategoriasByCategoria
          .where((item) => item.idSubcategoria != event.idSubcategoria)
          .toList();

      final List<SubcategoriaData> byTipoActualizadas = state
          .subcategoriasByTipo
          .where((item) => item.idSubcategoria != event.idSubcategoria)
          .toList();

      final bool selectedWasDeleted =
          state.subcategoriaSelected?.idSubcategoria == event.idSubcategoria;

      final int nuevoTotal = state.total > 0 ? state.total - 1 : 0;

      final int nuevosTotalPages = state.limit > 0
          ? (nuevoTotal / state.limit).ceil()
          : 0;

      emit(
        state.copyWith(
          actionResponse: response,
          subcategorias: subcategoriasActualizadas,
          subcategoriasByCategoria: byCategoriaActualizadas,
          subcategoriasByTipo: byTipoActualizadas,
          total: nuevoTotal,
          totalPages: nuevosTotalPages,
          hasNextPage: state.page < nuevosTotalPages,
          hasPreviousPage: state.page > 1,
          clearSubcategoriaSelected: selectedWasDeleted,
        ),
      );

      return;
    }

    emit(state.copyWith(actionResponse: response));
  }

  // ==========================================================
  // 9. LIMPIAR ACTION RESPONSE
  // ==========================================================
  void _onClearActionResponse(
    ClearSubcategoriaActionResponseEvent event,
    Emitter<SubcategoriaState> emit,
  ) {
    emit(state.copyWith(clearActionResponse: true));
  }

  // ==========================================================
  // 10. LIMPIAR DETALLE
  // ==========================================================
  void _onClearDetail(
    ClearSubcategoriaDetailEvent event,
    Emitter<SubcategoriaState> emit,
  ) {
    emit(
      state.copyWith(
        clearDetailResponse: true,
        clearSubcategoriaSelected: true,
      ),
    );
  }

  // ==========================================================
  // 11. LIMPIAR LISTAS AUXILIARES
  // ==========================================================
  void _onClearAuxiliaryLists(
    ClearSubcategoriaAuxiliaryListsEvent event,
    Emitter<SubcategoriaState> emit,
  ) {
    emit(
      state.copyWith(
        clearByCategoriaResponse: true,
        clearByTipoResponse: true,
        clearSubcategoriasByCategoria: true,
        clearSubcategoriasByTipo: true,
      ),
    );
  }

  // ==========================================================
  // 12. RESET GENERAL
  // ==========================================================
  void _onResetState(
    ResetSubcategoriaStateEvent event,
    Emitter<SubcategoriaState> emit,
  ) {
    emit(const SubcategoriaState());
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// // Uses Cases
// import 'package:app_aryoria/src/domain/use_cases/sub_categoria/SubcategoriaUsesCases.dart';

// // Resource
// import 'package:app_aryoria/src/domain/utils/Resource.dart';

// // Bloc
// import 'subcategoria_event.dart';
// import 'subcategoria_state.dart';

// class SubcategoriaBloc extends Bloc<SubcategoriaEvent, SubcategoriaState> {
//   final SubcategoriaUsesCases subcategoriaUsesCases;

//   SubcategoriaBloc(this.subcategoriaUsesCases)
//     : super(const SubcategoriaState()) {
//     // 1.- Paginado
//     on<GetSubcategoriasPaginatedEvent>(_onGetSubcategoriasPaginated);

//     // 2.- Refresh
//     on<RefreshSubcategoriasEvent>(_onRefreshSubcategorias);

//     // 3.- Por categoria
//     on<GetSubcategoriasByCategoriaEvent>(_onGetSubcategoriasByCategoria);

//     // 4.- Por tipo
//     on<GetSubcategoriasByTipoEvent>(_onGetSubcategoriasByTipo);

//     // 5.- Por ID
//     on<GetSubcategoriaByIdEvent>(_onGetSubcategoriaById);

//     // 6.- Crear
//     on<CreateSubcategoriaEvent>(_onCreateSubcategoria);

//     // 7.- Actualizar
//     on<UpdateSubcategoriaEvent>(_onUpdateSubcategoria);

//     // 8.- Cambiar estado
//     on<ChangeSubcategoriaEstadoEvent>(_onChangeSubcategoriaEstado);

//     // 9.- Eliminar
//     on<DeleteSubcategoriaEvent>(_onDeleteSubcategoria);

//     // 10.- Limpiar action response
//     on<ClearSubcategoriaActionResponseEvent>(_onClearActionResponse);

//     // 11.- Limpiar detalle
//     on<ClearSubcategoriaDetailEvent>(_onClearDetail);

//     // 12.- Limpiar listas auxiliares
//     on<ClearSubcategoriaAuxiliaryListsEvent>(_onClearAuxiliaryLists);
//   }

//   // ***************************************************************************
//   // 1.- Obtener subcategorias paginadas
//   // ***************************************************************************
//   Future<void> _onGetSubcategoriasPaginated(
//     GetSubcategoriasPaginatedEvent event,
//     Emitter<SubcategoriaState> emit,
//   ) async {
//     emit(state.copyWith(paginatedResponse: Loading()));

//     final response = await subcategoriaUsesCases.getSubcategoriasPaginated.run(
//       idEmpresa: event.idEmpresa,
//       queryParams: event.queryParams,
//     );

//     debugPrint("response BLOC para paginado: ${response}");

//     emit(state.copyWith(paginatedResponse: response));
//   }

//   // ***************************************************************************
//   // 2.- Refrescar subcategorias
//   // ***************************************************************************
//   Future<void> _onRefreshSubcategorias(
//     RefreshSubcategoriasEvent event,
//     Emitter<SubcategoriaState> emit,
//   ) async {
//     final response = await subcategoriaUsesCases.getSubcategoriasPaginated.run(
//       idEmpresa: event.idEmpresa,
//       queryParams: event.queryParams,
//     );

//     emit(state.copyWith(paginatedResponse: response));
//   }

//   // ***************************************************************************
//   // 3.- Obtener subcategorias por categoria
//   // ***************************************************************************
//   Future<void> _onGetSubcategoriasByCategoria(
//     GetSubcategoriasByCategoriaEvent event,
//     Emitter<SubcategoriaState> emit,
//   ) async {
//     emit(state.copyWith(byCategoriaResponse: Loading()));

//     final response = await subcategoriaUsesCases.getSubcategoriaByCategoria.run(
//       idEmpresa: event.idEmpresa,
//       idCategoria: event.idCategoria,
//     );

//     emit(state.copyWith(byCategoriaResponse: response));
//   }

//   // ***************************************************************************
//   // 4.- Obtener subcategorias por tipo
//   // ***************************************************************************
//   Future<void> _onGetSubcategoriasByTipo(
//     GetSubcategoriasByTipoEvent event,
//     Emitter<SubcategoriaState> emit,
//   ) async {
//     emit(state.copyWith(byTipoResponse: Loading()));

//     final response = await subcategoriaUsesCases.getSubcategoriasByTipo.run(
//       idEmpresa: event.idEmpresa,
//       tipo: event.tipo,
//     );

//     emit(state.copyWith(byTipoResponse: response));
//   }

//   // ***************************************************************************
//   // 5.- Obtener subcategoria por ID
//   // ***************************************************************************
//   Future<void> _onGetSubcategoriaById(
//     GetSubcategoriaByIdEvent event,
//     Emitter<SubcategoriaState> emit,
//   ) async {
//     emit(state.copyWith(detailResponse: Loading()));

//     final response = await subcategoriaUsesCases.getSubcategoriaById.run(
//       idEmpresa: event.idEmpresa,
//       idSubcategoria: event.idSubcategoria,
//     );

//     emit(state.copyWith(detailResponse: response));
//   }

//   // ***************************************************************************
//   // 6.- Crear subcategoria
//   // ***************************************************************************
//   Future<void> _onCreateSubcategoria(
//     CreateSubcategoriaEvent event,
//     Emitter<SubcategoriaState> emit,
//   ) async {
//     emit(state.copyWith(actionResponse: Loading(), clearDeleteResponse: true));

//     final response = await subcategoriaUsesCases.createSubcategoria.run(
//       idEmpresa: event.idEmpresa,
//       request: event.request,
//     );

//     emit(state.copyWith(actionResponse: response));
//   }

//   // ***************************************************************************
//   // 7.- Actualizar subcategoria
//   // ***************************************************************************
//   Future<void> _onUpdateSubcategoria(
//     UpdateSubcategoriaEvent event,
//     Emitter<SubcategoriaState> emit,
//   ) async {
//     emit(state.copyWith(actionResponse: Loading(), clearDeleteResponse: true));

//     final response = await subcategoriaUsesCases.updateSubcategoria.run(
//       idEmpresa: event.idEmpresa,
//       idSubcategoria: event.idSubcategoria,
//       request: event.request,
//     );

//     emit(state.copyWith(actionResponse: response));
//   }

//   // ***************************************************************************
//   // 8.- Cambiar estado
//   // ***************************************************************************
//   Future<void> _onChangeSubcategoriaEstado(
//     ChangeSubcategoriaEstadoEvent event,
//     Emitter<SubcategoriaState> emit,
//   ) async {
//     emit(state.copyWith(actionResponse: Loading(), clearDeleteResponse: true));

//     final response = await subcategoriaUsesCases.changeSubcategoriaEstado.run(
//       idEmpresa: event.idEmpresa,
//       idSubcategoria: event.idSubcategoria,
//       estado: event.estado,
//     );

//     emit(state.copyWith(actionResponse: response));
//   }

//   // ***************************************************************************
//   // 9.- Eliminar subcategoria
//   // ***************************************************************************
//   Future<void> _onDeleteSubcategoria(
//     DeleteSubcategoriaEvent event,
//     Emitter<SubcategoriaState> emit,
//   ) async {
//     emit(state.copyWith(deleteResponse: Loading(), clearActionResponse: true));

//     final response = await subcategoriaUsesCases.deleteSubcategoria.run(
//       idEmpresa: event.idEmpresa,
//       idSubcategoria: event.idSubcategoria,
//     );

//     emit(state.copyWith(deleteResponse: response));
//   }

//   // ***************************************************************************
//   // 10.- Limpiar respuesta de acciones
//   // ***************************************************************************
//   void _onClearActionResponse(
//     ClearSubcategoriaActionResponseEvent event,
//     Emitter<SubcategoriaState> emit,
//   ) {
//     emit(state.copyWith(clearActionResponse: true, clearDeleteResponse: true));
//   }

//   // ***************************************************************************
//   // 11.- Limpiar detalle
//   // ***************************************************************************
//   void _onClearDetail(
//     ClearSubcategoriaDetailEvent event,
//     Emitter<SubcategoriaState> emit,
//   ) {
//     emit(state.copyWith(clearDetailResponse: true));
//   }

//   // ***************************************************************************
//   // 12.- Limpiar listas auxiliares
//   // ***************************************************************************
//   void _onClearAuxiliaryLists(
//     ClearSubcategoriaAuxiliaryListsEvent event,
//     Emitter<SubcategoriaState> emit,
//   ) {
//     emit(
//       state.copyWith(clearByCategoriaResponse: true, clearByTipoResponse: true),
//     );
//   }
// }
