// Models
import 'package:app_aryoria/src/data/datasources/remote/services/reporte_service.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_categoria_response.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_evolucion_response.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_general_data.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_resumen_periodo_response.dart';

// Repositories
import 'package:app_aryoria/src/domain/repositories/reporte_repository.dart';
import 'package:app_aryoria/src/domain/repositories/auth_repository.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class ReporteRepositoryImpl implements ReporteRepository {
  final ReporteService reporteService;
  final AuthRepository authRepository;

  ReporteRepositoryImpl({
    required this.reporteService,
    required this.authRepository,
  });

  // *********************************************************
  // 1. Obtener reporte general
  // *********************************************************
  @override
  Future<Resource<ReporteGeneralData>> getReporteGeneral({
    required int idEmpresa,
    required int idPeriodo,
  }) async {
    try {
      final String? token = await authRepository.getToken();

      if (token == null || token.trim().isEmpty) {
        return ErrorData<ReporteGeneralData>(
          'No se encontró una sesión activa.',
        );
      }

      return await reporteService.getReporteGeneral(
        token: token,
        idEmpresa: idEmpresa,
        idPeriodo: idPeriodo,
      );
    } catch (error) {
      return ErrorData<ReporteGeneralData>(
        'No fue posible obtener el reporte general: $error',
      );
    }
  }

  // *********************************************************
  // 2. Obtener resumen del período
  // *********************************************************
  @override
  Future<Resource<ReporteResumenPeriodoResponse>> getResumenPeriodo({
    required int idEmpresa,
    required int idPeriodo,
  }) async {
    try {
      final String? token = await authRepository.getToken();

      if (token == null || token.trim().isEmpty) {
        return ErrorData<ReporteResumenPeriodoResponse>(
          'No se encontró una sesión activa.',
        );
      }

      return await reporteService.getResumenPeriodo(
        token: token,
        idEmpresa: idEmpresa,
        idPeriodo: idPeriodo,
      );
    } catch (error) {
      return ErrorData<ReporteResumenPeriodoResponse>(
        'No fue posible obtener el resumen del período: $error',
      );
    }
  }

  // *********************************************************
  // 3. Obtener evolución del período
  // *********************************************************
  @override
  Future<Resource<ReporteEvolucionResponse>> getEvolucionPeriodo({
    required int idEmpresa,
    required int idPeriodo,
  }) async {
    try {
      final String? token = await authRepository.getToken();

      if (token == null || token.trim().isEmpty) {
        return ErrorData<ReporteEvolucionResponse>(
          'No se encontró una sesión activa.',
        );
      }

      return await reporteService.getEvolucionPeriodo(
        token: token,
        idEmpresa: idEmpresa,
        idPeriodo: idPeriodo,
      );
    } catch (error) {
      return ErrorData<ReporteEvolucionResponse>(
        'No fue posible obtener la evolución del período: $error',
      );
    }
  }

  // *********************************************************
  // 4. Obtener reporte por categorías
  // *********************************************************
  @override
  Future<Resource<ReporteCategoriaResponse>> getReporteCategorias({
    required int idEmpresa,
    required int idPeriodo,
    String? tipo,
  }) async {
    try {
      final String? token = await authRepository.getToken();

      if (token == null || token.trim().isEmpty) {
        return ErrorData<ReporteCategoriaResponse>(
          'No se encontró una sesión activa.',
        );
      }

      final String? tipoNormalizado = tipo == null || tipo.trim().isEmpty
          ? null
          : tipo.trim().toUpperCase();

      if (tipoNormalizado != null &&
          tipoNormalizado != 'INGRESO' &&
          tipoNormalizado != 'EGRESO') {
        return ErrorData<ReporteCategoriaResponse>(
          'El tipo del reporte debe ser INGRESO o EGRESO.',
        );
      }

      return await reporteService.getReporteCategorias(
        token: token,
        idEmpresa: idEmpresa,
        idPeriodo: idPeriodo,
        tipo: tipoNormalizado,
      );
    } catch (error) {
      return ErrorData<ReporteCategoriaResponse>(
        'No fue posible obtener el reporte por categorías: $error',
      );
    }
  }
}
