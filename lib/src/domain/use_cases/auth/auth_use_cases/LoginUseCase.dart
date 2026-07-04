import 'package:app_aryoria/src/domain/repositories/auth_repository.dart';

class LoginUseCase {
  AuthRepository authRepository;
  LoginUseCase(this.authRepository);

  run(String username, String password) =>
      authRepository.login(username, password);
}
