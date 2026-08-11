import 'package:app_aryoria/src/presentation/shared/screens/loading/bloc/loading_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/loading_bloc.dart';
import '../bloc/loading_state.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    context.read<LoadingBloc>().add(const LoadingStarted());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BlocListener<LoadingBloc, LoadingState>(
      listener: (context, state) {
        if (state is LoadingSuccess) {
          context.goNamed('home');
        }

        if (state is LoadingFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));

          context.goNamed('login');
        }
      },

      child: Scaffold(
        backgroundColor: colors.surface,

        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ========================================================
                  // LOGO
                  // ========================================================
                  Container(
                    width: 150,
                    height: 150,

                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: colors.primaryContainer,
                      shape: BoxShape.circle,
                    ),

                    child: Image.asset(
                      'assets/img/tag-logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ========================================================
                  // LOADING
                  // ========================================================
                  SizedBox(
                    width: 42,
                    height: 42,

                    child: CircularProgressIndicator(
                      strokeWidth: 3.5,
                      color: colors.primary,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ========================================================
                  // TITULO
                  // ========================================================
                  Text(
                    'Preparando tu información...',
                    textAlign: TextAlign.center,

                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ========================================================
                  // SUBTITULO
                  // ========================================================
                  Text(
                    'Estamos cargando la configuración de tu cuenta.',
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
      ),
    );
  }
}
