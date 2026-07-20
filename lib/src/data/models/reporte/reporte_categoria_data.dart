class ReporteCategoriaInfoData {
  final int idCategoria;
  final String nombre;
  final String tipo;
  final String? descripcion;
  final String color;
  final String icono;

  const ReporteCategoriaInfoData({
    required this.idCategoria,
    required this.nombre,
    required this.tipo,
    this.descripcion,
    required this.color,
    required this.icono,
  });

  factory ReporteCategoriaInfoData.fromJson(Map<String, dynamic> json) {
    return ReporteCategoriaInfoData(
      idCategoria: _parseInt(json['id_categoria']),
      nombre: json['nombre']?.toString() ?? 'Sin categoría',
      tipo: json['tipo']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      color: json['color']?.toString() ?? '#9E9E9E',
      icono: json['icono']?.toString() ?? 'category',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_categoria': idCategoria,
      'nombre': nombre,
      'tipo': tipo,
      'descripcion': descripcion,
      'color': color,
      'icono': icono,
    };
  }
}

class ReporteCategoriaData {
  final int idCategoria;
  final String tipo;
  final ReporteCategoriaInfoData categoria;

  final double total;
  final double porcentaje;

  final int cantidadMovimientos;

  final double promedioMovimiento;
  final double montoMinimo;
  final double montoMaximo;

  const ReporteCategoriaData({
    required this.idCategoria,
    required this.tipo,
    required this.categoria,
    required this.total,
    required this.porcentaje,
    required this.cantidadMovimientos,
    required this.promedioMovimiento,
    required this.montoMinimo,
    required this.montoMaximo,
  });

  factory ReporteCategoriaData.fromJson(Map<String, dynamic> json) {
    final categoriaJson = json['categoria'];

    return ReporteCategoriaData(
      idCategoria: _parseInt(json['id_categoria']),
      tipo: json['tipo']?.toString() ?? '',
      categoria: categoriaJson is Map
          ? ReporteCategoriaInfoData.fromJson(
              Map<String, dynamic>.from(categoriaJson),
            )
          : ReporteCategoriaInfoData(
              idCategoria: _parseInt(json['id_categoria']),
              nombre: 'Sin categoría',
              tipo: json['tipo']?.toString() ?? '',
              color: '#9E9E9E',
              icono: 'category',
            ),
      total: _parseDouble(json['total']),
      porcentaje: _parseDouble(json['porcentaje']),
      cantidadMovimientos: _parseInt(json['cantidad_movimientos']),
      promedioMovimiento: _parseDouble(json['promedio_movimiento']),
      montoMinimo: _parseDouble(json['monto_minimo']),
      montoMaximo: _parseDouble(json['monto_maximo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_categoria': idCategoria,
      'tipo': tipo,
      'categoria': categoria.toJson(),
      'total': total,
      'porcentaje': porcentaje,
      'cantidad_movimientos': cantidadMovimientos,
      'promedio_movimiento': promedioMovimiento,
      'monto_minimo': montoMinimo,
      'monto_maximo': montoMaximo,
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
