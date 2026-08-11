import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/splash_bloc.dart';
import '../bloc/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashAuthenticated) {
          context.read<SessionBloc>().updateSession(state.session);

          context.go('/loading');
        }

        if (state is SplashUnauthenticated) {
          context.go('/login');
        }

        if (state is SplashFailure) {
          final colors = Theme.of(context).colorScheme;

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colors.error,
              ),
            );

          context.go('/login');
        }
      },
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      // ========================================================
      // BACKGROUND ADAPTABLE
      // ========================================================
      backgroundColor: colors.surface,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ==================================================
                // LOGO
                // ==================================================
                const Logo(titulo: 'Bienvenido', logoSize: 220),

                const SizedBox(height: 10),

                // ==================================================
                // SUBTÍTULO
                // ==================================================
                Text(
                  'Sistema de Gestión Financiera',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 48),

                // ==================================================
                // LOADING
                // ==================================================
                SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: colors.primary,
                  ),
                ),

                const SizedBox(height: 24),

                // ==================================================
                // ESTADO
                // ==================================================
                Text(
                  'Inicializando aplicación...',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ==========================================================
      // VERSION
      // ==========================================================
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Text(
            'Versión 1.0.0',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant.withValues(alpha: 0.70),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
