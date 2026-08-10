// =============================================
// 1. SUBCATEGORIA DATA
// =============================================
class SubcategoriaData {
  final int idSubcategoria;
  final int idEmpresa;
  final int idCategoria;

  final String nombre;
  final String? descripcion;
  final String? naturaleza;

  final bool esPredeterminada;
  final int orden;
  final bool estado;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  final CategoriaSubcategoriaData? categoria;

  const SubcategoriaData({
    required this.idSubcategoria,
    required this.idEmpresa,
    required this.idCategoria,
    required this.nombre,
    this.descripcion,
    this.naturaleza,
    required this.esPredeterminada,
    required this.orden,
    required this.estado,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.categoria,
  });

  factory SubcategoriaData.fromJson(Map<String, dynamic> json) {
    return SubcategoriaData(
      idSubcategoria: json['id_subcategoria'] ?? 0,
      idEmpresa: json['id_empresa'] ?? 0,
      idCategoria: json['id_categoria'] ?? 0,

      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      naturaleza: json['naturaleza']?.toString(),

      esPredeterminada: json['es_predeterminada'] ?? false,
      orden: json['orden'] ?? 0,
      estado: json['estado'] ?? false,

      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,

      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,

      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'].toString())
          : null,

      categoria: json['categoria'] != null
          ? CategoriaSubcategoriaData.fromJson(
              Map<String, dynamic>.from(json['categoria']),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_subcategoria': idSubcategoria,
      'id_empresa': idEmpresa,
      'id_categoria': idCategoria,
      'nombre': nombre,
      'descripcion': descripcion,
      'naturaleza': naturaleza,
      'es_predeterminada': esPredeterminada,
      'orden': orden,
      'estado': estado,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'categoria': categoria?.toJson(),
    };
  }

  SubcategoriaData copyWith({
    int? idSubcategoria,
    int? idEmpresa,
    int? idCategoria,
    String? nombre,
    String? descripcion,
    String? naturaleza,
    bool? esPredeterminada,
    int? orden,
    bool? estado,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    CategoriaSubcategoriaData? categoria,
  }) {
    return SubcategoriaData(
      idSubcategoria: idSubcategoria ?? this.idSubcategoria,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idCategoria: idCategoria ?? this.idCategoria,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      naturaleza: naturaleza ?? this.naturaleza,
      esPredeterminada: esPredeterminada ?? this.esPredeterminada,
      orden: orden ?? this.orden,
      estado: estado ?? this.estado,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      categoria: categoria ?? this.categoria,
    );
  }
}

// =============================================
// 2. CATEGORIA Y SUBCATEGORIA DATA
// =============================================
class CategoriaSubcategoriaData {
  final int idCategoria;
  final int? idEmpresa;

  final String nombre;
  final String tipo;

  final String? descripcion;
  final String? color;
  final String? icono;

  final bool? estado;

  const CategoriaSubcategoriaData({
    required this.idCategoria,
    this.idEmpresa,
    required this.nombre,
    required this.tipo,
    this.descripcion,
    this.color,
    this.icono,
    this.estado,
  });

  factory CategoriaSubcategoriaData.fromJson(Map<String, dynamic> json) {
    return CategoriaSubcategoriaData(
      idCategoria: json['id_categoria'] ?? 0,
      idEmpresa: json['id_empresa'],
      nombre: json['nombre']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      color: json['color']?.toString(),
      icono: json['icono']?.toString(),
      estado: json['estado'],
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
    };
  }
}
