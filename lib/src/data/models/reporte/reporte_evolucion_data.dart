class ReporteEvolucionData {
  final String fecha;
  final double ingresos;
  final double egresos;
  final double saldoDiario;
  final double saldoAcumulado;
  final int cantidadIngresos;
  final int cantidadEgresos;
  final int cantidadMovimientos;

  const ReporteEvolucionData({
    required this.fecha,
    required this.ingresos,
    required this.egresos,
    required this.saldoDiario,
    required this.saldoAcumulado,
    required this.cantidadIngresos,
    required this.cantidadEgresos,
    required this.cantidadMovimientos,
  });

  factory ReporteEvolucionData.fromJson(Map<String, dynamic> json) {
    return ReporteEvolucionData(
      fecha: json['fecha']?.toString() ?? '',
      ingresos: _parseDouble(json['ingresos']),
      egresos: _parseDouble(json['egresos']),
      saldoDiario: _parseDouble(json['saldo_diario']),
      saldoAcumulado: _parseDouble(json['saldo_acumulado']),
      cantidadIngresos: _parseInt(json['cantidad_ingresos']),
      cantidadEgresos: _parseInt(json['cantidad_egresos']),
      cantidadMovimientos: _parseInt(json['cantidad_movimientos']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fecha': fecha,
      'ingresos': ingresos,
      'egresos': egresos,
      'saldo_diario': saldoDiario,
      'saldo_acumulado': saldoAcumulado,
      'cantidad_ingresos': cantidadIngresos,
      'cantidad_egresos': cantidadEgresos,
      'cantidad_movimientos': cantidadMovimientos,
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
