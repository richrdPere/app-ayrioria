

import 'package:app_aryoria/src/domain/use_cases/index_uses_cases.dart';

class PeriodoContableUsesCases {
  ChangeEstadoPeriodoCUseCase changeEstadoPeriodoC;
  CreatePeriodoCUseCase createPeriodoC;
  DeletePeriodoCUseCase deletePeriodoC;
  GetPeriodoCByIdUseCase getPeriodoCById;
  GetPeriodoCUseCase getPeriodoC;
  UpdatePeriodoCUseCase updatePeriodoC;

  PeriodoContableUsesCases({
    required this.changeEstadoPeriodoC,
    required this.createPeriodoC,
    required this.deletePeriodoC,
    required this.getPeriodoCById,
    required this.getPeriodoC,
    required this.updatePeriodoC,
  });
}
