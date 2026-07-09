class PeriodoContableData {
  final int idPeriodo;
  final int idEmpresa;
  final String nombre;
  final int anio;
  final int mes;
  final String fechaInicio;
  final String fechaFin;
  final String estado;
  final double saldoInicial;
  final double saldoFinal;
  final String? observacion;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  const PeriodoContableData({
    required this.idPeriodo,
    required this.idEmpresa,
    required this.nombre,
    required this.anio,
    required this.mes,
    required this.fechaInicio,
    required this.fechaFin,
    required this.estado,
    required this.saldoInicial,
    required this.saldoFinal,
    this.observacion,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory PeriodoContableData.fromJson(Map<String, dynamic> json) {
    return PeriodoContableData(
      idPeriodo: json['id_periodo'] ?? 0,
      idEmpresa: json['id_empresa'] ?? 0,
      nombre: json['nombre'] ?? '',
      anio: json['anio'] ?? 0,
      mes: json['mes'] ?? 0,
      fechaInicio: json['fecha_inicio'] ?? '',
      fechaFin: json['fecha_fin'] ?? '',
      estado: json['estado'] ?? '',
      saldoInicial: double.tryParse(json['saldo_inicial'].toString()) ?? 0.0,
      saldoFinal: double.tryParse(json['saldo_final'].toString()) ?? 0.0,
      observacion: json['observacion'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_periodo': idPeriodo,
      'id_empresa': idEmpresa,
      'nombre': nombre,
      'anio': anio,
      'mes': mes,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
      'estado': estado,
      'saldo_inicial': saldoInicial,
      'saldo_final': saldoFinal,
      'observacion': observacion,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }

  PeriodoContableData copyWith({
    int? idPeriodo,
    int? idEmpresa,
    String? nombre,
    int? anio,
    int? mes,
    String? fechaInicio,
    String? fechaFin,
    String? estado,
    double? saldoInicial,
    double? saldoFinal,
    String? observacion,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) {
    return PeriodoContableData(
      idPeriodo: idPeriodo ?? this.idPeriodo,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      nombre: nombre ?? this.nombre,
      anio: anio ?? this.anio,
      mes: mes ?? this.mes,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      estado: estado ?? this.estado,
      saldoInicial: saldoInicial ?? this.saldoInicial,
      saldoFinal: saldoFinal ?? this.saldoFinal,
      observacion: observacion ?? this.observacion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
