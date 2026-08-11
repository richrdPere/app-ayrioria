import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/config/core/session/session_state.dart';

import 'package:app_aryoria/src/presentation/shared/screens/logout/bloc/logout_event.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/logo.dart';
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
    final colors = Theme.of(context).colorScheme;

    return MultiBlocListener(
      listeners: [
        // =========================================================
        // LOGOUT
        // =========================================================
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
                    backgroundColor: colors.errorContainer,
                  ),
                );
            }
          },
        ),

        // =========================================================
        // SESSION
        // =========================================================
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

// ============================================================================
// LOGOUT VIEW
// ============================================================================

class _LogoutView extends StatelessWidget {
  const _LogoutView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,

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

      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Text(
            'ARYORIA',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colors.onSurfaceVariant,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LOGOUT LOADING
// ============================================================================

class _LogoutLoadingView extends StatelessWidget {
  const _LogoutLoadingView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 30),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // =========================================================
            // LOGO
            // =========================================================
            // Container(
            //   width: 150,
            //   height: 150,

            //   padding: const EdgeInsets.all(18),

            //   decoration: BoxDecoration(
            //     color: colors.primaryContainer,
            //     shape: BoxShape.circle,
            //   ),

            //   child: Image.asset(
            //     'assets/img/tag-logo.png',
            //     fit: BoxFit.contain,
            //   ),
            // ),
             const Logo(titulo: '', logoSize: 220),

            const SizedBox(height: 34),

            // =========================================================
            // TITLE
            // =========================================================
            Text(
              'Cerrando sesión',
              textAlign: TextAlign.center,

              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 12),

            // =========================================================
            // SUBTITLE
            // =========================================================
            Text(
              'Finalizando tu sesión de forma segura.',
              textAlign: TextAlign.center,

              style: theme.textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 36),

            // =========================================================
            // PROGRESS
            // =========================================================
            SizedBox(
              width: 38,
              height: 38,

              child: CircularProgressIndicator(
                strokeWidth: 3.2,
                color: colors.primary,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Espera un momento...',
              textAlign: TextAlign.center,

              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// FAILURE VIEW
// ============================================================================

class _LogoutFailureView extends StatelessWidget {
  final String message;

  const _LogoutFailureView({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // =========================================================
            // ERROR ICON
            // =========================================================
            Container(
              width: 92,
              height: 92,

              decoration: BoxDecoration(
                color: colors.errorContainer,
                shape: BoxShape.circle,
              ),

              child: Icon(
                Icons.error_outline_rounded,
                size: 50,
                color: colors.onErrorContainer,
              ),
            ),

            const SizedBox(height: 24),

            // =========================================================
            // TITLE
            // =========================================================
            Text(
              'No se pudo cerrar la sesión',
              textAlign: TextAlign.center,

              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),

            const SizedBox(height: 12),

            // =========================================================
            // MESSAGE
            // =========================================================
            Text(
              message,
              textAlign: TextAlign.center,

              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 30),

            // =========================================================
            // RETRY
            // =========================================================
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
