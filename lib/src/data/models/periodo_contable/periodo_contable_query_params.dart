class PeriodosContablesParams {
  final int page;
  final int limit;

  final String? estado;
  final int? anio;
  final int? mes;
  final String? search;

  const PeriodosContablesParams({
    this.page = 1,
    this.limit = 10,
    this.estado,
    this.anio,
    this.mes,
    this.search,
  });

  Map<String, dynamic> toQueryParams() {
    final query = <String, dynamic>{'page': page, 'limit': limit};

    if (estado != null && estado!.trim().isNotEmpty) {
      query['estado'] = estado!.trim();
    }

    if (anio != null) {
      query['anio'] = anio;
    }

    if (mes != null) {
      query['mes'] = mes;
    }

    if (search != null && search!.trim().isNotEmpty) {
      query['search'] = search!.trim();
    }

    return query;
  }

  PeriodosContablesParams copyWith({
    int? idEmpresa,
    int? page,
    int? limit,
    String? estado,
    int? anio,
    int? mes,
    String? search,
    bool clearEstado = false,
    bool clearAnio = false,
    bool clearMes = false,
    bool clearSearch = false,
  }) {
    return PeriodosContablesParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      estado: clearEstado ? null : estado ?? this.estado,
      anio: clearAnio ? null : anio ?? this.anio,
      mes: clearMes ? null : mes ?? this.mes,
      search: clearSearch ? null : search ?? this.search,
    );
  }

  @override
  String toString() {
    return 'GetPeriodosContablesParams('
        'page: $page, '
        'limit: $limit, '
        'estado: $estado, '
        'anio: $anio, '
        'mes: $mes, '
        'search: $search'
        ')';
  }
}
