import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/config/core/session/session_state.dart';
import 'package:app_aryoria/src/presentation/shared/screens/logout/bloc/logout_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/logout_bloc.dart';
import '../bloc/logout_state.dart';

class LogoutLoadingPage extends StatefulWidget {
  const LogoutLoadingPage({super.key});

  @override
  State<LogoutLoadingPage> createState() => _LogoutLoadingPageState();
}

class _LogoutLoadingPageState extends State<LogoutLoadingPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<LogoutBloc>().add(const LogoutRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // LOGOUT
        BlocListener<LogoutBloc, LogoutState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              context.read<SessionBloc>().logout();
            }

            if (state is LogoutFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
            }
          },
        ),

        // SESSION
        BlocListener<SessionBloc, SessionState>(
          listenWhen: (previous, current) =>
              previous.isAuthenticated != current.isAuthenticated,

          listener: (context, state) {
            if (!state.isAuthenticated) {
              context.goNamed('login');
            }
          },
        ),
      ],

      child: const _LogoutView(),
    );
  }
}

class _LogoutView extends StatelessWidget {
  const _LogoutView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<LogoutBloc, LogoutState>(
          builder: (context, state) {
            if (state is LogoutFailure) {
              return _LogoutFailureView(message: state.message);
            }

            return const _LogoutLoadingView();
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Text(
          'Ayroria',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade500),
        ),
      ),
    );
  }
}

class _LogoutLoadingView extends StatelessWidget {
  const _LogoutLoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/img/tag-logo.png', width: 150, height: 150),
          const SizedBox(height: 35),
          const Text(
            'Cerrando sesión',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Finalizando la sesión de forma segura',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 40),
          const SizedBox(
            width: 35,
            height: 35,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 25),
          Text(
            'Espere un momento...',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _LogoutFailureView extends StatelessWidget {
  final String message;

  const _LogoutFailureView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 70,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              'No se pudo cerrar la sesión',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () {
                context.read<LogoutBloc>().add(const LogoutRequested());
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
