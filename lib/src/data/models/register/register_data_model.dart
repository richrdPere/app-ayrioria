

import 'package:app_aryoria/src/data/models/persona_model.dart';
import 'package:app_aryoria/src/data/models/rol.model.dart';

class RegisterDataModel {
  final int idUsuario;
  final int idPersona;
  final String email;
  final String username;
  final bool estado;
  final dynamic ultimoAcceso;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic deletedAt;
  final Persona persona;
  final List<Role> roles;

  RegisterDataModel({
    required this.idUsuario,
    required this.idPersona,
    required this.email,
    required this.username,
    required this.estado,
    required this.ultimoAcceso,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.persona,
    required this.roles,
  });

  factory RegisterDataModel.fromJson(Map<String, dynamic> json) {
    return RegisterDataModel(
      idUsuario: json["id_usuario"],
      idPersona: json["id_persona"],
      email: json["email"],
      username: json["username"],
      estado: json["estado"],
      ultimoAcceso: json["ultimo_acceso"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      deletedAt: json["deleted_at"],
      persona: Persona.fromJson(json["persona"]),
      roles: List<Role>.from(
        json["roles"].map((x) => Role.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_usuario": idUsuario,
      "id_persona": idPersona,
      "email": email,
      "username": username,
      "estado": estado,
      "ultimo_acceso": ultimoAcceso,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "deleted_at": deletedAt,
      "persona": persona.toJson(),
      "roles": roles.map((e) => e.toJson()).toList(),
    };
  }
}