import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Common
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/common/chart_container.dart';

// Modelo
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_anual.dart';

class ChartCurvaS extends StatelessWidget {
  final List<FlujoAnualMes> meses;

  const ChartCurvaS({super.key, required this.meses});

  @override
  Widget build(BuildContext context) {
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

    return ChartContainer(
      titulo: 'Curva S',
      subtitulo: 'Ingresos y egresos acumulados durante el año.',
      child: SizedBox(
        height: 300,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: true, drawVerticalLine: false),

            borderData: FlBorderData(show: false),

            lineBarsData: [
              LineChartBarData(
                spots: ingresos,
                isCurved: true,
                barWidth: 3,
                color: Theme.of(context).colorScheme.primary,
                dotData: const FlDotData(show: false),
              ),

              LineChartBarData(
                spots: egresos,
                isCurved: true,
                barWidth: 3,
                color: Theme.of(context).colorScheme.error,
                dotData: const FlDotData(show: false),
              ),
            ],

            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 48),
              ),

              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();

                    if (index < 0 || index >= meses.length) {
                      return const SizedBox();
                    }

                    final nombre = meses[index].nombre;

                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        nombre.length >= 3 ? nombre.substring(0, 3) : nombre,
                        style: const TextStyle(fontSize: 10),
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
}
