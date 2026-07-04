class PersonaEntity {
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

  const PersonaEntity({
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
}