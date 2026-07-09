import 'package:app_aryoria/src/domain/use_cases/categoria/categoria_use_cases/CreateCategoriaUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/categoria/categoria_use_cases/DeleteCategoriaUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/categoria/categoria_use_cases/GetCategoriaByIdUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/categoria/categoria_use_cases/GetCategoriaByTipoUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/categoria/categoria_use_cases/GetCategoriasUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/categoria/categoria_use_cases/UpdateCategoriaUseCase.dart';

class CategoriaUsesCases {
  CreateCategoriaUseCase createCategoria;
  DeleteCategoriaUseCase deleteCategoria;
  GetCategoriaByIdUseCase getCategoriaById;
  GetCategoriaByTipoUseCase getCategoriaByTipo;
  GetCategoriasUseCase getCategorias;
  UpdateCategoriaUseCase updateCategoria;

  CategoriaUsesCases({
    required this.createCategoria,
    required this.deleteCategoria,
    required this.getCategoriaById,
    required this.getCategoriaByTipo,
    required this.getCategorias,
    required this.updateCategoria,
  });
}
