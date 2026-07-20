import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_data.dart';

import 'package:app_aryoria/src/data/models/reporte/reporte_categoria_data.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_evolucion_data.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_general_data.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_movimiento_data.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_resumen_data.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_state.dart';

import 'package:app_aryoria/src/presentation/screens/reportes/bloc/reporte_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/reportes/bloc/reporte_event.dart';
import 'package:app_aryoria/src/presentation/screens/reportes/bloc/reporte_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ReporteContent extends StatefulWidget {
  final int idEmpresa;

  const ReporteContent({super.key, required this.idEmpresa});

  @override
  State<ReporteContent> createState() => _ReporteContentState();
}

class _ReporteContentState extends State<ReporteContent> {
  int? _idPeriodoSeleccionado;
  bool _periodoInicialAsignado = false;

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'es_PE',
    symbol: 'S/ ',
    decimalDigits: 2,
  );

  void _seleccionarPeriodo(int? idPeriodo) {
    if (idPeriodo == null) return;

    setState(() {
      _idPeriodoSeleccionado = idPeriodo;
    });

    context.read<ReporteBloc>().add(
      GetReporteGeneralEvent(idEmpresa: widget.idEmpresa, idPeriodo: idPeriodo),
    );
  }

  void _seleccionarPeriodoInicial(List<PeriodoContableData> periodos) {
    if (_periodoInicialAsignado || periodos.isEmpty) {
      return;
    }

    _periodoInicialAsignado = true;

    final abiertos = periodos.where((periodo) {
      return periodo.estado.toUpperCase() == 'ABIERTO';
    }).toList();

    final periodoInicial = abiertos.isNotEmpty
        ? abiertos.first
        : periodos.first;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _seleccionarPeriodo(periodoInicial.idPeriodo);
    });
  }

  Future<void> _refresh() async {
    final idPeriodo = _idPeriodoSeleccionado;

    if (idPeriodo == null) return;

    context.read<ReporteBloc>().add(
      GetReporteGeneralEvent(idEmpresa: widget.idEmpresa, idPeriodo: idPeriodo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PeriodoContableBloc, PeriodoContableState>(
      builder: (context, periodoState) {
        final List<PeriodoContableData> periodos = periodoState.periodos;

        _seleccionarPeriodoInicial(periodos);

        return BlocBuilder<ReporteBloc, ReporteState>(
          builder: (context, reporteState) {
            final response = reporteState.generalResponse;
            final reporte = reporteState.reporteGeneral;

            return RefreshIndicator(
              onRefresh: _refresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                    sliver: SliverToBoxAdapter(
                      child: _buildPeriodoSelector(
                        periodos: periodos,
                        periodoState: periodoState,
                      ),
                    ),
                  ),

                  if (_idPeriodoSeleccionado == null)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _ReporteSinPeriodo(),
                    )
                  else if (response is Loading && reporte == null)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _ReporteLoading(),
                    )
                  // else if (response is ErrorData && reporte == null)
                  //   SliverFillRemaining(
                  //     hasScrollBody: false,
                  //     child: _ReporteError(
                  //       message: response.,
                  //       onRetry: _refresh,
                  //     ),
                  //   )
                  else if (reporte == null)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: _ReporteEmpty(),
                    )
                  else
                    ..._buildReporteSlivers(
                      reporte,
                      isRefreshing: response is Loading,
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPeriodoSelector({
    required List<PeriodoContableData> periodos,
    required PeriodoContableState periodoState,
  }) {
    final isLoading = periodoState.response is Loading && periodos.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Período contable', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          initialValue:
              periodos.any(
                (periodo) => periodo.idPeriodo == _idPeriodoSeleccionado,
              )
              ? _idPeriodoSeleccionado
              : null,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: isLoading
                ? 'Cargando períodos...'
                : periodos.isEmpty
                ? 'No existen períodos disponibles'
                : 'Selecciona un período',
            prefixIcon: const Icon(Icons.calendar_month_outlined),
            suffixIcon: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
            border: const OutlineInputBorder(),
          ),
          items: periodos.map((periodo) {
            return DropdownMenuItem<int>(
              value: periodo.idPeriodo,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      periodo.nombre,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _PeriodoEstadoChip(estado: periodo.estado),
                ],
              ),
            );
          }).toList(),
          onChanged: isLoading || periodos.isEmpty ? null : _seleccionarPeriodo,
        ),
      ],
    );
  }

  List<Widget> _buildReporteSlivers(
    ReporteGeneralData reporte, {
    required bool isRefreshing,
  }) {
    return [
      if (isRefreshing)
        const SliverToBoxAdapter(child: LinearProgressIndicator()),

      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        sliver: SliverToBoxAdapter(child: _buildPeriodoHeader(reporte)),
      ),

      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
        sliver: SliverToBoxAdapter(child: _buildResumen(reporte.resumen)),
      ),

      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
        sliver: SliverToBoxAdapter(child: _buildCategorias(reporte.categorias)),
      ),

      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
        sliver: SliverToBoxAdapter(child: _buildEvolucion(reporte.evolucion)),
      ),

      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 26, 20, 32),
        sliver: SliverToBoxAdapter(
          child: _buildUltimosMovimientos(reporte.ultimosMovimientos),
        ),
      ),
    ];
  }

  Widget _buildPeriodoHeader(ReporteGeneralData reporte) {
    final periodo = reporte.periodo;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.assessment_outlined,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  periodo.nombre,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatDate(periodo.fechaInicio)} - '
                  '${_formatDate(periodo.fechaFin)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          _PeriodoEstadoChip(estado: periodo.estado),
        ],
      ),
    );
  }

  Widget _buildResumen(ReporteResumenData resumen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'Resumen financiero',
          subtitle: 'Resultados principales del período',
          icon: Icons.account_balance_wallet_outlined,
        ),
        const SizedBox(height: 14),

        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final cardWidth = width > 600 ? (width - 24) / 3 : (width - 12) / 2;

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: _ResumenCard(
                    title: 'Ingresos',
                    value: _currencyFormat.format(resumen.totalIngresos),
                    icon: Icons.trending_up,
                    type: _ResumenCardType.success,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _ResumenCard(
                    title: 'Egresos',
                    value: _currencyFormat.format(resumen.totalEgresos),
                    icon: Icons.trending_down,
                    type: _ResumenCardType.danger,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _ResumenCard(
                    title: 'Saldo',
                    value: _currencyFormat.format(resumen.saldoFinalCalculado),
                    icon: Icons.savings_outlined,
                    type: resumen.saldoFinalCalculado >= 0
                        ? _ResumenCardType.primary
                        : _ResumenCardType.danger,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _ResumenCard(
                    title: 'Movimientos',
                    value: resumen.cantidadMovimientos.toString(),
                    icon: Icons.receipt_long_outlined,
                    type: _ResumenCardType.neutral,
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 14),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _InfoRow(
                label: 'Saldo inicial',
                value: _currencyFormat.format(resumen.saldoInicial),
              ),
              const Divider(height: 22),
              _InfoRow(
                label: 'Saldo por movimientos',
                value: _currencyFormat.format(resumen.saldoMovimientos),
              ),
              const Divider(height: 22),
              _InfoRow(
                label: 'Cantidad de ingresos',
                value: resumen.cantidadIngresos.toString(),
              ),
              const Divider(height: 22),
              _InfoRow(
                label: 'Cantidad de egresos',
                value: resumen.cantidadEgresos.toString(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategorias(List<ReporteCategoriaData> categorias) {
    if (categorias.isEmpty) {
      return const _EmptySection(
        title: 'Categorías',
        message: 'Todavía no existen movimientos agrupados por categoría.',
        icon: Icons.category_outlined,
      );
    }

    final maxTotal = categorias.fold<double>(
      0,
      (current, item) => item.total > current ? item.total : current,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'Movimientos por categoría',
          subtitle: 'Distribución de ingresos y egresos',
          icon: Icons.donut_large_outlined,
        ),
        const SizedBox(height: 14),

        ...categorias.take(8).map((item) {
          final progress = maxTotal <= 0
              ? 0.0
              : (item.total / maxTotal).clamp(0.0, 1.0);

          final isIngreso = item.tipo.toUpperCase() == 'INGRESO';

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: isIngreso
                            ? Colors.green.withValues(alpha: 0.12)
                            : Colors.red.withValues(alpha: 0.12),
                        child: Icon(
                          isIngreso ? Icons.arrow_downward : Icons.arrow_upward,
                          color: isIngreso ? Colors.green : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.categoria.nombre,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item.cantidadMovimientos} '
                              'movimiento${item.cantidadMovimientos == 1 ? '' : 's'}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _currencyFormat.format(item.total),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 7,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${item.porcentaje.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEvolucion(List<ReporteEvolucionData> evolucion) {
    if (evolucion.isEmpty) {
      return const _EmptySection(
        title: 'Evolución diaria',
        message: 'Todavía no existen movimientos para mostrar una evolución.',
        icon: Icons.show_chart,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'Evolución diaria',
          subtitle: 'Ingresos, egresos y saldo por día',
          icon: Icons.show_chart,
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: evolucion.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = evolucion[index];

              return Container(
                width: 210,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(item.fecha),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const Spacer(),
                    _AmountRow(
                      label: 'Ingresos',
                      amount: item.ingresos,
                      amountFormat: _currencyFormat,
                      positive: true,
                    ),
                    const SizedBox(height: 8),
                    _AmountRow(
                      label: 'Egresos',
                      amount: item.egresos,
                      amountFormat: _currencyFormat,
                      positive: false,
                    ),
                    const Divider(height: 22),
                    _InfoRow(
                      label: 'Saldo',
                      value: _currencyFormat.format(item.saldoDiario),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUltimosMovimientos(List<ReporteMovimientoData> movimientos) {
    if (movimientos.isEmpty) {
      return const _EmptySection(
        title: 'Últimos movimientos',
        message: 'No existen movimientos registrados en este período.',
        icon: Icons.receipt_long_outlined,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'Últimos movimientos',
          subtitle: 'Operaciones recientes del período',
          icon: Icons.history,
        ),
        const SizedBox(height: 14),

        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(18),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: movimientos.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 70),
            itemBuilder: (context, index) {
              final movimiento = movimientos[index];
              final isIngreso = movimiento.tipo.toUpperCase() == 'INGRESO';

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                leading: CircleAvatar(
                  backgroundColor: isIngreso
                      ? Colors.green.withValues(alpha: 0.12)
                      : Colors.red.withValues(alpha: 0.12),
                  child: Icon(
                    isIngreso ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isIngreso ? Colors.green : Colors.red,
                  ),
                ),
                title: Text(
                  movimiento.descripcion,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${movimiento.categoria?.nombre ?? 'Sin categoría'}'
                  ' · ${_formatDate(movimiento.fecha)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  '${isIngreso ? '+' : '-'}'
                  '${_currencyFormat.format(movimiento.monto)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isIngreso ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatDate(String value) {
    final date = DateTime.tryParse(value);

    if (date == null) {
      return value;
    }

    return DateFormat('dd MMM yyyy', 'es_PE').format(date);
  }
}

class _PeriodoEstadoChip extends StatelessWidget {
  final String estado;

  const _PeriodoEstadoChip({required this.estado});

  @override
  Widget build(BuildContext context) {
    final isOpen = estado.toUpperCase() == 'ABIERTO';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: isOpen
            ? Colors.green.withValues(alpha: 0.12)
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        estado,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: isOpen
              ? Colors.green
              : Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum _ResumenCardType { success, danger, primary, neutral }

class _ResumenCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final _ResumenCardType type;

  const _ResumenCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (type) {
      _ResumenCardType.success => Colors.green,
      _ResumenCardType.danger => Colors.red,
      _ResumenCardType.primary => Theme.of(context).colorScheme.primary,
      _ResumenCardType.neutral => Theme.of(context).colorScheme.secondary,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: color.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 14),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final double amount;
  final NumberFormat amountFormat;
  final bool positive;

  const _AmountRow({
    required this.label,
    required this.amount,
    required this.amountFormat,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    final color = positive ? Colors.green : Colors.red;

    return Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        Text(
          amountFormat.format(amount),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EmptySection extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const _EmptySection({
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, size: 38, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 10),
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 5),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReporteLoading extends StatelessWidget {
  const _ReporteLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _ReporteSinPeriodo extends StatelessWidget {
  const _ReporteSinPeriodo();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Text(
          'Selecciona un período contable para consultar el reporte.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _ReporteEmpty extends StatelessWidget {
  const _ReporteEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 58,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 14),
            const Text(
              'No existe información para mostrar.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// class _ReporteError extends StatelessWidget {
//   final String message;
//   final Future<void> Function() onRetry;

//   const _ReporteError({required this.message, required this.onRetry});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.error_outline,
//               size: 58,
//               color: Theme.of(context).colorScheme.error,
//             ),
//             const SizedBox(height: 14),
//             Text(message, textAlign: TextAlign.center),
//             const SizedBox(height: 18),
//             FilledButton.icon(
//               onPressed: onRetry,
//               icon: const Icon(Icons.refresh),
//               label: const Text('Reintentar'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
