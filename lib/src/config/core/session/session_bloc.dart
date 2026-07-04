import 'package:app_aryoria/src/config/core/session/session_state.dart';
import 'package:app_aryoria/src/data/models/login/auth_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionBloc extends Cubit<SessionState> {
  SessionBloc() : super(SessionState());

  void setUser(AuthResponse user) {
    emit(SessionState(
      user: user,
      isAuthenticated: true,
    ));
  }

  void logout() {
    emit(SessionState(
      user: null,
      isAuthenticated: false,
    ));
  }
}