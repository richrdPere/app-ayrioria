import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:app_aryoria/src/data/models/flujo_contable/flujo_proyectado.dart';

class FlujoProyectadoView extends StatelessWidget {
  final FlujoProyectadoData data;

  const FlujoProyectadoView({super.key, required this.data});

  String moneda(double value) {
    return NumberFormat.currency(symbol: 'S/ ', decimalDigits: 2).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.periodo.nombre,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _ProyeccionCard(
                titulo: 'Saldo real',
                valor: data.saldoFinalReal,
                icono: Icons.account_balance_wallet_outlined,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _ProyeccionCard(
                titulo: 'Saldo proyectado',
                valor: data.saldoFinalProyectado,
                icono: Icons.trending_up_rounded,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        const Text(
          'Ingresos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        _DetalleProyeccion(
          pagado: data.ingresos.pagados,
          pendiente: data.ingresos.pendientes,
          proyectado: data.ingresos.totalProyectado,
        ),

        const SizedBox(height: 24),

        const Text(
          'Egresos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        _DetalleProyeccion(
          pagado: data.egresos.pagados,
          pendiente: data.egresos.pendientes,
          proyectado: data.egresos.totalProyectado,
        ),

        const SizedBox(height: 24),

        Card(
          elevation: 0,
          child: ListTile(
            leading: const Icon(Icons.timeline),
            title: const Text('Flujo proyectado'),
            subtitle: Text('Real: ${moneda(data.flujoReal)}'),
            trailing: Text(
              moneda(data.flujoProyectado),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProyeccionCard extends StatelessWidget {
  final String titulo;
  final double valor;
  final IconData icono;

  const _ProyeccionCard({
    required this.titulo,
    required this.valor,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: 'S/ ', decimalDigits: 2);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono),

            const SizedBox(height: 12),

            Text(titulo),

            const SizedBox(height: 5),

            Text(
              formatter.format(valor),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetalleProyeccion extends StatelessWidget {
  final double pagado;
  final double pendiente;
  final double proyectado;

  const _DetalleProyeccion({
    required this.pagado,
    required this.pendiente,
    required this.proyectado,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(symbol: 'S/ ', decimalDigits: 2);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _fila('Pagados', formatter.format(pagado)),
            const Divider(),
            _fila('Pendientes', formatter.format(pendiente)),
            const Divider(),
            _fila(
              'Total proyectado',
              formatter.format(proyectado),
              destacado: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _fila(String label, String value, {bool destacado = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(
            fontWeight: destacado ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
