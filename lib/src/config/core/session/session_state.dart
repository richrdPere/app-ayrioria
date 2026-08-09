import 'package:app_aryoria/src/data/models/empresa/empresa_data.dart';
import 'package:app_aryoria/src/data/models/login/auth_response.dart';

enum SessionCloseReason { none, logout, expired, unauthorized }

class SessionState {
  final AuthResponse? user;
  final bool isAuthenticated;
  final EmpresaData? empresaActiva;
  final bool isChecking;

  final SessionCloseReason closeReason;

  SessionState({
    this.user,
    this.isAuthenticated = false,
    this.empresaActiva,
    this.isChecking = false,
    this.closeReason = SessionCloseReason.none,
  });

  SessionState copyWith({
    AuthResponse? user,
    bool? isAuthenticated,
    EmpresaData? empresaActiva,
    bool? isChecking,
    SessionCloseReason? closeReason,
  }) {
    return SessionState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      empresaActiva: empresaActiva ?? this.empresaActiva,
      isChecking: isChecking ?? this.isChecking,
      closeReason: closeReason ?? this.closeReason,
    );
  }
}
