import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Common
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/common/chart_container.dart';

// Modelo
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_anual.dart';

class ChartIngresosEgresos extends StatelessWidget {
  final List<FlujoAnualMes> meses;

  const ChartIngresosEgresos({super.key, required this.meses});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final maxValue = meses.fold<double>(
      0,
      (previous, mes) => max(
        previous,
        max(mes.totalIngresos.toDouble(), mes.totalEgresos.toDouble()),
      ),
    );

    final maxY = maxValue == 0 ? 1000.0 : maxValue * 1.20;

    final intervalY = _calcularIntervalo(maxY);

    return ChartContainer(
      titulo: 'Ingresos y egresos mensuales',
      subtitulo: 'Comparación del comportamiento financiero por mes.',
      child: SizedBox(
        height: 320,
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
              getDrawingHorizontalLine: (value) {
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
            barGroups: meses.map((mes) {
              return BarChartGroupData(
                x: mes.mes,
                barsSpace: 4,
                barRods: [
                  // INGRESOS
                  BarChartRodData(
                    toY: mes.totalIngresos.toDouble(),
                    width: 9,
                    borderRadius: BorderRadius.circular(3),
                    color: colors.primary,
                  ),

                  // EGRESOS
                  BarChartRodData(
                    toY: mes.totalEgresos.toDouble(),
                    width: 9,
                    borderRadius: BorderRadius.circular(3),
                    color: colors.error,
                  ),
                ],
              );
            }).toList(),

            // ======================================================
            // TOUCH / TOOLTIP
            // ======================================================
            barTouchData: BarTouchData(
              enabled: true,
              handleBuiltInTouches: true,

              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => colors.inverseSurface,

                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final mesIndex = meses.indexWhere(
                    (mes) => mes.mes == group.x,
                  );

                  if (mesIndex == -1) {
                    return null;
                  }

                  final mes = meses[mesIndex];

                  final esIngreso = rodIndex == 0;

                  final tipo = esIngreso ? 'Ingresos' : 'Egresos';

                  final tipoColor = esIngreso
                      ? colors.primaryContainer
                      : colors.errorContainer;

                  return BarTooltipItem(
                    '${mes.nombre}\n',
                    TextStyle(
                      color: colors.onInverseSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: '$tipo\n',
                        style: TextStyle(
                          color: tipoColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: _formatSoles(rod.toY),
                        style: TextStyle(
                          color: colors.onInverseSurface,
                          fontSize: 15,
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

              // ====================================================
              // EJE Y - SOLES
              // ====================================================
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

              // ====================================================
              // EJE X - MESES
              // ====================================================
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  // reservedSize: 34,
                  interval: 1,

                  getTitlesWidget: (value, meta) {
                    final index = value.toInt() - 1;

                    if (index < 0 || index >= meses.length) {
                      return const SizedBox();
                    }

                    final nombre = meses[index].nombre;

                    final nombreCorto = nombre.length >= 3
                        ? nombre.substring(0, 3)
                        : nombre;

                    return SideTitleWidget(
                      meta: meta,
                      space: 8,
                      child: Transform.rotate(
                        angle: -0.45,
                        child: Text(
                          nombreCorto,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colors.onSurfaceVariant,
                            fontSize: 9,
                          ),
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

  // ============================================================
  // FORMATO COMPLETO PARA TOOLTIP
  // ============================================================

  static String _formatSoles(double value) {
    final formatter = NumberFormat('#,##0.00', 'en_US');

    return 'S/ ${formatter.format(value)}';
  }

  // ============================================================
  // FORMATO PARA EJE Y
  // ============================================================

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

  // ============================================================
  // INTERVALO EJE Y
  // ============================================================

  double _calcularIntervalo(double maxY) {
    if (maxY <= 5000) {
      return 1000;
    }

    if (maxY <= 10000) {
      return 2000;
    }

    if (maxY <= 30000) {
      return 5000;
    }

    if (maxY <= 50000) {
      return 10000;
    }

    if (maxY <= 100000) {
      return 20000;
    }

    return maxY / 5;
  }
}

// import 'dart:math';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// // Common
// import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/common/chart_container.dart';

// // Modelo
// import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_anual.dart';

// class ChartIngresosEgresos extends StatelessWidget {
//   final List<FlujoAnualMes> meses;

//   const ChartIngresosEgresos({super.key, required this.meses});

//   @override
//   Widget build(BuildContext context) {
//     final maxValue = meses.fold<double>(
//       0,
//       (previous, mes) =>
//           max(previous, max(mes.totalIngresos, mes.totalEgresos)),
//     );

//     return ChartContainer(
//       titulo: 'Ingresos y egresos mensuales',
//       subtitulo: 'Comparación del comportamiento financiero por mes.',
//       child: SizedBox(
//         height: 300,
//         child: BarChart(
//           BarChartData(
//             maxY: maxValue == 0 ? 100 : maxValue * 1.2,

//             borderData: FlBorderData(show: false),

//             gridData: const FlGridData(show: true, drawVerticalLine: false),

//             barGroups: meses.map((mes) {
//               return BarChartGroupData(
//                 x: mes.mes,
//                 barsSpace: 3,
//                 barRods: [
//                   BarChartRodData(
//                     toY: mes.totalIngresos,
//                     width: 8,
//                     borderRadius: BorderRadius.circular(3),
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                   BarChartRodData(
//                     toY: mes.totalEgresos,
//                     width: 8,
//                     borderRadius: BorderRadius.circular(3),
//                     color: Theme.of(context).colorScheme.error,
//                   ),
//                 ],
//               );
//             }).toList(),

//             titlesData: FlTitlesData(
//               topTitles: const AxisTitles(
//                 sideTitles: SideTitles(showTitles: false),
//               ),

//               rightTitles: const AxisTitles(
//                 sideTitles: SideTitles(showTitles: false),
//               ),

//               bottomTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   reservedSize: 35,
//                   getTitlesWidget: (value, meta) {
//                     final index = value.toInt() - 1;

//                     if (index < 0 || index >= meses.length) {
//                       return const SizedBox();
//                     }

//                     final nombre = meses[index].nombre;

//                     return Padding(
//                       padding: const EdgeInsets.only(top: 8),
//                       child: Text(
//                         nombre.substring(0, min(3, nombre.length)),
//                         style: const TextStyle(fontSize: 10),
//                       ),
//                     );
//                   },
//                 ),
//               ),

//               leftTitles: const AxisTitles(
//                 sideTitles: SideTitles(showTitles: true, reservedSize: 48),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
