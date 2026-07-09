import 'package:app_aryoria/src/data/models/categoria/categoria_request.dart';
import 'package:app_aryoria/src/domain/repositories/categoria_repostory.dart';

class UpdateCategoriaUseCase {
  CategoriaRepository categoriaRepository;
  UpdateCategoriaUseCase(this.categoriaRepository);

  run({required int idCategoria, required CategoriaRequest request}) =>
      categoriaRepository.updateCategoria(
        idCategoria: idCategoria,
        request: request,
      );
}
