import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_data.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetPerfilUsuarioUC {
  UsuarioRepository usuarioRepository;
  GetPerfilUsuarioUC(this.usuarioRepository);

  Future<Resource<ApiResponse<PerfilUsuarioData>>> run() =>
      usuarioRepository.getPerfilUsuario();
}
