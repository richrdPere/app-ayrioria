import 'package:app_aryoria/src/data/models/reporte/reporte_evolucion_response.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetEvolucionPeriodoUseCase {
  ReporteRepository reporteRepository;
  GetEvolucionPeriodoUseCase(this.reporteRepository);

  Future<Resource<ReporteEvolucionResponse>> run({
    required int idEmpresa,
    required int idPeriodo,
  }) => reporteRepository.getEvolucionPeriodo(
    idEmpresa: idEmpresa,
    idPeriodo: idPeriodo,
  );
}
