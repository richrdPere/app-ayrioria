import 'package:app_aryoria/src/domain/repositories/categoria_repository.dart';

class DeleteCategoriaUseCase {
  CategoriaRepository categoriaRepository;
  DeleteCategoriaUseCase(this.categoriaRepository);

  run(int idCategoria) => categoriaRepository.deleteCategoria(idCategoria);
}
