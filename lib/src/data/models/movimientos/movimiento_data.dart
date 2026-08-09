class MovimientoData {
  final int idMovimiento;
  final int idEmpresa;
  final int idCategoria;
  final int idSubcategoria;
  final int? idCuenta;
  final int idUsuario;
  final int idPeriodo;

  final String tipo;
  final String fecha;
  final String descripcion;
  final double monto;

  final String? observacion;
  final String? comprobante;

  final String estado;
  final bool activo;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  final MovimientoEmpresaData? empresa;
  final MovimientoCategoriaData? categoria;
  final MovimientoSubcategoriaData? subcategoria;
  final MovimientoUsuarioData? usuario;
  final MovimientoPeriodoData? periodoContable;

  const MovimientoData({
    required this.idMovimiento,
    required this.idEmpresa,
    required this.idCategoria,
    required this.idSubcategoria,
    this.idCuenta,
    required this.idUsuario,
    required this.idPeriodo,
    required this.tipo,
    required this.fecha,
    required this.descripcion,
    required this.monto,
    this.observacion,
    this.comprobante,
    required this.estado,
    required this.activo,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.empresa,
    this.categoria,
    this.subcategoria,
    this.usuario,
    this.periodoContable,
  });

  factory MovimientoData.fromJson(Map<String, dynamic> json) {
    return MovimientoData(
      idMovimiento: _toInt(json['id_movimiento']),
      idEmpresa: _toInt(json['id_empresa']),
      idCategoria: _toInt(json['id_categoria']),
      idSubcategoria: _toInt(json['id_subcategoria']),
      idCuenta: json['id_cuenta'] != null ? _toInt(json['id_cuenta']) : null,
      idUsuario: _toInt(json['id_usuario']),
      idPeriodo: _toInt(json['id_periodo']),

      tipo: json['tipo']?.toString() ?? '',
      fecha: json['fecha']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      monto: _toDouble(json['monto']),

      observacion: json['observacion']?.toString(),
      comprobante: json['comprobante']?.toString(),

      estado: json['estado']?.toString() ?? '',
      activo: json['activo'] == true,

      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
      deletedAt: _toDateTime(json['deleted_at']),

      empresa: json['empresa'] is Map
          ? MovimientoEmpresaData.fromJson(
              Map<String, dynamic>.from(json['empresa']),
            )
          : null,

      categoria: json['categoria'] is Map
          ? MovimientoCategoriaData.fromJson(
              Map<String, dynamic>.from(json['categoria']),
            )
          : null,

      subcategoria: json['subcategoria'] is Map
          ? MovimientoSubcategoriaData.fromJson(
              Map<String, dynamic>.from(json['subcategoria']),
            )
          : null,

      usuario: json['usuario'] is Map
          ? MovimientoUsuarioData.fromJson(
              Map<String, dynamic>.from(json['usuario']),
            )
          : null,

      periodoContable: json['periodoContable'] is Map
          ? MovimientoPeriodoData.fromJson(
              Map<String, dynamic>.from(json['periodoContable']),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_movimiento': idMovimiento,
      'id_empresa': idEmpresa,
      'id_categoria': idCategoria,
      'id_subcategoria': idSubcategoria,
      'id_cuenta': idCuenta,
      'id_usuario': idUsuario,
      'id_periodo': idPeriodo,
      'tipo': tipo,
      'fecha': fecha,
      'descripcion': descripcion,
      'monto': monto,
      'observacion': observacion,
      'comprobante': comprobante,
      'estado': estado,
      'activo': activo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'empresa': empresa?.toJson(),
      'categoria': categoria?.toJson(),
      'subcategoria': subcategoria?.toJson(),
      'usuario': usuario?.toJson(),
      'periodoContable': periodoContable?.toJson(),
    };
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

// ==========================================================
// EMPRESA
// ==========================================================
class MovimientoEmpresaData {
  final int idEmpresa;
  final String razonSocial;
  final String? ruc;

  const MovimientoEmpresaData({
    required this.idEmpresa,
    required this.razonSocial,
    this.ruc,
  });

  factory MovimientoEmpresaData.fromJson(Map<String, dynamic> json) {
    return MovimientoEmpresaData(
      idEmpresa: MovimientoData._toInt(json['id_empresa']),
      razonSocial: json['razon_social']?.toString() ?? '',
      ruc: json['ruc']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id_empresa': idEmpresa, 'razon_social': razonSocial, 'ruc': ruc};
  }
}

// ==========================================================
// CATEGORÍA
// ==========================================================
class MovimientoCategoriaData {
  final int idCategoria;
  final String nombre;
  final String tipo;
  final String? color;
  final String? icono;

  const MovimientoCategoriaData({
    required this.idCategoria,
    required this.nombre,
    required this.tipo,
    this.color,
    this.icono,
  });

  factory MovimientoCategoriaData.fromJson(Map<String, dynamic> json) {
    return MovimientoCategoriaData(
      idCategoria: MovimientoData._toInt(json['id_categoria']),
      nombre: json['nombre']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? '',
      color: json['color']?.toString(),
      icono: json['icono']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_categoria': idCategoria,
      'nombre': nombre,
      'tipo': tipo,
      'color': color,
      'icono': icono,
    };
  }
}

// ==========================================================
// SUBCATEGORÍA
// ==========================================================
class MovimientoSubcategoriaData {
  final int idSubcategoria;
  final int idCategoria;
  final String nombre;
  final String? naturaleza;
  final bool estado;

  const MovimientoSubcategoriaData({
    required this.idSubcategoria,
    required this.idCategoria,
    required this.nombre,
    this.naturaleza,
    required this.estado,
  });

  factory MovimientoSubcategoriaData.fromJson(Map<String, dynamic> json) {
    return MovimientoSubcategoriaData(
      idSubcategoria: MovimientoData._toInt(json['id_subcategoria']),
      idCategoria: MovimientoData._toInt(json['id_categoria']),
      nombre: json['nombre']?.toString() ?? '',
      naturaleza: json['naturaleza']?.toString(),
      estado: json['estado'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_subcategoria': idSubcategoria,
      'id_categoria': idCategoria,
      'nombre': nombre,
      'naturaleza': naturaleza,
      'estado': estado,
    };
  }
}

// ==========================================================
// USUARIO
// ==========================================================
class MovimientoUsuarioData {
  final int idUsuario;
  final String username;
  final String email;

  const MovimientoUsuarioData({
    required this.idUsuario,
    required this.username,
    required this.email,
  });

  factory MovimientoUsuarioData.fromJson(Map<String, dynamic> json) {
    return MovimientoUsuarioData(
      idUsuario: MovimientoData._toInt(json['id_usuario']),
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id_usuario': idUsuario, 'username': username, 'email': email};
  }
}

// ==========================================================
// PERÍODO CONTABLE
// ==========================================================
class MovimientoPeriodoData {
  final int idPeriodo;
  final String nombre;
  final int anio;
  final int mes;
  final String estado;

  final String fechaInicio;
  final String fechaFin;

  final double saldoInicial;
  final double saldoFinal;

  const MovimientoPeriodoData({
    required this.idPeriodo,
    required this.nombre,
    required this.anio,
    required this.mes,
    required this.estado,
    required this.fechaInicio,
    required this.fechaFin,
    required this.saldoInicial,
    required this.saldoFinal,
  });

  factory MovimientoPeriodoData.fromJson(Map<String, dynamic> json) {
    return MovimientoPeriodoData(
      idPeriodo: MovimientoData._toInt(json['id_periodo']),
      nombre: json['nombre']?.toString() ?? '',
      anio: MovimientoData._toInt(json['anio']),
      mes: MovimientoData._toInt(json['mes']),
      estado: json['estado']?.toString() ?? '',
      fechaInicio: json['fecha_inicio']?.toString() ?? '',
      fechaFin: json['fecha_fin']?.toString() ?? '',
      saldoInicial: MovimientoData._toDouble(json['saldo_inicial']),
      saldoFinal: MovimientoData._toDouble(json['saldo_final']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_periodo': idPeriodo,
      'nombre': nombre,
      'anio': anio,
      'mes': mes,
      'estado': estado,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
      'saldo_inicial': saldoInicial,
      'saldo_final': saldoFinal,
    };
  }
}
