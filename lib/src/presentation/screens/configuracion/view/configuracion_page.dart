import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Modelo
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_data.dart';

// Usuario
import 'package:app_aryoria/src/presentation/screens/usuarios_perfil/bloc/usuario_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/usuarios_perfil/bloc/usuario_event.dart';
import 'package:app_aryoria/src/presentation/screens/usuarios_perfil/bloc/usuario_state.dart';

// Content
import 'package:app_aryoria/src/presentation/screens/configuracion/view/configuracion_content.dart';

class ConfiguracionPage extends StatefulWidget {
  const ConfiguracionPage({super.key});

  @override
  State<ConfiguracionPage> createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends State<ConfiguracionPage> {
  // ==========================================================
  // INIT
  // ==========================================================
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _loadPerfil();
    });
  }

  // ==========================================================
  // CARGAR PERFIL
  // ==========================================================
  void _loadPerfil() {
    final state = context.read<UsuarioBloc>().state;

    // Evitamos hacer un GET innecesario si ya
    // tenemos el perfil cargado.
    if (state.perfil != null) {
      return;
    }

    context.read<UsuarioBloc>().add(const GetPerfilUsuarioEvent());
  }

  // ==========================================================
  // ABRIR PERFIL
  // ==========================================================
  Future<void> _onPerfil() async {
    final result = await context.pushNamed('perfil_usuario');

    if (!mounted) return;

    if (result == true) {
      context.read<UsuarioBloc>().add(const GetPerfilUsuarioEvent());
    }
  }

  // ==========================================================
  // TEMA
  // ==========================================================
  void _onTheme() {
    context.pushNamed('theme');
  }

  // ==========================================================
  // EMPRESA
  // ==========================================================
  void _onEmpresa() {
    // Puedes conectarlo después con tu selector de empresa.
  }

  // ==========================================================
  // PERÍODO
  // ==========================================================
  void _onPeriodo() {
    context.pushNamed('periodos_contables');
  }

  // ==========================================================
  // IDIOMA
  // ==========================================================
  void _onIdioma() {
    // Para implementar más adelante.
  }

  // ==========================================================
  // ROLES
  // ==========================================================
  void _onRolesPermisos() {
    // Solo habilitar cuando corresponda al rol.
  }

  // ==========================================================
  // ACERCA DE
  // ==========================================================
  void _onAcercaDe() {
    showAboutDialog(
      context: context,
      applicationName: 'Aryoria',
      applicationVersion: '1.0.0',
      applicationLegalese: 'Sistema de gestión financiera.',
    );
  }

  // ==========================================================
  // CERRAR SESIÓN
  // ==========================================================
  Future<void> _onLogout() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Deseas cerrar tu sesión actual?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    context.goNamed('logout');
  }

  // ==========================================================
  // ERROR
  // ==========================================================
  void _showError(String message) {
    if (!mounted) return;

    final colors = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: colors.error),
      );
  }

  // ==========================================================
  // BUILD
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    return BlocListener<UsuarioBloc, UsuarioState>(
      listenWhen: (previous, current) {
        return previous.perfilResponse != current.perfilResponse;
      },
      listener: (context, state) {
        final response = state.perfilResponse;

        if (response is ErrorData<ApiResponse<PerfilUsuarioData>>) {
          _showError(response.displayMessage);
        }
      },
      child: ConfiguracionContent(
        onPerfil: _onPerfil,
        onEmpresa: _onEmpresa,
        onPeriodo: _onPeriodo,
        onTheme: _onTheme,
        onIdioma: _onIdioma,
        onRolesPermisos: _onRolesPermisos,
        onAcercaDe: _onAcercaDe,
        onLogout: _onLogout,
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class ConfiguracionPage extends StatelessWidget {
//   const ConfiguracionPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;
//     // final textTheme = theme.textTheme;

//     return Scaffold(
//       backgroundColor: colors.surface,

//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),

//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ============================================================
//               // HEADER
//               // ============================================================
//               // Text(
//               //   'Configuración',
//               //   style: textTheme.headlineMedium?.copyWith(
//               //     fontWeight: FontWeight.bold,
//               //     color: colors.onSurface,
//               //   ),
//               // ),

//               // const SizedBox(height: 6),

//               // Text(
//               //   'Administra tu cuenta y las preferencias del sistema.',
//               //   style: textTheme.bodyMedium?.copyWith(
//               //     color: colors.onSurfaceVariant,
//               //   ),
//               // ),
//               // const SizedBox(height: 24),


//               const _SectionTitle(title: 'Perfil', icon: Icons.person_sharp),

//               const SizedBox(height: 10),

//               // ============================================================
//               // PERFIL
//               // ============================================================
//               _ProfileCard(
//                 name: 'Richard Pereira',
//                 role: 'Administrador',
//                 email: 'richard@email.com',
//                 onEdit: () {},
//               ),

//               const SizedBox(height: 28),

//               // ============================================================
//               // GENERAL
//               // ============================================================
//               const _SectionTitle(title: 'General', icon: Icons.tune_outlined),

//               const SizedBox(height: 10),

//               _SettingsCard(
//                 children: [
//                   _SettingTile(
//                     icon: Icons.business_outlined,
//                     title: 'Empresa activa',
//                     subtitle: 'Seleccionar empresa',
//                     onTap: () {},
//                   ),

//                   const _SettingDivider(),

//                   _SettingTile(
//                     icon: Icons.calendar_month_outlined,
//                     title: 'Período contable',
//                     subtitle: 'Seleccionar período',
//                     onTap: () {},
//                   ),

//                   const _SettingDivider(),

//                   _SettingTile(
//                     icon: Icons.palette_outlined,
//                     title: 'Tema',
//                     subtitle: 'Personalizar apariencia',
//                     onTap: () {
//                       context.pushNamed('theme');
//                     },
//                   ),

//                   const _SettingDivider(),

//                   _SettingTile(
//                     icon: Icons.language_outlined,
//                     title: 'Idioma',
//                     subtitle: 'Español',
//                     onTap: () {},
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 28),

//               // ============================================================
//               // SEGURIDAD
//               // ============================================================
//               const _SectionTitle(
//                 title: 'Seguridad',
//                 icon: Icons.security_outlined,
//               ),

//               const SizedBox(height: 10),

//               _SettingsCard(
//                 children: [
//                   _SettingTile(
//                     icon: Icons.lock_outline,
//                     title: 'Cambiar contraseña',
//                     subtitle: 'Actualizar tus credenciales',
//                     onTap: () {},
//                   ),

//                   const _SettingDivider(),

//                   _SettingTile(
//                     icon: Icons.admin_panel_settings_outlined,
//                     title: 'Roles y permisos',
//                     subtitle: 'Administrar accesos',
//                     onTap: () {},
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 28),

//               // ============================================================
//               // APLICACIÓN
//               // ============================================================
//               const _SectionTitle(
//                 title: 'Aplicación',
//                 icon: Icons.apps_outlined,
//               ),

//               const SizedBox(height: 10),

//               _SettingsCard(
//                 children: [
//                   _SettingTile(
//                     icon: Icons.info_outline,
//                     title: 'Acerca de Aryoria',
//                     subtitle: 'Versión 1.0.0',
//                     onTap: () {},
//                   ),

//                   const _SettingDivider(),

//                   _SettingTile(
//                     icon: Icons.logout_outlined,
//                     title: 'Cerrar sesión',
//                     subtitle: 'Salir de tu cuenta',
//                     destructive: true,
//                     showChevron: false,
//                     onTap: () {
//                       // Logout
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ============================================================================
// // PROFILE CARD
// // ============================================================================
// class _ProfileCard extends StatelessWidget {
//   final String name;
//   final String role;
//   final String email;
//   final VoidCallback onEdit;

//   const _ProfileCard({
//     required this.name,
//     required this.role,
//     required this.email,
//     required this.onEdit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: colors.surfaceContainerLow,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
//       ),
//       child: Row(
//         children: [
//           // Avatar
//           Container(
//             width: 64,
//             height: 64,
//             decoration: BoxDecoration(
//               color: colors.primaryContainer,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.person_outline,
//               size: 34,
//               color: colors.onPrimaryContainer,
//             ),
//           ),

//           const SizedBox(width: 16),

//           // Datos
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: theme.textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: colors.onSurface,
//                   ),
//                 ),

//                 const SizedBox(height: 4),

//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 9,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: colors.secondaryContainer,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     role,
//                     style: theme.textTheme.labelMedium?.copyWith(
//                       color: colors.onSecondaryContainer,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 7),

//                 Row(
//                   children: [
//                     Icon(
//                       Icons.email_outlined,
//                       size: 15,
//                       color: colors.onSurfaceVariant,
//                     ),

//                     const SizedBox(width: 5),

//                     Expanded(
//                       child: Text(
//                         email,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: theme.textTheme.bodySmall?.copyWith(
//                           color: colors.onSurfaceVariant,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(width: 8),

//           // Editar
//           IconButton(
//             tooltip: 'Editar perfil',
//             onPressed: onEdit,
//             icon: const Icon(Icons.edit_outlined),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ============================================================================
// // SECTION TITLE
// // ============================================================================

// class _SectionTitle extends StatelessWidget {
//   final String title;
//   final IconData icon;

//   const _SectionTitle({required this.title, required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;

//     return Row(
//       children: [
//         Icon(icon, size: 22, color: colors.primary),

//         const SizedBox(width: 8),

//         Text(
//           title,
//           style: theme.textTheme.titleMedium?.copyWith(
//             fontWeight: FontWeight.bold,
//             color: colors.onSurface,
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ============================================================================
// // SETTINGS CARD
// // ============================================================================
// class _SettingsCard extends StatelessWidget {
//   final List<Widget> children;

//   const _SettingsCard({required this.children});

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return Container(
//       decoration: BoxDecoration(
//         color: colors.surfaceContainerLow,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(18),
//         child: Column(children: children),
//       ),
//     );
//   }
// }

// // ============================================================================
// // SETTING TILE
// // ============================================================================
// class _SettingTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;

//   final bool destructive;
//   final bool showChevron;

//   const _SettingTile({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.onTap,
//     this.destructive = false,
//     this.showChevron = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;

//     final iconBackground = destructive
//         ? colors.errorContainer
//         : colors.primaryContainer;

//     final iconForeground = destructive
//         ? colors.onErrorContainer
//         : colors.onPrimaryContainer;

//     final titleColor = destructive ? colors.error : colors.onSurface;

//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
//           child: ListTile(
//             contentPadding: EdgeInsets.zero,

//             leading: Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 color: iconBackground,
//                 borderRadius: BorderRadius.circular(13),
//               ),
//               child: Icon(icon, color: iconForeground, size: 23),
//             ),

//             title: Text(
//               title,
//               style: theme.textTheme.bodyLarge?.copyWith(
//                 fontWeight: FontWeight.w600,
//                 color: titleColor,
//               ),
//             ),

//             subtitle: Padding(
//               padding: const EdgeInsets.only(top: 2),
//               child: Text(
//                 subtitle,
//                 style: theme.textTheme.bodySmall?.copyWith(
//                   color: colors.onSurfaceVariant,
//                 ),
//               ),
//             ),

//             trailing: showChevron
//                 ? Icon(
//                     Icons.chevron_right_rounded,
//                     color: colors.onSurfaceVariant,
//                   )
//                 : null,

//             onTap: onTap,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ============================================================================
// // DIVIDER
// // ============================================================================

// class _SettingDivider extends StatelessWidget {
//   const _SettingDivider();

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return Divider(
//       height: 1,
//       indent: 72,
//       endIndent: 16,
//       color: colors.outlineVariant.withValues(alpha: 0.5),
//     );
//   }
// }
