import 'package:app_aryoria/src/data/models/login/auth_response.dart';
import 'package:app_aryoria/src/domain/repositories/auth_repository.dart';


class SaveUserSessionUseCase {
  AuthRepository authRepository;
  SaveUserSessionUseCase(this.authRepository);

  run(AuthResponse authResponse) =>
      authRepository.saveUserSession(authResponse);
}
