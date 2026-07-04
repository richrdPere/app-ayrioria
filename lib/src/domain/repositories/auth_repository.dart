// Model

import 'package:app_aryoria/src/data/models/login/auth_response.dart';
import 'package:app_aryoria/src/data/models/register/register_request.dart';
import 'package:app_aryoria/src/data/models/register/register_response.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

abstract class AuthRepository {
  /// Obtener sesión almacenada localmente
  Future<AuthResponse?> getUserSession();

  /// Guardar sesión del usuario
  Future<void> saveUserSession(AuthResponse authResponse);

  /// Login
  Future<Resource<AuthResponse>> login(String username, String password);

  /// Registro de usuario
  Future<Resource<RegisterResponse>> register(RegisterRequest user);

  /// Eliminar sesión
  Future<bool> logout();

  /// Token
  Future<String?> getToken();
}
