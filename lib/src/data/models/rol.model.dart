import 'package:app_aryoria/src/domain/entity/rol_entity.dart';

class Role {
  final int idRol;
  final String nombre;
  final String? descripcion;
  final bool estado;

  Role({
    required this.idRol,
    required this.nombre,
    this.descripcion,
    required this.estado,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    idRol: json["id_rol"],
    nombre: json["nombre"],
    descripcion: json["descripcion"],
    estado: json["estado"],
  );

  Map<String, dynamic> toJson() => {
    "id_rol": idRol,
    "nombre": nombre,
    "descripcion": descripcion,
    "estado": estado,
  };

  RolEntity toEntity() {
    return RolEntity(
      idRol: idRol,
      nombre: nombre,
      descripcion: descripcion,
      estado: estado,
    );
  }
}
