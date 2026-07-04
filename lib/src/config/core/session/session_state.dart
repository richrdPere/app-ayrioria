import 'package:app_aryoria/src/data/models/login/auth_response.dart';

class SessionState {
  final AuthResponse? user;
  final bool isAuthenticated;

  SessionState({this.user, this.isAuthenticated = false});

  SessionState copyWith({AuthResponse? user, bool? isAuthenticated}) {
    return SessionState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
