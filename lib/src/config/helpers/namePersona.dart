import 'package:app_aryoria/src/data/models/login/auth_response.dart';

extension PersonaNombre on AuthResponse {
  String get nombreCompleto {
    final nombres = data.usuario.persona.nombres;
    final apellidos = data.usuario.persona.apellidos;

    return [nombres, apellidos].where((e) => e.trim().isNotEmpty).join(' ');
  }
}
