import 'package:app_aryoria/src/domain/use_cases/periodo_contable/periodo_contable_uses_cases/ChangeEstadoPeriodoCUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/periodo_contable/periodo_contable_uses_cases/CreatePeriodoCUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/periodo_contable/periodo_contable_uses_cases/DeletePeriodoCUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/periodo_contable/periodo_contable_uses_cases/GetPeriodoCByIdUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/periodo_contable/periodo_contable_uses_cases/GetPeriodoCUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/periodo_contable/periodo_contable_uses_cases/UpdatePeriodoCUseCase.dart';

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
