class PerfilUsuarioData {
  final PerfilUsuario usuario;
  final PerfilPersona persona;
  final List<PerfilRol> roles;

  const PerfilUsuarioData({
    required this.usuario,
    required this.persona,
    required this.roles,
  });

  factory PerfilUsuarioData.fromJson(Map<String, dynamic> json) {
    return PerfilUsuarioData(
      usuario: PerfilUsuario.fromJson(
        json['usuario'] is Map
            ? Map<String, dynamic>.from(json['usuario'])
            : {},
      ),

      persona: PerfilPersona.fromJson(
        json['persona'] is Map
            ? Map<String, dynamic>.from(json['persona'])
            : {},
      ),

      roles: json['roles'] is List
          ? (json['roles'] as List)
                .whereType<Map>()
                .map(
                  (item) => PerfilRol.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : <PerfilRol>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario': usuario.toJson(),
      'persona': persona.toJson(),
      'roles': roles.map((rol) => rol.toJson()).toList(),
    };
  }
}

// ==========================================================
// USUARIO
// ==========================================================
class PerfilUsuario {
  final int idUsuario;
  final int idPersona;

  final String email;
  final String username;

  final bool estado;

  final DateTime? ultimoAcceso;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PerfilUsuario({
    required this.idUsuario,
    required this.idPersona,
    required this.email,
    required this.username,
    required this.estado,
    this.ultimoAcceso,
    this.createdAt,
    this.updatedAt,
  });

  factory PerfilUsuario.fromJson(Map<String, dynamic> json) {
    return PerfilUsuario(
      idUsuario: _toInt(json['id_usuario']),
      idPersona: _toInt(json['id_persona']),
      email: json['email']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      estado: json['estado'] == true,
      ultimoAcceso: _toDateTime(json['ultimo_acceso']),
      createdAt: _toDateTime(json['created_at']),
      updatedAt: _toDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_usuario': idUsuario,
      'id_persona': idPersona,
      'email': email,
      'username': username,
      'estado': estado,
      'ultimo_acceso': ultimoAcceso?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

// ==========================================================
// PERSONA
// ==========================================================
class PerfilPersona {
  final int idPersona;

  final String nombres;
  final String apellidos;

  final String? email;

  final String? tipoDocumento;
  final String? numeroDocumento;

  final DateTime? fechaNacimiento;

  final String? celular;
  final String? direccion;
  final String? fotoUrl;

  final String? genero;

  final bool estado;

  const PerfilPersona({
    required this.idPersona,
    required this.nombres,
    required this.apellidos,
    this.email,
    this.tipoDocumento,
    this.numeroDocumento,
    this.fechaNacimiento,
    this.celular,
    this.direccion,
    this.fotoUrl,
    this.genero,
    required this.estado,
  });

  factory PerfilPersona.fromJson(Map<String, dynamic> json) {
    return PerfilPersona(
      idPersona: _toInt(json['id_persona']),
      nombres: json['nombres']?.toString() ?? '',
      apellidos: json['apellidos']?.toString() ?? '',
      email: _toNullableString(json['email']),
      tipoDocumento: _toNullableString(json['tipo_documento']),
      numeroDocumento: _toNullableString(json['numero_documento']),
      fechaNacimiento: _toDateTime(json['fecha_nacimiento']),
      celular: _toNullableString(json['celular']),
      direccion: _toNullableString(json['direccion']),
      fotoUrl: _toNullableString(json['foto_url']),
      genero: _toNullableString(json['genero']),
      estado: json['estado'] == true,
    );
  }

  String get nombreCompleto {
    return '$nombres $apellidos'.trim();
  }

  Map<String, dynamic> toJson() {
    return {
      'id_persona': idPersona,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'tipo_documento': tipoDocumento,
      'numero_documento': numeroDocumento,
      'fecha_nacimiento': fechaNacimiento == null
          ? null
          : _formatDateOnly(fechaNacimiento!),
      'celular': celular,
      'direccion': direccion,
      'foto_url': fotoUrl,
      'genero': genero,
      'estado': estado,
    };
  }
}

// ==========================================================
// ROL
// ==========================================================
class PerfilRol {
  final int idRol;
  final String nombre;

  const PerfilRol({required this.idRol, required this.nombre});

  factory PerfilRol.fromJson(Map<String, dynamic> json) {
    return PerfilRol(
      idRol: _toInt(json['id_rol']),
      nombre: json['nombre']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id_rol': idRol, 'nombre': nombre};
  }
}

// ==========================================================
// HELPERS
// ==========================================================
int _toInt(dynamic value, {int fallback = 0}) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

DateTime? _toDateTime(dynamic value) {
  if (value == null) {
    return null;
  }

  final text = value.toString().trim();

  if (text.isEmpty) {
    return null;
  }

  return DateTime.tryParse(text);
}

String? _toNullableString(dynamic value) {
  if (value == null) {
    return null;
  }

  final text = value.toString().trim();

  return text.isEmpty ? null : text;
}

String _formatDateOnly(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
