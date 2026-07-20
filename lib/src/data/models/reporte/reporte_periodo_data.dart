class ReportePeriodoData {
  final int idPeriodo;
  final int idEmpresa;
  final String nombre;
  final int anio;
  final int mes;
  final String fechaInicio;
  final String fechaFin;
  final String estado;
  final double saldoInicial;
  final double? saldoFinal;

  const ReportePeriodoData({
    required this.idPeriodo,
    required this.idEmpresa,
    required this.nombre,
    required this.anio,
    required this.mes,
    required this.fechaInicio,
    required this.fechaFin,
    required this.estado,
    required this.saldoInicial,
    this.saldoFinal,
  });

  factory ReportePeriodoData.fromJson(Map<String, dynamic> json) {
    return ReportePeriodoData(
      idPeriodo: _parseInt(json['id_periodo']),
      idEmpresa: _parseInt(json['id_empresa']),
      nombre: json['nombre']?.toString() ?? '',
      anio: _parseInt(json['anio']),
      mes: _parseInt(json['mes']),
      fechaInicio: json['fecha_inicio']?.toString() ?? '',
      fechaFin: json['fecha_fin']?.toString() ?? '',
      estado: json['estado']?.toString() ?? '',
      saldoInicial: _parseDouble(json['saldo_inicial']),
      saldoFinal: json['saldo_final'] == null
          ? null
          : _parseDouble(json['saldo_final']),
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
