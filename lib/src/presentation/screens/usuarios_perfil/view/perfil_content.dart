import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// Environment
import 'package:app_aryoria/src/config/constants/environment.dart'
    as url_backend;

// Bloc
import 'package:app_aryoria/src/presentation/screens/usuarios_perfil/bloc/usuario_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/usuarios_perfil/bloc/usuario_state.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Models
import 'package:app_aryoria/src/data/models/usuario-perfil/perfil_usuario_data.dart';

// Global widgets
// import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_module_header.dart';

class PerfilContent extends StatelessWidget {
  final Future<void> Function() onRefresh;

  final VoidCallback onRetry;
  final VoidCallback onEditarPerfil;
  final VoidCallback onCambiarPassword;

  const PerfilContent({
    super.key,
    required this.onRefresh,
    required this.onRetry,
    required this.onEditarPerfil,
    required this.onCambiarPassword,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsuarioBloc, UsuarioState>(
      buildWhen: (previous, current) {
        return previous.perfil != current.perfil ||
            previous.perfilResponse != current.perfilResponse ||
            previous.actionResponse != current.actionResponse ||
            previous.fotoResponse != current.fotoResponse;
      },
      builder: (context, state) {
        final response = state.perfilResponse;

        // ======================================================
        // LOADING
        // ======================================================
        if (response is Loading && state.perfil == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // ======================================================
        // ERROR
        // ======================================================
        if (response is ErrorData<ApiResponse<PerfilUsuarioData>> &&
            state.perfil == null) {
          return _PerfilError(
            message: response.displayMessage,
            onRetry: onRetry,
          );
        }

        // ======================================================
        // SIN PERFIL
        // ======================================================
        final perfil = state.perfil;

        if (perfil == null) {
          return _PerfilError(
            message: 'No se pudo cargar la información del perfil.',
            onRetry: onRetry,
          );
        }

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              // ==================================================
              // HEADER
              // ==================================================
              // const AppModuleHeader(
              //   icon: Icons.person_outline_rounded,
              //   title: 'Tu perfil',
              //   description:
              //       'Consulta y administra tu información personal y los datos de acceso de tu cuenta.',
              // ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // ============================================
                    // AVATAR
                    // ============================================
                    _PerfilHeaderCard(perfil: perfil),

                    const SizedBox(height: 20),

                    // ============================================
                    // DATOS PERSONALES
                    // ============================================
                    _SectionCard(
                      title: 'Información personal',
                      icon: Icons.badge_outlined,
                      children: [
                        _InfoRow(
                          label: 'Nombres',
                          value: perfil.persona.nombres,
                          icon: Icons.person_outline,
                        ),

                        _InfoRow(
                          label: 'Apellidos',
                          value: perfil.persona.apellidos,
                          icon: Icons.person_outline,
                        ),

                        _InfoRow(
                          label: 'Tipo de documento',
                          value:
                              perfil.persona.tipoDocumento ?? 'No registrado',
                          icon: Icons.credit_card_outlined,
                        ),

                        _InfoRow(
                          label: 'Número de documento',
                          value:
                              perfil.persona.numeroDocumento ?? 'No registrado',
                          icon: Icons.numbers_outlined,
                        ),

                        _InfoRow(
                          label: 'Fecha de nacimiento',
                          value: _formatDate(perfil.persona.fechaNacimiento),
                          icon: Icons.cake_outlined,
                        ),

                        _InfoRow(
                          label: 'Género',
                          value: _formatGenero(perfil.persona.genero),
                          icon: Icons.wc_outlined,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ============================================
                    // CONTACTO
                    // ============================================
                    _SectionCard(
                      title: 'Información de contacto',
                      icon: Icons.contact_phone_outlined,
                      children: [
                        _InfoRow(
                          label: 'Correo personal',
                          value: perfil.persona.email ?? 'No registrado',
                          icon: Icons.email_outlined,
                        ),

                        _InfoRow(
                          label: 'Celular',
                          value: perfil.persona.celular ?? 'No registrado',
                          icon: Icons.phone_outlined,
                        ),

                        _InfoRow(
                          label: 'Dirección',
                          value: perfil.persona.direccion ?? 'No registrada',
                          icon: Icons.location_on_outlined,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ============================================
                    // CUENTA
                    // ============================================
                    _SectionCard(
                      title: 'Cuenta',
                      icon: Icons.manage_accounts_outlined,
                      children: [
                        _InfoRow(
                          label: 'Nombre de usuario',
                          value: perfil.usuario.username,
                          icon: Icons.alternate_email_rounded,
                        ),

                        _InfoRow(
                          label: 'Correo de acceso',
                          value: perfil.usuario.email,
                          icon: Icons.mail_outline_rounded,
                        ),

                        _InfoRow(
                          label: 'Estado',
                          value: perfil.usuario.estado ? 'Activo' : 'Inactivo',
                          icon: Icons.verified_user_outlined,
                        ),

                        _InfoRow(
                          label: 'Último acceso',
                          value: _formatDateTime(perfil.usuario.ultimoAcceso),
                          icon: Icons.history_rounded,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ============================================
                    // ROLES
                    // ============================================
                    _RolesCard(roles: perfil.roles),

                    const SizedBox(height: 24),

                    // ============================================
                    // ACCIONES
                    // ============================================
                    // _ActionsCard(
                    //   isUpdating: state.isUpdatingPerfil,
                    //   onEditarPerfil: onEditarPerfil,
                    //   onCambiarPassword: onCambiarPassword,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static String _formatDate(DateTime? date) {
    if (date == null) {
      return 'No registrada';
    }

    return DateFormat('dd/MM/yyyy', 'es_PE').format(date);
  }

  static String _formatDateTime(DateTime? date) {
    if (date == null) {
      return 'No registrado';
    }

    return DateFormat('dd/MM/yyyy · HH:mm', 'es_PE').format(date.toLocal());
  }

  static String _formatGenero(String? genero) {
    switch (genero?.toUpperCase()) {
      case 'M':
        return 'Masculino';

      case 'F':
        return 'Femenino';

      case 'OTRO':
        return 'Otro';

      default:
        return 'No registrado';
    }
  }
}

// ==========================================================
// PROFILE HEADER
// ==========================================================
class _PerfilHeaderCard extends StatelessWidget {
  final PerfilUsuarioData perfil;

  const _PerfilHeaderCard({required this.perfil});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final fotoUrl = _getFotoUrl(perfil.persona.fotoUrl);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // ====================================================
          // AVATAR
          // ====================================================
          CircleAvatar(
            radius: 48,
            backgroundColor: colors.primaryContainer,
            backgroundImage: fotoUrl != null ? NetworkImage(fotoUrl) : null,
            child: fotoUrl == null
                ? Icon(
                    Icons.person_rounded,
                    size: 46,
                    color: colors.onPrimaryContainer,
                  )
                : null,
          ),

          const SizedBox(height: 14),

          Text(
            perfil.persona.nombreCompleto,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            perfil.usuario.email,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: perfil.roles
                .map(
                  (rol) => Chip(
                    avatar: const Icon(Icons.shield_outlined, size: 16),
                    label: Text(rol.nombre),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  static String? _getFotoUrl(String? fotoUrl) {
    if (fotoUrl == null || fotoUrl.trim().isEmpty) {
      return null;
    }

    if (fotoUrl.startsWith('http://') || fotoUrl.startsWith('https://')) {
      return fotoUrl;
    }

    return '${url_backend.Environment.mainUrl}$fotoUrl';
  }
}

// ==========================================================
// SECTION CARD
// ==========================================================
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              children: [
                Icon(icon, color: colors.primary, size: 21),

                const SizedBox(width: 10),

                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            color: colors.outlineVariant.withValues(alpha: 0.5),
          ),

          ...children,
        ],
      ),
    );
  }
}

// ==========================================================
// INFO ROW
// ==========================================================
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colors.onSurfaceVariant),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
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

// ==========================================================
// ROLES
// ==========================================================
class _RolesCard extends StatelessWidget {
  final List<PerfilRol> roles;

  const _RolesCard({required this.roles});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.admin_panel_settings_outlined, color: colors.primary),

              const SizedBox(width: 10),

              Text(
                'Roles',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          if (roles.isEmpty)
            Text(
              'No existen roles asignados.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: roles
                  .map(
                    (rol) => Chip(
                      label: Text(rol.nombre),
                      avatar: const Icon(
                        Icons.verified_user_outlined,
                        size: 17,
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}

// // ==========================================================
// // ACTIONS
// // ==========================================================
// class _ActionsCard extends StatelessWidget {
//   final bool isUpdating;

//   final VoidCallback onEditarPerfil;
//   final VoidCallback onCambiarPassword;

//   const _ActionsCard({
//     required this.isUpdating,
//     required this.onEditarPerfil,
//     required this.onCambiarPassword,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           width: double.infinity,
//           child: FilledButton.icon(
//             onPressed: isUpdating ? null : onEditarPerfil,
//             icon: isUpdating
//                 ? const SizedBox(
//                     width: 18,
//                     height: 18,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                 : const Icon(Icons.edit_outlined),
//             label: Text(isUpdating ? 'Actualizando...' : 'Editar perfil'),
//           ),
//         ),

//         const SizedBox(height: 10),

//         SizedBox(
//           width: double.infinity,
//           child: OutlinedButton.icon(
//             onPressed: onCambiarPassword,
//             icon: const Icon(Icons.lock_outline_rounded),
//             label: const Text('Cambiar contraseña'),
//           ),
//         ),
//       ],
//     );
//   }
// }

// ==========================================================
// ERROR
// ==========================================================
class _PerfilError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _PerfilError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_off_outlined, size: 52, color: colors.error),

            const SizedBox(height: 16),

            Text(
              'No se pudo cargar el perfil',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
