import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_paginado.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetSubcategoriasPaginatedUC {
  SubcategoriaRepository subcategoriaRepository;
  GetSubcategoriasPaginatedUC(this.subcategoriaRepository);

  Future<Resource<ApiResponse<SubcategoriaPaginated>>> run({
    required int idEmpresa,
    required Map<String, dynamic> queryParams,
  }) => subcategoriaRepository.getSubcategoriasPaginated(
    idEmpresa: idEmpresa,
    queryParams: queryParams,
  );
}
