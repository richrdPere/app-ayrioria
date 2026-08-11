// Services
import 'package:app_aryoria/src/data/datasources/remote/services/usuarios_service.dart';

// Repo
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_data.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_update_req.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_password_req.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/password_update_data.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/foto_perfil_update_data.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final UsuariosService usuariosService;
  final AuthRepository authRepository;

  UsuarioRepositoryImpl({
    required this.usuariosService,
    required this.authRepository,
  });

  // *********************************************************
  // 1.- Obtener perfil usuario
  // *********************************************************
  @override
  Future<Resource<ApiResponse<PerfilUsuarioData>>> getPerfilUsuario() async {
    final token = await authRepository.getToken();

    if (token == null || token.trim().isEmpty) {
      return const ErrorData<ApiResponse<PerfilUsuarioData>>(
        'No existe una sesión activa.',
      );
    }

    return usuariosService.getPerfilUsuario(token: token);
  }

  // *********************************************************
  // 2.- Actualizar perfil usuario
  // *********************************************************
  @override
  Future<Resource<ApiResponse<PerfilUsuarioData>>> updatePerfilUsuario({
    required PerfilUpdateRequest request,
  }) async {
    final token = await authRepository.getToken();

    if (token == null || token.trim().isEmpty) {
      return const ErrorData<ApiResponse<PerfilUsuarioData>>(
        'No existe una sesión activa.',
      );
    }

    return usuariosService.updatePerfilUsuario(token: token, request: request);
  }

  // *********************************************************
  // 3.- Actualizar contraseña
  // *********************************************************
  @override
  Future<Resource<ApiResponse<PasswordUpdateData>>> updatePasswordUsuario({
    required PasswordUpdateRequest request,
  }) async {
    final token = await authRepository.getToken();

    if (token == null || token.trim().isEmpty) {
      return const ErrorData<ApiResponse<PasswordUpdateData>>(
        'No existe una sesión activa.',
      );
    }

    return usuariosService.updatePasswordUsuario(
      token: token,
      request: request,
    );
  }

  // *********************************************************
  // 4.- Actualizar foto de perfil
  // *********************************************************
  @override
  Future<Resource<ApiResponse<FotoPerfilUpdateData>>> updateFotoUsuario({
    required String filePath,
  }) async {
    final token = await authRepository.getToken();

    if (token == null || token.trim().isEmpty) {
      return const ErrorData<ApiResponse<FotoPerfilUpdateData>>(
        'No existe una sesión activa.',
      );
    }

    if (filePath.trim().isEmpty) {
      return const ErrorData<ApiResponse<FotoPerfilUpdateData>>(
        'Debes seleccionar una imagen.',
      );
    }

    return usuariosService.updateFotoUsuario(token: token, filePath: filePath);
  }
}
