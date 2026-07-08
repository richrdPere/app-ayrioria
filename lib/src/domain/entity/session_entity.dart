import 'package:app_aryoria/src/domain/entity/empresa_entity.dart';

import 'usuario_entity.dart';

class SessionEntity {
  final String token;
  final UsuarioEntity usuario;
  final EmpresaEntity? empresa;

  const SessionEntity({
    required this.token,
    required this.usuario,
    this.empresa,
  });
}
