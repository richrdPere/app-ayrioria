class CategoriaData {
  final int idCategoria;
  final int idEmpresa;
  final String nombre;
  final String tipo;
  final String? descripcion;
  final String? color;
  final String? icono;
  final bool estado;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  const CategoriaData({
    required this.idCategoria,
    required this.idEmpresa,
    required this.nombre,
    required this.tipo,
    this.descripcion,
    this.color,
    this.icono,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory CategoriaData.fromJson(Map<String, dynamic> json) {
    return CategoriaData(
      idCategoria: json['id_categoria'] ?? 0,
      idEmpresa: json['id_empresa'] ?? 0,
      nombre: json['nombre'] ?? '',
      tipo: json['tipo'] ?? '',
      descripcion: json['descripcion'],
      color: json['color'],
      icono: json['icono'],
      estado: json['estado'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_categoria': idCategoria,
      'id_empresa': idEmpresa,
      'nombre': nombre,
      'tipo': tipo,
      'descripcion': descripcion,
      'color': color,
      'icono': icono,
      'estado': estado,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  CategoriaData copyWith({
    int? idCategoria,
    int? idEmpresa,
    String? nombre,
    String? tipo,
    String? descripcion,
    String? color,
    String? icono,
    bool? estado,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) {
    return CategoriaData(
      idCategoria: idCategoria ?? this.idCategoria,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      descripcion: descripcion ?? this.descripcion,
      color: color ?? this.color,
      icono: icono ?? this.icono,
      estado: estado ?? this.estado,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
