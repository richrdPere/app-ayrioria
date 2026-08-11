import 'package:flutter/material.dart';

class AppSettingsCard extends StatelessWidget {
  final List<Widget> children;

  final EdgeInsetsGeometry? padding;

  final Color? backgroundColor;

  final double borderRadius;

  final bool showBorder;

  const AppSettingsCard({
    super.key,
    required this.children,
    this.padding,
    this.backgroundColor,
    this.borderRadius = 18,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(borderRadius),

        border: showBorder
            ? Border.all(color: colors.outlineVariant.withValues(alpha: 0.5))
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}
