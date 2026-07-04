import 'package:app_aryoria/src/data/models/register/register_request.dart';
import 'package:app_aryoria/src/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  AuthRepository authRepository;

  RegisterUseCase(this.authRepository);

  run(RegisterRequest usuario) => authRepository.register(usuario);
}
