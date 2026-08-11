import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Common
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/common/chart_container.dart';

class ChartRealProyectado extends StatelessWidget {
  final double flujoReal;
  final double flujoProyectado;

  final double saldoFinalReal;
  final double saldoFinalProyectado;

  const ChartRealProyectado({
    super.key,
    required this.flujoReal,
    required this.flujoProyectado,
    required this.saldoFinalReal,
    required this.saldoFinalProyectado,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final valores = [
      flujoReal,
      flujoProyectado,
      saldoFinalReal,
      saldoFinalProyectado,
    ];

    final maxValue = valores.fold<double>(
      0,
      (previous, value) => max(previous, value),
    );

    final minValue = valores.fold<double>(
      0,
      (previous, value) => min(previous, value),
    );

    final maxY = _calcularMaxY(maxValue);
    final minY = _calcularMinY(minValue);

    final intervalY = _calcularIntervalo(minY, maxY);

    return ChartContainer(
      titulo: 'Real vs proyectado',
      subtitulo: 'Compara el resultado actual con la proyección del período.',
      child: SizedBox(
        height: 320,
        child: BarChart(
          BarChartData(
            minY: minY,
            maxY: maxY,
            baselineY: 0,

            // ======================================================
            // GRID
            // ======================================================
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: intervalY,

              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: value == 0
                      ? colors.outline.withValues(alpha: 0.65)
                      : colors.outlineVariant.withValues(alpha: 0.35),
                  strokeWidth: value == 0 ? 1.4 : 1,
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
              // ----------------------------------------------------
              // FLUJO
              // ----------------------------------------------------
              BarChartGroupData(
                x: 0,
                barsSpace: 5,
                barRods: [
                  BarChartRodData(
                    toY: flujoReal,
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                    color: flujoReal >= 0 ? colors.primary : colors.error,
                  ),

                  BarChartRodData(
                    toY: flujoProyectado,
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                    color: flujoProyectado >= 0
                        ? colors.primaryContainer
                        : colors.errorContainer,
                  ),
                ],
              ),

              // ----------------------------------------------------
              // SALDO FINAL
              // ----------------------------------------------------
              BarChartGroupData(
                x: 1,
                barsSpace: 5,
                barRods: [
                  BarChartRodData(
                    toY: saldoFinalReal,
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                    color: colors.secondary,
                  ),

                  BarChartRodData(
                    toY: saldoFinalProyectado,
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                    color: colors.secondaryContainer,
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
                  final esFlujo = group.x == 0;
                  final esReal = rodIndex == 0;

                  final tipo = esFlujo ? 'Flujo' : 'Saldo final';

                  final estado = esReal ? 'Real' : 'Proyectado';

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
            // EJES
            // ======================================================
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              // ----------------------------------------------------
              // Y
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
              // X
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

                    final label = index == 0 ? 'Flujo' : 'Saldo final';

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

    if (value < 0) {
      return '-S/ ${formatter.format(value.abs())}';
    }

    return 'S/ ${formatter.format(value)}';
  }

  static String _formatSolesAxis(double value) {
    final absValue = value.abs();

    String formatted;

    if (absValue >= 1000000) {
      formatted = '${(absValue / 1000000).toStringAsFixed(1)}M';
    } else if (absValue >= 1000) {
      final miles = absValue / 1000;

      formatted = miles == miles.roundToDouble()
          ? '${miles.toStringAsFixed(0)}K'
          : '${miles.toStringAsFixed(1)}K';
    } else {
      formatted = absValue.toStringAsFixed(0);
    }

    return value < 0 ? '-S/ $formatted' : 'S/ $formatted';
  }

  double _calcularMaxY(double maxValue) {
    if (maxValue <= 0) {
      return 1000;
    }

    return maxValue * 1.25;
  }

  double _calcularMinY(double minValue) {
    if (minValue >= 0) {
      return 0;
    }

    return minValue * 1.25;
  }

  double _calcularIntervalo(double minY, double maxY) {
    final rango = (maxY - minY).abs();

    if (rango <= 1000) return 200;
    if (rango <= 5000) return 1000;
    if (rango <= 10000) return 2000;
    if (rango <= 30000) return 5000;
    if (rango <= 50000) return 10000;
    if (rango <= 100000) return 20000;

    return rango / 5;
  }
}
