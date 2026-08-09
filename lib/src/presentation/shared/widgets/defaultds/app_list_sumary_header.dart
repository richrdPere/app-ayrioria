import 'package:flutter/material.dart';

class AppListSummaryHeader extends StatelessWidget {
  final String title;

  /// Ej: movimiento / movimientos
  final String itemSingular;
  final String itemPlural;

  final int total;

  /// Ej: "Agosto 2026"
  final String? periodoNombre;

  final EdgeInsetsGeometry margin;

  const AppListSummaryHeader({
    super.key,
    required this.title,
    required this.total,
    required this.itemSingular,
    required this.itemPlural,
    this.periodoNombre,
    this.margin = const EdgeInsets.fromLTRB(20, 18, 20, 8),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final String itemText = total == 1 ? itemSingular : itemPlural;

    final bool tienePeriodo =
        periodoNombre != null && periodoNombre!.trim().isNotEmpty;

    return Padding(
      padding: margin,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ==================================================
          // INFORMACIÓN
          // ==================================================
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
                  '$total $itemText registrado${total == 1 ? '' : 's'}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // PERÍODO ACTIVO
          // ==================================================
          if (tienePeriodo) ...[
            const SizedBox(width: 12),

            Container(
              constraints: const BoxConstraints(maxWidth: 165),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 17,
                    color: colors.primary,
                  ),

                  const SizedBox(width: 6),

                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Período activo',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colors.onPrimaryContainer.withValues(
                              alpha: 0.70,
                            ),
                          ),
                        ),
                        Text(
                          periodoNombre!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
