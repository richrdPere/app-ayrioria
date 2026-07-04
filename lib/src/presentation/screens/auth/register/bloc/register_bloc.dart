import 'package:flutter_bloc/flutter_bloc.dart';

// Register Event y State
import 'package:app_aryoria/src/presentation/screens/auth/register/bloc/register_event.dart';
import 'package:app_aryoria/src/presentation/screens/auth/register/bloc/register_state.dart';

// Auth Uses Cases
import 'package:app_aryoria/src/domain/use_cases/auth/AuthUseCases.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  AuthUsesCases authUsesCases;

  RegisterBloc(this.authUsesCases) : super(RegisterState.initial()) {
    on<RegisterSubmitEvent>(_onRegister);
    on<RegisterResetEvent>(_onReset);
  }

  // 1. Register
  Future<void> _onRegister(
    RegisterSubmitEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await authUsesCases.register.run(event.request);

    emit(state.copyWith(isLoading: false, response: response));
  }

  // 2. Reset formulario
  void _onReset(RegisterResetEvent event, Emitter<RegisterState> emit) {
    emit(RegisterState.initial());
  }
}
