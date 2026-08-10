import 'package:equatable/equatable.dart';

// Models
import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class CategoriaState extends Equatable {
  // ==========================================================
  // DATA
  // ==========================================================

  /// Categorías de la página cargada actualmente.
  final List<CategoriaData> categorias;

  /// Categorías obtenidas mediante el endpoint por tipo.
  final List<CategoriaData> categoriasByTipo;

  /// Categoría seleccionada mediante búsqueda por ID.
  final CategoriaData? categoriaSelected;

  // ==========================================================
  // RESPUESTAS
  // ==========================================================

  /// Respuesta del listado paginado.
  final Resource? response;

  /// Respuesta para crear, actualizar o eliminar.
  ///
  /// Se mantiene como Resource porque:
  /// - Create -> ApiResponse<CategoriaData>
  /// - Update -> ApiResponse<CategoriaData>
  /// - Delete -> ApiResponse<void>
  final Resource? actionResponse;

  /// Respuesta del detalle por ID.
  final Resource? detailResponse;

  /// Respuesta del listado por tipo.
  final Resource? tipoResponse;

  // ==========================================================
  // PAGINACIÓN
  // ==========================================================

  /// Página actual.
  final int page;

  /// Cantidad de registros por página.
  final int limit;

  /// Total de registros.
  final int total;

  /// Total de páginas.
  final int totalPages;

  /// Indica si existe una página siguiente.
  final bool hasNextPage;

  /// Indica si existe una página anterior.
  final bool hasPreviousPage;

  // ==========================================================
  // LOADING
  // ==========================================================

  /// Indica si se está realizando una carga adicional
  /// o cambio de página.
  final bool isLoadingMore;

  const CategoriaState({
    this.categorias = const [],
    this.categoriasByTipo = const [],
    this.categoriaSelected,
    this.response,
    this.actionResponse,
    this.detailResponse,
    this.tipoResponse,
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

  bool get tieneCategorias => categorias.isNotEmpty;

  bool get isEmpty => categorias.isEmpty;

  bool get isFirstPage => page <= 1;

  bool get isLastPage => !hasNextPage;

  // ==========================================================
  // COPY WITH
  // ==========================================================

  CategoriaState copyWith({
    List<CategoriaData>? categorias,

    List<CategoriaData>? categoriasByTipo,
    bool clearCategoriasByTipo = false,

    CategoriaData? categoriaSelected,
    bool clearCategoriaSelected = false,

    Resource? response,
    bool clearResponse = false,

    Resource? actionResponse,
    bool clearActionResponse = false,

    Resource? detailResponse,
    bool clearDetailResponse = false,

    Resource? tipoResponse,
    bool clearTipoResponse = false,

    int? page,
    int? limit,
    int? total,
    int? totalPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
    bool? isLoadingMore,
  }) {
    return CategoriaState(
      categorias: categorias ?? this.categorias,

      categoriasByTipo: clearCategoriasByTipo
          ? const []
          : categoriasByTipo ?? this.categoriasByTipo,

      categoriaSelected: clearCategoriaSelected
          ? null
          : categoriaSelected ?? this.categoriaSelected,

      response: clearResponse ? null : response ?? this.response,

      actionResponse: clearActionResponse
          ? null
          : actionResponse ?? this.actionResponse,

      detailResponse: clearDetailResponse
          ? null
          : detailResponse ?? this.detailResponse,

      tipoResponse: clearTipoResponse
          ? null
          : tipoResponse ?? this.tipoResponse,

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
    categorias,
    categoriasByTipo,
    categoriaSelected,
    response,
    actionResponse,
    detailResponse,
    tipoResponse,
    page,
    limit,
    total,
    totalPages,
    hasNextPage,
    hasPreviousPage,
    isLoadingMore,
  ];
}
