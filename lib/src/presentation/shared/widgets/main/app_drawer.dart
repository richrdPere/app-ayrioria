import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void go(BuildContext context, String routeName) {
    Navigator.pop(context);
    context.goNamed(routeName);
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

            // 👤 Avatar
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),

            const SizedBox(height: 10),

            // Nombre dinámico
            Text(
              nombre.isEmpty ? "Usuario" : nombre,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            // 🛡 Rol dinámico
            Text(rol, style: const TextStyle(color: Colors.grey)),

            const Divider(),

            // MENU
            Expanded(
              child: ListView(
                children: [
                  _item(context, Icons.home, "Inicio", "home"),
                  _item(context, Icons.business, "Empresas", "empresas"),
                  _item(
                    context,
                    Icons.calendar_month,
                    "Periodos Contables",
                    "categorias",
                  ),
                  _item(
                    context,
                    Icons.swap_horiz,
                    "Movimientos",
                    "movimientos",
                  ),
                  _item(context, Icons.assessment, "Reportes", "reportes"),
                  _item(
                    context,
                    Icons.settings,
                    "Configuración",
                    "configuracion",
                  ),
                ],
              ),
            ),

            const Divider(),

            // LOGOUT
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Cerrar sesión"),
              onTap: () {
                context.read<SessionBloc>().logout();
                Navigator.pop(context);
                context.goNamed("login");
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
      onTap: () {
        Navigator.pop(context);
        context.goNamed(routeName);
      },
    );
  }
}
