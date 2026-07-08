import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/data/models/login/auth_response.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/presentation/screens/auth/login/bloc/login_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/auth/login/bloc/login_state.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthListener extends StatelessWidget {
  final Widget child;

  const AuthListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// LOGIN
        BlocListener<LoginBloc, LoginState>(
          listenWhen: (previous, current) =>
              previous.response != current.response ||
              previous.isLoggedOut != current.isLoggedOut,

          listener: (context, state) {
            /// LOGIN EXITOSO
            if (state.response is Success<AuthResponse>) {
              final auth = (state.response as Success<AuthResponse>).data;

              context.read<SessionBloc>().updateSession(auth);

              // Próximamente:
              // EmpresaBloc.add(...)
              // SocketBloc.add(...)
              // ConfigBloc.add(...)
              // NotificationBloc.add(...)
            }

            /// LOGOUT
            if (state.isLoggedOut) {
              debugPrint("Usuario deslogueado");
              context.read<SessionBloc>().logout();

              // SocketBloc.add(...)
              // EmpresaBloc.add(ClearEmpresa())
              // HomeBloc.add(ClearHome())
            }
          },
        ),

        /// EMPRESA
        BlocListener<EmpresaBloc, EmpresaState>(
          listenWhen: (p, c) => p.selectResponse != c.selectResponse,
          listener: (context, state) {
            final response = state.selectResponse;

            if (response is Success<AuthResponse>) {
              context.read<SessionBloc>().updateSession(response.data);
            }
          },
        ),
      ],

      child: child,
    );
  }
}
