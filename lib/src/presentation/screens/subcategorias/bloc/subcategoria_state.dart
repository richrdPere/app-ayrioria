import 'package:equatable/equatable.dart';

// Models
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_data.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class SubcategoriaState extends Equatable {
  // ==========================================================
  // DATA
  // ==========================================================

  /// Subcategorías correspondientes a la página actual.
  final List<SubcategoriaData> subcategorias;

  /// Subcategorías obtenidas por categoría.
  final List<SubcategoriaData> subcategoriasByCategoria;

  /// Subcategorías obtenidas por tipo.
  final List<SubcategoriaData> subcategoriasByTipo;

  /// Subcategoría seleccionada por ID.
  final SubcategoriaData? subcategoriaSelected;

  // ==========================================================
  // RESPUESTAS
  // ==========================================================

  /// Respuesta del listado paginado.
  final Resource? response;

  /// Respuesta del detalle.
  final Resource? detailResponse;

  /// Crear / actualizar / cambiar estado / eliminar.
  final Resource? actionResponse;

  /// Respuesta del listado por categoría.
  final Resource? byCategoriaResponse;

  /// Respuesta del listado por tipo.
  final Resource? byTipoResponse;

  // ==========================================================
  // PAGINACIÓN
  // ==========================================================

  final int page;
  final int limit;
  final int total;
  final int totalPages;

  final bool hasNextPage;
  final bool hasPreviousPage;

  /// Indica si se está cargando otra página.
  final bool isLoadingMore;

  const SubcategoriaState({
    this.subcategorias = const [],
    this.subcategoriasByCategoria = const [],
    this.subcategoriasByTipo = const [],
    this.subcategoriaSelected,
    this.response,
    this.detailResponse,
    this.actionResponse,
    this.byCategoriaResponse,
    this.byTipoResponse,
    this.page = 1,
    this.limit = 10,
    this.total = 0,
    this.totalPages = 0,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.isLoadingMore = false,
  });

  // ==========================================================
  // HELPERS
  // ==========================================================

  bool get tieneSubcategorias => subcategorias.isNotEmpty;

  bool get isEmpty => subcategorias.isEmpty;

  bool get isFirstPage => page <= 1;

  bool get isLastPage => !hasNextPage;

  bool get tieneSubcategoriasByCategoria => subcategoriasByCategoria.isNotEmpty;

  bool get tieneSubcategoriasByTipo => subcategoriasByTipo.isNotEmpty;

  // ==========================================================
  // COPY WITH
  // ==========================================================

  SubcategoriaState copyWith({
    List<SubcategoriaData>? subcategorias,

    List<SubcategoriaData>? subcategoriasByCategoria,
    bool clearSubcategoriasByCategoria = false,

    List<SubcategoriaData>? subcategoriasByTipo,
    bool clearSubcategoriasByTipo = false,

    SubcategoriaData? subcategoriaSelected,
    bool clearSubcategoriaSelected = false,

    Resource? response,
    bool clearResponse = false,

    Resource? detailResponse,
    bool clearDetailResponse = false,

    Resource? actionResponse,
    bool clearActionResponse = false,

    Resource? byCategoriaResponse,
    bool clearByCategoriaResponse = false,

    Resource? byTipoResponse,
    bool clearByTipoResponse = false,

    int? page,
    int? limit,
    int? total,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    bool? isLoadingMore,
  }) {
    return SubcategoriaState(
      // ========================================================
      // DATA
      // ========================================================
      subcategorias: subcategorias ?? this.subcategorias,
      subcategoriasByCategoria: clearSubcategoriasByCategoria
          ? const <SubcategoriaData>[]
          : subcategoriasByCategoria ?? this.subcategoriasByCategoria,
      subcategoriasByTipo: clearSubcategoriasByTipo
          ? const <SubcategoriaData>[]
          : subcategoriasByTipo ?? this.subcategoriasByTipo,
      subcategoriaSelected: clearSubcategoriaSelected
          ? null
          : subcategoriaSelected ?? this.subcategoriaSelected,

      // ========================================================
      // RESPUESTAS
      // ========================================================
      response: clearResponse ? null : response ?? this.response,
      detailResponse: clearDetailResponse
          ? null
          : detailResponse ?? this.detailResponse,
      actionResponse: clearActionResponse
          ? null
          : actionResponse ?? this.actionResponse,
      byCategoriaResponse: clearByCategoriaResponse
          ? null
          : byCategoriaResponse ?? this.byCategoriaResponse,
      byTipoResponse: clearByTipoResponse
          ? null
          : byTipoResponse ?? this.byTipoResponse,

      // ========================================================
      // PAGINACIÓN
      // ========================================================
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  // ==========================================================
  // EQUATABLE
  // ==========================================================

  @override
  List<Object?> get props => [
    subcategorias,
    subcategoriasByCategoria,
    subcategoriasByTipo,
    subcategoriaSelected,
    response,
    detailResponse,
    actionResponse,
    byCategoriaResponse,
    byTipoResponse,
    page,
    limit,
    total,
    totalPages,
    hasNextPage,
    hasPreviousPage,
    isLoadingMore,
  ];
}

// import 'package:app_aryoria/src/data/models/common/api_response.dart';
// import 'package:equatable/equatable.dart';

// // Resource
// import 'package:app_aryoria/src/domain/utils/Resource.dart';

// // Models
// import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';
// import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_paginado.dart';

// class SubcategoriaState extends Equatable {
//   // 1.- Paginado
//   final Resource<ApiResponse<SubcategoriaPaginated>>? paginatedResponse;

//   // 2.- Por categoría
//   final Resource<ApiResponse<List<SubcategoriaData>>>? byCategoriaResponse;

//   // 3.- Por tipo
//   final Resource<ApiResponse<List<SubcategoriaData>>>? byTipoResponse;

//   // 4.- Detalle
//   final Resource<ApiResponse<SubcategoriaData>>? detailResponse;

//   // 5.- Crear / actualizar / cambiar estado
//   final Resource<ApiResponse<SubcategoriaData>>? actionResponse;

//   // 6.- Eliminar
//   final Resource<ApiResponse<void>>? deleteResponse;

//   const SubcategoriaState({
//     this.paginatedResponse,
//     this.byCategoriaResponse,
//     this.byTipoResponse,
//     this.detailResponse,
//     this.actionResponse,
//     this.deleteResponse,
//   });

//   SubcategoriaState copyWith({
//     Resource<ApiResponse<SubcategoriaPaginated>>? paginatedResponse,
//     Resource<ApiResponse<List<SubcategoriaData>>>? byCategoriaResponse,
//     Resource<ApiResponse<List<SubcategoriaData>>>? byTipoResponse,
//     Resource<ApiResponse<SubcategoriaData>>? detailResponse,
//     Resource<ApiResponse<SubcategoriaData>>? actionResponse,
//     Resource<ApiResponse<void>>? deleteResponse,

//     bool clearPaginatedResponse = false,
//     bool clearByCategoriaResponse = false,
//     bool clearByTipoResponse = false,
//     bool clearDetailResponse = false,
//     bool clearActionResponse = false,
//     bool clearDeleteResponse = false,
//   }) {
//     return SubcategoriaState(
//       paginatedResponse: clearPaginatedResponse
//           ? null
//           : paginatedResponse ?? this.paginatedResponse,

//       byCategoriaResponse: clearByCategoriaResponse
//           ? null
//           : byCategoriaResponse ?? this.byCategoriaResponse,

//       byTipoResponse: clearByTipoResponse
//           ? null
//           : byTipoResponse ?? this.byTipoResponse,

//       detailResponse: clearDetailResponse
//           ? null
//           : detailResponse ?? this.detailResponse,

//       actionResponse: clearActionResponse
//           ? null
//           : actionResponse ?? this.actionResponse,

//       deleteResponse: clearDeleteResponse
//           ? null
//           : deleteResponse ?? this.deleteResponse,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     paginatedResponse,
//     byCategoriaResponse,
//     byTipoResponse,
//     detailResponse,
//     actionResponse,
//     deleteResponse,
//   ];
// }
