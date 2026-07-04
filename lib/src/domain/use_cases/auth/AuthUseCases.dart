import 'package:app_aryoria/src/domain/use_cases/auth/auth_use_cases/GetUserSessionUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/auth/auth_use_cases/LoginUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/auth/auth_use_cases/LogoutUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/auth/auth_use_cases/RegisterUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/auth/auth_use_cases/SaveUserSessionUseCase.dart';

class AuthUsesCases {
  LoginUseCase login;
  RegisterUseCase register;
  SaveUserSessionUseCase saveUserSession;
  GetUserSessionUseCase getUserSession;
  LogoutUseCase logoutSession;

  AuthUsesCases({
    required this.login,
    required this.register,
    required this.saveUserSession,
    required this.getUserSession,
    required this.logoutSession,
  });
}
