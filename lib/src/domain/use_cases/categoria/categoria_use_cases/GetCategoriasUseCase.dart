import 'package:app_aryoria/src/data/models/categoria/categoria_paginated.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_query_params.dart';
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/domain/repositories/categoria_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetCategoriasUseCase {
  CategoriaRepository categoriaRepository;
  GetCategoriasUseCase(this.categoriaRepository);

  Future<Resource<ApiResponse<CategoriaPaginated>>> run({
    required int idEmpresa,
    required CategoriasParams queryParams,
  }) => categoriaRepository.getCategorias(
    queryParams: queryParams,
    idEmpresa: idEmpresa,
  );
}
