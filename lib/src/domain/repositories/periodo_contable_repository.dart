import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_data.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_paginated.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_query_params.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_request.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

abstract class PeriodoContableRepository {
  /// 1. CREAR PERÍODO CONTABLE
  Future<Resource<ApiResponse<PeriodoContableData>>> createPeriodoContable(
    PeriodoContableRequest request,
  );

  /// 2. LISTAR PERÍODOS CONTABLES
  Future<Resource<ApiResponse<PeriodoContablePaginated>>> getPeriodosContables({
    required int idEmpresa,
    required PeriodosContablesParams queryParams,
  });

  /// 3. OBTENER PERÍODO POR ID
  Future<Resource<ApiResponse<PeriodoContableData>>> getPeriodoContableById({
    required int idPeriodo,
    required int idEmpresa,
  });

  /// 4. ACTUALIZAR PERÍODO CONTABLE
  Future<Resource<ApiResponse<PeriodoContableData>>> updatePeriodoContable({
    required int idPeriodo,
    required int idEmpresa,
    required PeriodoContableRequest request,
  });

  /// 5. ELIMINAR PERÍODO CONTABLE
  Future<Resource<ApiResponse<void>>> deletePeriodoContable({
    required int idPeriodo,
    required int idEmpresa,
  });

  /// 6. CAMBIAR ESTADO
  Future<Resource<ApiResponse<PeriodoContableData>>>
  changeEstadoPeriodoContable({
    required int idPeriodo,
    required int idEmpresa,
    required String estado,
  });
}
