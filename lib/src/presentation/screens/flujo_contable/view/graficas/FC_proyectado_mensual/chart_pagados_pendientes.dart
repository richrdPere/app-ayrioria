import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Common
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/common/chart_container.dart';

// Model
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_proyectado.dart';

class ChartPagadosPendientes extends StatelessWidget {
  final FlujoProyectadoResumen ingresos;
  final FlujoProyectadoResumen egresos;

  const ChartPagadosPendientes({
    super.key,
    required this.ingresos,
    required this.egresos,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final maxValue = [
      ingresos.pagados,
      ingresos.pendientes,
      egresos.pagados,
      egresos.pendientes,
    ].fold<double>(0, (previous, value) => max(previous, value));

    final maxY = maxValue <= 0 ? 1000.0 : maxValue * 1.25;
    final intervalY = _calcularIntervalo(maxY);

    return ChartContainer(
      titulo: 'Pagados vs pendientes',
      subtitulo: 'Compara los movimientos realizados y pendientes del período.',
      child: SizedBox(
        height: 310,
        child: BarChart(
          BarChartData(
            minY: 0,
            maxY: maxY,

            // ======================================================
            // GRID
            // ======================================================
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: intervalY,
              getDrawingHorizontalLine: (_) {
                return FlLine(
                  color: colors.outlineVariant.withValues(alpha: 0.35),
                  strokeWidth: 1,
                );
              },
            ),

            // ======================================================
            // BORDER
            // ======================================================
            borderData: FlBorderData(show: false),

            // ======================================================
            // BARRAS
            // ======================================================
            barGroups: [
              BarChartGroupData(
                x: 0,
                barsSpace: 5,
                barRods: [
                  // Ingresos pagados
                  BarChartRodData(
                    toY: ingresos.pagados,
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                    color: colors.primary,
                  ),

                  // Ingresos pendientes
                  BarChartRodData(
                    toY: ingresos.pendientes,
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                    color: colors.primaryContainer,
                  ),
                ],
              ),

              BarChartGroupData(
                x: 1,
                barsSpace: 5,
                barRods: [
                  // Egresos pagados
                  BarChartRodData(
                    toY: egresos.pagados,
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                    color: colors.error,
                  ),

                  // Egresos pendientes
                  BarChartRodData(
                    toY: egresos.pendientes,
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                    color: colors.errorContainer,
                  ),
                ],
              ),
            ],

            // ======================================================
            // TOOLTIP
            // ======================================================
            barTouchData: BarTouchData(
              enabled: true,
              handleBuiltInTouches: true,

              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => colors.inverseSurface,

                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final esIngreso = group.x == 0;
                  final esPagado = rodIndex == 0;

                  final tipo = esIngreso ? 'Ingresos' : 'Egresos';

                  final estado = esPagado ? 'Pagados' : 'Pendientes';

                  return BarTooltipItem(
                    '$tipo\n',
                    TextStyle(
                      color: colors.onInverseSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: '$estado\n',
                        style: TextStyle(
                          color: colors.onInverseSurface.withValues(
                            alpha: 0.75,
                          ),
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text: _formatSoles(rod.toY),
                        style: TextStyle(
                          color: colors.onInverseSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // ======================================================
            // TITLES
            // ======================================================
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              // ----------------------------------------------------
              // EJE Y
              // ----------------------------------------------------
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 64,
                  interval: intervalY,

                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      meta: meta,
                      space: 8,
                      child: Text(
                        _formatSolesAxis(value),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ----------------------------------------------------
              // EJE X
              // ----------------------------------------------------
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,

                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();

                    if (index < 0 || index > 1) {
                      return const SizedBox();
                    }

                    final label = index == 0 ? 'Ingresos' : 'Egresos';

                    return SideTitleWidget(
                      meta: meta,
                      space: 8,
                      child: Text(
                        label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _formatSoles(double value) {
    final formatter = NumberFormat('#,##0.00', 'en_US');

    return 'S/ ${formatter.format(value)}';
  }

  static String _formatSolesAxis(double value) {
    final absValue = value.abs();

    if (absValue >= 1000000) {
      return 'S/ ${(value / 1000000).toStringAsFixed(1)}M';
    }

    if (absValue >= 1000) {
      final miles = value / 1000;

      return miles == miles.roundToDouble()
          ? 'S/ ${miles.toStringAsFixed(0)}K'
          : 'S/ ${miles.toStringAsFixed(1)}K';
    }

    return 'S/ ${value.toStringAsFixed(0)}';
  }

  double _calcularIntervalo(double maxY) {
    if (maxY <= 5000) return 1000;
    if (maxY <= 10000) return 2000;
    if (maxY <= 30000) return 5000;
    if (maxY <= 50000) return 10000;
    if (maxY <= 100000) return 20000;

    return maxY / 5;
  }
}
