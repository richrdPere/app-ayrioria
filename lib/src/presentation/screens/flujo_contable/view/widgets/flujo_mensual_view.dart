import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_mensual.dart';

class FlujoMensualView extends StatelessWidget {
  final FlujoContableMensualData data;

  const FlujoMensualView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final resumen = data.resumen;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.periodo.nombre,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        _SaldoPrincipalCard(
          saldo: resumen.saldoFinalCalculado,
          flujo: resumen.flujoNeto,
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _IndicadorCard(
                titulo: 'Ingresos',
                monto: resumen.totalIngresos,
                icono: Icons.arrow_downward_rounded,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _IndicadorCard(
                titulo: 'Egresos',
                monto: resumen.totalEgresos,
                icono: Icons.arrow_upward_rounded,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _IndicadorCard(
                titulo: 'Saldo inicial',
                monto: resumen.saldoInicial,
                icono: Icons.account_balance_wallet_outlined,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _IndicadorCard(
                titulo: 'Flujo neto',
                monto: resumen.flujoNeto,
                icono: Icons.swap_vert_rounded,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        Text(
          '${resumen.cantidadMovimientos} movimientos registrados',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _SaldoPrincipalCard extends StatelessWidget {
  final double saldo;
  final double flujo;

  const _SaldoPrincipalCard({required this.saldo, required this.flujo});

  String moneda(double value) {
    return NumberFormat.currency(symbol: 'S/ ', decimalDigits: 2).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saldo disponible',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 7),

            Text(
              moneda(saldo),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text('Flujo del período: ${moneda(flujo)}'),
          ],
        ),
      ),
    );
  }
}

class _IndicadorCard extends StatelessWidget {
  final String titulo;
  final double monto;
  final IconData icono;

  const _IndicadorCard({
    required this.titulo,
    required this.monto,
    required this.icono,
  });

  String moneda(double value) {
    return NumberFormat.currency(symbol: 'S/ ', decimalDigits: 2).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono),

            const SizedBox(height: 12),

            Text(titulo, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 4),

            Text(
              moneda(monto),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
