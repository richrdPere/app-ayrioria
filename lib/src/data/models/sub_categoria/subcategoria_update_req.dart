class SubcategoriaUpdateRequest {
  final int? idCategoria;
  final String? nombre;
  final String? descripcion;
  final bool? esPredeterminada;
  final int? orden;
  final bool? estado;

  const SubcategoriaUpdateRequest({
    this.idCategoria,
    this.nombre,
    this.descripcion,
    this.esPredeterminada,
    this.orden,
    this.estado,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (idCategoria != null) {
      data['id_categoria'] = idCategoria;
    }

    if (nombre != null) {
      data['nombre'] = nombre!.trim();
    }

    if (descripcion != null) {
      data['descripcion'] = descripcion!.trim();
    }

    if (esPredeterminada != null) {
      data['es_predeterminada'] = esPredeterminada;
    }

    if (orden != null) {
      data['orden'] = orden;
    }

    if (estado != null) {
      data['estado'] = estado;
    }

    return data;
  }

  factory SubcategoriaUpdateRequest.fromJson(Map<String, dynamic> json) {
    return SubcategoriaUpdateRequest(
      idCategoria: json['id_categoria'],
      nombre: json['nombre']?.toString(),
      descripcion: json['descripcion']?.toString(),
      esPredeterminada: json['es_predeterminada'],
      orden: json['orden'],
      estado: json['estado'],
    );
  }

  SubcategoriaUpdateRequest copyWith({
    int? idCategoria,
    String? nombre,
    String? descripcion,
    bool? esPredeterminada,
    int? orden,
    bool? estado,
  }) {
    return SubcategoriaUpdateRequest(
      idCategoria: idCategoria ?? this.idCategoria,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      esPredeterminada: esPredeterminada ?? this.esPredeterminada,
      orden: orden ?? this.orden,
      estado: estado ?? this.estado,
    );
  }
}
