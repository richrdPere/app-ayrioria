import 'package:app_aryoria/src/domain/use_cases/reporte/reporte_uses_cases/GetEvolucionPeriodoUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/reporte/reporte_uses_cases/GetReporteCategoriasUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/reporte/reporte_uses_cases/GetReporteGeneralUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/reporte/reporte_uses_cases/GetResumenPeriodoUseCase.dart';

class ReporteUsesCases {
  GetEvolucionPeriodoUseCase getEvolucionPeriodo;
  GetReporteCategoriasUseCase getReporteCategorias;
  GetReporteGeneralUseCase getReporteGeneral;
  GetResumenPeriodoUseCase getResumenPeriodo;

  ReporteUsesCases({
    required this.getEvolucionPeriodo,
    required this.getReporteCategorias,
    required this.getReporteGeneral,
    required this.getResumenPeriodo,
  });
}
