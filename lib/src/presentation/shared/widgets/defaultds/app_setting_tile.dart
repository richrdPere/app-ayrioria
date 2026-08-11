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
  });

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
        onTap: onTap,
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
                        Icons.chevron_right_rounded,
                        color: colors.onSurfaceVariant,
                      )
                    : null),

            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
