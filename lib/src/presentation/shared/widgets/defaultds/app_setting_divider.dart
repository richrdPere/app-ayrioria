import 'package:flutter/material.dart';

class AppSettingDivider extends StatelessWidget {
  final double indent;
  final double endIndent;

  final double height;

  final double opacity;

  const AppSettingDivider({
    super.key,
    this.indent = 72,
    this.endIndent = 16,
    this.height = 1,
    this.opacity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Divider(
      height: height,
      indent: indent,
      endIndent: endIndent,
      color: colors.outlineVariant.withValues(alpha: opacity),
    );
  }
}
