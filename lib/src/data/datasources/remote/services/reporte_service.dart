// ignore_for_file: non_constant_identifier_names, unnecessary_this

// Environment
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:app_aryoria/src/config/constants/environment.dart'
    as url_backend;

// Helpers
import 'package:app_aryoria/src/data/datasources/remote/services/helpers/http_Service_helper.dart';

// Models
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_categoria_response.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_evolucion_response.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_general_data.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_resumen_periodo_response.dart';

class ReporteService {
  // APIS
  String get API_BASE => '${url_backend.Environment.mainUrl}/reportes';

  String get API_GET_REPORTE_GENERAL => '$API_BASE/general';
  String get API_GET_EVOLUCION_PERIODO => '$API_BASE/evolucion-periodo';
  String get API_GET_CATEGORIAS => '$API_BASE/categorias';
  String get API_GET_RESUMEN_PERIODO => '$API_BASE/resumen-periodo';

  // *********************************************************
  // 1. Obtener reporte general
  // *********************************************************
  Future<Resource<ReporteGeneralData>> getReporteGeneral({
    required String token,
    required int idEmpresa,
    required int idPeriodo,
  }) async {
    try {
      final uri = Uri.parse(API_GET_REPORTE_GENERAL).replace(
        queryParameters: {
          'id_empresa': idEmpresa.toString(),
          'id_periodo': idPeriodo.toString(),
        },
      );

      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final data = body['data'];

        debugPrint('REPORTE GENERAL: $data');

        if (data is! Map) {
          return ErrorData<ReporteGeneralData>(
            'La respuesta del reporte general no contiene datos válidos.',
          );
        }

        return Success<ReporteGeneralData>(
          ReporteGeneralData.fromJson(Map<String, dynamic>.from(data)),
        );
      }

      return HttpServiceHelper.buildError<ReporteGeneralData>(
        body,
        response.statusCode,
      );
    } catch (error, stackTrace) {
      debugPrint('ERROR GET REPORTE GENERAL: $error');
      debugPrintStack(stackTrace: stackTrace);

      return ErrorData<ReporteGeneralData>(
        'No fue posible obtener el reporte general.',
      );
    }
  }

  // *********************************************************
  // 2. Obtener resumen del período
  // *********************************************************
  Future<Resource<ReporteResumenPeriodoResponse>> getResumenPeriodo({
    required String token,
    required int idEmpresa,
    required int idPeriodo,
  }) async {
    try {
      final uri = Uri.parse(API_GET_RESUMEN_PERIODO).replace(
        queryParameters: {
          'id_empresa': idEmpresa.toString(),
          'id_periodo': idPeriodo.toString(),
        },
      );

      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      debugPrint('RESUMEN PERIODO: $body');

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        //  final data = _extractData(body);

        return Success<ReporteResumenPeriodoResponse>(
          ReporteResumenPeriodoResponse.fromJson(body),
        );
      }

      return HttpServiceHelper.buildError<ReporteResumenPeriodoResponse>(
        body,
        response.statusCode,
      );
    } catch (error, stackTrace) {
      debugPrint('ERROR GET RESUMEN PERIODO: $error');
      debugPrintStack(stackTrace: stackTrace);

      return ErrorData<ReporteResumenPeriodoResponse>(
        'No fue posible obtener el resumen del período.',
      );
    }
  }

  // *********************************************************
  // 3. Obtener evolución del período
  // *********************************************************
  Future<Resource<ReporteEvolucionResponse>> getEvolucionPeriodo({
    required String token,
    required int idEmpresa,
    required int idPeriodo,
  }) async {
    try {
      final uri = Uri.parse(API_GET_EVOLUCION_PERIODO).replace(
        queryParameters: {
          'id_empresa': idEmpresa.toString(),
          'id_periodo': idPeriodo.toString(),
        },
      );

      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      debugPrint('EVOLUCION PERIODO: $body');

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        // final data = _extractData(body);

        return Success<ReporteEvolucionResponse>(
          ReporteEvolucionResponse.fromJson(body),
        );
      }

      return HttpServiceHelper.buildError<ReporteEvolucionResponse>(
        body,
        response.statusCode,
      );
    } catch (error, stackTrace) {
      debugPrint('ERROR GET EVOLUCION PERIODO: $error');
      debugPrintStack(stackTrace: stackTrace);

      return ErrorData<ReporteEvolucionResponse>(
        'No fue posible obtener la evolución del período.',
      );
    }
  }

  // *********************************************************
  // 4. Obtener reporte por categorías
  // *********************************************************
  Future<Resource<ReporteCategoriaResponse>> getReporteCategorias({
    required String token,
    required int idEmpresa,
    required int idPeriodo,
    String? tipo,
  }) async {
    try {
      final queryParameters = <String, String>{
        'id_empresa': idEmpresa.toString(),
        'id_periodo': idPeriodo.toString(),
      };

      final tipoNormalizado = tipo?.trim().toUpperCase();

      if (tipoNormalizado != null && tipoNormalizado.isNotEmpty) {
        queryParameters['tipo'] = tipoNormalizado;
      }

      final uri = Uri.parse(
        API_GET_CATEGORIAS,
      ).replace(queryParameters: queryParameters);

      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      debugPrint('REPORTE CATEGORIAS: $body');

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        // final data = _extractData(body);

        return Success<ReporteCategoriaResponse>(
          ReporteCategoriaResponse.fromJson(body),
        );
      }

      return HttpServiceHelper.buildError<ReporteCategoriaResponse>(
        body,
        response.statusCode,
      );
    } catch (error, stackTrace) {
      debugPrint('ERROR GET REPORTE CATEGORIAS: $error');
      debugPrintStack(stackTrace: stackTrace);

      return ErrorData<ReporteCategoriaResponse>(
        'No fue posible obtener el reporte por categorías.',
      );
    }
  }
}
