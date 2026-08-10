class SubcategoriaCreateRequest {
  final int idCategoria;
  final String nombre;
  final String? descripcion;
  final int orden;
  final bool estado;

  const SubcategoriaCreateRequest({
    required this.idCategoria,
    required this.nombre,
    this.descripcion,
    required this.orden,
    required this.estado,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_categoria': idCategoria,
      'nombre': nombre.trim(),
      'descripcion': descripcion?.trim(),
      'orden': orden,
      'estado': estado,
    };
  }

  SubcategoriaCreateRequest copyWith({
    int? idCategoria,
    String? nombre,
    String? descripcion,
    int? orden,
    bool? estado,
  }) {
    return SubcategoriaCreateRequest(
      idCategoria: idCategoria ?? this.idCategoria,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      orden: orden ?? this.orden,
      estado: estado ?? this.estado,
    );
  }
}
