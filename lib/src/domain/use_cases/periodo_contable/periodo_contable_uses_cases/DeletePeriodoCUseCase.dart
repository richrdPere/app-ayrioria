import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_response.dart';
import 'package:app_aryoria/src/domain/repositories/periodo_contable_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class DeletePeriodoCUseCase {
  PeriodoContableRepository periodoCRepository;
  DeletePeriodoCUseCase(this.periodoCRepository);

  Future<Resource<PeriodoContableResponse>> run({
    required int idPeriodo,
    required int idEmpresa,
  }) => periodoCRepository.deletePeriodoContable(
    idPeriodo: idPeriodo,
    idEmpresa: idEmpresa,
  );
}
