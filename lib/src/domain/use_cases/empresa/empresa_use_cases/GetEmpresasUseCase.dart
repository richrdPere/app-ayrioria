import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_paginated.dart';
import 'package:app_aryoria/src/domain/repositories/empresa_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetEmpresasUseCase {
  EmpresaRepository empresaRepository;
  GetEmpresasUseCase(this.empresaRepository);

  Future<Resource<ApiResponse<EmpresaPaginated>>> run({
    int page = 1,
    int limit = 10,
    String search = '',
  }) => empresaRepository.getEmpresas(page: page, limit: limit, search: search);
}
