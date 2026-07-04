import 'package:app_aryoria/src/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  AuthRepository authRepository;

  LogoutUseCase(this.authRepository);

  run() => authRepository.logout();
}
