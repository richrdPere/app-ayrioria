// ignore_for_file: unnecessary_underscores

// import 'package:app_aryoria/src/config/router/go_router_refresh_stream.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/detalle/categoria_detalle_page.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/form/categoria_form_page.dart';
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/flujo_contable_page.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/view/detalle/subcategoria_detail_page.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/view/form/subcategoria_form_page.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/view/listado/subcategoria_page.dart';
import 'package:app_aryoria/src/presentation/shared/screens/theme/view/theme_changer_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Config
import 'package:app_aryoria/src/config/core/main_shell.dart';
import 'package:app_aryoria/src/config/core/session/session_bloc.dart';

// Screen's
import 'package:app_aryoria/src/presentation/screens/auth/login/view/login_page.dart';
import 'package:app_aryoria/src/presentation/screens/auth/register/view/register_page.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/listado/categoria_page.dart';
import 'package:app_aryoria/src/presentation/screens/configuracion/view/configuracion_page.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/view/create_empresa/empresa_create_page.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/view/selected_empresa/empresa_page.dart';
import 'package:app_aryoria/src/presentation/screens/home/view/home_page.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/view/listado/movimiento_page.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/view/detalle/movimiento_detalle_page.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/view/form/movimiento_form_page.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/view/listado/periodo_contable_page.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/view/detalle/periodo_contable_detalle_page.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/view/form/periodo_contable_form_page.dart';
import 'package:app_aryoria/src/presentation/screens/reportes/view/reportes_page.dart';

// Shared
import 'package:app_aryoria/src/presentation/shared/screens/loading/view/loading_page.dart';
import 'package:app_aryoria/src/presentation/shared/screens/logout/view/logout_page.dart';
import 'package:app_aryoria/src/presentation/shared/screens/splash/view/splash_page.dart';

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

    GoRoute(
      path: '/logout',
      name: "logout",
      builder: (_, __) => const LogoutLoadingPage(),
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
          path: '/theme',
          name: 'theme',
          builder: (_, __) => const ThemeChangerPage(),
        ),

        GoRoute(
          path: '/home',
          name: 'home',
          builder: (_, __) => const HomePage(),
        ),

        // ==========================================================
        // CATEGORIAS
        // ==========================================================
        GoRoute(
          path: '/categorias',
          name: 'categorias',
          builder: (_, __) => const CategoriaPage(),

          routes: [
            // ========================================================
            // CREAR
            // ========================================================
            GoRoute(
              path: 'crear',
              name: 'crear_categoria',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: true,
                  child: const CategoriaFormPage(),
                );
              },
            ),

            // ========================================================
            // DETALLE
            // ========================================================
            GoRoute(
              path: ':idCategoria',
              name: 'categoria_detalle',
              pageBuilder: (context, state) {
                final int? idCategoria = int.tryParse(
                  state.pathParameters['idCategoria'] ?? '',
                );

                return MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: true,
                  child: idCategoria == null
                      ? const Scaffold(
                          body: Center(child: Text('Categoría inválida.')),
                        )
                      : CategoriaDetallePage(idCategoria: idCategoria),
                );
              },

              routes: [
                // ====================================================
                // EDITAR
                // ====================================================
                GoRoute(
                  path: 'editar',
                  name: 'editar_categoria',
                  pageBuilder: (context, state) {
                    final int? idCategoria = int.tryParse(
                      state.pathParameters['idCategoria'] ?? '',
                    );

                    return MaterialPage(
                      key: state.pageKey,
                      fullscreenDialog: true,
                      child: idCategoria == null
                          ? const Scaffold(
                              body: Center(child: Text('Categoría inválida.')),
                            )
                          : CategoriaFormPage(idCategoria: idCategoria),
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        // ==========================================================
        // SUBCATEGORÍAS
        // ==========================================================
        GoRoute(
          path: '/subcategorias',
          name: 'subcategorias',
          builder: (context, state) {
            final session = context.read<SessionBloc>().state;

            final int? idEmpresa = session.empresaActiva?.idEmpresa;

            if (idEmpresa == null) {
              return const Scaffold(
                body: Center(child: Text('No existe una empresa activa.')),
              );
            }

            return SubcategoriaPage(idEmpresa: idEmpresa);
          },

          routes: [
            // ========================================================
            // CREAR SUBCATEGORÍA
            // ========================================================
            GoRoute(
              path: 'crear',
              name: 'crear_subcategoria',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: true,
                  child: const SubcategoriaFormPage(),
                );
              },
            ),

            // ========================================================
            // DETALLE SUBCATEGORÍA
            // ========================================================
            GoRoute(
              path: ':idSubcategoria',
              name: 'subcategoria_detalle',
              pageBuilder: (context, state) {
                final int? idSubcategoria = int.tryParse(
                  state.pathParameters['idSubcategoria'] ?? '',
                );

                return MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: true,
                  child: idSubcategoria == null
                      ? const Scaffold(
                          body: Center(child: Text('Subcategoría inválida.')),
                        )
                      : SubcategoriaDetallePage(idSubcategoria: idSubcategoria),
                );
              },

              routes: [
                // ====================================================
                // EDITAR SUBCATEGORÍA
                // ====================================================
                GoRoute(
                  path: 'editar',
                  name: 'editar_subcategoria',
                  pageBuilder: (context, state) {
                    final int? idSubcategoria = int.tryParse(
                      state.pathParameters['idSubcategoria'] ?? '',
                    );

                    return MaterialPage(
                      key: state.pageKey,
                      fullscreenDialog: true,
                      child: idSubcategoria == null
                          ? const Scaffold(
                              body: Center(
                                child: Text('Subcategoría inválida.'),
                              ),
                            )
                          : SubcategoriaFormPage(
                              idSubcategoria: idSubcategoria,
                            ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        // ==========================================================
        // PERÍODOS CONTABLES
        // ==========================================================
        GoRoute(
          path: '/periodos_contables',
          name: 'periodos_contables',
          builder: (_, __) => const PeriodoContablePage(),
          routes: [
            // - Crear
            GoRoute(
              path: 'crear',
              name: 'crear_periodo_contable',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: true,
                  child: const PeriodoContableFormPage(),
                );
              },
              //builder: (_, __) => const PeriodoContableFormPage(),
            ),

            // - Detalle
            GoRoute(
              path: ':idPeriodo',
              name: 'periodo_contable_detalle',
              builder: (context, state) {
                final idPeriodo = int.tryParse(
                  state.pathParameters['idPeriodo'] ?? '',
                );

                if (idPeriodo == null) {
                  return const Scaffold(
                    body: Center(child: Text('Período contable inválido')),
                  );
                }

                return PeriodoContableDetallePage(idPeriodo: idPeriodo);
              },
              routes: [
                // - Actualizar
                GoRoute(
                  path: 'editar',
                  name: 'editar_periodo_contable',
                  pageBuilder: (context, state) {
                    final idPeriodo = int.tryParse(
                      state.pathParameters['idPeriodo'] ?? '',
                    );

                    if (idPeriodo == null) {
                      return MaterialPage(
                        key: state.pageKey,
                        child: const Scaffold(
                          body: Center(
                            child: Text('Período contable inválido'),
                          ),
                        ),
                      );
                    }

                    return MaterialPage(
                      key: state.pageKey,
                      fullscreenDialog: true,
                      child: PeriodoContableFormPage(idPeriodo: idPeriodo),
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        // ==========================================================
        // MOVIMIENTOS
        // ==========================================================
        GoRoute(
          path: '/movimientos',
          name: 'movimientos',
          builder: (_, __) => const MovimientoPage(),
          routes: [
            GoRoute(
              path: 'crear',
              name: 'crear_movimiento',
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: true,
                  child: const MovimientoFormPage(),
                );
              },
            ),
            GoRoute(
              path: ':idMovimiento',
              name: 'movimiento_detalle',
              pageBuilder: (context, state) {
                final idMovimiento = int.parse(
                  state.pathParameters['idMovimiento']!,
                );

                return MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: true,
                  child: MovimientoDetailPage(idMovimiento: idMovimiento),
                );
              },
              routes: [
                GoRoute(
                  path: 'editar',
                  name: 'editar_movimiento',
                  pageBuilder: (context, state) {
                    final idMovimiento = int.tryParse(
                      state.pathParameters['idMovimiento'] ?? '',
                    );

                    return MaterialPage(
                      key: state.pageKey,
                      fullscreenDialog: true,
                      child: MovimientoFormPage(idMovimiento: idMovimiento),
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        // ==========================================================
        // FLUJO CONTABLE
        // ==========================================================
        GoRoute(
          path: '/flujo-contable',
          name: 'flujo_contable',
          builder: (_, __) => const FlujoContablePage(),
        ),

        // ==========================================================
        // REPORTES
        // ==========================================================
        GoRoute(
          path: '/reportes',
          name: 'reportes',
          builder: (_, __) => const ReportePage(),
        ),

        // ==========================================================
        // CONFIGURACION
        // ==========================================================
        GoRoute(
          path: '/configuracion',
          name: 'configuracion',
          builder: (_, __) => const ConfiguracionPage(),
        ),
      ],
    ),
  ],
);
