import 'package:app_aryoria/src/data/models/reporte/reporte_categoria_response.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_evolucion_response.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_general_data.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_resumen_periodo_response.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

abstract class ReporteRepository {
  /// 1. Obtiene el reporte completo de una empresa y período.
  Future<Resource<ReporteGeneralData>> getReporteGeneral({
    required int idEmpresa,
    required int idPeriodo,
  });

  /// 2. Obtiene solamente el resumen financiero del período.
  Future<Resource<ReporteResumenPeriodoResponse>> getResumenPeriodo({
    required int idEmpresa,
    required int idPeriodo,
  });

  /// 3. Obtiene la evolución diaria de ingresos y egresos.
  Future<Resource<ReporteEvolucionResponse>> getEvolucionPeriodo({
    required int idEmpresa,
    required int idPeriodo,
  });

  /// 4. Obtiene los movimientos agrupados por categoría.
  ///
  /// [tipo] puede ser:
  /// - INGRESO
  /// - EGRESO
  /// - null para obtener ambos
  Future<Resource<ReporteCategoriaResponse>> getReporteCategorias({
    required int idEmpresa,
    required int idPeriodo,
    String? tipo,
  });
}
