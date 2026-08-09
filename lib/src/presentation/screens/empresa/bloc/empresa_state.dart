import 'package:app_aryoria/src/data/models/common/api_response.dart';

import 'package:app_aryoria/src/data/models/empresa/empresa_data.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_paginated.dart';

import 'package:app_aryoria/src/data/models/login/login_data_model.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:equatable/equatable.dart';

class EmpresaState extends Equatable {
  final bool isLoading;

  // 1. CREAR EMPRESA
  final Resource<ApiResponse<EmpresaData>>? createResponse;

  // 2. OBTENER EMPRESAS
  final Resource<ApiResponse<EmpresaPaginated>>? empresasResponse;

  // 3. OBTENER EMPRESA POR ID
  final Resource<ApiResponse<EmpresaData>>? empresaResponse;

  // 4. ACTUALIZAR EMPRESA
  final Resource<ApiResponse<EmpresaData>>? updateResponse;

  // 5. ELIMINAR EMPRESA
  final Resource<ApiResponse<void>>? deleteResponse;

  // 6. SELECCIONAR EMPRESA
  final Resource<ApiResponse<LoginDataModel>>? selectResponse;

  const EmpresaState({
    this.isLoading = false,
    this.createResponse,
    this.empresasResponse,
    this.empresaResponse,
    this.updateResponse,
    this.deleteResponse,
    this.selectResponse,
  });

  factory EmpresaState.initial() {
    return const EmpresaState();
  }

  EmpresaState copyWith({
    bool? isLoading,
    Resource<ApiResponse<EmpresaData>>? createResponse,
    Resource<ApiResponse<EmpresaPaginated>>? empresasResponse,
    Resource<ApiResponse<EmpresaData>>? empresaResponse,
    Resource<ApiResponse<EmpresaData>>? updateResponse,
    Resource<ApiResponse<void>>? deleteResponse,
    Resource<ApiResponse<LoginDataModel>>? selectResponse,
  }) {
    return EmpresaState(
      isLoading: isLoading ?? this.isLoading,
      createResponse: createResponse ?? this.createResponse,
      empresasResponse: empresasResponse ?? this.empresasResponse,
      empresaResponse: empresaResponse ?? this.empresaResponse,
      updateResponse: updateResponse ?? this.updateResponse,
      deleteResponse: deleteResponse ?? this.deleteResponse,
      selectResponse: selectResponse ?? this.selectResponse,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    createResponse,
    empresasResponse,
    empresaResponse,
    updateResponse,
    selectResponse,
    deleteResponse,
  ];
}
