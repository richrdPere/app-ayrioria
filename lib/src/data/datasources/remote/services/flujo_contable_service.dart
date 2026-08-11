// ignore_for_file: non_constant_identifier_names, unnecessary_this

// Environment
import 'package:http/http.dart' as http;
import 'package:app_aryoria/src/config/constants/environment.dart'
    as url_backend;

// Helpers
import 'package:app_aryoria/src/data/datasources/remote/services/helpers/http_Service_helper.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_anual.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_mensual.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_proyectado.dart';

class FlujoContableService {
  String get API_BASE => '${url_backend.Environment.mainUrl}/flujo-contable';

  String get API_GET_FLUJO_CONTABLE_MENSUAL => '$API_BASE/mensual';
  String get API_GET_FLUJO_CONTABLE_ANUAL => '$API_BASE/anual';
  String get API_GET_FLUJO_PROYECTADO => '$API_BASE/proyectado';

  // *********************************************************
  // 1.- Obtener Flujo Contable Mensual
  // *********************************************************
  Future<Resource<ApiResponse<FlujoContableMensualData>>>
  getFlujoContableMensual({
    required int idPeriodo,
    required int idEmpresa,
    required String token,
  }) async {
    try {
      final uri = Uri.parse(
        '$API_GET_FLUJO_CONTABLE_MENSUAL/$idPeriodo',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<FlujoContableMensualData>.fromJson(
          body,
          (rawData) {
            return FlujoContableMensualData.fromJson(
              Map<String, dynamic>.from(rawData),
            );
          },
        );

        return Success<ApiResponse<FlujoContableMensualData>>(apiResponse);
      }

      return HttpServiceHelper.buildError<
        ApiResponse<FlujoContableMensualData>
      >(body, response.statusCode);
    } catch (error) {
      return ErrorData<ApiResponse<FlujoContableMensualData>>(
        'Error al obtener el flujo contable mensual: $error',
      );
    }
  }

  // *********************************************************
  // 2.- Obtener Flujo Contable Anual
  // *********************************************************
  Future<Resource<ApiResponse<FlujoAnualData>>> getFlujoAnual({
    required int idEmpresa,
    required int anio,
    required String token,
  }) async {
    try {
      final uri = Uri.parse(API_GET_FLUJO_CONTABLE_ANUAL).replace(
        queryParameters: {
          'id_empresa': idEmpresa.toString(),
          'anio': anio.toString(),
        },
      );

      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<FlujoAnualData>.fromJson(body, (
          rawData,
        ) {
          return FlujoAnualData.fromJson(Map<String, dynamic>.from(rawData));
        });

        return Success<ApiResponse<FlujoAnualData>>(apiResponse);
      }

      return HttpServiceHelper.buildError<ApiResponse<FlujoAnualData>>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<ApiResponse<FlujoAnualData>>(
        'Error al obtener el flujo contable mensual: $error',
      );
    }
  }

  // *********************************************************
  // 3.- Obtener Flujo Contable Anual
  // *********************************************************
  Future<Resource<ApiResponse<FlujoProyectadoData>>> getFlujoProyectado({
    required int idPeriodo,
    required int idEmpresa,
    required String token,
  }) async {
    try {
      final uri = Uri.parse(
        '$API_GET_FLUJO_PROYECTADO/$idPeriodo',
      ).replace(queryParameters: {'id_empresa': idEmpresa.toString()});

      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<FlujoProyectadoData>.fromJson(body, (
          rawData,
        ) {
          return FlujoProyectadoData.fromJson(
            Map<String, dynamic>.from(rawData),
          );
        });

        return Success<ApiResponse<FlujoProyectadoData>>(apiResponse);
      }

      return HttpServiceHelper.buildError<ApiResponse<FlujoProyectadoData>>(
        body,
        response.statusCode,
      );
    } catch (error) {
      return ErrorData<ApiResponse<FlujoProyectadoData>>(
        'Error al obtener el flujo contable mensual: $error',
      );
    }
  }
}
