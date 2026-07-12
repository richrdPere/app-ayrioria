import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_paginated.dart';
import 'package:app_aryoria/src/domain/repositories/periodo_contable_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetPeriodoCUseCase {
  PeriodoContableRepository periodoCRepository;
  GetPeriodoCUseCase(this.periodoCRepository);

  Future<Resource<PeriodoContablePaginatedResponse>> run({
    required int idEmpresa,
    required Map<String, dynamic> queryParams,
  }) => periodoCRepository.getPeriodosContables(
    idEmpresa: idEmpresa,
    queryParams: queryParams,
  );
}
