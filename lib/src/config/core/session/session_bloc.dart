import 'package:app_aryoria/src/config/core/session/session_state.dart';
// import 'package:app_aryoria/src/data/models/empresa/empresa_data.dart';
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
      ),
    );
  }

  // void setEmpresa(EmpresaData empresa) {
  //   emit(state.copyWith(empresaActiva: empresa, isAuthenticated: true));
  // }

  void logout() {
    emit(SessionState(user: null, isAuthenticated: false, empresaActiva: null));
  }
}
