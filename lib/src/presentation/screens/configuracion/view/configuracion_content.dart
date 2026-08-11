import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Widgets
import 'package:app_aryoria/src/presentation/screens/configuracion/view/widgets/profile_card.dart';
import 'package:app_aryoria/src/presentation/screens/configuracion/view/widgets/profile_loading_card.dart';
import 'package:app_aryoria/src/presentation/screens/usuarios_perfil/bloc/usuario_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/usuarios_perfil/bloc/usuario_state.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_section_title.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_setting_divider.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_setting_tile.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_settings_card.dart';

// Defaults
// import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_module_header.dart';

class ConfiguracionContent extends StatelessWidget {
  final VoidCallback onPerfil;
  final VoidCallback onEmpresa;
  final VoidCallback onPeriodo;
  final VoidCallback onTheme;
  final VoidCallback onIdioma;
  final VoidCallback onRolesPermisos;
  final VoidCallback onAcercaDe;
  final VoidCallback onLogout;

  const ConfiguracionContent({
    super.key,
    required this.onPerfil,
    required this.onEmpresa,
    required this.onPeriodo,
    required this.onTheme,
    required this.onIdioma,
    required this.onRolesPermisos,
    required this.onAcercaDe,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colors.surface,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // HEADER
              // ==================================================
              // const AppModuleHeader(
              //   icon: Icons.settings_outlined,
              //   title: 'Personaliza Aryoria',
              //   description:
              //       'Administra tu perfil, preferencias de apariencia y opciones generales de tu cuenta.',
              // ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ============================================
                    // PERFIL
                    // ============================================
                    const AppSectionTitle(
                      title: 'Perfil',
                      icon: Icons.person_outline_rounded,
                    ),

                    const SizedBox(height: 10),

                    BlocBuilder<UsuarioBloc, UsuarioState>(
                      buildWhen: (previous, current) {
                        return previous.perfil != current.perfil ||
                            previous.perfilResponse != current.perfilResponse;
                      },
                      builder: (context, state) {
                        if (state.perfil == null) {
                          return ProfileLoadingCard(
                            isLoading: state.isLoadingPerfil,
                          );
                        }

                        final perfil = state.perfil!;

                        return ProfileCard(
                          name: perfil.persona.nombreCompleto,
                          role: perfil.roles.isNotEmpty
                              ? perfil.roles.first.nombre
                              : 'Usuario',
                          email: perfil.usuario.email,
                          fotoUrl: perfil.persona.fotoUrl,
                          onTap: onPerfil,
                        );
                      },
                    ),

                    const SizedBox(height: 28),

                    // ============================================
                    // GENERAL
                    // ============================================
                    const AppSectionTitle(
                      title: 'General',
                      icon: Icons.tune_outlined,
                    ),

                    const SizedBox(height: 10),

                    AppSettingsCard(
                      children: [
                        AppSettingTile(
                          icon: Icons.business_outlined,
                          title: 'Empresa activa',
                          subtitle: 'Seleccionar empresa',
                          // onTap: onEmpresa,
                        ),

                        const AppSettingDivider(),

                        AppSettingTile(
                          icon: Icons.calendar_month_outlined,
                          title: 'Período contable',
                          subtitle: 'Administrar períodos',
                          onTap: onPeriodo,
                        ),

                        const AppSettingDivider(),

                        AppSettingTile(
                          icon: Icons.palette_outlined,
                          title: 'Tema',
                          subtitle: 'Color y apariencia de la aplicación',
                          onTap: onTheme,
                        ),

                        const AppSettingDivider(),

                        AppSettingTile(
                          icon: Icons.language_outlined,
                          title: 'Idioma',
                          subtitle: 'Español',
                          // onTap: onIdioma,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ============================================
                    // SEGURIDAD
                    // ============================================
                    // const AppSectionTitle(
                    //   title: 'Seguridad',
                    //   icon: Icons.security_outlined,
                    // ),

                    // const SizedBox(height: 10),

                    // AppSettingsCard(
                    //   children: [
                    //     AppSettingTile(
                    //       icon: Icons.lock_outline_rounded,
                    //       title: 'Perfil y seguridad',
                    //       subtitle: 'Datos personales y contraseña',
                    //       onTap: onPerfil,
                    //     ),

                    //     const AppSettingDivider(),

                    //     AppSettingTile(
                    //       icon: Icons.admin_panel_settings_outlined,
                    //       title: 'Roles y permisos',
                    //       subtitle: 'Consulta tus accesos',
                    //       onTap: onRolesPermisos,
                    //     ),
                    //   ],
                    // ),

                    // const SizedBox(height: 28),

                    // ============================================
                    // APLICACIÓN
                    // ============================================
                    const AppSectionTitle(
                      title: 'Aplicación',
                      icon: Icons.apps_outlined,
                    ),

                    const SizedBox(height: 10),

                    AppSettingsCard(
                      children: [
                        AppSettingTile(
                          icon: Icons.info_outline,
                          title: 'Acerca de Aryoria',
                          subtitle: 'Versión 1.0.0',
                          // onTap: onAcercaDe,
                        ),

                        const AppSettingDivider(),

                        AppSettingTile(
                          icon: Icons.logout_outlined,
                          title: 'Cerrar sesión',
                          subtitle: 'Salir de tu cuenta',
                          destructive: true,
                          showChevron: false,
                          onTap: onLogout,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
