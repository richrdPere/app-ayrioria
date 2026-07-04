import 'package:app_aryoria/src/data/models/rol.model.dart';
import 'package:app_aryoria/src/domain/entity/usuario_entity.dart';

import 'persona_model.dart';

class Usuario {
  final int idUsuario;
  final int idPersona;
  final String email;
  final String username;
  final String password;
  final bool estado;
  final DateTime? ultimoAcceso;

  final Persona persona;
  final List<Role> roles;

  Usuario({
    required this.idUsuario,
    required this.idPersona,
    required this.email,
    required this.username,
    required this.password,
    required this.estado,
    this.ultimoAcceso,
    required this.persona,
    required this.roles,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    idUsuario: json["id_usuario"],
    idPersona: json["id_persona"],
    email: json["email"],
    username: json["username"],
    password: json["password"],
    estado: json["estado"],
    ultimoAcceso: json["ultimo_acceso"] != null
        ? DateTime.parse(json["ultimo_acceso"])
        : null,
    // createdAt: DateTime.parse(json["created_at"]),
    // updatedAt: DateTime.parse(json["updated_at"]),
    // deletedAt: json["deleted_at"],
    persona: Persona.fromJson(json["persona"]),
    roles: json["roles"] != null
        ? List<Role>.from(json["roles"].map((x) => Role.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "id_usuario": idUsuario,
    "id_persona": idPersona,
    "email": email,
    "username": username,
    "password": password,
    "estado": estado,
    "ultimo_acceso": ultimoAcceso?.toIso8601String(),
    // "created_at": createdAt.toIso8601String(),
    // "updated_at": updatedAt.toIso8601String(),
    // "deleted_at": deletedAt,
    "persona": persona.toJson(),
    "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
  };

  UsuarioEntity toEntity() {
    return UsuarioEntity(
      idUsuario: idUsuario,
      idPersona: idPersona,
      email: email,
      username: username,
      estado: estado,
      ultimoAcceso: ultimoAcceso,
      persona: persona.toEntity(),
      roles: roles.map((e) => e.toEntity()).toList(),
    );
  }
}
