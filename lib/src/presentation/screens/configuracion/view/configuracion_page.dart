
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfiguracionPage extends StatelessWidget {
  const ConfiguracionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    // final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colors.surface,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================================
              // HEADER
              // ============================================================
              // Text(
              //   'Configuración',
              //   style: textTheme.headlineMedium?.copyWith(
              //     fontWeight: FontWeight.bold,
              //     color: colors.onSurface,
              //   ),
              // ),

              // const SizedBox(height: 6),

              // Text(
              //   'Administra tu cuenta y las preferencias del sistema.',
              //   style: textTheme.bodyMedium?.copyWith(
              //     color: colors.onSurfaceVariant,
              //   ),
              // ),
              // const SizedBox(height: 24),


              const _SectionTitle(title: 'Perfil', icon: Icons.person_sharp),

              const SizedBox(height: 10),

              // ============================================================
              // PERFIL
              // ============================================================
              _ProfileCard(
                name: 'Richard Pereira',
                role: 'Administrador',
                email: 'richard@email.com',
                onEdit: () {},
              ),

              const SizedBox(height: 28),

              // ============================================================
              // GENERAL
              // ============================================================
              const _SectionTitle(title: 'General', icon: Icons.tune_outlined),

              const SizedBox(height: 10),

              _SettingsCard(
                children: [
                  _SettingTile(
                    icon: Icons.business_outlined,
                    title: 'Empresa activa',
                    subtitle: 'Seleccionar empresa',
                    onTap: () {},
                  ),

                  const _SettingDivider(),

                  _SettingTile(
                    icon: Icons.calendar_month_outlined,
                    title: 'Período contable',
                    subtitle: 'Seleccionar período',
                    onTap: () {},
                  ),

                  const _SettingDivider(),

                  _SettingTile(
                    icon: Icons.palette_outlined,
                    title: 'Tema',
                    subtitle: 'Personalizar apariencia',
                    onTap: () {
                      context.pushNamed('theme');
                    },
                  ),

                  const _SettingDivider(),

                  _SettingTile(
                    icon: Icons.language_outlined,
                    title: 'Idioma',
                    subtitle: 'Español',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ============================================================
              // SEGURIDAD
              // ============================================================
              const _SectionTitle(
                title: 'Seguridad',
                icon: Icons.security_outlined,
              ),

              const SizedBox(height: 10),

              _SettingsCard(
                children: [
                  _SettingTile(
                    icon: Icons.lock_outline,
                    title: 'Cambiar contraseña',
                    subtitle: 'Actualizar tus credenciales',
                    onTap: () {},
                  ),

                  const _SettingDivider(),

                  _SettingTile(
                    icon: Icons.admin_panel_settings_outlined,
                    title: 'Roles y permisos',
                    subtitle: 'Administrar accesos',
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ============================================================
              // APLICACIÓN
              // ============================================================
              const _SectionTitle(
                title: 'Aplicación',
                icon: Icons.apps_outlined,
              ),

              const SizedBox(height: 10),

              _SettingsCard(
                children: [
                  _SettingTile(
                    icon: Icons.info_outline,
                    title: 'Acerca de Aryoria',
                    subtitle: 'Versión 1.0.0',
                    onTap: () {},
                  ),

                  const _SettingDivider(),

                  _SettingTile(
                    icon: Icons.logout_outlined,
                    title: 'Cerrar sesión',
                    subtitle: 'Salir de tu cuenta',
                    destructive: true,
                    showChevron: false,
                    onTap: () {
                      // Logout
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PROFILE CARD
// ============================================================================
class _ProfileCard extends StatelessWidget {
  final String name;
  final String role;
  final String email;
  final VoidCallback onEdit;

  const _ProfileCard({
    required this.name,
    required this.role,
    required this.email,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline,
              size: 34,
              color: colors.onPrimaryContainer,
            ),
          ),

          const SizedBox(width: 16),

          // Datos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),

                const SizedBox(height: 4),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colors.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    role,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colors.onSecondaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 7),

                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 15,
                      color: colors.onSurfaceVariant,
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Editar
          IconButton(
            tooltip: 'Editar perfil',
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SECTION TITLE
// ============================================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 22, color: colors.primary),

        const SizedBox(width: 8),

        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// SETTINGS CARD
// ============================================================================
class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(children: children),
      ),
    );
  }
}

// ============================================================================
// SETTING TILE
// ============================================================================
class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  final bool destructive;
  final bool showChevron;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.destructive = false,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final iconBackground = destructive
        ? colors.errorContainer
        : colors.primaryContainer;

    final iconForeground = destructive
        ? colors.onErrorContainer
        : colors.onPrimaryContainer;

    final titleColor = destructive ? colors.error : colors.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          child: ListTile(
            contentPadding: EdgeInsets.zero,

            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: iconForeground, size: 23),
            ),

            title: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
            ),

            subtitle: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),

            trailing: showChevron
                ? Icon(
                    Icons.chevron_right_rounded,
                    color: colors.onSurfaceVariant,
                  )
                : null,

            onTap: onTap,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DIVIDER
// ============================================================================

class _SettingDivider extends StatelessWidget {
  const _SettingDivider();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Divider(
      height: 1,
      indent: 72,
      endIndent: 16,
      color: colors.outlineVariant.withValues(alpha: 0.5),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class ConfiguracionPage extends StatelessWidget {
//   const ConfiguracionPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),

//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,

//           children: [
//             const Text(
//               "Configuración",
//               style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 5),

//             Text(
//               "Administra tu cuenta y las preferencias del sistema.",
//               style: TextStyle(color: Colors.grey.shade700),
//             ),

//             const SizedBox(height: 25),

//             Card(
//               elevation: 2,

//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),

//               child: Padding(
//                 padding: const EdgeInsets.all(20),

//                 child: Row(
//                   children: [
//                     const CircleAvatar(
//                       radius: 35,
//                       child: Icon(Icons.person, size: 35),
//                     ),

//                     const SizedBox(width: 20),

//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,

//                         children: const [
//                           Text(
//                             "Richard Pereira",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                             ),
//                           ),

//                           SizedBox(height: 5),

//                           Text(
//                             "Administrador",
//                             style: TextStyle(color: Colors.grey),
//                           ),

//                           SizedBox(height: 3),

//                           Text(
//                             "richard@email.com",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ),

//                     IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 30),

//             const Text(
//               "General",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),

//             const SizedBox(height: 10),

//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),

//               child: Column(
//                 children: [
//                   _SettingTile(
//                     icon: Icons.business,
//                     title: "Empresa Activa",
//                     subtitle: "Seleccionar empresa",
//                     onTap: () {},
//                   ),

//                   Divider(height: 1),

//                   _SettingTile(
//                     icon: Icons.calendar_month,
//                     title: "Periodo Contable",
//                     subtitle: "Seleccionar periodo",
//                     onTap: () {},
//                   ),

//                   Divider(height: 1),

//                   _SettingTile(
//                     icon: Icons.palette,
//                     title: "Tema",
//                     subtitle: "Claro",
//                     onTap: () {
//                       context.pushNamed('theme');
//                     },
//                   ),

//                   Divider(height: 1),

//                   _SettingTile(
//                     icon: Icons.language,
//                     title: "Idioma",
//                     subtitle: "Español",
//                     onTap: () {},
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 25),

//             const Text(
//               "Seguridad",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),

//             const SizedBox(height: 10),

//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),

//               child: Column(
//                 children: [
//                   _SettingTile(
//                     icon: Icons.lock,
//                     title: "Cambiar contraseña",
//                     subtitle: "Actualizar credenciales",
//                     onTap: () {},
//                   ),

//                   Divider(height: 1),

//                   _SettingTile(
//                     icon: Icons.verified_user,
//                     title: "Roles y permisos",
//                     subtitle: "Administrar accesos",
//                     onTap: () {},
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 25),

//             const Text(
//               "Aplicación",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),

//             const SizedBox(height: 10),

//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),

//               child: Column(
//                 children: [
//                   _SettingTile(
//                     icon: Icons.info_outline,
//                     title: "Acerca de",
//                     subtitle: "Versión 1.0.0",
//                     onTap: () {},
//                   ),

//                   Divider(height: 1),

//                   _SettingTile(
//                     icon: Icons.logout,
//                     title: "Cerrar sesión",
//                     subtitle: "Salir del sistema",
//                     iconColor: Colors.red,
//                     onTap: () {
//                       // Logout
//                     },
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _SettingTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final VoidCallback onTap;
//   final Color? iconColor;

//   const _SettingTile({
//     required this.icon,
//     required this.title,
//     required this.subtitle,
//     required this.onTap,
//     this.iconColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: CircleAvatar(
//         backgroundColor: Colors.blue.shade50,

//         child: Icon(icon, color: iconColor ?? Colors.blue),
//       ),

//       title: Text(title),

//       subtitle: Text(subtitle),

//       trailing: const Icon(Icons.chevron_right),

//       onTap: onTap,
//     );
//   }
// }
