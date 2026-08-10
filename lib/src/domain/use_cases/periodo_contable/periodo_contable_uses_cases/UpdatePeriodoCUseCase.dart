import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_data.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_request.dart';
import 'package:app_aryoria/src/domain/repositories/periodo_contable_repository.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

class UpdatePeriodoCUseCase {
  PeriodoContableRepository periodoCRepository;
  UpdatePeriodoCUseCase(this.periodoCRepository);

  Future<Resource<ApiResponse<PeriodoContableData>>> run({
    required int idPeriodo,
    required int idEmpresa,
    required PeriodoContableRequest request,
  }) => periodoCRepository.updatePeriodoContable(
    idPeriodo: idPeriodo,
    idEmpresa: idEmpresa,
    request: request,
  );
}
