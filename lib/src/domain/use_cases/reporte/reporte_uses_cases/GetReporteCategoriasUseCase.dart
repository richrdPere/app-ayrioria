import 'package:app_aryoria/src/data/models/reporte/reporte_categoria_response.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetReporteCategoriasUseCase {
  ReporteRepository reporteRepository;
  GetReporteCategoriasUseCase(this.reporteRepository);

  Future<Resource<ReporteCategoriaResponse>> run({
    required int idEmpresa,
    required int idPeriodo,
    String? tipo,
  }) => reporteRepository.getReporteCategorias(
    idEmpresa: idEmpresa,
    idPeriodo: idPeriodo,
    tipo: tipo,
  );
}
