import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/common/chart_container.dart';

class ChartFlujoMensual extends StatelessWidget {
  final double saldoInicial;
  final double ingresos;
  final double egresos;
  final double saldoFinal;

  const ChartFlujoMensual({
    super.key,
    required this.saldoInicial,
    required this.ingresos,
    required this.egresos,
    required this.saldoFinal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final valores = [saldoInicial, ingresos, egresos, saldoFinal];

    final maxValor = valores.reduce((a, b) => a > b ? a : b);

    final maxY = maxValor <= 0 ? 1000.0 : maxValor * 1.25;
    final interval = _calcularIntervalo(maxY);

    return ChartContainer(
      titulo: 'Evolución del flujo',
      subtitulo: 'Saldo inicial, ingresos, egresos y saldo final del período.',
      child: SizedBox(
        height: 300,
        child: BarChart(
          BarChartData(
            minY: 0,
            maxY: maxY,

            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: interval,
              getDrawingHorizontalLine: (_) {
                return FlLine(
                  color: colors.outlineVariant.withValues(alpha: 0.35),
                  strokeWidth: 1,
                );
              },
            ),

            borderData: FlBorderData(show: false),

            barGroups: [
              _grupo(x: 0, value: saldoInicial, color: colors.secondary),
              _grupo(x: 1, value: ingresos, color: colors.primary),
              _grupo(x: 2, value: egresos, color: colors.error),
              _grupo(x: 3, value: saldoFinal, color: colors.tertiary),
            ],

            barTouchData: BarTouchData(
              enabled: true,
              handleBuiltInTouches: true,

              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => colors.inverseSurface,

                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final labels = [
                    'Saldo inicial',
                    'Ingresos',
                    'Egresos',
                    'Saldo final',
                  ];

                  return BarTooltipItem(
                    '${labels[group.x]}\n',
                    TextStyle(
                      color: colors.onInverseSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
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

            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 64,
                  interval: interval,

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

              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 44,

                  getTitlesWidget: (value, meta) {
                    const labels = ['Inicial', 'Ingresos', 'Egresos', 'Final'];

                    final index = value.toInt();

                    if (index < 0 || index >= labels.length) {
                      return const SizedBox();
                    }

                    return SideTitleWidget(
                      meta: meta,
                      space: 8,
                      child: Text(
                        labels[index],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
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

  BarChartGroupData _grupo({
    required int x,
    required double value,
    required Color color,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          width: 24,
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

  static String _formatSoles(double value) {
    final formatter = NumberFormat('#,##0.00', 'en_US');

    return 'S/ ${formatter.format(value)}';
  }

  static String _formatSolesAxis(double value) {
    if (value.abs() >= 1000) {
      return 'S/ ${(value / 1000).toStringAsFixed(1)}K';
    }

    return 'S/ ${value.toStringAsFixed(0)}';
  }

  double _calcularIntervalo(double maxY) {
    if (maxY <= 5000) return 1000;
    if (maxY <= 10000) return 2000;
    if (maxY <= 30000) return 5000;
    if (maxY <= 50000) return 10000;

    return maxY / 5;
  }
}
