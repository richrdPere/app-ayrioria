import 'package:app_aryoria/src/domain/repositories/categoria_repostory.dart';

class GetCategoriasUseCase {
  CategoriaRepository categoriaRepository;
  GetCategoriasUseCase(this.categoriaRepository);

  run({
    int page = 1,
    int limit = 10,
    String search = '',
    required int idCategoria,
  }) => categoriaRepository.getCategorias(
    page: page,
    limit: limit,
    search: search,
    idCategoria: idCategoria,
  );
}
