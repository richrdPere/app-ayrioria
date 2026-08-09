import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class DeleteSubcategoriaUC {
  SubcategoriaRepository subcategoriaRepository;
  DeleteSubcategoriaUC(this.subcategoriaRepository);

  Future<Resource<ApiResponse<void>>> run({
    required int idEmpresa,
    required int idSubcategoria,
  }) => subcategoriaRepository.deleteSubcategoria(
    idEmpresa: idEmpresa,
    idSubcategoria: idSubcategoria,
  );
}
