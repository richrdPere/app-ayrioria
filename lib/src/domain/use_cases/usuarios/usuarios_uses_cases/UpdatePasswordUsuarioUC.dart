import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/password_update_data.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_password_req.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

class UpdatePasswordUsuarioUC {
  UsuarioRepository usuarioRepository;
  UpdatePasswordUsuarioUC(this.usuarioRepository);

  Future<Resource<ApiResponse<PasswordUpdateData>>> run({
    required PasswordUpdateRequest request,
  }) => usuarioRepository.updatePasswordUsuario(request: request);
}
