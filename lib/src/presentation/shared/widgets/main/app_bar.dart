import 'package:app_aryoria/src/config/core/main_shell.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app_aryoria/src/config/constants/environment.dart'
    as url_backend;

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isHome;
  final String nombreUsuario;
  final String empresaNombre;
  final String title;
  final String? fotoUrl;
  final VoidCallback? onMenuPressed;

  const MainAppBar({
    super.key,
    required this.isHome,
    required this.nombreUsuario,
    required this.empresaNombre,
    required this.title,
    this.fotoUrl,
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

  String? _buildFotoUrl() {
    final value = fotoUrl?.trim();

    if (value == null || value.isEmpty) {
      return null;
    }

    // Ya es una URL completa
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    // URL relativa enviada por el backend
    final baseUrl = url_backend.Environment.mainUrl.replaceAll(
      RegExp(r'/$'),
      '',
    );

    final path = value.startsWith('/') ? value : '/$value';

    return '$baseUrl$path';
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
              child: _UserAvatarButton(
                fotoUrl: _buildFotoUrl(),
                onTap: () {
                  context.pushNamed('perfil');
                },
              ),
            ),
          ),
      ],
      // actions: [
      //   if (isHome)
      //     Padding(
      //       padding: const EdgeInsets.only(right: 15),
      //       child: Center(
      //         child: Material(
      //           color: Colors.transparent,
      //           shape: const CircleBorder(),
      //           child: InkWell(
      //             onTap: () {
      //               context.pushNamed('perfil');
      //             },
      //             customBorder: const CircleBorder(),
      //             child: Container(
      //               width: 42,
      //               height: 42,
      //               padding: const EdgeInsets.all(6),
      //               decoration: BoxDecoration(
      //                 color: colors.surface,
      //                 shape: BoxShape.circle,
      //               ),
      //               child: fotoUrl == null
      //                   ? Icon(
      //                       Icons.person_rounded,
      //                       size: 34,
      //                       color: colors.onPrimaryContainer,
      //                     )
      //                   : null,
      //               // child: Image.asset(
      //               //   'assets/img/user_black.png',
      //               //   fit: BoxFit.contain,
      //               // ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _UserAvatarButton extends StatelessWidget {
  final String? fotoUrl;
  final VoidCallback onTap;

  const _UserAvatarButton({required this.fotoUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 44,
          height: 44,
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surface,
          ),
          child: ClipOval(
            child: fotoUrl != null
                ? Image.network(
                    fotoUrl!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,

                    // Si la URL existe pero la imagen falla
                    errorBuilder: (context, error, stackTrace) {
                      return _DefaultUserAvatar(
                        backgroundColor: colors.primaryContainer,
                        iconColor: colors.onPrimaryContainer,
                      );
                    },
                  )
                : _DefaultUserAvatar(
                    backgroundColor: colors.primaryContainer,
                    iconColor: colors.onPrimaryContainer,
                  ),
          ),
        ),
      ),
    );
  }
}

class _DefaultUserAvatar extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;

  const _DefaultUserAvatar({
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Center(
        child: Icon(Icons.person_rounded, size: 27, color: iconColor),
      ),
    );
  }
}
