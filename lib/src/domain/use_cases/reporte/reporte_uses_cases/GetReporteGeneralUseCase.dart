import 'package:app_aryoria/src/data/models/reporte/reporte_general_data.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetReporteGeneralUseCase {
  ReporteRepository reporteRepository;
  GetReporteGeneralUseCase(this.reporteRepository);

  Future<Resource<ReporteGeneralData>> run({
    required int idEmpresa,
    required int idPeriodo,
  }) => reporteRepository.getReporteGeneral(
    idEmpresa: idEmpresa,
    idPeriodo: idPeriodo,
  );
}
