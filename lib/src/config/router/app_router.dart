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
import 'package:app_aryoria/src/presentation/screens/movimiento/page/movimiento_page.dart';
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

  final location = state.matchedLocation;

  const publicRoutes = {'/splash', '/login', '/register', '/loading'};

  final isPublic = publicRoutes.contains(location);
  final isEmpresaFlow = location.startsWith('/empresas');

  // 1. Usuario NO autenticado
  if (!loggedIn) {
    return isPublic ? null : '/login';
  }

  // 2. Usuario autenticado intentando ir a Login/Register/Splash
  if (isPublic) {
    return hasEmpresa ? '/home' : '/empresas';
  }

  // 3. Usuario autenticado pero SIN empresa activa
  if (!hasEmpresa) {
    return isEmpresaFlow ? null : '/empresas';
  }

  // 4. Usuario autenticado + empresa activa
  // Puede navegar libremente por las rutas privadas
  return null;
}

// ===================================
// RUTAS
// ===================================
final GoRouter appRouter = GoRouter(
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

    // EMPRESAS
    GoRoute(
      path: '/empresas',
      name: 'empresas',
      builder: (_, __) => const EmpresaPage(),
      routes: [
        GoRoute(
          path: 'create',
          name: 'crear_empresa',
          builder: (_, __) => const EmpresaCreatePage(),
        ),
      ],
    ),

    // APP PRINCIPAL
    ShellRoute(
      builder: (context, state, child) {
        return MainShell(state: state, child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (_, __) => const HomePage(),
        ),

        GoRoute(
          path: '/categorias',
          name: 'categorias',
          builder: (_, __) => const CategoriaPage(),
        ),

        GoRoute(
          path: '/movimientos',
          name: 'movimientos',
          builder: (_, __) => const MovimientoPage(),
        ),

        GoRoute(
          path: '/reportes',
          name: 'reportes',
          builder: (_, __) => const ReportesPage(),
        ),

        GoRoute(
          path: '/configuracion',
          name: 'configuracion',
          builder: (_, __) => const ConfiguracionPage(),
        ),
      ],
    ),
  ],
);
