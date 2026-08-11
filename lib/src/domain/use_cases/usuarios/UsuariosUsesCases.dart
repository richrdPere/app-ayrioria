
import 'package:app_aryoria/src/domain/use_cases/index_uses_cases.dart';


class UsuariosUsesCases {
  GetPerfilUsuarioUC getPerfilUsuario;
  UpdateFotoUsuarioUC updateFotoUsuario;
  UpdatePasswordUsuarioUC updatePasswordUsuario;
  UpdatePerfilUsuarioUC updatePerfilUsuario;

  UsuariosUsesCases({
    required this.getPerfilUsuario,
    required this.updateFotoUsuario,
    required this.updatePasswordUsuario,
    required this.updatePerfilUsuario,
  });
}
