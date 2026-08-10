import 'package:app_aryoria/src/domain/repositories/categoria_repository.dart';
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_request.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

class CreateCategoriaUseCase {
  CategoriaRepository categoriaRepository;
  CreateCategoriaUseCase(this.categoriaRepository);

  Future<Resource<ApiResponse<CategoriaData>>> run(CategoriaRequest req) =>
      categoriaRepository.createCategoria(req);
}
