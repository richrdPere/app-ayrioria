import 'package:app_aryoria/src/data/datasources/local/sharefPref.dart';
import 'package:app_aryoria/src/data/datasources/remote/services/auth_service.dart';
import 'package:app_aryoria/src/data/repositories/auth_repository_impl.dart';
import 'package:app_aryoria/src/domain/repositories/auth_repository.dart';
import 'package:app_aryoria/src/domain/use_cases/auth/AuthUseCases.dart';
import 'package:app_aryoria/src/domain/use_cases/auth/auth_use_cases/GetUserSessionUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/auth/auth_use_cases/LoginUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/auth/auth_use_cases/LogoutUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/auth/auth_use_cases/RegisterUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/auth/auth_use_cases/SaveUserSessionUseCase.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @injectable
  SharefPref get sharedPref => SharefPref();

  @injectable
  AuthService get authService => AuthService();

  @injectable
  AuthRepository get authRepository =>
      AuthRepositoryImpl(authService, sharedPref);

  @injectable
  AuthUsesCases get authUsesCases => AuthUsesCases(
    login: LoginUseCase(authRepository),
    register: RegisterUseCase(authRepository),
    saveUserSession: SaveUserSessionUseCase(authRepository),
    getUserSession: GetUserSessionUseCase(authRepository),
    logoutSession: LogoutUseCase(authRepository),
  );
}
