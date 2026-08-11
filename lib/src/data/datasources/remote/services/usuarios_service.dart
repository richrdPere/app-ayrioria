// ignore_for_file: non_constant_identifier_names, unnecessary_this

// Environment
import 'dart:convert';
import 'package:app_aryoria/src/config/constants/environment.dart'
    as url_backend;
import 'package:app_aryoria/src/data/models/usuario-perfil/foto_perfil_update_data.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/password_update_data.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_password_req.dart';
import 'package:http/http.dart' as http;

// Helpers
import 'package:app_aryoria/src/data/datasources/remote/services/helpers/http_Service_helper.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_data.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_update_req.dart';

class UsuariosService {
  // APIS
  String get API_BASE => '${url_backend.Environment.mainUrl}/usuarios';

  String get API_GET_USUARIO_PERFIL => '$API_BASE/perfil';
  String get API_PUT_USUARIO_PERFIL => '$API_BASE/perfil';
  String get API_PATCH_USUARIO_PASSWORD => '$API_BASE/password';
  String get API_PATCH_USUARIO_PHOTO => '$API_BASE/foto';

  // *********************************************************
  // 1.- Obtener perfil usuario
  // *********************************************************
  Future<Resource<ApiResponse<PerfilUsuarioData>>> getPerfilUsuario({
    required String token,
  }) async {
    try {
      // 1.- URL
      final uri = Uri.parse(API_GET_USUARIO_PERFIL);

      // 2.- Response
      final response = await http.get(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Return JSON
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<PerfilUsuarioData>.fromJson(body, (
          rawData,
        ) {
          return PerfilUsuarioData.fromJson(Map<String, dynamic>.from(rawData));
        });

        return Success<ApiResponse<PerfilUsuarioData>>(apiResponse);
      }

      // 4.- Return Error
      return HttpServiceHelper.buildError<ApiResponse<PerfilUsuarioData>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      return ErrorData<ApiResponse<PerfilUsuarioData>>(
        'No se pudo obtener el perfil del usuario: $e',
      );
    }
  }

  // *********************************************************
  // 2.- Actualizar perfil usuario
  // *********************************************************
  Future<Resource<ApiResponse<PerfilUsuarioData>>> updatePerfilUsuario({
    required String token,
    required PerfilUpdateRequest request,
  }) async {
    try {
      // 1.- URL
      final uri = Uri.parse(API_PUT_USUARIO_PERFIL);

      // 2.- Response
      final response = await http.put(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode(request.toJson()),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Success
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<PerfilUsuarioData>.fromJson(body, (
          rawData,
        ) {
          return PerfilUsuarioData.fromJson(Map<String, dynamic>.from(rawData));
        });

        return Success<ApiResponse<PerfilUsuarioData>>(apiResponse);
      }

      // 4.- Error backend
      return HttpServiceHelper.buildError<ApiResponse<PerfilUsuarioData>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      return ErrorData<ApiResponse<PerfilUsuarioData>>(
        'No se pudo actualizar el perfil del usuario.',
        error: e.toString(),
      );
    }
  }

  // *********************************************************
  // 3.- Actualizar contraseña
  // *********************************************************
  Future<Resource<ApiResponse<PasswordUpdateData>>> updatePasswordUsuario({
    required String token,
    required PasswordUpdateRequest request,
  }) async {
    try {
      // 1.- URL
      final uri = Uri.parse(API_PATCH_USUARIO_PASSWORD);

      // 2.- Response
      final response = await http.patch(
        uri,
        headers: HttpServiceHelper.getHeaders(token),
        body: jsonEncode(request.toJson()),
      );

      final body = HttpServiceHelper.decodeResponse(response);

      // 3.- Success
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<PasswordUpdateData>.fromJson(body, (
          rawData,
        ) {
          return PasswordUpdateData.fromJson(
            Map<String, dynamic>.from(rawData),
          );
        });

        return Success<ApiResponse<PasswordUpdateData>>(apiResponse);
      }

      // 4.- Error backend
      return HttpServiceHelper.buildError<ApiResponse<PasswordUpdateData>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      return ErrorData<ApiResponse<PasswordUpdateData>>(
        'No se pudo actualizar la contraseña.',
        error: e.toString(),
      );
    }
  }

  // *********************************************************
  // 4.- Actualizar foto de perfil
  // *********************************************************
  Future<Resource<ApiResponse<FotoPerfilUpdateData>>> updateFotoUsuario({
    required String token,
    required String filePath,
  }) async {
    try {
      // 1.- URL
      final uri = Uri.parse(API_PATCH_USUARIO_PHOTO);

      // 2.- REQUEST MULTIPART
      final request = http.MultipartRequest('PATCH', uri);

      // 3.- HEADERS
      request.headers.addAll({'Authorization': 'Bearer $token'});

      // 4.- ARCHIVO
      final multipartFile = await http.MultipartFile.fromPath('foto', filePath);
      request.files.add(multipartFile);

      // 5.- ENVIAR REQUEST
      final streamedResponse = await request.send();

      // 6.- CONVERTIR STREAMED RESPONSE
      final response = await http.Response.fromStream(streamedResponse);
      final body = HttpServiceHelper.decodeResponse(response);

      // 7.- SUCCESS
      if (HttpServiceHelper.isSuccess(response.statusCode)) {
        final apiResponse = ApiResponse<FotoPerfilUpdateData>.fromJson(body, (
          rawData,
        ) {
          return FotoPerfilUpdateData.fromJson(
            Map<String, dynamic>.from(rawData),
          );
        });

        return Success<ApiResponse<FotoPerfilUpdateData>>(apiResponse);
      }

      // 8.- ERROR BACKEND
      return HttpServiceHelper.buildError<ApiResponse<FotoPerfilUpdateData>>(
        body,
        response.statusCode,
      );
    } catch (e) {
      return ErrorData<ApiResponse<FotoPerfilUpdateData>>(
        'No se pudo actualizar la foto de perfil.',
        error: e.toString(),
      );
    }
  }
}
