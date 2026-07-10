import 'package:app_aryoria/src/domain/use_cases/auth/AuthUseCases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logout_event.dart';
import 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthUsesCases authUsesCases;

  LogoutBloc(this.authUsesCases) : super(LogoutInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LogoutState> emit,
  ) async {
    if (state is LogoutLoading) return;

    emit(LogoutLoading());

    try {
      await authUsesCases.logoutSession.run();

      emit(LogoutSuccess());
    } catch (e) {
      emit(
        LogoutFailure('No fue posible cerrar la sesión. Inténtelo nuevamente.'),
      );
    }
  }
}
