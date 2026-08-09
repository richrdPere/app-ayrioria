class FlujoProyectadoData {
  final FlujoProyectadoPeriodo periodo;

  final double saldoInicial;

  final FlujoProyectadoResumen ingresos;
  final FlujoProyectadoResumen egresos;

  final double flujoReal;
  final double flujoProyectado;

  final double saldoFinalReal;
  final double saldoFinalProyectado;

  FlujoProyectadoData({
    required this.periodo,
    required this.saldoInicial,
    required this.ingresos,
    required this.egresos,
    required this.flujoReal,
    required this.flujoProyectado,
    required this.saldoFinalReal,
    required this.saldoFinalProyectado,
  });

  factory FlujoProyectadoData.fromJson(Map<String, dynamic> json) {
    return FlujoProyectadoData(
      periodo: FlujoProyectadoPeriodo.fromJson(json['periodo'] ?? {}),

      saldoInicial: _toDouble(json['saldo_inicial']),

      ingresos: FlujoProyectadoResumen.fromJson(json['ingresos'] ?? {}),

      egresos: FlujoProyectadoResumen.fromJson(json['egresos'] ?? {}),

      flujoReal: _toDouble(json['flujo_real']),
      flujoProyectado: _toDouble(json['flujo_proyectado']),

      saldoFinalReal: _toDouble(json['saldo_final_real']),
      saldoFinalProyectado: _toDouble(json['saldo_final_proyectado']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'periodo': periodo.toJson(),
      'saldo_inicial': saldoInicial,
      'ingresos': ingresos.toJson(),
      'egresos': egresos.toJson(),
      'flujo_real': flujoReal,
      'flujo_proyectado': flujoProyectado,
      'saldo_final_real': saldoFinalReal,
      'saldo_final_proyectado': saldoFinalProyectado,
    };
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0;

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString()) ?? 0;
}

class FlujoProyectadoPeriodo {
  final int idPeriodo;
  final String nombre;
  final int anio;
  final int mes;
  final String estado;

  FlujoProyectadoPeriodo({
    required this.idPeriodo,
    required this.nombre,
    required this.anio,
    required this.mes,
    required this.estado,
  });

  factory FlujoProyectadoPeriodo.fromJson(Map<String, dynamic> json) {
    return FlujoProyectadoPeriodo(
      idPeriodo: json['id_periodo'] ?? 0,
      nombre: json['nombre'] ?? '',
      anio: json['anio'] ?? 0,
      mes: json['mes'] ?? 0,
      estado: json['estado'] ?? '',
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

class FlujoProyectadoResumen {
  final double pagados;
  final double pendientes;
  final double totalProyectado;

  final int cantidadPagados;
  final int cantidadPendientes;

  FlujoProyectadoResumen({
    required this.pagados,
    required this.pendientes,
    required this.totalProyectado,
    required this.cantidadPagados,
    required this.cantidadPendientes,
  });

  factory FlujoProyectadoResumen.fromJson(Map<String, dynamic> json) {
    return FlujoProyectadoResumen(
      pagados: _toDouble(json['pagados']),
      pendientes: _toDouble(json['pendientes']),
      totalProyectado: _toDouble(json['total_proyectado']),
      cantidadPagados: json['cantidad_pagados'] ?? 0,
      cantidadPendientes: json['cantidad_pendientes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pagados': pagados,
      'pendientes': pendientes,
      'total_proyectado': totalProyectado,
      'cantidad_pagados': cantidadPagados,
      'cantidad_pendientes': cantidadPendientes,
    };
  }
}
