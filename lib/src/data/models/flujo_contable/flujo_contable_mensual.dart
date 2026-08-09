// ===========================================
// Flujo Contable Mensual - Data
// ===========================================
class FlujoContableMensualData {
  final FlujoPeriodo periodo;
  final FlujoResumen resumen;
  final FlujoSeccion ingresos;
  final FlujoSeccion egresos;

  FlujoContableMensualData({
    required this.periodo,
    required this.resumen,
    required this.ingresos,
    required this.egresos,
  });

  factory FlujoContableMensualData.fromJson(Map<String, dynamic> json) {
    return FlujoContableMensualData(
      periodo: FlujoPeriodo.fromJson(json['periodo'] ?? {}),
      resumen: FlujoResumen.fromJson(json['resumen'] ?? {}),
      ingresos: FlujoSeccion.fromJson(json['ingresos'] ?? {}),
      egresos: FlujoSeccion.fromJson(json['egresos'] ?? {}),
    );
  }
}

// ===========================================
// Flujo Periodo
// ===========================================
class FlujoPeriodo {
  final int idPeriodo;
  final int idEmpresa;
  final String nombre;
  final int anio;
  final int mes;
  final String nombreMes;
  final String fechaInicio;
  final String fechaFin;
  final String estado;

  FlujoPeriodo({
    required this.idPeriodo,
    required this.idEmpresa,
    required this.nombre,
    required this.anio,
    required this.mes,
    required this.nombreMes,
    required this.fechaInicio,
    required this.fechaFin,
    required this.estado,
  });

  factory FlujoPeriodo.fromJson(Map<String, dynamic> json) {
    return FlujoPeriodo(
      idPeriodo: json['id_periodo'] ?? 0,
      idEmpresa: json['id_empresa'] ?? 0,
      nombre: json['nombre'] ?? '',
      anio: json['anio'] ?? 0,
      mes: json['mes'] ?? 0,
      nombreMes: json['nombre_mes'] ?? '',
      fechaInicio: json['fecha_inicio'] ?? '',
      fechaFin: json['fecha_fin'] ?? '',
      estado: json['estado'] ?? '',
    );
  }
}

// ===========================================
// Flujo Resumen
// ===========================================
class FlujoResumen {
  final double saldoInicial;
  final double totalIngresos;
  final double totalEgresos;
  final double flujoNeto;
  final double saldoFinalCalculado;
  final double saldoFinalRegistrado;

  final int cantidadIngresos;
  final int cantidadEgresos;
  final int cantidadMovimientos;

  FlujoResumen({
    required this.saldoInicial,
    required this.totalIngresos,
    required this.totalEgresos,
    required this.flujoNeto,
    required this.saldoFinalCalculado,
    required this.saldoFinalRegistrado,
    required this.cantidadIngresos,
    required this.cantidadEgresos,
    required this.cantidadMovimientos,
  });

  factory FlujoResumen.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0;
    }

    return FlujoResumen(
      saldoInicial: toDouble(json['saldo_inicial']),
      totalIngresos: toDouble(json['total_ingresos']),
      totalEgresos: toDouble(json['total_egresos']),
      flujoNeto: toDouble(json['flujo_neto']),
      saldoFinalCalculado: toDouble(json['saldo_final_calculado']),
      saldoFinalRegistrado: toDouble(json['saldo_final_registrado']),
      cantidadIngresos: json['cantidad_ingresos'] ?? 0,
      cantidadEgresos: json['cantidad_egresos'] ?? 0,
      cantidadMovimientos: json['cantidad_movimientos'] ?? 0,
    );
  }
}

// ===========================================
// Flujo Seccion
// ===========================================
class FlujoSeccion {
  final List<dynamic> categorias;
  final List<dynamic> detalle;
  final double total;
  final int cantidadMovimientos;

  FlujoSeccion({
    required this.categorias,
    required this.detalle,
    required this.total,
    required this.cantidadMovimientos,
  });

  factory FlujoSeccion.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0;
    }

    return FlujoSeccion(
      categorias: List<dynamic>.from(json['categorias'] ?? []),
      detalle: List<dynamic>.from(json['detalle'] ?? []),
      total: toDouble(json['total']),
      cantidadMovimientos: json['cantidad_movimientos'] ?? 0,
    );
  }
}
