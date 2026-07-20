import 'package:app_aryoria/src/data/models/reporte/reporte_resumen_periodo_response.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetResumenPeriodoUseCase {
  ReporteRepository reporteRepository;
  GetResumenPeriodoUseCase(this.reporteRepository);

  Future<Resource<ReporteResumenPeriodoResponse>> run({
    required int idEmpresa,
    required int idPeriodo,
  }) => reporteRepository.getResumenPeriodo(
    idEmpresa: idEmpresa,
    idPeriodo: idPeriodo,
  );
}
