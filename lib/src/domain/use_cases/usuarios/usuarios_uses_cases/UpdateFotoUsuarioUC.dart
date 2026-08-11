import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/foto_perfil_update_data.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

class UpdateFotoUsuarioUC {
  UsuarioRepository usuarioRepository;
  UpdateFotoUsuarioUC(this.usuarioRepository);

  Future<Resource<ApiResponse<FotoPerfilUpdateData>>> run({
    required String filePath,
  }) => usuarioRepository.updateFotoUsuario(filePath: filePath);
}
