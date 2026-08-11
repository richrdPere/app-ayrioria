class PerfilUpdateRequest {
  final String email;
  final String username;

  final String nombres;
  final String apellidos;

  final String? emailPersonal;

  final String? tipoDocumento;
  final String? numeroDocumento;

  final DateTime? fechaNacimiento;

  final String? celular;
  final String? direccion;

  final String? genero;

  const PerfilUpdateRequest({
    required this.email,
    required this.username,
    required this.nombres,
    required this.apellidos,
    this.emailPersonal,
    this.tipoDocumento,
    this.numeroDocumento,
    this.fechaNacimiento,
    this.celular,
    this.direccion,
    this.genero,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email.trim(),
      'username': username.trim(),
      'nombres': nombres.trim(),
      'apellidos': apellidos.trim(),

      'email_personal': _nullableString(emailPersonal),

      'tipo_documento': _nullableString(tipoDocumento),

      'numero_documento': _nullableString(numeroDocumento),

      'fecha_nacimiento': fechaNacimiento != null
          ? _formatDateOnly(fechaNacimiento!)
          : null,

      'celular': _nullableString(celular),

      'direccion': _nullableString(direccion),

      'genero': _nullableString(genero),
    };
  }

  String? _nullableString(String? value) {
    if (value == null) {
      return null;
    }

    final text = value.trim();

    return text.isEmpty ? null : text;
  }

  String _formatDateOnly(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
