import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Common
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/common/chart_container.dart';

// Modelo
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_anual.dart';

class ChartCurvaS extends StatelessWidget {
  final List<FlujoAnualMes> meses;

  const ChartCurvaS({super.key, required this.meses});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    double ingresoAcumulado = 0;
    double egresoAcumulado = 0;

    final ingresos = <FlSpot>[];
    final egresos = <FlSpot>[];

    for (var i = 0; i < meses.length; i++) {
      ingresoAcumulado += meses[i].totalIngresos;
      egresoAcumulado += meses[i].totalEgresos;

      ingresos.add(FlSpot(i.toDouble(), ingresoAcumulado));

      egresos.add(FlSpot(i.toDouble(), egresoAcumulado));
    }

    // ==========================================================
    // MÁXIMO DEL EJE Y
    // ==========================================================
    final valores = [...ingresos.map((e) => e.y), ...egresos.map((e) => e.y)];

    final maxValor = valores.isEmpty
        ? 0.0
        : valores.reduce((a, b) => a > b ? a : b);

    final maxY = _calcularMaxY(maxValor);
    final intervalY = _calcularIntervalo(maxY);

    return ChartContainer(
      titulo: 'Curva S',
      subtitulo: 'Ingresos y egresos acumulados durante el año.',
      child: SizedBox(
        height: 320,
        child: LineChart(
          LineChartData(
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
            // LÍNEAS
            // ======================================================
            lineBarsData: [
              // INGRESOS
              LineChartBarData(
                spots: ingresos,
                isCurved: true,
                curveSmoothness: 0.25,
                barWidth: 3,
                color: colors.primary,
                isStrokeCapRound: true,

                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: colors.primary,
                      strokeWidth: 2,
                      strokeColor: colors.surface,
                    );
                  },
                ),

                belowBarData: BarAreaData(
                  show: true,
                  color: colors.primary.withValues(alpha: 0.07),
                ),
              ),

              // EGRESOS
              LineChartBarData(
                spots: egresos,
                isCurved: true,
                curveSmoothness: 0.25,
                barWidth: 3,
                color: colors.error,
                isStrokeCapRound: true,

                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: colors.error,
                      strokeWidth: 2,
                      strokeColor: colors.surface,
                    );
                  },
                ),

                belowBarData: BarAreaData(
                  show: true,
                  color: colors.error.withValues(alpha: 0.05),
                ),
              ),
            ],

            // ======================================================
            // TOOLTIP
            // ======================================================
            lineTouchData: LineTouchData(
              enabled: true,
              handleBuiltInTouches: true,

              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => colors.inverseSurface,

                getTooltipItems: (spots) {
                  return spots.map((spot) {
                    final esIngreso = spot.barIndex == 0;

                    final tipo = esIngreso
                        ? 'Ingresos acumulados'
                        : 'Egresos acumulados';

                    final index = spot.x.toInt();

                    final mes = index >= 0 && index < meses.length
                        ? meses[index].nombre
                        : '';

                    return LineTooltipItem(
                      '$tipo\n',
                      TextStyle(
                        color: esIngreso
                            ? colors.primaryContainer
                            : colors.errorContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: '$mes\n',
                          style: TextStyle(
                            color: colors.onInverseSurface,
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextSpan(
                          text: _formatSoles(spot.y),
                          style: TextStyle(
                            color: colors.onInverseSurface,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }).toList();
                },
              ),

              getTouchedSpotIndicator: (barData, spotIndexes) {
                return spotIndexes.map((index) {
                  return TouchedSpotIndicatorData(
                    FlLine(
                      color: colors.outline.withValues(alpha: 0.45),
                      strokeWidth: 1,
                      dashArray: [4, 4],
                    ),
                    FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) {
                        return FlDotCirclePainter(
                          radius: 6,
                          color: bar.color ?? colors.primary,
                          strokeWidth: 3,
                          strokeColor: colors.surface,
                        );
                      },
                    ),
                  );
                }).toList();
              },
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
                  interval: intervalY,
                  reservedSize: 62,

                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        _formatSolesAxis(value),
                        textAlign: TextAlign.right,
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
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt() ;

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

              // bottomTitles: AxisTitles(
              //   sideTitles: SideTitles(
              //     showTitles: true,
              //     interval: 1,
              //     reservedSize: 34,

              //     getTitlesWidget: (value, meta) {
              //       final index = value.toInt();

              //       if (index < 0 || index >= meses.length) {
              //         return const SizedBox();
              //       }

              //       final nombre = meses[index].nombre;

              //       return Padding(
              //         padding: const EdgeInsets.only(top: 8),
              //         child: Text(
              //           nombre.length >= 3 ? nombre.substring(0, 3) : nombre,
              //           style: theme.textTheme.labelSmall?.copyWith(
              //             color: colors.onSurfaceVariant,
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SOLES COMPLETO
  // ============================================================

  static String _formatSoles(double value) {
    final formatter = NumberFormat.currency(
      locale: 'es_PE',
      symbol: 'S/ ',
      decimalDigits: 2,
    );

    return formatter.format(value);
  }

  // ============================================================
  // SOLES PARA EJE Y
  // ============================================================

  static String _formatSolesAxis(double value) {
    if (value.abs() >= 1000000) {
      return 'S/ ${(value / 1000000).toStringAsFixed(1)}M';
    }

    if (value.abs() >= 1000) {
      final miles = value / 1000;

      if (miles == miles.roundToDouble()) {
        return 'S/ ${miles.toStringAsFixed(0)}K';
      }

      return 'S/ ${miles.toStringAsFixed(1)}K';
    }

    return 'S/ ${value.toStringAsFixed(0)}';
  }

  // ============================================================
  // MAX Y
  // ============================================================

  double _calcularMaxY(double maxValor) {
    if (maxValor <= 0) {
      return 1000;
    }

    return maxValor * 1.15;
  }

  // ============================================================
  // INTERVALO Y
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
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// // Common
// import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/common/chart_container.dart';

// // Modelo
// import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_anual.dart';

// class ChartCurvaS extends StatelessWidget {
//   final List<FlujoAnualMes> meses;

//   const ChartCurvaS({super.key, required this.meses});

//   @override
//   Widget build(BuildContext context) {
//     double ingresoAcumulado = 0;
//     double egresoAcumulado = 0;

//     final ingresos = <FlSpot>[];
//     final egresos = <FlSpot>[];

//     for (var i = 0; i < meses.length; i++) {
//       ingresoAcumulado += meses[i].totalIngresos;

//       egresoAcumulado += meses[i].totalEgresos;

//       ingresos.add(FlSpot(i.toDouble(), ingresoAcumulado));

//       egresos.add(FlSpot(i.toDouble(), egresoAcumulado));
//     }

//     return ChartContainer(
//       titulo: 'Curva S',
//       subtitulo: 'Ingresos y egresos acumulados durante el año.',
//       child: SizedBox(
//         height: 300,
//         child: LineChart(
//           LineChartData(
//             gridData: const FlGridData(show: true, drawVerticalLine: false),

//             borderData: FlBorderData(show: false),

//             lineBarsData: [
//               LineChartBarData(
//                 spots: ingresos,
//                 isCurved: true,
//                 barWidth: 3,
//                 color: Theme.of(context).colorScheme.primary,
//                 dotData: const FlDotData(show: false),
//               ),

//               LineChartBarData(
//                 spots: egresos,
//                 isCurved: true,
//                 barWidth: 3,
//                 color: Theme.of(context).colorScheme.error,
//                 dotData: const FlDotData(show: false),
//               ),
//             ],

//             titlesData: FlTitlesData(
//               topTitles: const AxisTitles(
//                 sideTitles: SideTitles(showTitles: false),
//               ),

//               rightTitles: const AxisTitles(
//                 sideTitles: SideTitles(showTitles: false),
//               ),

//               leftTitles: const AxisTitles(
//                 sideTitles: SideTitles(showTitles: true, reservedSize: 48),
//               ),

//               bottomTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   interval: 1,
//                   getTitlesWidget: (value, meta) {
//                     final index = value.toInt();

//                     if (index < 0 || index >= meses.length) {
//                       return const SizedBox();
//                     }

//                     final nombre = meses[index].nombre;

//                     return Padding(
//                       padding: const EdgeInsets.only(top: 8),
//                       child: Text(
//                         nombre.length >= 3 ? nombre.substring(0, 3) : nombre,
//                         style: const TextStyle(fontSize: 10),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
