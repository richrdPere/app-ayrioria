// ignore_for_file: unnecessary_underscores

import 'package:app_aryoria/src/config/core/main_shell.dart';
import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/auth/login/view/login_page.dart';
import 'package:app_aryoria/src/presentation/screens/auth/register/view/register_page.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/categoria_page.dart';
import 'package:app_aryoria/src/presentation/screens/configuracion/view/configuracion_page.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/view/empresa_page.dart';
import 'package:app_aryoria/src/presentation/screens/home/view/home_page.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/view/movimiento_page.dart';
import 'package:app_aryoria/src/presentation/screens/reportes/view/reportes_page.dart';
import 'package:app_aryoria/src/presentation/shared/screens/loading/view/loading_page.dart';
import 'package:app_aryoria/src/presentation/shared/screens/splah/view/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

String? authRedirect(BuildContext context, GoRouterState state) {
  final loggedIn = context.read<SessionBloc>().state.isAuthenticated;

  const publicRoutes = {'/login', '/register', '/splash'};

  final isPublic = publicRoutes.contains(state.matchedLocation);

  if (!loggedIn && !isPublic) {
    return '/login';
  }

  if (loggedIn && state.matchedLocation == '/login') {
    return '/home';
  }

  return null;
}

// ===================================
// RUTAS
// ===================================

final GoRouter appRouter = GoRouter(
  // initialLocation: '/login',
  initialLocation: '/splash',
  debugLogDiagnostics: true,

  redirect: authRedirect,

  routes: [
    // AUTH
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (_, __) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (_, __) => const LoginPage(),
    ),

    GoRoute(
      path: '/register',
      name: 'register',
      builder: (_, __) => const RegisterPage(),
    ),

    GoRoute(
      path: '/loading',
      name: 'loading',
      builder: (_, __) => const LoadingPage(),
    ),

    // APP
    ShellRoute(
      builder: (context, state, child) {
        return MainShell(state: state, child: child);
      },

      routes: [
        // 1. HOME
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (_, __) => const HomePage(),
        ),

        // 2. EMPRESA
        GoRoute(
          path: '/empresas',
          name: 'empresas',
          builder: (_, __) => const EmpresaPage(),
        ),

        // 3. PERIODOS CONTABLE
        GoRoute(
          path: '/categorias',
          name: 'categorias',
          builder: (_, __) => const CategoriaPage(),
        ),

        // 4. MOVIMIENTOS
        GoRoute(
          path: '/movimientos',
          name: 'movimientos',
          builder: (_, __) => const MovimientoPage(),
        ),

        // 5. REPORTES
        GoRoute(
          path: '/reportes',
          name: 'reportes',
          builder: (_, __) => const ReportesPage(),
        ),

        // 6. CONFIGURACION
        GoRoute(
          path: '/configuracion',
          name: 'configuracion',
          builder: (_, __) => const ConfiguracionPage(),
        ),
      ],
    ),
  ],
);
