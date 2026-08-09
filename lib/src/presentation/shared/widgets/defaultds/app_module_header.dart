import 'package:flutter/material.dart';

class AppModuleHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  final Color? backgroundColor;
  final Color? iconBackgroundColor;
  final Color? iconColor;

  const AppModuleHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.margin = const EdgeInsets.fromLTRB(20, 16, 20, 8),
    this.padding = const EdgeInsets.all(18),
    this.backgroundColor,
    this.iconBackgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBackgroundColor ?? colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: iconColor ?? colorScheme.onPrimary,
              size: 26,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                    color: colorScheme.onPrimaryContainer.withValues(
                      alpha: 0.80,
                    ),
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
