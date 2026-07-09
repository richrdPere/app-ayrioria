class MovimientoRequest {
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

  const MovimientoRequest({
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
  });

  factory MovimientoRequest.fromJson(Map<String, dynamic> json) {
    return MovimientoRequest(
      idEmpresa: json['id_empresa'] ?? 0,
      idCategoria: json['id_categoria'] ?? 0,
      idUsuario: json['id_usuario'] ?? 0,
      idPeriodo: json['id_periodo'] ?? 0,
      tipo: json['tipo'] ?? '',
      fecha: json['fecha'] ?? '',
      descripcion: json['descripcion'] ?? '',
      monto: double.tryParse(json['monto'].toString()) ?? 0.0,
      observacion: json['observacion'],
      comprobante: json['comprobante'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
    };
  }

  MovimientoRequest copyWith({
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
  }) {
    return MovimientoRequest(
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
    );
  }
}
