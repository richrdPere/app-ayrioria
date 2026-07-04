import 'package:app_aryoria/src/domain/entity/persona_entity.dart';

class Persona {
  final int idPersona;
  final String nombres;
  final String apellidos;
  final String? email;
  final String tipoDocumento;
  final String? numeroDocumento;
  final DateTime? fechaNacimiento;
  final String? celular;
  final String? direccion;
  final String? fotoUrl;
  final String? genero;
  final bool estado;

  Persona({
    required this.idPersona,
    required this.nombres,
    required this.apellidos,
    this.email,
    required this.tipoDocumento,
    this.numeroDocumento,
    this.fechaNacimiento,
    this.celular,
    this.direccion,
    this.fotoUrl,
    this.genero,
    required this.estado,
  });

  factory Persona.fromJson(Map<String, dynamic> json) => Persona(
    idPersona: json["id_persona"],
    nombres: json["nombres"],
    apellidos: json["apellidos"],
    email: json["email"],
    tipoDocumento: json["tipo_documento"],
    numeroDocumento: json["numero_documento"],
    fechaNacimiento: json["fecha_nacimiento"] != null
        ? DateTime.parse(json["fecha_nacimiento"])
        : null,
    celular: json["celular"],
    direccion: json["direccion"],
    fotoUrl: json["foto_url"],
    genero: json["genero"],
    estado: json["estado"],
  );

  Map<String, dynamic> toJson() => {
    "id_persona": idPersona,
    "nombres": nombres,
    "apellidos": apellidos,
    "email": email,
    "tipo_documento": tipoDocumento,
    "numero_documento": numeroDocumento,
    "fecha_nacimiento": fechaNacimiento?.toIso8601String(),
    "celular": celular,
    "direccion": direccion,
    "foto_url": fotoUrl,
    "genero": genero,
    "estado": estado,
  };

  PersonaEntity toEntity() {
    return PersonaEntity(
      idPersona: idPersona,
      nombres: nombres,
      apellidos: apellidos,
      email: email,
      tipoDocumento: tipoDocumento,
      numeroDocumento: numeroDocumento,
      fechaNacimiento: fechaNacimiento,
      celular: celular,
      direccion: direccion,
      fotoUrl: fotoUrl,
      genero: genero,
      estado: estado,
    );
  }
}
