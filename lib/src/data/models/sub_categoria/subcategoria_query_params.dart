class SubcategoriasParams {
  final int page;
  final int limit;

  final String? search;
  final int? idCategoria;
  final String? tipo;
  final bool? estado;

  const SubcategoriasParams({
    this.page = 1,
    this.limit = 10,
    this.search,
    this.idCategoria,
    this.tipo,
    this.estado,
  });

  // ==========================================================
  // QUERY PARAMS
  // ==========================================================

  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> params = {
      'page': page,
      'limit': limit,
      'id_categoria': idCategoria,
      'tipo': tipo,
      'estado': estado,
    };

    // ========================================================
    // SEARCH
    // ========================================================
    final String? searchValue = search?.trim();

    if (searchValue != null && searchValue.isNotEmpty) {
      params['search'] = searchValue;
    }

    // ========================================================
    // CATEGORÍA
    // ========================================================
    if (idCategoria != null && idCategoria! > 0) {
      params['idCategoria'] = idCategoria;
    }

    // ========================================================
    // TIPO
    // ========================================================
    final String? tipoValue = tipo?.trim().toUpperCase();

    if (tipoValue != null &&
        (tipoValue == 'INGRESO' || tipoValue == 'EGRESO')) {
      params['tipo'] = tipoValue;
    }

    // ========================================================
    // ESTADO
    // ========================================================
    if (estado != null) {
      params['estado'] = estado;
    }

    return params;
  }

  // ==========================================================
  // COPY WITH
  // ==========================================================

  SubcategoriasParams copyWith({
    int? page,
    int? limit,
    String? search,
    int? idCategoria,
    String? tipo,
    bool? estado,

    bool clearSearch = false,
    bool clearIdCategoria = false,
    bool clearTipo = false,
    bool clearEstado = false,
  }) {
    return SubcategoriasParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,

      search: clearSearch ? null : search ?? this.search,

      idCategoria: clearIdCategoria ? null : idCategoria ?? this.idCategoria,

      tipo: clearTipo ? null : tipo ?? this.tipo,

      estado: clearEstado ? null : estado ?? this.estado,
    );
  }

  // ==========================================================
  // HELPERS
  // ==========================================================

  /// Indica si existe al menos un filtro aplicado.
  bool get hasFilters {
    return (search?.trim().isNotEmpty ?? false) ||
        idCategoria != null ||
        (tipo?.trim().isNotEmpty ?? false) ||
        estado != null;
  }

  /// Crea los mismos filtros pero vuelve a la primera página.
  SubcategoriasParams firstPage() {
    return copyWith(page: 1);
  }

  /// Crea los mismos filtros para la página siguiente.
  SubcategoriasParams nextPage() {
    return copyWith(page: page + 1);
  }

  /// Crea los mismos filtros para la página anterior.
  SubcategoriasParams previousPage() {
    return copyWith(page: page > 1 ? page - 1 : 1);
  }

  /// Elimina todos los filtros manteniendo page y limit.
  SubcategoriasParams clearFilters() {
    return SubcategoriasParams(page: page, limit: limit);
  }

  @override
  String toString() {
    return 'SubcategoriasParams('
        'page: $page, '
        'limit: $limit, '
        'search: $search, '
        'idCategoria: $idCategoria, '
        'tipo: $tipo, '
        'estado: $estado'
        ')';
  }
}
