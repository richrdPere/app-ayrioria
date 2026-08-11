import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/graficas/FC_mensual/chart_egresos_circular.dart';
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/graficas/FC_mensual/chart_ingresos_circular.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_mensual.dart';

// Charts
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/graficas/FC_mensual/chart_flujo_mensual.dart';

class FlujoMensualView extends StatelessWidget {
  final FlujoContableMensualData data;

  const FlujoMensualView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final resumen = data.resumen;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ========================================================
        // PERÍODO
        // ========================================================
        Text(
          data.periodo.nombre,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          data.periodo.estado,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 16),

        // ========================================================
        // SALDO PRINCIPAL
        // ========================================================
        _SaldoPrincipalCard(
          saldo: resumen.saldoFinalCalculado,
          flujo: resumen.flujoNeto,
        ),

        const SizedBox(height: 16),

        // ========================================================
        // INGRESOS / EGRESOS
        // ========================================================
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

        // ========================================================
        // SALDO INICIAL / FLUJO NETO
        // ========================================================
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

        const SizedBox(height: 28),

        // ========================================================
        // 1. EVOLUCIÓN DEL FLUJO
        // ========================================================
        ChartFlujoMensual(
          saldoInicial: resumen.saldoInicial,
          ingresos: resumen.totalIngresos,
          egresos: resumen.totalEgresos,
          saldoFinal: resumen.saldoFinalCalculado,
        ),

        const SizedBox(height: 24),

        // ========================================================
        // 2. DISTRIBUCIÓN DE INGRESOS
        // ========================================================
        ChartIngresosCircular(
          categorias: data.ingresos.categorias,
          total: data.ingresos.total,
        ),

        const SizedBox(height: 24),

        // ========================================================
        // 3. DISTRIBUCIÓN DE EGRESOS
        // ========================================================
        ChartEgresosCircular(
          categorias: data.egresos.categorias,
          total: data.egresos.total,
        ),

        const SizedBox(height: 24),

        // ========================================================
        // MOVIMIENTOS
        // ========================================================
        // Row(
        //   children: [
        //     Icon(
        //       Icons.receipt_long_outlined,
        //       size: 18,
        //       color: colors.onSurfaceVariant,
        //     ),

        //     const SizedBox(width: 8),

        //     Text(
        //       '${resumen.cantidadMovimientos} movimientos registrados',
        //       style: theme.textTheme.bodyMedium?.copyWith(
        //         color: colors.onSurfaceVariant,
        //       ),
        //     ),
        //   ],
        // ),

        const SizedBox(height: 16),
      ],
    );
  }
}

class _SaldoPrincipalCard extends StatelessWidget {
  final double saldo;
  final double flujo;

  const _SaldoPrincipalCard({required this.saldo, required this.flujo});

  String moneda(double value) {
    final formatter = NumberFormat('#,##0.00', 'en_US');

    if (value < 0) {
      return '-S/ ${formatter.format(value.abs())}';
    }

    return 'S/ ${formatter.format(value)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final flujoPositivo = flujo >= 0;

    return Card(
      elevation: 0,
      color: colors.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo disponible',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              moneda(saldo),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Icon(
                  flujoPositivo ? Icons.trending_up : Icons.trending_down,
                  size: 18,
                  color: flujoPositivo ? colors.primary : colors.error,
                ),

                const SizedBox(width: 6),

                Text(
                  'Flujo del período: ${moneda(flujo)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: flujoPositivo ? colors.primary : colors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
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
    final formatter = NumberFormat('#,##0.00', 'en_US');

    if (value < 0) {
      return '-S/ ${formatter.format(value.abs())}';
    }

    return 'S/ ${formatter.format(value)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colors.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono, color: colors.primary),

            const SizedBox(height: 12),

            Text(
              titulo,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 4),

            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                moneda(monto),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_mensual.dart';

// class FlujoMensualView extends StatelessWidget {
//   final FlujoContableMensualData data;

//   const FlujoMensualView({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) {
//     final resumen = data.resumen;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           data.periodo.nombre,
//           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),

//         const SizedBox(height: 16),

//         _SaldoPrincipalCard(
//           saldo: resumen.saldoFinalCalculado,
//           flujo: resumen.flujoNeto,
//         ),

//         const SizedBox(height: 16),

//         Row(
//           children: [
//             Expanded(
//               child: _IndicadorCard(
//                 titulo: 'Ingresos',
//                 monto: resumen.totalIngresos,
//                 icono: Icons.arrow_downward_rounded,
//               ),
//             ),

//             const SizedBox(width: 12),

//             Expanded(
//               child: _IndicadorCard(
//                 titulo: 'Egresos',
//                 monto: resumen.totalEgresos,
//                 icono: Icons.arrow_upward_rounded,
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 12),

//         Row(
//           children: [
//             Expanded(
//               child: _IndicadorCard(
//                 titulo: 'Saldo inicial',
//                 monto: resumen.saldoInicial,
//                 icono: Icons.account_balance_wallet_outlined,
//               ),
//             ),

//             const SizedBox(width: 12),

//             Expanded(
//               child: _IndicadorCard(
//                 titulo: 'Flujo neto',
//                 monto: resumen.flujoNeto,
//                 icono: Icons.swap_vert_rounded,
//               ),
//             ),
//           ],
//         ),

//         const SizedBox(height: 24),

//         Text(
//           '${resumen.cantidadMovimientos} movimientos registrados',
//           style: Theme.of(context).textTheme.bodyMedium,
//         ),
//       ],
//     );
//   }
// }

// class _SaldoPrincipalCard extends StatelessWidget {
//   final double saldo;
//   final double flujo;

//   const _SaldoPrincipalCard({required this.saldo, required this.flujo});

//   String moneda(double value) {
//     return NumberFormat.currency(symbol: 'S/ ', decimalDigits: 2).format(value);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Saldo disponible',
//               style: TextStyle(color: Colors.grey),
//             ),

//             const SizedBox(height: 7),

//             Text(
//               moneda(saldo),
//               style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 10),

//             Text('Flujo del período: ${moneda(flujo)}'),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _IndicadorCard extends StatelessWidget {
//   final String titulo;
//   final double monto;
//   final IconData icono;

//   const _IndicadorCard({
//     required this.titulo,
//     required this.monto,
//     required this.icono,
//   });

//   String moneda(double value) {
//     return NumberFormat.currency(symbol: 'S/ ', decimalDigits: 2).format(value);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 0,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icono),

//             const SizedBox(height: 12),

//             Text(titulo, style: const TextStyle(color: Colors.grey)),

//             const SizedBox(height: 4),

//             Text(
//               moneda(monto),
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
