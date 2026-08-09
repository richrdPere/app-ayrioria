class MovimientoQueryParams {
  final int page;
  final int limit;

  final String? search;

  final int? idPeriodo;
  final int? idCategoria;
  final int? idSubcategoria;
  final int? idCuenta;

  final String? tipo;
  final String? estado;

  final String? fechaInicio;
  final String? fechaFin;

  const MovimientoQueryParams({
    this.page = 1,
    this.limit = 10,
    this.search,
    this.idPeriodo,
    this.idCategoria,
    this.idSubcategoria,
    this.idCuenta,
    this.tipo,
    this.estado,
    this.fechaInicio,
    this.fechaFin,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
      'search': search,
      'id_periodo': idPeriodo,
      'id_categoria': idCategoria,
      'id_subcategoria': idSubcategoria,
      'id_cuenta': idCuenta,
      'tipo': tipo,
      'estado': estado,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
    };

    params.removeWhere(
      (key, value) =>
          value == null || (value is String && value.trim().isEmpty),
    );

    return params;
  }

  MovimientoQueryParams copyWith({
    int? page,
    int? limit,
    String? search,
    int? idPeriodo,
    int? idCategoria,
    int? idSubcategoria,
    int? idCuenta,
    String? tipo,
    String? estado,
    String? fechaInicio,
    String? fechaFin,

    bool clearSearch = false,
    bool clearIdCategoria = false,
    bool clearIdSubcategoria = false,
    bool clearIdCuenta = false,
    bool clearTipo = false,
    bool clearEstado = false,
    bool clearFechaInicio = false,
    bool clearFechaFin = false,
  }) {
    return MovimientoQueryParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      search: clearSearch ? null : search ?? this.search,
      idPeriodo: idPeriodo ?? this.idPeriodo,
      idCategoria: clearIdCategoria ? null : idCategoria ?? this.idCategoria,
      idSubcategoria: clearIdSubcategoria
          ? null
          : idSubcategoria ?? this.idSubcategoria,
      idCuenta: clearIdCuenta ? null : idCuenta ?? this.idCuenta,
      tipo: clearTipo ? null : tipo ?? this.tipo,
      estado: clearEstado ? null : estado ?? this.estado,
      fechaInicio: clearFechaInicio ? null : fechaInicio ?? this.fechaInicio,
      fechaFin: clearFechaFin ? null : fechaFin ?? this.fechaFin,
    );
  }
}
