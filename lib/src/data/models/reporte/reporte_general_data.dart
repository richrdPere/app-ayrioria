import 'reporte_categoria_data.dart';
import 'reporte_evolucion_data.dart';
import 'reporte_movimiento_data.dart';
import 'reporte_periodo_data.dart';
import 'reporte_resumen_data.dart';

class ReporteGeneralData {
  final ReportePeriodoData periodo;
  final ReporteResumenData resumen;

  final List<ReporteCategoriaData> categorias;
  final List<ReporteCategoriaData> categoriasIngreso;
  final List<ReporteCategoriaData> categoriasEgreso;

  final List<ReporteEvolucionData> evolucion;
  final List<ReporteMovimientoData> ultimosMovimientos;

  const ReporteGeneralData({
    required this.periodo,
    required this.resumen,
    required this.categorias,
    required this.categoriasIngreso,
    required this.categoriasEgreso,
    required this.evolucion,
    required this.ultimosMovimientos,
  });

  factory ReporteGeneralData.fromJson(Map<String, dynamic> json) {
    return ReporteGeneralData(
      periodo: ReportePeriodoData.fromJson(_mapFrom(json['periodo'])),
      resumen: ReporteResumenData.fromJson(_mapFrom(json['resumen'])),
      categorias: _listFrom(
        json['categorias'],
      ).map(ReporteCategoriaData.fromJson).toList(),
      categoriasIngreso: _listFrom(
        json['categorias_ingreso'],
      ).map(ReporteCategoriaData.fromJson).toList(),
      categoriasEgreso: _listFrom(
        json['categorias_egreso'],
      ).map(ReporteCategoriaData.fromJson).toList(),
      evolucion: _listFrom(
        json['evolucion'],
      ).map(ReporteEvolucionData.fromJson).toList(),
      ultimosMovimientos: _listFrom(
        json['ultimos_movimientos'],
      ).map(ReporteMovimientoData.fromJson).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'periodo': periodo.toJson(),
      'resumen': resumen.toJson(),
      'categorias': categorias.map((e) => e.toJson()).toList(),
      'categorias_ingreso': categoriasIngreso.map((e) => e.toJson()).toList(),
      'categorias_egreso': categoriasEgreso.map((e) => e.toJson()).toList(),
      'evolucion': evolucion.map((e) => e.toJson()).toList(),
      'ultimos_movimientos': ultimosMovimientos.map((e) => e.toJson()).toList(),
    };
  }
}

Map<String, dynamic> _mapFrom(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return <String, dynamic>{};
}

List<Map<String, dynamic>> _listFrom(dynamic value) {
  if (value is! List) {
    return [];
  }

  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}
