import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Models
import 'package:app_aryoria/src/data/models/sub_categoria/create_sub_categoria_req.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_paginado.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/update_sub_categoria_req.dart';

abstract class SubcategoriaRepository {
  /// 1.- Obtener subcategorias paginadas
  Future<Resource<ApiResponse<SubcategoriaPaginated>>>
  getSubcategoriasPaginated({
    required int idEmpresa,
    required Map<String, dynamic> queryParams,
  });

  /// 2.- Obtener subcategorias por categoria
  Future<Resource<ApiResponse<List<SubcategoriaData>>>>
  getSubcategoriasByCategoria({
    required int idEmpresa,
    required int idCategoria,
  });

  /// 3.- Obtener subcategorias por tipo
  Future<Resource<ApiResponse<List<SubcategoriaData>>>> getSubcategoriasByTipo({
    required int idEmpresa,
    required String tipo,
  });

  // 4.- Obtener subcategoria por ID
  Future<Resource<ApiResponse<SubcategoriaData>>> getSubcategoriaById({
    required int idEmpresa,
    required int idSubcategoria,
  });

  /// 5.- Crear subcategoria
  Future<Resource<ApiResponse<SubcategoriaData>>> createSubcategoria({
    required int idEmpresa,
    required CreateSubcategoriaRequest request,
  });

  /// 6.- Actualizar subcategoria
  Future<Resource<ApiResponse<SubcategoriaData>>> updateSubcategoria({
    required int idEmpresa,
    required int idSubcategoria,
    required UpdateSubcategoriaRequest request,
  });

  /// 7.- Cambiar estado
  Future<Resource<ApiResponse<SubcategoriaData>>> changeSubcategoriaEstado({
    required int idEmpresa,
    required int idSubcategoria,
    required bool estado,
  });

  /// 8.- Eliminar subcategoria
  Future<Resource<ApiResponse<void>>> deleteSubcategoria({
    required int idEmpresa,
    required int idSubcategoria,
  });
}
