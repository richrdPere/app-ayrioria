import 'persona_entity.dart';
import 'rol_entity.dart';

class UsuarioEntity {
  final int idUsuario;
  final int idPersona;
  final String email;
  final String username;
  final bool estado;
  final DateTime? ultimoAcceso;

  final PersonaEntity persona;
  final List<RolEntity> roles;

  const UsuarioEntity({
    required this.idUsuario,
    required this.idPersona,
    required this.email,
    required this.username,
    required this.estado,
    this.ultimoAcceso,
    required this.persona,
    required this.roles,
  });
}