import 'package:flutter_bloc/flutter_bloc.dart';

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
    // 1.- Paginado
    on<GetSubcategoriasPaginatedEvent>(_onGetSubcategoriasPaginated);

    // 2.- Refresh
    on<RefreshSubcategoriasEvent>(_onRefreshSubcategorias);

    // 3.- Por categoria
    on<GetSubcategoriasByCategoriaEvent>(_onGetSubcategoriasByCategoria);

    // 4.- Por tipo
    on<GetSubcategoriasByTipoEvent>(_onGetSubcategoriasByTipo);

    // 5.- Por ID
    on<GetSubcategoriaByIdEvent>(_onGetSubcategoriaById);

    // 6.- Crear
    on<CreateSubcategoriaEvent>(_onCreateSubcategoria);

    // 7.- Actualizar
    on<UpdateSubcategoriaEvent>(_onUpdateSubcategoria);

    // 8.- Cambiar estado
    on<ChangeSubcategoriaEstadoEvent>(_onChangeSubcategoriaEstado);

    // 9.- Eliminar
    on<DeleteSubcategoriaEvent>(_onDeleteSubcategoria);

    // 10.- Limpiar action response
    on<ClearSubcategoriaActionResponseEvent>(_onClearActionResponse);

    // 11.- Limpiar detalle
    on<ClearSubcategoriaDetailEvent>(_onClearDetail);

    // 12.- Limpiar listas auxiliares
    on<ClearSubcategoriaAuxiliaryListsEvent>(_onClearAuxiliaryLists);
  }

  // ***************************************************************************
  // 1.- Obtener subcategorias paginadas
  // ***************************************************************************
  Future<void> _onGetSubcategoriasPaginated(
    GetSubcategoriasPaginatedEvent event,
    Emitter<SubcategoriaState> emit,
  ) async {
    emit(state.copyWith(paginatedResponse: Loading()));

    final response = await subcategoriaUsesCases.getSubcategoriasPaginated.run(
      idEmpresa: event.idEmpresa,
      queryParams: event.queryParams,
    );

    emit(state.copyWith(paginatedResponse: response));
  }

  // ***************************************************************************
  // 2.- Refrescar subcategorias
  // ***************************************************************************
  Future<void> _onRefreshSubcategorias(
    RefreshSubcategoriasEvent event,
    Emitter<SubcategoriaState> emit,
  ) async {
    final response = await subcategoriaUsesCases.getSubcategoriasPaginated.run(
      idEmpresa: event.idEmpresa,
      queryParams: event.queryParams,
    );

    emit(state.copyWith(paginatedResponse: response));
  }

  // ***************************************************************************
  // 3.- Obtener subcategorias por categoria
  // ***************************************************************************
  Future<void> _onGetSubcategoriasByCategoria(
    GetSubcategoriasByCategoriaEvent event,
    Emitter<SubcategoriaState> emit,
  ) async {
    emit(state.copyWith(byCategoriaResponse: Loading()));

    final response = await subcategoriaUsesCases.getSubcategoriaByCategoria.run(
      idEmpresa: event.idEmpresa,
      idCategoria: event.idCategoria,
    );

    emit(state.copyWith(byCategoriaResponse: response));
  }

  // ***************************************************************************
  // 4.- Obtener subcategorias por tipo
  // ***************************************************************************
  Future<void> _onGetSubcategoriasByTipo(
    GetSubcategoriasByTipoEvent event,
    Emitter<SubcategoriaState> emit,
  ) async {
    emit(state.copyWith(byTipoResponse: Loading()));

    final response = await subcategoriaUsesCases.getSubcategoriasByTipo.run(
      idEmpresa: event.idEmpresa,
      tipo: event.tipo,
    );

    emit(state.copyWith(byTipoResponse: response));
  }

  // ***************************************************************************
  // 5.- Obtener subcategoria por ID
  // ***************************************************************************
  Future<void> _onGetSubcategoriaById(
    GetSubcategoriaByIdEvent event,
    Emitter<SubcategoriaState> emit,
  ) async {
    emit(state.copyWith(detailResponse: Loading()));

    final response = await subcategoriaUsesCases.getSubcategoriaById.run(
      idEmpresa: event.idEmpresa,
      idSubcategoria: event.idSubcategoria,
    );

    emit(state.copyWith(detailResponse: response));
  }

  // ***************************************************************************
  // 6.- Crear subcategoria
  // ***************************************************************************
  Future<void> _onCreateSubcategoria(
    CreateSubcategoriaEvent event,
    Emitter<SubcategoriaState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading(), clearDeleteResponse: true));

    final response = await subcategoriaUsesCases.createSubcategoria.run(
      idEmpresa: event.idEmpresa,
      request: event.request,
    );

    emit(state.copyWith(actionResponse: response));
  }

  // ***************************************************************************
  // 7.- Actualizar subcategoria
  // ***************************************************************************
  Future<void> _onUpdateSubcategoria(
    UpdateSubcategoriaEvent event,
    Emitter<SubcategoriaState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading(), clearDeleteResponse: true));

    final response = await subcategoriaUsesCases.updateSubcategoria.run(
      idEmpresa: event.idEmpresa,
      idSubcategoria: event.idSubcategoria,
      request: event.request,
    );

    emit(state.copyWith(actionResponse: response));
  }

  // ***************************************************************************
  // 8.- Cambiar estado
  // ***************************************************************************
  Future<void> _onChangeSubcategoriaEstado(
    ChangeSubcategoriaEstadoEvent event,
    Emitter<SubcategoriaState> emit,
  ) async {
    emit(state.copyWith(actionResponse: Loading(), clearDeleteResponse: true));

    final response = await subcategoriaUsesCases.changeSubcategoriaEstado.run(
      idEmpresa: event.idEmpresa,
      idSubcategoria: event.idSubcategoria,
      estado: event.estado,
    );

    emit(state.copyWith(actionResponse: response));
  }

  // ***************************************************************************
  // 9.- Eliminar subcategoria
  // ***************************************************************************
  Future<void> _onDeleteSubcategoria(
    DeleteSubcategoriaEvent event,
    Emitter<SubcategoriaState> emit,
  ) async {
    emit(state.copyWith(deleteResponse: Loading(), clearActionResponse: true));

    final response = await subcategoriaUsesCases.deleteSubcategoria.run(
      idEmpresa: event.idEmpresa,
      idSubcategoria: event.idSubcategoria,
    );

    emit(state.copyWith(deleteResponse: response));
  }

  // ***************************************************************************
  // 10.- Limpiar respuesta de acciones
  // ***************************************************************************
  void _onClearActionResponse(
    ClearSubcategoriaActionResponseEvent event,
    Emitter<SubcategoriaState> emit,
  ) {
    emit(state.copyWith(clearActionResponse: true, clearDeleteResponse: true));
  }

  // ***************************************************************************
  // 11.- Limpiar detalle
  // ***************************************************************************
  void _onClearDetail(
    ClearSubcategoriaDetailEvent event,
    Emitter<SubcategoriaState> emit,
  ) {
    emit(state.copyWith(clearDetailResponse: true));
  }

  // ***************************************************************************
  // 12.- Limpiar listas auxiliares
  // ***************************************************************************
  void _onClearAuxiliaryLists(
    ClearSubcategoriaAuxiliaryListsEvent event,
    Emitter<SubcategoriaState> emit,
  ) {
    emit(
      state.copyWith(clearByCategoriaResponse: true, clearByTipoResponse: true),
    );
  }
}
