import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/data/models/persona_model.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/main/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/main/app_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppScaffoldKeys {
  static final GlobalKey<ScaffoldState> main = GlobalKey<ScaffoldState>();
}

class MainShell extends StatelessWidget {
  final GoRouterState state;
  final Widget child;

  const MainShell({super.key, required this.child, required this.state});

  // ==========================================================
  // RUTA ACTUAL
  // ==========================================================
  String get currentLocation => state.matchedLocation;
  String get currentFullPath => state.fullPath ?? currentLocation;

  // ==========================================================
  // HOME
  // ==========================================================
  bool get isHome => currentFullPath == '/home';

  // ==========================================================
  // RUTAS QUE USAN SU PROPIO APP BAR
  // ==========================================================

  bool get hasOwnAppBar {
    switch (currentFullPath) {
      // ======================================================
      // CATEGORÍAS
      // ======================================================
      case '/categorias/crear':
      case '/categorias/:idCategoria/editar':

      // ======================================================
      // PERÍODOS CONTABLES
      // ======================================================
      case '/periodos_contables/crear':
      case '/periodos_contables/:idPeriodo/editar':

      // ======================================================
      // MOVIMIENTOS
      // ======================================================
      case '/movimientos/crear':
      case '/movimientos/:idMovimiento/editar':
        return true;

      default:
        return false;
    }
  }

  // ==========================================================
  // DRAWER
  // ==========================================================

  bool get showDrawer {
    return currentFullPath == '/home' && !hasOwnAppBar;
  }

  // ==========================================================
  // TITLE
  // ==========================================================

  String get title {
    switch (currentFullPath) {
      case '/home':
        return '';

      // ======================================================
      // CATEGORÍAS
      // ======================================================
      case '/categorias':
        return 'Categorías';

      case '/categorias/:idCategoria':
        return 'Detalle de categoría';

      // ======================================================
      // SUBCATEGORÍAS
      // ======================================================
      case '/subcategorias':
        return 'Subcategorías';

      // ======================================================
      // FLUJO CONTABLE
      // ======================================================
      case '/flujo_contable':
        return 'Flujo contable';

      // ======================================================
      // PERÍODOS CONTABLES
      // ======================================================
      case '/periodos_contables':
        return 'Períodos contables';

      case '/periodos_contables/:idPeriodo':
        return 'Detalle del período';

      // ======================================================
      // MOVIMIENTOS
      // ======================================================
      case '/movimientos':
        return 'Movimientos';

      case '/movimientos/:idMovimiento':
        return 'Detalle del movimiento';

      // ======================================================
      // REPORTES
      // ======================================================
      case '/reportes':
        return 'Reportes';

      // ======================================================
      // CONFIGURACIÓN
      // ======================================================
      case '/configuracion':
        return 'Configuración';

      default:
        return '';
    }
  }

  // ==========================================================
  // NOMBRE USUARIO
  // ==========================================================

  String formatNombreUsuario(Persona? persona) {
    if (persona == null) {
      return '';
    }

    final nombres = persona.nombres.trim().split(' ');

    final apellidos = persona.apellidos.trim().split(' ');

    final primerNombre = nombres.isNotEmpty ? nombres.first : '';

    final primerApellido = apellidos.isNotEmpty ? apellidos.first : '';

    return '$primerNombre $primerApellido'.trim();
  }

  // ==========================================================
  // BUILD
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionBloc>().state;
    final auth = session.user;

    final persona = auth?.data.usuario.persona;
    final empresaNombre = session.empresaActiva?.nombreComercial ?? '';
    final nombreUsuario = formatNombreUsuario(persona);

    return Scaffold(
      key: AppScaffoldKeys.main,

      // ======================================================
      // DRAWER
      // ======================================================
      drawer: showDrawer ? const AppDrawer() : null,

      // ======================================================
      // APP BAR
      // ======================================================
      appBar: hasOwnAppBar
          ? null
          : MainAppBar(
              isHome: isHome,
              nombreUsuario: nombreUsuario,
              empresaNombre: empresaNombre,
              title: title,
            ),

      // ======================================================
      // BODY
      // ======================================================
      body: child,
    );
  }
}
