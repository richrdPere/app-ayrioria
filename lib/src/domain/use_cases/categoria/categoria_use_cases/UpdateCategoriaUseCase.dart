import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_request.dart';
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/domain/repositories/categoria_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class UpdateCategoriaUseCase {
  CategoriaRepository categoriaRepository;
  UpdateCategoriaUseCase(this.categoriaRepository);

  Future<Resource<ApiResponse<CategoriaData>>> run({
    required int idCategoria,
    required int idEmpresa,
    required CategoriaRequest request,
  }) => categoriaRepository.updateCategoria(
    idCategoria: idCategoria,
    idEmpresa: idEmpresa,
    request: request,
  );
}
