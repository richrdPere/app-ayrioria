import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/domain/repositories/categoria_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class DeleteCategoriaUseCase {
  CategoriaRepository categoriaRepository;
  DeleteCategoriaUseCase(this.categoriaRepository);

  Future<Resource<ApiResponse<void>>> run({
    required int idCategoria,
    required int idEmpresa,
  }) => categoriaRepository.deleteCategoria(
    idCategoria: idCategoria,
    idEmpresa: idEmpresa,
  );
}
