import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class ChangeSubcategoriaEstadoUC {
  SubcategoriaRepository subcategoriaRepository;
  ChangeSubcategoriaEstadoUC(this.subcategoriaRepository);

  Future<Resource<SubcategoriaData>> run({
    required int idEmpresa,
    required int idSubcategoria,
    required bool estado,
  }) => subcategoriaRepository.changeSubcategoriaEstado(
    idEmpresa: idEmpresa,
    idSubcategoria: idSubcategoria,
    estado: estado,
  );
}
