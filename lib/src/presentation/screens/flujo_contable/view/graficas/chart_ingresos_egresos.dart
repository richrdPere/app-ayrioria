import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Common
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/common/chart_container.dart';

// Modelo
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_anual.dart';

class ChartIngresosEgresos extends StatelessWidget {
  final List<FlujoAnualMes> meses;

  const ChartIngresosEgresos({super.key, required this.meses});

  @override
  Widget build(BuildContext context) {
    final maxValue = meses.fold<double>(
      0,
      (previous, mes) =>
          max(previous, max(mes.totalIngresos, mes.totalEgresos)),
    );

    return ChartContainer(
      titulo: 'Ingresos y egresos mensuales',
      subtitulo: 'Comparación del comportamiento financiero por mes.',
      child: SizedBox(
        height: 300,
        child: BarChart(
          BarChartData(
            maxY: maxValue == 0 ? 100 : maxValue * 1.2,

            borderData: FlBorderData(show: false),

            gridData: const FlGridData(show: true, drawVerticalLine: false),

            barGroups: meses.map((mes) {
              return BarChartGroupData(
                x: mes.mes,
                barsSpace: 3,
                barRods: [
                  BarChartRodData(
                    toY: mes.totalIngresos,
                    width: 8,
                    borderRadius: BorderRadius.circular(3),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  BarChartRodData(
                    toY: mes.totalEgresos,
                    width: 8,
                    borderRadius: BorderRadius.circular(3),
                    color: Theme.of(context).colorScheme.error,
                  ),
                ],
              );
            }).toList(),

            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 35,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt() - 1;

                    if (index < 0 || index >= meses.length) {
                      return const SizedBox();
                    }

                    final nombre = meses[index].nombre;

                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        nombre.substring(0, min(3, nombre.length)),
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                ),
              ),

              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 48),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
