import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_paginated.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_request.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_response.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

abstract class PeriodoContableRepository {
  /// 1. CREAR PERÍODO CONTABLE
  Future<Resource<PeriodoContableResponse>> createPeriodoContable(
    PeriodoContableRequest request,
  );

  /// 2. LISTAR PERÍODOS CONTABLES
  Future<Resource<PeriodoContablePaginatedResponse>> getPeriodosContables({
    required int idEmpresa,
    required Map<String, dynamic> queryParams,
  });

  /// 3. OBTENER PERÍODO POR ID
  Future<Resource<PeriodoContableResponse>> getPeriodoContableById({
    required int idPeriodo,
    required int idEmpresa,
  });

  /// 4. ACTUALIZAR PERÍODO CONTABLE
  Future<Resource<PeriodoContableResponse>> updatePeriodoContable({
    required int idPeriodo,
    required int idEmpresa,
    required PeriodoContableRequest request,
  });

  /// 5. ELIMINAR PERÍODO CONTABLE
  Future<Resource<PeriodoContableResponse>> deletePeriodoContable({
    required int idPeriodo,
    required int idEmpresa,
  });

  /// 6. CAMBIAR ESTADO
  Future<Resource<PeriodoContableResponse>> changeEstadoPeriodoContable({
    required int idPeriodo,
    required int idEmpresa,
    required String estado,
  });
}
