import 'package:app_aryoria/src/domain/repositories/categoria_repository.dart';

class GetCategoriaByTipoUseCase {
  CategoriaRepository categoriaRepository;

  GetCategoriaByTipoUseCase(this.categoriaRepository);

  run({
    int page = 1,
    int limit = 10,
    String search = '',
    required String tipo,
  }) => categoriaRepository.getCategoriasByTipo(
    page: page,
    limit: limit,
    search: search,
    tipo: tipo,
  );
}
