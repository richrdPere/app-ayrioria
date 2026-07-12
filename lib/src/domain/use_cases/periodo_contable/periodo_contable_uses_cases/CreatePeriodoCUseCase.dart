import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_request.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_response.dart';
import 'package:app_aryoria/src/domain/repositories/periodo_contable_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class CreatePeriodoCUseCase {
  PeriodoContableRepository periodoCRepository;
  CreatePeriodoCUseCase(this.periodoCRepository);

  Future<Resource<PeriodoContableResponse>> run(PeriodoContableRequest req) =>
      periodoCRepository.createPeriodoContable(req);
}
