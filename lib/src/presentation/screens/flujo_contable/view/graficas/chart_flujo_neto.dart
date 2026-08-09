import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// Common
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/common/chart_container.dart';

// Modelo
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_anual.dart';

class ChartFlujoNeto extends StatelessWidget {
  final List<FlujoAnualMes> meses;

  const ChartFlujoNeto({super.key, required this.meses});

  @override
  Widget build(BuildContext context) {
    return ChartContainer(
      titulo: 'Flujo neto mensual',
      subtitulo: 'Resultado mensual después de restar egresos a los ingresos.',
      child: SizedBox(
        height: 280,
        child: BarChart(
          BarChartData(
            baselineY: 0,

            borderData: FlBorderData(show: false),

            gridData: const FlGridData(show: true, drawVerticalLine: false),

            barGroups: meses.map((mes) {
              final positivo = mes.flujoNeto >= 0;

              return BarChartGroupData(
                x: mes.mes,
                barRods: [
                  BarChartRodData(
                    toY: mes.flujoNeto,
                    width: 12,
                    borderRadius: BorderRadius.circular(4),
                    color: positivo
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
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

              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 48),
              ),

              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt() - 1;

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
