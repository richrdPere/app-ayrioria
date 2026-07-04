import 'package:flutter_bloc/flutter_bloc.dart';

import 'empresa_event.dart';
import 'empresa_state.dart';

import 'package:app_aryoria/src/domain/use_cases/empresa/EmpresaUseCases.dart';

class EmpresaBloc extends Bloc<EmpresaEvent, EmpresaState> {
  final EmpresaUseCases empresaUseCases;

  EmpresaBloc(this.empresaUseCases) : super(EmpresaState.initial()) {
    on<CreateEmpresaEvent>(_createEmpresa);
    on<GetEmpresasEvent>(_getEmpresas);
    on<GetEmpresaByIdEvent>(_getEmpresaById);
    on<UpdateEmpresaEvent>(_updateEmpresa);
    on<DeleteEmpresaEvent>(_deleteEmpresa);
    on<EmpresaResetEvent>(_reset);
  }

  //-------------------------------------------------------
  // Crear
  //-------------------------------------------------------
  Future<void> _createEmpresa(
    CreateEmpresaEvent event,
    Emitter<EmpresaState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await empresaUseCases.createEmpresa.run(event.request);

    emit(state.copyWith(isLoading: false, createResponse: response));
  }

  //-------------------------------------------------------
  // Obtener empresas
  //-------------------------------------------------------
  Future<void> _getEmpresas(
    GetEmpresasEvent event,
    Emitter<EmpresaState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await empresaUseCases.getEmpresas.run(
      page: event.page,
      limit: event.limit,
      search: event.search,
    );

    emit(state.copyWith(isLoading: false, empresasResponse: response));
  }

  //-------------------------------------------------------
  // Obtener empresa por id
  //-------------------------------------------------------
  Future<void> _getEmpresaById(
    GetEmpresaByIdEvent event,
    Emitter<EmpresaState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await empresaUseCases.getEmpresaById.run(event.idEmpresa);

    emit(state.copyWith(isLoading: false, empresaResponse: response));
  }

  //-------------------------------------------------------
  // Actualizar
  //-------------------------------------------------------
  Future<void> _updateEmpresa(
    UpdateEmpresaEvent event,
    Emitter<EmpresaState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await empresaUseCases.updateEmpresa.run(
      idEmpresa: event.idEmpresa,
      request: event.request,
    );

    emit(state.copyWith(isLoading: false, updateResponse: response));
  }

  //-------------------------------------------------------
  // Eliminar
  //-------------------------------------------------------
  Future<void> _deleteEmpresa(
    DeleteEmpresaEvent event,
    Emitter<EmpresaState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await empresaUseCases.deleteEmpresa.run(event.idEmpresa);

    emit(state.copyWith(isLoading: false, deleteResponse: response));
  }

  //-------------------------------------------------------
  // Reset
  //-------------------------------------------------------
  void _reset(EmpresaResetEvent event, Emitter<EmpresaState> emit) {
    emit(EmpresaState.initial());
  }
}
