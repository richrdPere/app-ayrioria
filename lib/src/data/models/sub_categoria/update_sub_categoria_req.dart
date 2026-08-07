class UpdateSubcategoriaRequest {
  final int? idCategoria;
  final String? nombre;
  final String? descripcion;
  final bool? esPredeterminada;
  final int? orden;
  final bool? estado;

  const UpdateSubcategoriaRequest({
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

  factory UpdateSubcategoriaRequest.fromJson(Map<String, dynamic> json) {
    return UpdateSubcategoriaRequest(
      idCategoria: json['id_categoria'],
      nombre: json['nombre']?.toString(),
      descripcion: json['descripcion']?.toString(),
      esPredeterminada: json['es_predeterminada'],
      orden: json['orden'],
      estado: json['estado'],
    );
  }

  UpdateSubcategoriaRequest copyWith({
    int? idCategoria,
    String? nombre,
    String? descripcion,
    bool? esPredeterminada,
    int? orden,
    bool? estado,
  }) {
    return UpdateSubcategoriaRequest(
      idCategoria: idCategoria ?? this.idCategoria,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      esPredeterminada: esPredeterminada ?? this.esPredeterminada,
      orden: orden ?? this.orden,
      estado: estado ?? this.estado,
    );
  }
}
