import 'package:flutter/material.dart';

class AppSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  final EdgeInsetsGeometry padding;

  const AppSectionTitle({
    super.key,
    required this.title,
    required this.icon,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: padding,
      child: Row(
        children: [
          Icon(icon, size: 22, color: colors.primary),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
