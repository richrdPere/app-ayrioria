// lib/src/domain/repositories/usuario_repository.dart

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_data.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_update_req.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_password_req.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/password_update_data.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/foto_perfil_update_data.dart';

abstract class UsuarioRepository {
  /// 1.- Obtener perfil usuario
  Future<Resource<ApiResponse<PerfilUsuarioData>>> getPerfilUsuario();

  /// 2.- Actualizar perfil usuario
  Future<Resource<ApiResponse<PerfilUsuarioData>>> updatePerfilUsuario({
    required PerfilUpdateRequest request,
  });

  /// 3.- Actualizar contraseña
  Future<Resource<ApiResponse<PasswordUpdateData>>> updatePasswordUsuario({
    required PasswordUpdateRequest request,
  });

  /// 4.- Actualizar foto de perfil
  Future<Resource<ApiResponse<FotoPerfilUpdateData>>> updateFotoUsuario({
    required String filePath,
  });
}
