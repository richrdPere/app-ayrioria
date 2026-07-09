import 'package:app_aryoria/src/data/models/categoria/categoria_request.dart';
import 'package:app_aryoria/src/domain/repositories/categoria_repostory.dart';

class CreateCategoriaUseCase {
  CategoriaRepository categoriaRepository;
  CreateCategoriaUseCase(this.categoriaRepository);

  run(CategoriaRequest req) => categoriaRepository.createCategoria(req);
}
