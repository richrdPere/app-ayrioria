import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetSubcategoriaByCategoriaUC {
  SubcategoriaRepository subcategoriaRepository;
  GetSubcategoriaByCategoriaUC(this.subcategoriaRepository);

  Future<Resource<ApiResponse<List<SubcategoriaData>>>> run({
    required int idEmpresa,
    required int idCategoria,
  }) => subcategoriaRepository.getSubcategoriasByCategoria(
    idEmpresa: idEmpresa,
    idCategoria: idCategoria,
  );
}
