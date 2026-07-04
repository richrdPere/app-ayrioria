class RegisterRequest {
  final PersonaRequest persona;
  final UsuarioRequest usuario;
  final List<String> roles;

  RegisterRequest({
    required this.persona,
    required this.usuario,
    this.roles = const ['USUARIO'],
  });

  Map<String, dynamic> toJson() {
    return {
      'persona': persona.toJson(),
      'usuario': usuario.toJson(),
      'roles': roles,
    };
  }

  RegisterRequest copyWith({
    PersonaRequest? persona,
    UsuarioRequest? usuario,
    List<String>? roles,
  }) {
    return RegisterRequest(
      persona: persona ?? this.persona,
      usuario: usuario ?? this.usuario,
      roles: roles ?? this.roles,
    );
  }
}


// ===========================================================
// PERSONA REQUEST
// ===========================================================
class PersonaRequest {
  final String nombres;
  final String apellidos;
  final String email;
  final String tipoDocumento;
  final String numeroDocumento;
  final DateTime fechaNacimiento;
  final String celular;
  final String direccion;
  final String genero;

  PersonaRequest({
    required this.nombres,
    required this.apellidos,
    required this.email,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.fechaNacimiento,
    required this.celular,
    required this.direccion,
    required this.genero,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'tipo_documento': tipoDocumento,
      'numero_documento': numeroDocumento,
      'fecha_nacimiento': fechaNacimiento.toIso8601String().split('T').first,
      'celular': celular,
      'direccion': direccion,
      'genero': genero,
    };
  }

  PersonaRequest copyWith({
    String? nombres,
    String? apellidos,
    String? email,
    String? tipoDocumento,
    String? numeroDocumento,
    DateTime? fechaNacimiento,
    String? celular,
    String? direccion,
    String? genero,
  }) {
    return PersonaRequest(
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      email: email ?? this.email,
      tipoDocumento: tipoDocumento ?? this.tipoDocumento,
      numeroDocumento: numeroDocumento ?? this.numeroDocumento,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      celular: celular ?? this.celular,
      direccion: direccion ?? this.direccion,
      genero: genero ?? this.genero,
    );
  }
}

// ===========================================================
// USUARIO REQUEST
// ===========================================================
class UsuarioRequest {
  final String email;
  final String username;
  final String password;

  UsuarioRequest({
    required this.email,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'username': username, 'password': password};
  }

  UsuarioRequest copyWith({String? email, String? username, String? password}) {
    return UsuarioRequest(
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}
