import 'package:app_aryoria/src/data/datasources/local/sharefPref.dart';
import 'package:app_aryoria/src/data/datasources/remote/services/auth_service.dart';
import 'package:app_aryoria/src/data/models/login/auth_response.dart';
import 'package:app_aryoria/src/data/models/register/register_request.dart';
import 'package:app_aryoria/src/data/models/register/register_response.dart';
import 'package:app_aryoria/src/domain/repositories/auth_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthService authService;
  SharefPref sharedPref;

  AuthRepositoryImpl(this.authService, this.sharedPref);

  @override
  Future<String?> getToken() async {
    final session = await getUserSession();
    return session?.data.token;
  }

  @override
  Future<AuthResponse?> getUserSession() async {
    final data = await sharedPref.read("user");

    print(data);

    if (data != null) {
      AuthResponse authResponse = AuthResponse.fromJson(data);
      return authResponse;
    }
    return null;
  }

  @override
  Future<Resource<AuthResponse>> login(String username, String password) {
    return authService.login(username, password);
  }

  @override
  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove("user");
  }

  @override
  Future<Resource<RegisterResponse>> register(RegisterRequest user) {
    return authService.register(user);
  }

  @override
  Future<void> saveUserSession(AuthResponse authResponse) async {
    sharedPref.save('user', authResponse.toJson());
  }
}
