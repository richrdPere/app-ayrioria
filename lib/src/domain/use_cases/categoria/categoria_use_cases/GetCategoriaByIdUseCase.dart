import 'package:app_aryoria/src/domain/repositories/categoria_repostory.dart';

class GetCategoriaByIdUseCase {
  CategoriaRepository categoriaRepository;
  GetCategoriaByIdUseCase(this.categoriaRepository);

  run(int idCategoria) => categoriaRepository.getCategoriaById(idCategoria);
}
