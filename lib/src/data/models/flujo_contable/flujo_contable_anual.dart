class FlujoAnualData {
  final FlujoAnualEmpresa empresa;
  final int anio;

  final FlujoAnualResumen resumen;

  final List<FlujoAnualMes> meses;

  final FlujoAnualConceptos ingresos;
  final FlujoAnualConceptos egresos;

  const FlujoAnualData({
    required this.empresa,
    required this.anio,
    required this.resumen,
    required this.meses,
    required this.ingresos,
    required this.egresos,
  });

  factory FlujoAnualData.fromJson(Map<String, dynamic> json) {
    return FlujoAnualData(
      empresa: FlujoAnualEmpresa.fromJson(
        json['empresa'] as Map<String, dynamic>? ?? {},
      ),
      anio: _toInt(json['anio']),
      resumen: FlujoAnualResumen.fromJson(
        json['resumen'] as Map<String, dynamic>? ?? {},
      ),
      meses: (json['meses'] as List<dynamic>? ?? [])
          .map((item) => FlujoAnualMes.fromJson(item as Map<String, dynamic>))
          .toList(),
      ingresos: FlujoAnualConceptos.fromJson(
        json['ingresos'] as Map<String, dynamic>? ?? {},
      ),
      egresos: FlujoAnualConceptos.fromJson(
        json['egresos'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class FlujoAnualEmpresa {
  final int idEmpresa;

  const FlujoAnualEmpresa({required this.idEmpresa});

  factory FlujoAnualEmpresa.fromJson(Map<String, dynamic> json) {
    return FlujoAnualEmpresa(idEmpresa: _toInt(json['id_empresa']));
  }
}

class FlujoAnualResumen {
  final double totalIngresos;
  final double totalEgresos;
  final double flujoNetoAnual;

  final int periodosRegistrados;
  final int conceptosIngreso;
  final int conceptosEgreso;

  const FlujoAnualResumen({
    required this.totalIngresos,
    required this.totalEgresos,
    required this.flujoNetoAnual,
    required this.periodosRegistrados,
    required this.conceptosIngreso,
    required this.conceptosEgreso,
  });

  factory FlujoAnualResumen.fromJson(Map<String, dynamic> json) {
    return FlujoAnualResumen(
      totalIngresos: _toDouble(json['total_ingresos']),
      totalEgresos: _toDouble(json['total_egresos']),
      flujoNetoAnual: _toDouble(json['flujo_neto_anual']),
      periodosRegistrados: _toInt(json['periodos_registrados']),
      conceptosIngreso: _toInt(json['conceptos_ingreso']),
      conceptosEgreso: _toInt(json['conceptos_egreso']),
    );
  }
}

class FlujoAnualMes {
  final int mes;
  final String nombre;

  final double totalIngresos;
  final double totalEgresos;
  final double flujoNeto;

  final int? idPeriodo;
  final String? periodo;
  final String? estadoPeriodo;

  final double saldoInicial;
  final double saldoFinal;

  const FlujoAnualMes({
    required this.mes,
    required this.nombre,
    required this.totalIngresos,
    required this.totalEgresos,
    required this.flujoNeto,
    this.idPeriodo,
    this.periodo,
    this.estadoPeriodo,
    required this.saldoInicial,
    required this.saldoFinal,
  });

  factory FlujoAnualMes.fromJson(Map<String, dynamic> json) {
    return FlujoAnualMes(
      mes: _toInt(json['mes']),
      nombre: json['nombre']?.toString() ?? '',
      totalIngresos: _toDouble(json['total_ingresos']),
      totalEgresos: _toDouble(json['total_egresos']),
      flujoNeto: _toDouble(json['flujo_neto']),
      idPeriodo: json['id_periodo'] != null ? _toInt(json['id_periodo']) : null,
      periodo: json['periodo']?.toString(),
      estadoPeriodo: json['estado_periodo']?.toString(),
      saldoInicial: _toDouble(json['saldo_inicial']),
      saldoFinal: _toDouble(json['saldo_final']),
    );
  }

  bool get tienePeriodo => idPeriodo != null;
}

class FlujoAnualConceptos {
  final List<FlujoAnualConcepto> conceptos;
  final double totalAnual;

  const FlujoAnualConceptos({
    required this.conceptos,
    required this.totalAnual,
  });

  factory FlujoAnualConceptos.fromJson(Map<String, dynamic> json) {
    return FlujoAnualConceptos(
      conceptos: (json['conceptos'] as List<dynamic>? ?? [])
          .map(
            (item) => FlujoAnualConcepto.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      totalAnual: _toDouble(json['total_anual']),
    );
  }
}

class FlujoAnualConcepto {
  final int idCategoria;
  final String categoria;
  final String tipo;

  final String? color;
  final String? icono;

  final int idSubcategoria;
  final String concepto;

  final int orden;
  final bool esPredeterminada;

  final List<FlujoConceptoMes> meses;

  final double totalAnual;
  final int cantidadMovimientos;

  const FlujoAnualConcepto({
    required this.idCategoria,
    required this.categoria,
    required this.tipo,
    this.color,
    this.icono,
    required this.idSubcategoria,
    required this.concepto,
    required this.orden,
    required this.esPredeterminada,
    required this.meses,
    required this.totalAnual,
    required this.cantidadMovimientos,
  });

  factory FlujoAnualConcepto.fromJson(Map<String, dynamic> json) {
    return FlujoAnualConcepto(
      idCategoria: _toInt(json['id_categoria']),
      categoria: json['categoria']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? '',
      color: json['color']?.toString(),
      icono: json['icono']?.toString(),
      idSubcategoria: _toInt(json['id_subcategoria']),
      concepto: json['concepto']?.toString() ?? '',
      orden: _toInt(json['orden']),
      esPredeterminada: _toBool(json['es_predeterminada']),
      meses: (json['meses'] as List<dynamic>? ?? [])
          .map(
            (item) => FlujoConceptoMes.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      totalAnual: _toDouble(json['total_anual']),
      cantidadMovimientos: _toInt(json['cantidad_movimientos']),
    );
  }
}

class FlujoConceptoMes {
  final int mes;
  final String nombre;

  final double total;
  final int cantidadMovimientos;

  const FlujoConceptoMes({
    required this.mes,
    required this.nombre,
    required this.total,
    required this.cantidadMovimientos,
  });

  factory FlujoConceptoMes.fromJson(Map<String, dynamic> json) {
    return FlujoConceptoMes(
      mes: _toInt(json['mes']),
      nombre: json['nombre']?.toString() ?? '',
      total: _toDouble(json['total']),
      cantidadMovimientos: _toInt(json['cantidad_movimientos']),
    );
  }
}

// ======================================================
// HELPERS
// ======================================================

double _toDouble(dynamic value) {
  if (value == null) return 0.0;

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString()) ?? 0.0;
}

int _toInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value.toString()) ?? 0;
}

bool _toBool(dynamic value) {
  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value == 1;
  }

  return value?.toString().toLowerCase() == 'true';
}
