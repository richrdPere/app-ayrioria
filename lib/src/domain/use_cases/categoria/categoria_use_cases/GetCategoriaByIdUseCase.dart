import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/domain/repositories/categoria_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetCategoriaByIdUseCase {
  CategoriaRepository categoriaRepository;
  GetCategoriaByIdUseCase(this.categoriaRepository);

  Future<Resource<ApiResponse<CategoriaData>>> run({
    required int idCategoria,
    required int idEmpresa,
  }) => categoriaRepository.getCategoriaById(
    idCategoria: idCategoria,
    idEmpresa: idEmpresa,
  );
}
