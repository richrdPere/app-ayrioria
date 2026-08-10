import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/domain/repositories/categoria_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetCategoriaByTipoUseCase {
  CategoriaRepository categoriaRepository;

  GetCategoriaByTipoUseCase(this.categoriaRepository);

  Future<Resource<ApiResponse<List<CategoriaData>>>> run({
    required String tipo,
    required int idEmpresa,
  }) =>
      categoriaRepository.getCategoriasByTipo(idEmpresa: idEmpresa, tipo: tipo);
}
