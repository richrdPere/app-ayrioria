import 'package:app_aryoria/src/domain/use_cases/index_uses_cases.dart';

class SubcategoriaUsesCases {
  ChangeSubcategoriaEstadoUC changeSubcategoriaEstado;
  CreateSubcategoriaUC createSubcategoria;
  DeleteSubcategoriaUC deleteSubcategoria;
  GetSubcategoriaByIdUC getSubcategoriaById;
  GetSubcategoriaByCategoriaUC getSubcategoriaByCategoria;
  GetSubcategoriasByTipoUC getSubcategoriasByTipo;
  GetSubcategoriasPaginatedUC getSubcategoriasPaginated;
  UpdateSubcategoriaUC updateSubcategoria;

  SubcategoriaUsesCases({
    required this.changeSubcategoriaEstado,
    required this.createSubcategoria,
    required this.deleteSubcategoria,
    required this.getSubcategoriaById,
    required this.getSubcategoriaByCategoria,
    required this.getSubcategoriasByTipo,
    required this.getSubcategoriasPaginated,
    required this.updateSubcategoria,
  });
}
