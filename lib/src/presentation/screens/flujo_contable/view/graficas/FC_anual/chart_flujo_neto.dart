import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Common
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/common/chart_container.dart';

// Modelo
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_anual.dart';

class ChartFlujoNeto extends StatelessWidget {
  final List<FlujoAnualMes> meses;

  const ChartFlujoNeto({super.key, required this.meses});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // ==========================================================
    // VALORES
    // ==========================================================
    final valores = meses.map((mes) => mes.flujoNeto.toDouble()).toList();

    final maxValor = valores.isEmpty
        ? 0.0
        : valores.reduce((a, b) => a > b ? a : b);

    final minValor = valores.isEmpty
        ? 0.0
        : valores.reduce((a, b) => a < b ? a : b);

    final maxY = _calcularMaxY(maxValor);
    final minY = _calcularMinY(minValor);

    final intervaloY = _calcularIntervalo(minY, maxY);

    return ChartContainer(
      titulo: 'Flujo neto mensual',
      subtitulo: 'Resultado mensual después de restar egresos a los ingresos.',
      child: SizedBox(
        height: 320,
        child: BarChart(
          BarChartData(
            baselineY: 0,

            minY: minY,
            maxY: maxY,

            // ======================================================
            // GRID
            // ======================================================
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: intervaloY,
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
              final valor = mes.flujoNeto.toDouble();

              final positivo = valor >= 0;

              return BarChartGroupData(
                x: mes.mes,

                // IMPORTANTE:
                // No usar showingTooltipIndicators aquí.
                barRods: [
                  BarChartRodData(
                    toY: valor,
                    width: 14,
                    borderRadius: BorderRadius.circular(4),
                    color: positivo ? colors.primary : colors.error,
                  ),
                ],
              );
            }).toList(),

            // ======================================================
            // TOUCH
            // ======================================================
            barTouchData: BarTouchData(
              enabled: true,

              handleBuiltInTouches: true,

              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => colors.inverseSurface,

                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  // ==================================================
                  // BUSCAR MES
                  // ==================================================
                  final mesIndex = meses.indexWhere(
                    (mes) => mes.mes == group.x,
                  );

                  if (mesIndex == -1) {
                    return null;
                  }

                  final mes = meses[mesIndex];

                  final valor = rod.toY;

                  // ==================================================
                  // TOOLTIP
                  // ==================================================
                  return BarTooltipItem(
                    '${mes.nombre}\n',
                    TextStyle(
                      color: colors.onInverseSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text: _formatSoles(valor),
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
              // ----------------------------------------------------
              // TOP
              // ----------------------------------------------------
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              // ----------------------------------------------------
              // RIGHT
              // ----------------------------------------------------
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              // ----------------------------------------------------
              // LEFT - SOLES
              // ----------------------------------------------------
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 64,
                  interval: intervaloY,

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

              // ----------------------------------------------------
              // BOTTOM - MESES
              // ----------------------------------------------------
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
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

              // bottomTitles: AxisTitles(
              //   sideTitles: SideTitles(
              //     showTitles: true,
              //     reservedSize: 34,
              //     interval: 1,

              //     getTitlesWidget: (value, meta) {
              //       final mesNumero = value.toInt();

              //       final index = meses.indexWhere(
              //         (mes) => mes.mes == mesNumero,
              //       );

              //       if (index == -1) {
              //         return const SizedBox();
              //       }

              //       // En móvil mostramos un mes sí y uno no.
              //       // Ene, Mar, May, Jul, Sep, Nov
              //       if (mesNumero % 2 == 0) {
              //         return const SizedBox();
              //       }

              //       final nombre = meses[index].nombre;

              //       final nombreCorto = nombre.length >= 3
              //           ? nombre.substring(0, 3)
              //           : nombre;

              //       return SideTitleWidget(
              //         meta: meta,
              //         space: 8,
              //         child: Transform.rotate(
              //           angle: -0.45,
              //           child: Text(
              //             nombreCorto,
              //             style: theme.textTheme.labelSmall?.copyWith(
              //               color: colors.onSurfaceVariant,
              //               fontSize: 9,
              //             ),
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
  // FORMATO SOLES PARA TOOLTIP
  // ============================================================

  static String _formatSoles(double value) {
    final formatter = NumberFormat('#,##0.00', 'en_US');

    if (value < 0) {
      return '-S/ ${formatter.format(value.abs())}';
    }

    return 'S/ ${formatter.format(value)}';
  }

  // ============================================================
  // FORMATO SOLES PARA EJE Y
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
  // MAX Y
  // ============================================================

  double _calcularMaxY(double maxValor) {
    if (maxValor <= 0) {
      return 1000;
    }

    // Espacio adicional para que el tooltip
    // tenga lugar encima de la barra.
    return maxValor * 1.25;
  }

  // ============================================================
  // MIN Y
  // ============================================================

  double _calcularMinY(double minValor) {
    if (minValor >= 0) {
      return 0;
    }

    return minValor * 1.20;
  }

  // ============================================================
  // INTERVALO Y
  // ============================================================

  double _calcularIntervalo(double minY, double maxY) {
    final rango = (maxY - minY).abs();

    if (rango <= 5000) {
      return 1000;
    }

    if (rango <= 10000) {
      return 2000;
    }

    if (rango <= 30000) {
      return 5000;
    }

    if (rango <= 50000) {
      return 10000;
    }

    if (rango <= 100000) {
      return 20000;
    }

    return rango / 5;
  }
}

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// // Common
// import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/common/chart_container.dart';

// // Modelo
// import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_anual.dart';

// class ChartFlujoNeto extends StatelessWidget {
//   final List<FlujoAnualMes> meses;

//   const ChartFlujoNeto({super.key, required this.meses});

//   @override
//   Widget build(BuildContext context) {
//     return ChartContainer(
//       titulo: 'Flujo neto mensual',
//       subtitulo: 'Resultado mensual después de restar egresos a los ingresos.',
//       child: SizedBox(
//         height: 280,
//         child: BarChart(
//           BarChartData(
//             baselineY: 0,

//             borderData: FlBorderData(show: false),

//             gridData: const FlGridData(show: true, drawVerticalLine: false),

//             barGroups: meses.map((mes) {
//               final positivo = mes.flujoNeto >= 0;

//               return BarChartGroupData(
//                 x: mes.mes,
//                 barRods: [
//                   BarChartRodData(
//                     toY: mes.flujoNeto,
//                     width: 12,
//                     borderRadius: BorderRadius.circular(4),
//                     color: positivo
//                         ? Theme.of(context).colorScheme.primary
//                         : Theme.of(context).colorScheme.error,
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

//               leftTitles: const AxisTitles(
//                 sideTitles: SideTitles(showTitles: true, reservedSize: 48),
//               ),

//               bottomTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   getTitlesWidget: (value, meta) {
//                     final index = value.toInt() - 1;

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
