import 'package:app_aryoria/src/config/core/session/session_state.dart';
import 'package:app_aryoria/src/data/models/login/auth_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionBloc extends Cubit<SessionState> {
  SessionBloc() : super(SessionState());

  void updateSession(AuthResponse session) {
    emit(
      SessionState(
        user: session,
        isAuthenticated: true,
        empresaActiva: session.data.empresa, // puede ser null
        isChecking: false,
        closeReason: SessionCloseReason.none,
      ),
    );
  }

  void logout() {
    emit(
      SessionState(
        user: null,
        isAuthenticated: false,
        empresaActiva: null,
        isChecking: false,
        closeReason: SessionCloseReason.logout,
      ),
    );
  }

  void sessionExpired() {
    emit(
      SessionState(
        user: null,
        isAuthenticated: false,
        empresaActiva: null,
        isChecking: false,
        closeReason: SessionCloseReason.expired,
      ),
    );
  }

  void unauthorized() {
    emit(
      SessionState(
        user: null,
        isAuthenticated: false,
        empresaActiva: null,
        isChecking: false,
        closeReason: SessionCloseReason.unauthorized,
      ),
    );
  }

  void checkingSession() {
    emit(state.copyWith(isChecking: true));
  }

  // void setEmpresa(EmpresaData empresa) {
  //   emit(state.copyWith(empresaActiva: empresa, isAuthenticated: true));
  // }

  // void logout() {
  //   emit(SessionState(user: null, isAuthenticated: false, empresaActiva: null));
  // }
}
