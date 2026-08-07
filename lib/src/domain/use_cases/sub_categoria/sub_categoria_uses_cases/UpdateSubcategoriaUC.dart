import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/update_sub_categoria_req.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class UpdateSubcategoriaUC {
  SubcategoriaRepository subcategoriaRepository;
  UpdateSubcategoriaUC(this.subcategoriaRepository);

  Future<Resource<SubcategoriaData>> run({
    required int idEmpresa,
    required int idSubcategoria,
    required UpdateSubcategoriaRequest request,
  }) => subcategoriaRepository.updateSubcategoria(
    idEmpresa: idEmpresa,
    idSubcategoria: idSubcategoria,
    request: request,
  );
}
