import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Service
import 'package:app_aryoria/src/data/datasources/remote/services/flujo_contable_service.dart';

// Repository
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_anual.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_mensual.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_proyectado.dart';

class FlujoContableRepositoryImpl implements FlujoContableRepository {
  final FlujoContableService flujoContableService;
  final AuthRepository authRepository;

  FlujoContableRepositoryImpl({
    required this.flujoContableService,
    required this.authRepository,
  });

  // *********************************************************
  // 1.- Obtener Flujo Contable Mensual
  // *********************************************************
  @override
  Future<Resource<ApiResponse<FlujoContableMensualData>>>
  getFlujoContableMensual({
    required int idPeriodo,
    required int idEmpresa,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return flujoContableService.getFlujoContableMensual(
      idPeriodo: idPeriodo,
      idEmpresa: idEmpresa,
      token: token,
    );
  }

  // *********************************************************
  // 2.- Obtener Flujo Contable Anual
  // *********************************************************
  @override
  Future<Resource<ApiResponse<FlujoAnualData>>> getFlujoContableAnual({
    required int idEmpresa,
    required int anio,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }

    return flujoContableService.getFlujoAnual(
      idEmpresa: idEmpresa,
      anio: anio,
      token: token,
    );
  }

  // *********************************************************
  // 3.- Obtener Flujo Proyectado
  // *********************************************************
  @override
  Future<Resource<ApiResponse<FlujoProyectadoData>>> getFlujoProyectado({
    required int idPeriodo,
    required int idEmpresa,
  }) async {
    final token = await authRepository.getToken();

    if (token == null) {
      return ErrorData("No existe una sesión iniciada.");
    }
    return flujoContableService.getFlujoProyectado(
      idPeriodo: idPeriodo,
      idEmpresa: idEmpresa,
      token: token,
    );
  }
}
