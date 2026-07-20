import 'reporte_evolucion_data.dart';
import 'reporte_periodo_data.dart';
import 'reporte_resumen_data.dart';

class ReporteEvolucionResponse {
  final ReportePeriodoData periodo;
  final ReporteResumenData resumen;
  final List<ReporteEvolucionData> evolucion;

  const ReporteEvolucionResponse({
    required this.periodo,
    required this.resumen,
    required this.evolucion,
  });

  factory ReporteEvolucionResponse.fromJson(Map<String, dynamic> json) {
    return ReporteEvolucionResponse(
      periodo: ReportePeriodoData.fromJson(_mapFrom(json['periodo'])),
      resumen: ReporteResumenData.fromJson(_mapFrom(json['resumen'])),
      evolucion: _listFrom(
        json['evolucion'],
      ).map(ReporteEvolucionData.fromJson).toList(),
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
