import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_data.dart';
import 'package:flutter/material.dart';

class PeriodoContableDetalleContent extends StatelessWidget {
  final PeriodoContableData periodo;
  final bool isProcessing;

  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onChangeEstado;

  const PeriodoContableDetalleContent({
    super.key,
    required this.periodo,
    required this.isProcessing,
    required this.onEdit,
    required this.onDelete,
    required this.onChangeEstado,
  });

  bool get _isOpen => periodo.estado.toUpperCase() == 'ABIERTO';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 35),
        children: [
          _buildHeader(context),
          const SizedBox(height: 18),

          _buildSummaryCard(context),
          const SizedBox(height: 18),

          _buildSection(
            context: context,
            title: 'Información general',
            icon: Icons.description_outlined,
            children: [
              _DetailRow(
                label: 'Nombre',
                value: periodo.nombre,
                icon: Icons.badge_outlined,
              ),
              _DetailRow(
                label: 'Año',
                value: periodo.anio.toString(),
                icon: Icons.calendar_today_outlined,
              ),
              _DetailRow(
                label: 'Mes',
                value: _monthName(periodo.mes),
                icon: Icons.date_range_outlined,
              ),
              _DetailRow(
                label: 'Estado',
                value: periodo.estado,
                icon: _isOpen ? Icons.lock_open_outlined : Icons.lock_outline,
                valueWidget: _EstadoChip(estado: periodo.estado),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _buildSection(
            context: context,
            title: 'Rango contable',
            icon: Icons.event_note_outlined,
            children: [
              _DetailRow(
                label: 'Fecha de inicio',
                value: _formatDate(periodo.fechaInicio),
                icon: Icons.event_outlined,
              ),
              _DetailRow(
                label: 'Fecha de fin',
                value: _formatDate(periodo.fechaFin),
                icon: Icons.event_available_outlined,
              ),
            ],
          ),

          const SizedBox(height: 18),

          _buildSection(
            context: context,
            title: 'Información financiera',
            icon: Icons.account_balance_wallet_outlined,
            children: [
              _DetailRow(
                label: 'Saldo inicial',
                value: _formatAmount(periodo.saldoInicial),
                icon: Icons.savings_outlined,
              ),
              _DetailRow(
                label: 'Saldo final',
                value: _formatAmount(periodo.saldoFinal),
                icon: Icons.account_balance_outlined,
              ),
              _DetailRow(
                label: 'Variación',
                value: _formatVariation(),
                icon: _variation >= 0 ? Icons.trending_up : Icons.trending_down,
                valueColor: _variation >= 0 ? Colors.green : Colors.red,
              ),
            ],
          ),

          if (periodo.observacion != null &&
              periodo.observacion!.trim().isNotEmpty) ...[
            const SizedBox(height: 18),
            _buildSection(
              context: context,
              title: 'Observación',
              icon: Icons.notes_outlined,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    periodo.observacion!,
                    style: TextStyle(
                      height: 1.5,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 26),

          _buildActions(context),
        ],
      ),
    );
  }

  double get _variation => periodo.saldoFinal - periodo.saldoInicial;

  String _formatVariation() {
    final String sign = _variation > 0 ? '+' : '';

    return '$sign${_formatAmount(_variation)}';
  }

  // ==========================================================
  // HEADER
  // ==========================================================
  Widget _buildHeader(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _isOpen
            ? Colors.green.withValues(alpha: 0.10)
            : colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _isOpen
              ? Colors.green.withValues(alpha: 0.30)
              : colors.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: _isOpen ? Colors.green : Colors.grey.shade700,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              _isOpen ? Icons.lock_open_outlined : Icons.lock_outline,
              color: Colors.white,
              size: 29,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  periodo.nombre,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${_monthName(periodo.mes)} ${periodo.anio}',
                  style: TextStyle(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          _EstadoChip(estado: periodo.estado),
        ],
      ),
    );
  }

  // ==========================================================
  // RESUMEN
  // ==========================================================
  Widget _buildSummaryCard(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryItem(
            title: 'Saldo inicial',
            value: _formatAmount(periodo.saldoInicial),
            icon: Icons.savings_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryItem(
            title: 'Saldo final',
            value: _formatAmount(periodo.saldoFinal),
            icon: Icons.account_balance_wallet_outlined,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // SECCIÓN
  // ==========================================================
  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 21, color: colors.primary),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ..._separateChildren(children),
        ],
      ),
    );
  }

  List<Widget> _separateChildren(List<Widget> children) {
    final List<Widget> result = [];

    for (int index = 0; index < children.length; index++) {
      result.add(children[index]);

      if (index < children.length - 1) {
        result.add(const Divider(height: 24));
      }
    }

    return result;
  }

  // ==========================================================
  // ACCIONES
  // ==========================================================
  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            onPressed: isProcessing ? null : onChangeEstado,
            icon: isProcessing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.3),
                  )
                : Icon(_isOpen ? Icons.lock_outline : Icons.lock_open_outlined),
            label: Text(_isOpen ? 'Cerrar período' : 'Abrir período'),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: isProcessing ? null : onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Editar'),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  onPressed: isProcessing ? null : onDelete,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Eliminar'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static String _monthName(int month) {
    const List<String> months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    if (month < 1 || month > 12) {
      return 'Mes $month';
    }

    return months[month - 1];
  }

  static String _formatDate(dynamic value) {
    final String date = value.toString();

    if (date.length >= 10) {
      final List<String> parts = date.substring(0, 10).split('-');

      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
    }

    return date;
  }

  static String _formatAmount(dynamic amount) {
    final double value = amount is num
        ? amount.toDouble()
        : double.tryParse(amount.toString()) ?? 0;

    return 'S/ ${value.toStringAsFixed(2)}';
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.primary),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Widget? valueWidget;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueWidget,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: colors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 3),
              valueWidget ??
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: valueColor,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EstadoChip extends StatelessWidget {
  final String estado;

  const _EstadoChip({required this.estado});

  @override
  Widget build(BuildContext context) {
    final bool isOpen = estado.toUpperCase() == 'ABIERTO';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: isOpen
            ? Colors.green.withValues(alpha: 0.13)
            : Colors.grey.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        estado,
        style: TextStyle(
          color: isOpen ? Colors.green.shade700 : Colors.grey.shade700,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
