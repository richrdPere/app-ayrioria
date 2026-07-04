import 'usuario_entity.dart';

class SessionEntity {
  final String token;
  final UsuarioEntity usuario;

  const SessionEntity({
    required this.token,
    required this.usuario,
  });
}