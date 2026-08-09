class MovimientoCreateRequest {
  final int idEmpresa;
  final int idPeriodo;
  final int idCategoria;
  final int idSubcategoria;
  final int? idCuenta;
  final int idUsuario;

  final String tipo;
  final String fecha;
  final String descripcion;
  final double monto;

  final String? observacion;
  final String? comprobante;
  final String estado;

  const MovimientoCreateRequest({
    required this.idEmpresa,
    required this.idPeriodo,
    required this.idCategoria,
    required this.idSubcategoria,
    this.idCuenta,
    required this.idUsuario,
    required this.tipo,
    required this.fecha,
    required this.descripcion,
    required this.monto,
    this.observacion,
    this.comprobante,
    this.estado = 'PAGADO',
  });

  factory MovimientoCreateRequest.fromJson(Map<String, dynamic> json) {
    return MovimientoCreateRequest(
      idEmpresa: json['id_empresa'] ?? 0,
      idPeriodo: json['id_periodo'] ?? 0,
      idCategoria: json['id_categoria'] ?? 0,
      idSubcategoria: json['id_subcategoria'] ?? 0,
      idCuenta: json['id_cuenta'] ?? 0,
      idUsuario: json['id_usuario'] ?? 0,
      tipo: json['tipo'] ?? '',
      fecha: json['fecha'] ?? '',
      descripcion: json['descripcion'] ?? '',
      monto: double.tryParse(json['monto'].toString()) ?? 0.0,
      observacion: json['observacion'],
      comprobante: json['comprobante'],
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_empresa': idEmpresa,
      'id_periodo': idPeriodo,
      'id_categoria': idCategoria,
      'id_subcategoria': idSubcategoria,
      'id_cuenta': idCuenta,
      'id_usuario': idUsuario,
      'tipo': tipo,
      'fecha': fecha,
      'descripcion': descripcion,
      'monto': monto,
      'observacion': observacion,
      'comprobante': comprobante,
      'estado': estado,
    };
  }

  MovimientoCreateRequest copyWith({
    int? idEmpresa,
    int? idPeriodo,
    int? idCategoria,
    int? idSubcategoria,
    int? idCuenta,
    int? idUsuario,
    String? tipo,
    String? fecha,
    String? descripcion,
    double? monto,
    String? observacion,
    String? comprobante,
    String? estado,
  }) {
    return MovimientoCreateRequest(
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idPeriodo: idPeriodo ?? this.idPeriodo,
      idCategoria: idCategoria ?? this.idCategoria,
      idCuenta: idCuenta ?? this.idCuenta,
      idSubcategoria: idSubcategoria ?? this.idSubcategoria,
      idUsuario: idUsuario ?? this.idUsuario,
      tipo: tipo ?? this.tipo,
      fecha: fecha ?? this.fecha,
      descripcion: descripcion ?? this.descripcion,
      monto: monto ?? this.monto,
      observacion: observacion ?? this.observacion,
      comprobante: comprobante ?? this.comprobante,
      estado: estado ?? this.estado,
    );
  }
}
