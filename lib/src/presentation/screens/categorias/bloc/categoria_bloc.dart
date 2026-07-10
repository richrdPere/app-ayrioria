import 'package:app_aryoria/src/data/models/categoria/categoria_paginated.dart';
import 'package:app_aryoria/src/domain/use_cases/categoria/CategoriaUsesCases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

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
    on<ResetCategoriaStateEvent>(_onResetCategoriaState);
  }

  Future<void> _onCreateCategoria(
    CreateCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await categoriaUsesCases.createCategoria.run(
      event.request,
    );

    emit(state.copyWith(actionResponse: response));
  }

  Future<void> _onGetCategorias(
    GetCategoriasEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    final isFirstPage = event.page == 1;

    emit(state.copyWith(isLoading: true));

    final response = await categoriaUsesCases.getCategorias.run(
      page: event.page,
      limit: event.limit,
      idEmpresa: event.idEmpresa,
      search: event.search,
    );

    if (response is Success<CategoriaPaginatedResponse>) {
      final paginatedResponse = response.data;

      final nuevasCategorias = isFirstPage
          ? paginatedResponse.data
          : [...state.categorias, ...paginatedResponse.data];

      emit(
        state.copyWith(
          categoriaResponse: response,
          categorias: nuevasCategorias,
          page: paginatedResponse.pagination.page,
          limit: paginatedResponse.pagination.limit,
          totalPages: paginatedResponse.pagination.totalPages,
          total: paginatedResponse.pagination.total,
          hasMore:
              paginatedResponse.pagination.page <
              paginatedResponse.pagination.totalPages,
          isLoading: false,
          isLoadingMore: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          categoriaResponse: response,
          isLoading: false,
          isLoadingMore: false,
        ),
      );
    }
  }

  Future<void> _onGetCategoriaById(
    GetCategoriaByIdEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await categoriaUsesCases.getCategoriaById.run(
      event.idCategoria,
    );

    emit(state.copyWith(detailResponse: response));
  }

  Future<void> _onGetCategoriasByTipo(
    GetCategoriasByTipoEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    final isFirstPage = event.page == 1;

    emit(state.copyWith(isLoading: true));

    final response = await categoriaUsesCases.getCategoriaByTipo.run(
      tipo: event.tipo,
      page: event.page,
      limit: event.limit,
      search: event.search,
    );

    if (response is Success) {
      final data = response.data;

      final nuevasCategorias = isFirstPage
          ? data.data
          : [...state.categorias, ...data.data];

      emit(
        state.copyWith(
          categoriaResponse: response.data,
          categorias: nuevasCategorias,
          page: data.pagination.page,
          limit: data.pagination.limit,
          totalPages: data.pagination.totalPages,
          total: data.pagination.total,
          search: event.search,
          hasMore: data.pagination.page < data.pagination.totalPages,
          isLoading: false,
          isLoadingMore: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          categoriaResponse: response,
          isLoading: false,
          isLoadingMore: false,
        ),
      );
    }
  }

  Future<void> _onUpdateCategoria(
    UpdateCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await categoriaUsesCases.updateCategoria.run(
      idCategoria: event.idCategoria,
      request: event.request,
    );

    emit(state.copyWith(actionResponse: response));
  }

  Future<void> _onDeleteCategoria(
    DeleteCategoriaEvent event,
    Emitter<CategoriaState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await categoriaUsesCases.deleteCategoria.run(
      event.idCategoria,
    );

    emit(state.copyWith(isLoading: false, actionResponse: response));
  }

  void _onResetCategoriaState(
    ResetCategoriaStateEvent event,
    Emitter<CategoriaState> emit,
  ) {
    emit(const CategoriaState());
  }
}
