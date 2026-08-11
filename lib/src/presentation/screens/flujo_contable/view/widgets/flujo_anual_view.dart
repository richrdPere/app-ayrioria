import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Modelo
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_anual.dart';

// Graficas
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/graficas/FC_anual/chart_curvas.dart';
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/graficas/FC_anual/chart_flujo_neto.dart';
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/graficas/FC_anual/chart_ingresos_egresos.dart';

class FlujoAnualView extends StatelessWidget {
  final FlujoAnualData data;

  const FlujoAnualView({super.key, required this.data});

  String moneda(double value) {
    return NumberFormat.currency(symbol: 'S/ ', decimalDigits: 2).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final resumen = data.resumen;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resumen ${data.anio}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _ResumenAnualCard(
                titulo: 'Ingresos',
                monto: resumen.totalIngresos,
                icono: Icons.arrow_downward,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _ResumenAnualCard(
                titulo: 'Egresos',
                monto: resumen.totalEgresos,
                icono: Icons.arrow_upward,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        _ResumenAnualCard(
          titulo: 'Flujo neto anual',
          monto: resumen.flujoNetoAnual,
          icono: Icons.swap_vert,
        ),

        const SizedBox(height: 30),

        ChartIngresosEgresos(meses: data.meses),

        const SizedBox(height: 30),

        ChartCurvaS(meses: data.meses),

        const SizedBox(height: 30),

        ChartFlujoNeto(meses: data.meses),

        const SizedBox(height: 24),
      ],
    );
  }
}

class _ResumenAnualCard extends StatelessWidget {
  final String titulo;
  final double monto;
  final IconData icono;

  const _ResumenAnualCard({
    required this.titulo,
    required this.monto,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: 'S/ ', decimalDigits: 2);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icono),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: const TextStyle(color: Colors.grey)),

                  const SizedBox(height: 4),

                  Text(
                    formatter.format(monto),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
