import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_anual.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_mensual.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_proyectado.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

abstract class FlujoContableRepository {
  /// 1.- Obtener Flujo Contable Mensual
  Future<Resource<ApiResponse<FlujoContableMensualData>>>
  getFlujoContableMensual(
    {required int idPeriodo, required int idEmpresa});

  /// 2.- Obtener Flujo Contable Anual
  Future<Resource<ApiResponse<FlujoAnualData>>> getFlujoContableAnual({
    required int idEmpresa,
    required int anio,
  });

  /// 3.- Obtener Flujo Proyectado
  Future<Resource<ApiResponse<FlujoProyectadoData>>> getFlujoProyectado({
    required int idPeriodo,
    required int idEmpresa,
  });
}
