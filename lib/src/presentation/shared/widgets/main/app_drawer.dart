import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void go(BuildContext context, String routeName) {
    final router = GoRouter.of(context);

    Navigator.of(context).pop();
    router.goNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionBloc>().state;
    final user = session.user;

    final persona = user?.data.usuario.persona;

    final nombre = [
      persona?.nombres ?? '',
      persona?.apellidos ?? '',
    ].where((e) => e.trim().isNotEmpty).join(' ');

    final rol = user?.data.usuario.roles.isNotEmpty == true
        ? user!.data.usuario.roles.first.nombre
        : 'Sin rol';

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),

            const SizedBox(height: 10),

            Text(
              nombre.isEmpty ? 'Usuario' : nombre,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            Text(rol, style: const TextStyle(color: Colors.grey)),

            const Divider(),

            Expanded(
              child: ListView(
                children: [
                  _item(context, Icons.home, 'Inicio', 'home'),
                  _item(context, Icons.business, 'Empresas', 'empresas'),
                  _item(
                    context,
                    Icons.category_outlined,
                    'Categorías',
                    'categorias',
                  ),
                  _item(
                    context,
                    Icons.swap_horiz,
                    'Movimientos',
                    'movimientos',
                  ),
                  _item(context, Icons.assessment, 'Reportes', 'reportes'),
                  _item(
                    context,
                    Icons.settings,
                    'Configuración',
                    'configuracion',
                  ),
                ],
              ),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                final router = GoRouter.of(context);

                Navigator.of(context).pop();
                router.goNamed('logout');
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String title,
    String routeName,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => go(context, routeName),
    );
  }
}
