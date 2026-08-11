import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_data.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_update_req.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

class UpdatePerfilUsuarioUC {
  UsuarioRepository usuarioRepository;
  UpdatePerfilUsuarioUC(this.usuarioRepository);

  Future<Resource<ApiResponse<PerfilUsuarioData>>> run({
    required PerfilUpdateRequest request,
  }) => usuarioRepository.updatePerfilUsuario(request: request);
}
