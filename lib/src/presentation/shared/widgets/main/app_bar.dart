import 'package:app_aryoria/src/config/core/main_shell.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isHome;
  final String nombreUsuario;
  final String empresaNombre;
  final String title;
  final VoidCallback? onMenuPressed;

  const MainAppBar({
    super.key,
    required this.isHome,
    required this.nombreUsuario,
    required this.empresaNombre,
    required this.title,
    this.onMenuPressed,
  });

  void _handleLeadingPressed(BuildContext context) {
    if (isHome) {
      AppScaffoldKeys.main.currentState?.openDrawer();
      return;
    }

    if (context.canPop()) {
      context.pop();
      return;
    }

    context.goNamed('home');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AppBar(
      elevation: 0,

      // ========================================================
      // COLOR DEL APPBAR
      // ========================================================
      backgroundColor: colors.primaryContainer,

      foregroundColor: colors.onPrimaryContainer,

      automaticallyImplyLeading: false,

      // ========================================================
      // BOTÓN IZQUIERDO
      // ========================================================
      leading: IconButton(
        icon: Icon(
          isHome ? Icons.menu_rounded : Icons.arrow_back_ios_new_rounded,
          color: colors.onPrimaryContainer,
        ),
        onPressed: onMenuPressed ?? () => _handleLeadingPressed(context),
      ),

      // ========================================================
      // TÍTULO
      // ========================================================
      title: isHome
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hola, $nombreUsuario',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: colors.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Empresa: $empresaNombre',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.onPrimaryContainer.withValues(alpha: 0.70),
                  ),
                ),
              ],
            )
          : Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: colors.onPrimaryContainer,
              ),
            ),

      // ========================================================
      // ACCIONES DERECHA
      // ========================================================
      actions: [
        if (isHome)
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Center(
              child: Container(
                width: 42,
                height: 42,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                ),
                child: Image.asset('assets/img/tag-logo.png', fit: BoxFit.contain),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// import 'package:app_aryoria/src/config/core/main_shell.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final bool isHome;
//   final String nombreUsuario;
//   final String empresaNombre;
//   final String title;
//   final VoidCallback? onMenuPressed;

//   const MainAppBar({
//     super.key,
//     required this.isHome,
//     required this.nombreUsuario,
//     required this.empresaNombre,
//     required this.title,
//     this.onMenuPressed,
//   });

//   void _handleLeadingPressed(BuildContext context) {
//     if (isHome) {
//       AppScaffoldKeys.main.currentState?.openDrawer();
//       return;
//     }

//     if (context.canPop()) {
//       context.pop();
//       return;
//     }

//     context.goNamed('home');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: const Color(0xffEAF6FC),
//       // backgroundColor: const Color(0xffEAF6FC),
//       // backgroundColor:  Theme.of(context).colorScheme,
//       // backgroundColor: Theme.of(context).colorScheme,
//       automaticallyImplyLeading: false,

//       leading: IconButton(
//         icon: Icon(isHome ? Icons.menu : Icons.arrow_back_ios_new),
//         onPressed: onMenuPressed ?? () => _handleLeadingPressed(context),
//       ),

//       title: isHome
//           ? Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   "Hola, $nombreUsuario",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//                 Text(
//                   "Empresa, $empresaNombre",
//                   style: TextStyle(fontSize: 13, color: Colors.black54),
//                 ),
//               ],
//             )
//           : Text(
//               title,
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//             ),

//       actions: [
//         if (isHome)
//           Padding(
//             padding: const EdgeInsets.only(right: 15),
//             child: CircleAvatar(
//               backgroundColor: Colors.white,
//               child: Icon(Icons.account_balance, color: Colors.blue),
//             ),
//           ),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
