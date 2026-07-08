import 'package:app_aryoria/src/data/models/empresa/empresa_data.dart';
import 'package:app_aryoria/src/data/models/login/auth_response.dart';

class SessionState {
  final AuthResponse? user;
  final bool isAuthenticated;
  final EmpresaData? empresaActiva;
  final bool isChecking;

  SessionState({
    this.user,
    this.isAuthenticated = false,
    this.empresaActiva,
    this.isChecking = false,
  });

  SessionState copyWith({
    AuthResponse? user,
    bool? isAuthenticated,
    EmpresaData? empresaActiva,
    bool? isChecking,
  }) {
    return SessionState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      empresaActiva: empresaActiva ?? this.empresaActiva,
      isChecking: isChecking ?? this.isChecking,
    );
  }
}
