import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Session
import 'package:app_aryoria/src/config/core/session/session_bloc.dart';

// Menu
import 'package:app_aryoria/src/config/helpers/menu_items.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  // ============================================================
  // NAVEGAR
  // ============================================================

  void _goTo(BuildContext context, String location) {
    // Cerramos primero el Drawer.
    Navigator.of(context).pop();

    // Navegación principal.
    context.go(location);
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  void _logout(BuildContext context) {
    Navigator.of(context).pop();

    context.goNamed('logout');
  }

  // ============================================================
  // ÍNDICE ACTUAL
  // ============================================================

  int? _getSelectedIndex(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;

    final index = appMenuItems.indexWhere(
      (item) =>
          currentPath == item.link || currentPath.startsWith('${item.link}/'),
    );

    return index >= 0 ? index : null;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final session = context.watch<SessionBloc>().state;

    final user = session.user;

    final persona = user?.data.usuario.persona;

    final nombre = [
      persona?.nombres ?? '',
      persona?.apellidos ?? '',
    ].where((item) => item.trim().isNotEmpty).join(' ');

    final rol = user?.data.usuario.roles.isNotEmpty == true
        ? user!.data.usuario.roles.first.nombre
        : 'Sin rol';

    final selectedIndex = _getSelectedIndex(context);

    return Drawer(
      backgroundColor: colors.surface,

      child: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // HEADER USUARIO
            // ==================================================
            _UserHeader(nombre: nombre.isEmpty ? 'Usuario' : nombre, rol: rol),

            const Divider(height: 1),

            // ==================================================
            // MENÚ
            // ==================================================
            Expanded(
              child: NavigationDrawer(
                selectedIndex: selectedIndex,

                backgroundColor: colors.surface,

                indicatorColor: colors.primaryContainer,

                onDestinationSelected: (index) {
                  final item = appMenuItems[index];

                  _goTo(context, item.link);
                },

                children: [
                  // ============================================
                  // ACCESOS RAPIDOS
                  // ============================================
                  const _DrawerSectionTitle(title: 'ACCESOS RÁPIDOS'),

                  _destination(context, appMenuItems[0], selectedIndex == 0),

                  // // ============================================
                  // // PRINCIPAL
                  // // ============================================
                  // const _DrawerSectionTitle(title: 'Principal'),

                  // _destination(context, appMenuItems[0], selectedIndex == 0),

                  // ============================================
                  // OPERACIONES
                  // ============================================
                  // const _DrawerDivider(),

                  // const _DrawerSectionTitle(title: 'Operaciones'),
                  _destination(context, appMenuItems[1], selectedIndex == 1),

                  _destination(context, appMenuItems[2], selectedIndex == 2),

                  _destination(context, appMenuItems[3], selectedIndex == 3),

                  // ============================================
                  // CLASIFICACIÓN
                  // ============================================
                  // const _DrawerDivider(),

                  // const _DrawerSectionTitle(title: 'Clasificación'),

                  // ============================================
                  // FINANZAS
                  // ============================================
                  const _DrawerDivider(),

                  const _DrawerSectionTitle(title: 'Finanzas'),

                  _destination(context, appMenuItems[4], selectedIndex == 4),

                  _destination(context, appMenuItems[5], selectedIndex == 5),

                  // _destination(context, appMenuItems[6], selectedIndex == 6),

                  // ============================================
                  // ADMINISTRACIÓN
                  // ============================================
                  // const _DrawerDivider(),

                  // const _DrawerSectionTitle(title: 'Administración'),

                  // _destination(context, appMenuItems[7], selectedIndex == 7),

                  // _destination(context, appMenuItems[8], selectedIndex == 8),

                  const SizedBox(height: 16),
                ],
              ),
            ),

            // ==================================================
            // LOGOUT
            // ==================================================
            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                leading: Icon(Icons.logout_rounded, color: colors.error),

                title: Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: colors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                onTap: () => _logout(context),
              ),
            ),

            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DESTINATION
  // ============================================================
  Widget _destination(BuildContext context, MenuItem item, bool selected) {
    final colors = Theme.of(context).colorScheme;

    return NavigationDrawerDestination(
      icon: Icon(item.icon, color: colors.onSurfaceVariant),

      selectedIcon: Icon(item.icon, color: colors.onPrimaryContainer),

      label: Text(
        item.title,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}

// ============================================================
// HEADER DEL USUARIO
// ============================================================
class _UserHeader extends StatelessWidget {
  final String nombre;
  final String rol;

  const _UserHeader({required this.nombre, required this.rol});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),

      color: colors.primaryContainer,

      child: Row(
        children: [
          // ====================================================
          // AVATAR
          // ====================================================
          Container(
            width: 54,
            height: 54,

            decoration: BoxDecoration(
              color: colors.surface,
              shape: BoxShape.circle,
            ),

            child: Icon(Icons.person_rounded, size: 30, color: colors.primary),
          ),

          const SizedBox(width: 14),

          // ====================================================
          // DATOS
          // ====================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: colors.onPrimaryContainer,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  rol,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 13,
                    color: colors.onPrimaryContainer.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TÍTULO DE SECCIÓN
// ============================================================

class _DrawerSectionTitle extends StatelessWidget {
  final String title;

  const _DrawerSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 18, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }
}

// ============================================================
// DIVISOR
// ============================================================

class _DrawerDivider extends StatelessWidget {
  const _DrawerDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(28, 8, 28, 0),
      child: Divider(),
    );
  }
}

// import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class AppDrawer extends StatelessWidget {
//   const AppDrawer({super.key});

//   void go(BuildContext context, String routeName) {
//     final router = GoRouter.of(context);

//     Navigator.of(context).pop();
//     router.goNamed(routeName);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final session = context.watch<SessionBloc>().state;
//     final user = session.user;

//     final persona = user?.data.usuario.persona;

//     final nombre = [
//       persona?.nombres ?? '',
//       persona?.apellidos ?? '',
//     ].where((e) => e.trim().isNotEmpty).join(' ');

//     final rol = user?.data.usuario.roles.isNotEmpty == true
//         ? user!.data.usuario.roles.first.nombre
//         : 'Sin rol';

//     return Drawer(
//       child: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),

//             const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),

//             const SizedBox(height: 10),

//             Text(
//               nombre.isEmpty ? 'Usuario' : nombre,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),

//             Text(rol, style: const TextStyle(color: Colors.grey)),

//             const Divider(),

//             Expanded(
//               child: ListView(
//                 children: [
//                   _item(context, Icons.home, 'Inicio', 'home'),
//                   _item(context, Icons.business, 'Empresas', 'empresas'),
//                   _item(
//                     context,
//                     Icons.category_outlined,
//                     'Categorías',
//                     'categorias',
//                   ),
//                   _item(
//                     context,
//                     Icons.swap_horiz,
//                     'Movimientos',
//                     'movimientos',
//                   ),
//                   _item(context, Icons.assessment, 'Reportes', 'reportes'),
//                   _item(
//                     context,
//                     Icons.settings,
//                     'Configuración',
//                     'configuracion',
//                   ),
//                 ],
//               ),
//             ),

//             const Divider(),

//             ListTile(
//               leading: const Icon(Icons.logout, color: Colors.red),
//               title: const Text(
//                 'Cerrar sesión',
//                 style: TextStyle(
//                   color: Colors.red,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               onTap: () {
//                 final router = GoRouter.of(context);

//                 Navigator.of(context).pop();
//                 router.goNamed('logout');
//               },
//             ),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _item(
//     BuildContext context,
//     IconData icon,
//     String title,
//     String routeName,
//   ) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(title),
//       onTap: () => go(context, routeName),
//     );
//   }
// }
