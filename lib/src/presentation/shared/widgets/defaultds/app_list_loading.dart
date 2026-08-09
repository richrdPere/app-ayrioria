import 'package:flutter/material.dart';

class AppListLoading extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double separatorHeight;

  const AppListLoading({
    super.key,
    this.itemCount = 6,
    this.itemHeight = 82,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 80),
    this.separatorHeight = 12,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: separatorHeight),
      itemBuilder: (_, __) {
        return Container(
          height: itemHeight,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
      },
    );
  }
}
