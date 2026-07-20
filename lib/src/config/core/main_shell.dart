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

  bool get isHome => state.fullPath == "/home";

  String get currentLocation => state.matchedLocation;

  bool get showDrawer {
    return currentLocation == '/home';
  }

  String get title {
    final fullPath = state.fullPath ?? currentLocation;

    switch (fullPath) {
      case '/home':
        return '';

      // Categorías
      case '/categorias':
        return 'Categorías';

      case '/categorias/crear':
        return 'Nueva categoría';

      case '/categorias/:idCategoria':
        return 'Detalle de categoría';

      case '/categorias/:idCategoria/editar':
        return 'Editar categoría';

      // Períodos contables
      case '/periodos_contables':
        return 'Períodos contables';

      case '/periodos_contables/crear':
        return 'Nuevo período';

      case '/periodos_contables/:idPeriodo':
        return 'Detalle del período';

      case '/periodos_contables/:idPeriodo/editar':
        return 'Editar período';

      // Movimientos
      case '/movimientos':
        return 'Movimientos';

      case '/movimientos/crear':
        return 'Nuevo movimiento';

      case '/movimientos/:idMovimiento':
        return 'Detalle del movimiento';

      case '/movimientos/:idMovimiento/editar':
        return 'Editar movimiento';

      // Reportes
      case '/reportes':
        return 'Reportes';

      // Configuración
      case '/configuracion':
        return 'Configuración';

      default:
        return '';
    }
  }

  String formatNombreUsuario(Persona? persona) {
    if (persona == null) return '';

    final nombres = persona.nombres.trim().split(' ');
    final apellidos = persona.apellidos.trim().split(' ');

    final primerNombre = nombres.isNotEmpty ? nombres.first : '';
    final primerApellido = apellidos.isNotEmpty ? apellidos.first : '';

    return '$primerNombre $primerApellido'.trim();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionBloc>().state;
    final auth = session.user;

    final persona = auth?.data.usuario.persona;
    final empresaNombre = session.empresaActiva?.nombreComercial ?? '';

    final nombreUsuario = formatNombreUsuario(persona);

    return Scaffold(
      key: AppScaffoldKeys.main,
      drawer: showDrawer ? const AppDrawer() : null,
      appBar: MainAppBar(
        isHome: isHome,
        nombreUsuario: nombreUsuario,
        empresaNombre: empresaNombre,
        title: title,
      ),

      body: child,
    );
  }
}
