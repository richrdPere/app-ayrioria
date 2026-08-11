import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Models
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_mensual.dart';

// Common
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/common/chart_container.dart';

class ChartEgresosCircular extends StatelessWidget {
  final List<FlujoCategoria> categorias;
  final double total;

  const ChartEgresosCircular({
    super.key,
    required this.categorias,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // ============================================================
    // OBTENER SUBCATEGORÍAS
    // ============================================================

    final subcategorias = categorias
        .expand(
          (categoria) => categoria.subcategorias.map(
            (subcategoria) => _SubcategoriaChartItem(
              nombre: subcategoria.nombre,
              categoria: categoria.categoria,
              total: subcategoria.total,
              cantidadMovimientos: subcategoria.cantidadMovimientos,
              color: _colorFromHex(
                categoria.color,
                fallback: colors.error,
              ),
            ),
          ),
        )
        .where(
          (subcategoria) => subcategoria.total > 0,
        )
        .toList();

    // ============================================================
    // SIN DATOS
    // ============================================================

    if (subcategorias.isEmpty) {
      return ChartContainer(
        titulo: 'Distribución de egresos',
        subtitulo: 'Egresos agrupados por subcategoría.',
        child: SizedBox(
          height: 220,
          child: Center(
            child: Text(
              'No hay egresos registrados.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      );
    }

    return ChartContainer(
      titulo: 'Distribución de egresos',
      subtitulo: 'Participación de cada subcategoría en los egresos.',
      child: Column(
        children: [
          // ========================================================
          // GRÁFICO
          // ========================================================

          SizedBox(
            height: 270,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 0,
                sectionsSpace: 2,

                sections: subcategorias.map(
                  (subcategoria) {
                    final porcentaje = total <= 0
                        ? 0.0
                        : (subcategoria.total / total) * 100;

                    return PieChartSectionData(
                      value: subcategoria.total,
                      color: subcategoria.color,
                      radius: 95,

                      // Evitamos mostrar porcentajes muy pequeños
                      // dentro del gráfico para no saturarlo.
                      title: porcentaje >= 3
                          ? '${porcentaje.toStringAsFixed(1)}%'
                          : '',

                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ========================================================
          // LEYENDA
          // ========================================================

          ...subcategorias.map(
            (subcategoria) {
              final porcentaje = total <= 0
                  ? 0.0
                  : (subcategoria.total / total) * 100;

              return _LegendRow(
                color: subcategoria.color,
                title: subcategoria.nombre,
                categoria: subcategoria.categoria,
                value: _formatSoles(
                  subcategoria.total,
                ),
                porcentaje: porcentaje,
                cantidadMovimientos:
                    subcategoria.cantidadMovimientos,
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FORMAT SOLES
  // ============================================================

  static String _formatSoles(double value) {
    final formatter = NumberFormat(
      '#,##0.00',
      'en_US',
    );

    return 'S/ ${formatter.format(value)}';
  }

  // ============================================================
  // HEX -> COLOR
  // ============================================================

  static Color _colorFromHex(
    String hex, {
    required Color fallback,
  }) {
    if (hex.isEmpty) {
      return fallback;
    }

    try {
      final cleanHex = hex.replaceFirst('#', '');

      final value = cleanHex.length == 6
          ? 'FF$cleanHex'
          : cleanHex;

      return Color(
        int.parse(
          value,
          radix: 16,
        ),
      );
    } catch (_) {
      return fallback;
    }
  }
}

// ============================================================
// MODELO INTERNO DEL CHART
// ============================================================

class _SubcategoriaChartItem {
  final String nombre;
  final String categoria;

  final double total;

  final int cantidadMovimientos;

  final Color color;

  const _SubcategoriaChartItem({
    required this.nombre,
    required this.categoria,
    required this.total,
    required this.cantidadMovimientos,
    required this.color,
  });
}

// ============================================================
// LEYENDA
// ============================================================

class _LegendRow extends StatelessWidget {
  final Color color;

  final String title;
  final String categoria;

  final String value;

  final double porcentaje;

  final int cantidadMovimientos;

  const _LegendRow({
    required this.color,
    required this.title,
    required this.categoria,
    required this.value,
    required this.porcentaje,
    required this.cantidadMovimientos,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========================================================
          // COLOR
          // ========================================================

          Container(
            width: 11,
            height: 11,
            margin: const EdgeInsets.only(
              top: 4,
            ),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 10),

          // ========================================================
          // INFORMACIÓN
          // ========================================================

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subcategoría
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                // Categoría padre
                Text(
                  categoria,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 2),

                // Cantidad de movimientos
                Text(
                  '$cantidadMovimientos '
                  '${cantidadMovimientos == 1 ? 'movimiento' : 'movimientos'}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // ========================================================
          // MONTO / PORCENTAJE
          // ========================================================

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                '${porcentaje.toStringAsFixed(1)}%',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}