import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/create_sub_categoria_req.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class CreateSubcategoriaUC {
  SubcategoriaRepository subcategoriaRepository;
  CreateSubcategoriaUC(this.subcategoriaRepository);

  Future<Resource<ApiResponse<SubcategoriaData>>> run({
    required int idEmpresa,
    required CreateSubcategoriaRequest request,
  }) => subcategoriaRepository.createSubcategoria(
    idEmpresa: idEmpresa,
    request: request,
  );
}
