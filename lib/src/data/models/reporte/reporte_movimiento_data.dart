import 'reporte_categoria_data.dart';

class ReporteMovimientoData {
  final int idMovimiento;
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

  final String estado;
  final bool activo;

  final String createdAt;
  final String updatedAt;

  final ReporteCategoriaInfoData? categoria;

  const ReporteMovimientoData({
    required this.idMovimiento,
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
    required this.estado,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
    this.categoria,
  });

  factory ReporteMovimientoData.fromJson(Map<String, dynamic> json) {
    final categoriaJson = json['categoria'];

    return ReporteMovimientoData(
      idMovimiento: _parseInt(json['id_movimiento']),
      idEmpresa: _parseInt(json['id_empresa']),
      idCategoria: _parseInt(json['id_categoria']),
      idUsuario: _parseInt(json['id_usuario']),
      idPeriodo: _parseInt(json['id_periodo']),
      tipo: json['tipo']?.toString() ?? '',
      fecha: json['fecha']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      monto: _parseDouble(json['monto']),
      observacion: json['observacion']?.toString(),
      comprobante: json['comprobante']?.toString(),
      estado: json['estado']?.toString() ?? '',
      activo: _parseBool(json['activo']),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      categoria: categoriaJson is Map
          ? ReporteCategoriaInfoData.fromJson(
              Map<String, dynamic>.from(categoriaJson),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_movimiento': idMovimiento,
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
      'estado': estado,
      'activo': activo,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'categoria': categoria?.toJson(),
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
