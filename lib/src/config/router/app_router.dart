// ignore_for_file: unnecessary_underscores

import 'package:app_aryoria/src/config/core/main_shell.dart';
import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
// import 'package:app_aryoria/src/config/router/go_router_refresh_stream.dart';
import 'package:app_aryoria/src/presentation/screens/auth/login/view/login_page.dart';
import 'package:app_aryoria/src/presentation/screens/auth/register/view/register_page.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/categoria_page.dart';
import 'package:app_aryoria/src/presentation/screens/configuracion/view/configuracion_page.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/view/create_empresa/empresa_create_page.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/view/selected_empresa/empresa_page.dart';
import 'package:app_aryoria/src/presentation/screens/home/view/home_page.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/view/movimiento_page.dart';
import 'package:app_aryoria/src/presentation/screens/reportes/view/reportes_page.dart';
import 'package:app_aryoria/src/presentation/shared/screens/loading/view/loading_page.dart';
import 'package:app_aryoria/src/presentation/shared/screens/splah/view/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

String? authRedirect(BuildContext context, GoRouterState state) {
  final session = context.read<SessionBloc>().state;

  final loggedIn = session.isAuthenticated;
  final hasEmpresa = session.empresaActiva != null;

  const publicRoutes = {'/login', '/register', '/splash'};

  final location = state.matchedLocation;
  final isPublic = publicRoutes.contains(state.matchedLocation);

  // 1. USUARIO NO AUTENTICADO
  if (!loggedIn) {
    return isPublic ? null : '/login';
  }

  // 2. USUARIO AUTENTICADO PERO SIN EMPRESA
  if (!hasEmpresa) {
    final isEmpresaFlow = location.startsWith('/empresas');
    return isEmpresaFlow ? null : '/empresas';
  }

  // 3. USUARIO AUTENTICADO + EMPRESA ACTIVA
  if (location == '/home') {
    return null;
  }

  // Si intenta entrar a Login, Splash, Empresas o cualquier
  // otra ruta inicial, siempre lo enviamos al Home.
  return '/home';
}

// ===================================
// RUTAS
// ===================================

final GoRouter appRouter = GoRouter(
  // initialLocation: '/login',
  initialLocation: '/splash',
  debugLogDiagnostics: true,
  // refreshListenable: GoRouterRefreshStream(SessionBloc().stream),
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

    GoRoute(
      path: '/empresas',
      name: 'empresas',
      builder: (_, __) => const EmpresaPage(),
      routes: [
        GoRoute(
          path: 'create',
          name: 'crear_empresa',
          builder: (context, state) => const EmpresaCreatePage(),
        ),
      ],
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
