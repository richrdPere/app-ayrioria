import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Service
import 'package:app_aryoria/src/data/datasources/remote/services/sub_categoria_service.dart';

// Repository
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/create_sub_categoria_req.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_paginado.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/update_sub_categoria_req.dart';

class SubcategoriaRepositoryImpl implements SubcategoriaRepository {
  final SubcategoriaService subcategoriaService;
  final AuthRepository authRepository;

  SubcategoriaRepositoryImpl({
    required this.subcategoriaService,
    required this.authRepository,
  });

  // *********************************************************
  // 1.- Obtener subcategorias paginadas
  // *********************************************************
  @override
  Future<Resource<ApiResponse<SubcategoriaPaginated>>>
  getSubcategoriasPaginated({
    required int idEmpresa,
    required Map<String, dynamic> queryParams,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return subcategoriaService.getSubcategoriasPaginated(
      token: token,
      idEmpresa: idEmpresa,
      queryParams: queryParams,
    );
  }

  // *********************************************************
  // 2.- Obtener subcategorias por categoria
  // *********************************************************
  @override
  Future<Resource<ApiResponse<List<SubcategoriaData>>>>
  getSubcategoriasByCategoria({
    required int idCategoria,
    required int idEmpresa,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return subcategoriaService.getSubcategoriasByCategoria(
      token: token,
      idEmpresa: idEmpresa,
      idCategoria: idCategoria,
    );
  }

  // *********************************************************
  // 3.- Obtener subcategorias por tipo
  // *********************************************************
  @override
  Future<Resource<ApiResponse<List<SubcategoriaData>>>> getSubcategoriasByTipo({
    required int idEmpresa,
    required String tipo,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return subcategoriaService.getSubcategoriasByTipo(
      token: token,
      idEmpresa: idEmpresa,
      tipo: tipo,
    );
  }

  // *********************************************************
  // 4.- Obtener subcategoria por ID
  // *********************************************************
  @override
  Future<Resource<ApiResponse<SubcategoriaData>>> getSubcategoriaById({
    required int idEmpresa,
    required int idSubcategoria,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return subcategoriaService.getSubcategoriaById(
      token: token,
      idEmpresa: idEmpresa,
      idSubcategoria: idSubcategoria,
    );
  }

  // *********************************************************
  // 5.- Crear subcategoria
  // *********************************************************
  @override
  Future<Resource<ApiResponse<SubcategoriaData>>> createSubcategoria({
    required int idEmpresa,
    required CreateSubcategoriaRequest request,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return subcategoriaService.createSubcategoria(
      token: token,
      idEmpresa: idEmpresa,
      request: request,
    );
  }

  // *********************************************************
  // 6.- Actualizar subcategoria
  // *********************************************************
  @override
  Future<Resource<ApiResponse<SubcategoriaData>>> updateSubcategoria({
    required int idEmpresa,
    required int idSubcategoria,
    required UpdateSubcategoriaRequest request,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return subcategoriaService.updateSubcategoria(
      token: token,
      idEmpresa: idEmpresa,
      idSubcategoria: idSubcategoria,
      request: request,
    );
  }

  // *********************************************************
  // 7.- Cambiar estado
  // *********************************************************
  @override
  Future<Resource<ApiResponse<SubcategoriaData>>> changeSubcategoriaEstado({
    required int idEmpresa,
    required int idSubcategoria,
    required bool estado,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return subcategoriaService.changeSubcategoriaEstado(
      token: token,
      idEmpresa: idEmpresa,
      idSubcategoria: idSubcategoria,
      estado: estado,
    );
  }

  // *********************************************************
  // 8.- Eliminar subcategoria
  // *********************************************************
  @override
  Future<Resource<ApiResponse<void>>> deleteSubcategoria({
    required int idEmpresa,
    required int idSubcategoria,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return subcategoriaService.deleteSubcategoria(
      token: token,
      idEmpresa: idEmpresa,
      idSubcategoria: idSubcategoria,
    );
  }
}
