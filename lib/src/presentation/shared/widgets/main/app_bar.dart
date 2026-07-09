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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xffEAF6FC),

      leading: IconButton(
        icon: Icon(isHome ? Icons.menu : Icons.arrow_back_ios_new),
        onPressed:
            onMenuPressed ??
            () {
              if (isHome) {
                //Scaffold.of(context).openDrawer();
                AppScaffoldKeys.main.currentState?.openDrawer();
              } else {
                // context.pop();
                context.goNamed("home");
              }
            },
      ),

      title: isHome
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hola, $nombreUsuario",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Empresa, $empresaNombre",
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            )
          : Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),

      actions: [
        if (isHome)
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.account_balance, color: Colors.blue),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
