import 'reporte_categoria_data.dart';
import 'reporte_periodo_data.dart';
import 'reporte_resumen_data.dart';

class ReporteCategoriaResponse {
  final ReportePeriodoData periodo;
  final ReporteResumenData resumen;

  final List<ReporteCategoriaData> categorias;
  final List<ReporteCategoriaData> categoriasIngreso;
  final List<ReporteCategoriaData> categoriasEgreso;

  const ReporteCategoriaResponse({
    required this.periodo,
    required this.resumen,
    required this.categorias,
    required this.categoriasIngreso,
    required this.categoriasEgreso,
  });

  factory ReporteCategoriaResponse.fromJson(Map<String, dynamic> json) {
    return ReporteCategoriaResponse(
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
    );
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
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
}
