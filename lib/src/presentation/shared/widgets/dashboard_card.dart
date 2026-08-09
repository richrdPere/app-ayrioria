import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final IconData icon;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.titulo,
    required this.descripcion,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // ======================================================
        // MEDIDAS RESPONSIVAS
        // ======================================================

        final horizontalPadding = (width * 0.045).clamp(14.0, 22.0);

        final verticalPadding = (width * 0.035).clamp(12.0, 18.0);

        final iconContainerSize = (width * 0.15).clamp(48.0, 58.0);

        final iconSize = (width * 0.075).clamp(24.0, 30.0);

        final arrowSize = (width * 0.05).clamp(16.0, 21.0);

        final titleFontSize = (width * 0.045).clamp(15.0, 18.0);

        final descriptionFontSize = (width * 0.034).clamp(12.0, 14.0);

        final borderRadius = (width * 0.045).clamp(14.0, 18.0);

        return Card(
          elevation: 1,

          margin: const EdgeInsets.only(bottom: 14),

          color: colors.surfaceContainerLow,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: colors.outlineVariant.withValues(alpha: 0.45),
            ),
          ),

          clipBehavior: Clip.antiAlias,

          child: InkWell(
            onTap: onTap,

            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),

              child: Row(
                children: [
                  // ==============================================
                  // ICONO
                  // ==============================================
                  Container(
                    width: iconContainerSize,
                    height: iconContainerSize,

                    decoration: BoxDecoration(
                      color: colors.primaryContainer,

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: Icon(
                      icon,
                      size: iconSize,
                      color: colors.onPrimaryContainer,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // ==============================================
                  // INFORMACIÓN
                  // ==============================================
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ------------------------------------------
                        // TÍTULO
                        // ------------------------------------------
                        Text(
                          titulo,

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface,
                          ),
                        ),

                        const SizedBox(height: 5),

                        // ------------------------------------------
                        // DESCRIPCIÓN
                        // ------------------------------------------
                        Text(
                          descripcion,

                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            fontSize: descriptionFontSize,
                            height: 1.25,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // ==============================================
                  // FLECHA
                  // ==============================================
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: arrowSize,
                    color: colors.onSurfaceVariant.withValues(alpha: 0.75),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
