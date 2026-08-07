import 'package:app_aryoria/src/data/models/rol.model.dart';
import 'package:app_aryoria/src/domain/entity/usuario_entity.dart';

import 'persona_model.dart';

class Usuario {
  final int idUsuario;
  final int? idPersona;
  final String email;
  final String username;
  final String? password;
  final bool estado;
  final DateTime? ultimoAcceso;

  final Persona? persona;
  final List<Role> roles;

  const Usuario({
    required this.idUsuario,
    this.idPersona,
    required this.email,
    required this.username,
    this.password,
    required this.estado,
    this.ultimoAcceso,
    this.persona,
    required this.roles,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json["id_usuario"] as int,
      idPersona: json["id_persona"] as int?,
      email: json["email"]?.toString() ?? "",
      username: json["username"]?.toString() ?? "",
      password: json["password"]?.toString(),
      estado: json["estado"] as bool? ?? false,
      ultimoAcceso: json["ultimo_acceso"] != null
          ? DateTime.tryParse(json["ultimo_acceso"].toString())
          : null,

      persona: json["persona"] is Map<String, dynamic>
          ? Persona.fromJson(json["persona"] as Map<String, dynamic>)
          : null,

      roles: (json["roles"] as List<dynamic>? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(Role.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_usuario": idUsuario,
      "id_persona": idPersona,
      "email": email,
      "username": username,
      "password": password,
      "estado": estado,
      "ultimo_acceso": ultimoAcceso?.toIso8601String(),
      "persona": persona?.toJson(),
      "roles": roles.map((role) => role.toJson()).toList(),
    };
  }

  UsuarioEntity toEntity() {
    return UsuarioEntity(
      idUsuario: idUsuario,
      idPersona: idPersona,
      email: email,
      username: username,
      estado: estado,
      ultimoAcceso: ultimoAcceso,
      persona: persona?.toEntity(),
      roles: roles.map((role) => role.toEntity()).toList(),
    );
  }
}
