class CategoriaData {
  final int idCategoria;
  final int idEmpresa;
  final String nombre;
  final String tipo;
  final String? descripcion;
  final String naturaleza;
  final String? color;
  final String? icono;
  final bool estado;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  const CategoriaData({
    required this.idCategoria,
    required this.idEmpresa,
    required this.nombre,
    required this.tipo,
    this.descripcion,
    required this.naturaleza,
    this.color,
    this.icono,
    required this.estado,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory CategoriaData.fromJson(Map<String, dynamic> json) {
    return CategoriaData(
      idCategoria: _toInt(json['id_categoria']),
      idEmpresa: _toInt(json['id_empresa']),
      nombre: json['nombre']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      naturaleza: json['naturaleza']?.toString() ?? 'OTRO',
      color: json['color']?.toString(),
      icono: json['icono']?.toString(),
      estado: _toBool(json['estado']),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_categoria': idCategoria,
      'id_empresa': idEmpresa,
      'nombre': nombre,
      'tipo': tipo,
      'descripcion': descripcion,
      'naturaleza': naturaleza,
      'color': color,
      'icono': icono,
      'estado': estado,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  bool get isIngreso => tipo.trim().toUpperCase() == 'INGRESO';

  bool get isEgreso => tipo.trim().toUpperCase() == 'EGRESO';

  bool get isActiva => estado;

  CategoriaData copyWith({
    int? idCategoria,
    int? idEmpresa,
    String? nombre,
    String? tipo,
    String? descripcion,
    String? naturaleza,
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
      naturaleza: naturaleza ?? this.naturaleza,
      color: color ?? this.color,
      icono: icono ?? this.icono,
      estado: estado ?? this.estado,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    if (value is String) {
      return value.toLowerCase() == 'true';
    }

    return false;
  }
}
