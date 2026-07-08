import 'package:app_aryoria/src/data/models/common/base_response.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_paginated.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_response.dart';
import 'package:app_aryoria/src/data/models/login/auth_response.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class EmpresaState {
  final bool isLoading;

  final Resource<EmpresaResponse>? createResponse;

  final Resource<EmpresaPaginatedResponse>? empresasResponse;

  final Resource<EmpresaResponse>? empresaResponse;

  final Resource<EmpresaResponse>? updateResponse;

  final Resource<BaseResponse>? deleteResponse;

  final Resource<AuthResponse>? selectResponse;

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
    Resource<EmpresaResponse>? createResponse,
    Resource<EmpresaPaginatedResponse>? empresasResponse,
    Resource<EmpresaResponse>? empresaResponse,
    Resource<EmpresaResponse>? updateResponse,
    Resource<BaseResponse>? deleteResponse,
    Resource<AuthResponse>? selectResponse,
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
}
