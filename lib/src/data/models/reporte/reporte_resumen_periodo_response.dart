import 'reporte_periodo_data.dart';
import 'reporte_resumen_data.dart';

class ReporteResumenPeriodoResponse {
  final ReportePeriodoData periodo;
  final ReporteResumenData resumen;
  final String generadoEn;

  const ReporteResumenPeriodoResponse({
    required this.periodo,
    required this.resumen,
    required this.generadoEn,
  });

  factory ReporteResumenPeriodoResponse.fromJson(Map<String, dynamic> json) {
    return ReporteResumenPeriodoResponse(
      periodo: ReportePeriodoData.fromJson(_mapFrom(json['periodo'])),
      resumen: ReporteResumenData.fromJson(_mapFrom(json['resumen'])),
      generadoEn: json['generado_en']?.toString() ?? '',
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
