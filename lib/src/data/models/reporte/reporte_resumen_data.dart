class ReporteResumenData {
  final double totalIngresos;
  final double totalEgresos;

  final double saldoMovimientos;
  final double saldoInicial;
  final double saldoFinalCalculado;

  final int cantidadIngresos;
  final int cantidadEgresos;
  final int cantidadMovimientos;

  final double promedioIngresos;
  final double promedioEgresos;

  final double ingresoMinimo;
  final double ingresoMaximo;
  final double egresoMinimo;
  final double egresoMaximo;

  final int cantidadCategorias;
  final int cantidadCategoriasIngreso;
  final int cantidadCategoriasEgreso;
  final int cantidadDiasConMovimientos;

  final bool tieneMovimientos;

  const ReporteResumenData({
    required this.totalIngresos,
    required this.totalEgresos,
    required this.saldoMovimientos,
    required this.saldoInicial,
    required this.saldoFinalCalculado,
    required this.cantidadIngresos,
    required this.cantidadEgresos,
    required this.cantidadMovimientos,
    required this.promedioIngresos,
    required this.promedioEgresos,
    required this.ingresoMinimo,
    required this.ingresoMaximo,
    required this.egresoMinimo,
    required this.egresoMaximo,
    required this.cantidadCategorias,
    required this.cantidadCategoriasIngreso,
    required this.cantidadCategoriasEgreso,
    required this.cantidadDiasConMovimientos,
    required this.tieneMovimientos,
  });

  factory ReporteResumenData.fromJson(Map<String, dynamic> json) {
    final cantidadMovimientos = _parseInt(json['cantidad_movimientos']);

    return ReporteResumenData(
      totalIngresos: _parseDouble(json['total_ingresos']),
      totalEgresos: _parseDouble(json['total_egresos']),
      saldoMovimientos: _parseDouble(
        json['saldo_movimientos'] ?? json['saldo_periodo'] ?? json['saldo'],
      ),
      saldoInicial: _parseDouble(json['saldo_inicial']),
      saldoFinalCalculado: _parseDouble(json['saldo_final_calculado']),
      cantidadIngresos: _parseInt(json['cantidad_ingresos']),
      cantidadEgresos: _parseInt(json['cantidad_egresos']),
      cantidadMovimientos: cantidadMovimientos,
      promedioIngresos: _parseDouble(json['promedio_ingresos']),
      promedioEgresos: _parseDouble(json['promedio_egresos']),
      ingresoMinimo: _parseDouble(json['ingreso_minimo']),
      ingresoMaximo: _parseDouble(json['ingreso_maximo']),
      egresoMinimo: _parseDouble(json['egreso_minimo']),
      egresoMaximo: _parseDouble(json['egreso_maximo']),
      cantidadCategorias: _parseInt(json['cantidad_categorias']),
      cantidadCategoriasIngreso: _parseInt(json['cantidad_categorias_ingreso']),
      cantidadCategoriasEgreso: _parseInt(json['cantidad_categorias_egreso']),
      cantidadDiasConMovimientos: _parseInt(
        json['cantidad_dias_con_movimientos'],
      ),
      tieneMovimientos:
          _parseBool(json['tiene_movimientos']) || cantidadMovimientos > 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_ingresos': totalIngresos,
      'total_egresos': totalEgresos,
      'saldo_movimientos': saldoMovimientos,
      'saldo_inicial': saldoInicial,
      'saldo_final_calculado': saldoFinalCalculado,
      'cantidad_ingresos': cantidadIngresos,
      'cantidad_egresos': cantidadEgresos,
      'cantidad_movimientos': cantidadMovimientos,
      'promedio_ingresos': promedioIngresos,
      'promedio_egresos': promedioEgresos,
      'ingreso_minimo': ingresoMinimo,
      'ingreso_maximo': ingresoMaximo,
      'egreso_minimo': egresoMinimo,
      'egreso_maximo': egresoMaximo,
      'cantidad_categorias': cantidadCategorias,
      'cantidad_categorias_ingreso': cantidadCategoriasIngreso,
      'cantidad_categorias_egreso': cantidadCategoriasEgreso,
      'cantidad_dias_con_movimientos': cantidadDiasConMovimientos,
      'tiene_movimientos': tieneMovimientos,
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
