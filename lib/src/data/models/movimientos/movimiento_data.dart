class MovimientoData {
  final int idMovimiento;
  final int idEmpresa;
  final int idCategoria;
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

  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  final MovimientoEmpresaData? empresa;
  final MovimientoCategoriaData? categoria;
  final MovimientoUsuarioData? usuario;
  final MovimientoPeriodoData? periodoContable;

  const MovimientoData({
    required this.idMovimiento,
    required this.idEmpresa,
    required this.idCategoria,
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
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.empresa,
    this.categoria,
    this.usuario,
    this.periodoContable,
  });

  factory MovimientoData.fromJson(Map<String, dynamic> json) {
    return MovimientoData(
      idMovimiento: _parseInt(json['id_movimiento']),
      idEmpresa: _parseInt(json['id_empresa']),
      idCategoria: _parseInt(json['id_categoria']),
      idUsuario: _parseInt(json['id_usuario']),
      idPeriodo: _parseInt(json['id_periodo']),
      tipo: json['tipo']?.toString() ?? '',
      fecha: json['fecha']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      monto: _parseDouble(json['monto']),
      observacion: json['observacion']?.toString(),
      comprobante: json['comprobante']?.toString(),
      estado: json['estado']?.toString() ?? '',
      activo: _parseBool(json['activo']),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      deletedAt: json['deleted_at']?.toString(),

      empresa: json['empresa'] is Map
          ? MovimientoEmpresaData.fromJson(
              Map<String, dynamic>.from(json['empresa'] as Map),
            )
          : null,

      categoria: json['categoria'] is Map
          ? MovimientoCategoriaData.fromJson(
              Map<String, dynamic>.from(json['categoria'] as Map),
            )
          : null,

      usuario: json['usuario'] is Map
          ? MovimientoUsuarioData.fromJson(
              Map<String, dynamic>.from(json['usuario'] as Map),
            )
          : null,

      periodoContable: json['periodoContable'] is Map
          ? MovimientoPeriodoData.fromJson(
              Map<String, dynamic>.from(json['periodoContable'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_movimiento': idMovimiento,
      'id_empresa': idEmpresa,
      'id_categoria': idCategoria,
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
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'empresa': empresa?.toJson(),
      'categoria': categoria?.toJson(),
      'usuario': usuario?.toJson(),
      'periodoContable': periodoContable?.toJson(),
    };
  }

  MovimientoData copyWith({
    int? idMovimiento,
    int? idEmpresa,
    int? idCategoria,
    int? idUsuario,
    int? idPeriodo,
    String? tipo,
    String? fecha,
    String? descripcion,
    double? monto,
    String? observacion,
    String? comprobante,
    String? estado,
    bool? activo,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
    MovimientoEmpresaData? empresa,
    MovimientoCategoriaData? categoria,
    MovimientoUsuarioData? usuario,
    MovimientoPeriodoData? periodoContable,
  }) {
    return MovimientoData(
      idMovimiento: idMovimiento ?? this.idMovimiento,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idCategoria: idCategoria ?? this.idCategoria,
      idUsuario: idUsuario ?? this.idUsuario,
      idPeriodo: idPeriodo ?? this.idPeriodo,
      tipo: tipo ?? this.tipo,
      fecha: fecha ?? this.fecha,
      descripcion: descripcion ?? this.descripcion,
      monto: monto ?? this.monto,
      observacion: observacion ?? this.observacion,
      comprobante: comprobante ?? this.comprobante,
      estado: estado ?? this.estado,
      activo: activo ?? this.activo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      empresa: empresa ?? this.empresa,
      categoria: categoria ?? this.categoria,
      usuario: usuario ?? this.usuario,
      periodoContable: periodoContable ?? this.periodoContable,
    );
  }
}

class MovimientoEmpresaData {
  final int idEmpresa;
  final String razonSocial;
  final String ruc;

  const MovimientoEmpresaData({
    required this.idEmpresa,
    required this.razonSocial,
    required this.ruc,
  });

  factory MovimientoEmpresaData.fromJson(Map<String, dynamic> json) {
    return MovimientoEmpresaData(
      idEmpresa: _parseInt(json['id_empresa']),
      razonSocial: json['razon_social']?.toString() ?? '',
      ruc: json['ruc']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id_empresa': idEmpresa, 'razon_social': razonSocial, 'ruc': ruc};
  }
}

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
      idCategoria: _parseInt(json['id_categoria']),
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
      idUsuario: _parseInt(json['id_usuario']),
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id_usuario': idUsuario, 'username': username, 'email': email};
  }
}

class MovimientoPeriodoData {
  final int idPeriodo;
  final String nombre;
  final int anio;
  final int mes;
  final String estado;

  const MovimientoPeriodoData({
    required this.idPeriodo,
    required this.nombre,
    required this.anio,
    required this.mes,
    required this.estado,
  });

  factory MovimientoPeriodoData.fromJson(Map<String, dynamic> json) {
    return MovimientoPeriodoData(
      idPeriodo: _parseInt(json['id_periodo']),
      nombre: json['nombre']?.toString() ?? '',
      anio: _parseInt(json['anio']),
      mes: _parseInt(json['mes']),
      estado: json['estado']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_periodo': idPeriodo,
      'nombre': nombre,
      'anio': anio,
      'mes': mes,
      'estado': estado,
    };
  }
}

int _parseInt(dynamic value, {int fallback = 0}) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

double _parseDouble(dynamic value, {double fallback = 0.0}) {
  if (value is double) {
    return value;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value?.toString() ?? '') ?? fallback;
}

bool _parseBool(dynamic value, {bool fallback = false}) {
  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value == 1;
  }

  final normalized = value?.toString().trim().toLowerCase();

  if (normalized == 'true' || normalized == '1') {
    return true;
  }

  if (normalized == 'false' || normalized == '0') {
    return false;
  }

  return fallback;
}
