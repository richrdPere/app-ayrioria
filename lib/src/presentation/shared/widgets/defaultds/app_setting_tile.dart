import 'package:flutter/material.dart';

class AppSettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  final VoidCallback? onTap;

  final bool destructive;
  final bool showChevron;

  final Widget? trailing;

  final Color? iconBackgroundColor;
  final Color? iconColor;
  final Color? titleColor;

  /// Mensaje personalizado cuando la opción todavía
  /// no tiene una acción implementada.
  final String? comingSoonMessage;

  const AppSettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.destructive = false,
    this.showChevron = true,
    this.trailing,
    this.iconBackgroundColor,
    this.iconColor,
    this.titleColor,
    this.comingSoonMessage,
  });

  // ==========================================================
  // ON TAP
  // ==========================================================
  void _handleTap(BuildContext context) {
    // ========================================================
    // FUNCIÓN IMPLEMENTADA
    // ========================================================
    if (onTap != null) {
      onTap!.call();
      return;
    }

    // ========================================================
    // FUNCIÓN PENDIENTE
    // ========================================================
    final colors = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,

          margin: const EdgeInsets.all(16),

          backgroundColor: colors.inverseSurface,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          content: Row(
            children: [
              // ==================================================
              // ICONO
              // ==================================================
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.construction_rounded,
                  size: 20,
                  color: colors.primary,
                ),
              ),

              const SizedBox(width: 12),

              // ==================================================
              // MENSAJE
              // ==================================================
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Próximamente',
                      style: TextStyle(
                        color: colors.onInverseSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      comingSoonMessage ??
                          '$title estará disponible en una próxima actualización.',
                      style: TextStyle(
                        color: colors.onInverseSurface.withValues(alpha: 0.80),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // ==========================================================
    // COLORES
    // ==========================================================
    final defaultIconBackground = destructive
        ? colors.errorContainer
        : colors.primaryContainer;

    final defaultIconColor = destructive
        ? colors.onErrorContainer
        : colors.onPrimaryContainer;

    final defaultTitleColor = destructive ? colors.error : colors.onSurface;

    // ==========================================================
    // TILE
    // ==========================================================
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _handleTap(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          child: ListTile(
            contentPadding: EdgeInsets.zero,

            // ==================================================
            // ICONO
            // ==================================================
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBackgroundColor ?? defaultIconBackground,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: iconColor ?? defaultIconColor, size: 23),
            ),

            // ==================================================
            // TÍTULO
            // ==================================================
            title: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: titleColor ?? defaultTitleColor,
              ),
            ),

            // ==================================================
            // SUBTÍTULO
            // ==================================================
            subtitle: subtitle != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  )
                : null,

            // ==================================================
            // TRAILING
            // ==================================================
            trailing:
                trailing ??
                (showChevron
                    ? Icon(
                        onTap != null
                            ? Icons.chevron_right_rounded
                            : Icons.schedule_rounded,
                        color: colors.onSurfaceVariant,
                      )
                    : null),

            onTap: () => _handleTap(context),
          ),
        ),
      ),
    );
  }
}
