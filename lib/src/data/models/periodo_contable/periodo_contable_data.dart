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
  final String? createdAt;
  final String? updatedAt;

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
    this.createdAt,
    this.updatedAt,
  });

  factory PeriodoContableData.fromJson(Map<String, dynamic> json) {
    return PeriodoContableData(
      idPeriodo: _parseInt(json['id_periodo']),
      idEmpresa: _parseInt(json['id_empresa']),
      nombre: json['nombre']?.toString() ?? '',
      anio: _parseInt(json['anio']),
      mes: _parseInt(json['mes']),
      fechaInicio: json['fecha_inicio']?.toString() ?? '',
      fechaFin: json['fecha_fin']?.toString() ?? '',
      estado: json['estado']?.toString() ?? 'ABIERTO',
      saldoInicial: _parseDouble(json['saldo_inicial']),
      saldoFinal: _parseDouble(json['saldo_final']),
      observacion: json['observacion']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
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
    };
  }

  bool get isAbierto => estado.toUpperCase() == 'ABIERTO';

  bool get isCerrado => estado.toUpperCase() == 'CERRADO';

  bool get isBloqueado => estado.toUpperCase() == 'BLOQUEADO';

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
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;

    if (value is int) return value.toDouble();

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
