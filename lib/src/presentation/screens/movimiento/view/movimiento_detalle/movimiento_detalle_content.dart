import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';

import 'package:flutter/material.dart';

class MovimientoDetailContent extends StatelessWidget {
  final MovimientoData movimiento;
  final bool isDeleting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const MovimientoDetailContent({
    super.key,
    required this.movimiento,
    required this.isDeleting,
    required this.onEdit,
    required this.onDelete,
  });

  bool get _isIngreso {
    return movimiento.tipo.trim().toUpperCase() == 'INGRESO';
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        /*
         * La recarga principal está controlada por la Page.
         * Puedes agregar un callback onRefresh si deseas habilitarlo.
         */
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          _buildAmountCard(context),
          const SizedBox(height: 20),
          _buildGeneralInformation(context),
          const SizedBox(height: 20),
          _buildDescription(context),
          const SizedBox(height: 20),
          _buildActions(context),
        ],
      ),
    );
  }

  // ==========================================================
  // ENCABEZADO
  // ==========================================================
  Widget _buildHeader(BuildContext context) {
    final Color statusColor = _isIngreso ? Colors.green : Colors.red;

    final IconData statusIcon = _isIngreso
        ? Icons.south_west_rounded
        : Icons.north_east_rounded;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(statusIcon, color: statusColor, size: 30),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getDescription(),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  movimiento.tipo.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // MONTO
  // ==========================================================
  Widget _buildAmountCard(BuildContext context) {
    final Color amountColor = _isIngreso ? Colors.green : Colors.red;

    final String prefix = _isIngreso ? '+' : '-';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: amountColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: amountColor.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Text(
            'Monto del movimiento',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          Text(
            '$prefix S/ ${_formatAmount(movimiento.monto)}',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // INFORMACIÓN GENERAL
  // ==========================================================
  Widget _buildGeneralInformation(BuildContext context) {
    return _DetailSection(
      title: 'Información general',
      icon: Icons.info_outline,
      children: [
        _DetailItem(
          icon: Icons.tag,
          label: 'ID del movimiento',
          value: movimiento.idMovimiento.toString(),
        ),
        _DetailItem(
          icon: Icons.category_outlined,
          label: 'Categoría',
          value: 'Categoría #${movimiento.idCategoria}',
        ),
        _DetailItem(
          icon: Icons.calendar_today_outlined,
          label: 'Fecha',
          value: _formatDate(movimiento.fecha),
        ),
        _DetailItem(
          icon: Icons.business_outlined,
          label: 'Empresa',
          value: movimiento.idEmpresa.toString(),
        ),
        _DetailItem(
          icon: Icons.date_range_outlined,
          label: 'Período contable',
          value: movimiento.idPeriodo.toString(),
        ),
      ],
    );
  }

  // ==========================================================
  // DESCRIPCIÓN Y OBSERVACIÓN
  // ==========================================================
  Widget _buildDescription(BuildContext context) {
    return _DetailSection(
      title: 'Detalle',
      icon: Icons.description_outlined,
      children: [
        _DetailItem(
          icon: Icons.subject_outlined,
          label: 'Descripción',
          value: _getDescription(),
        ),
        _DetailItem(
          icon: Icons.notes_outlined,
          label: 'Observación',
          value: _getObservation(),
        ),
      ],
    );
  }

  // ==========================================================
  // ACCIONES
  // ==========================================================
  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: FilledButton.icon(
            onPressed: isDeleting ? null : onEdit,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Editar movimiento'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: isDeleting ? null : onDelete,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
            icon: isDeleting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline),
            label: Text(isDeleting ? 'Eliminando...' : 'Eliminar movimiento'),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // HELPERS
  // ==========================================================
  String _getDescription() {
    final String description = movimiento.descripcion.trim();

    if (description.isEmpty) {
      return 'Movimiento sin descripción';
    }

    return description;
  }

  String _getObservation() {
    final String? observation = movimiento.observacion;

    if (observation == null || observation.trim().isEmpty) {
      return 'Sin observaciones';
    }

    return observation.trim();
  }

  String _formatAmount(dynamic value) {
    if (value == null) {
      return '0.00';
    }

    final double? amount = double.tryParse(value.toString());

    if (amount == null) {
      return value.toString();
    }

    return amount.toStringAsFixed(2);
  }

  String _formatDate(dynamic value) {
    if (value == null) {
      return 'Sin fecha';
    }

    DateTime? date;

    if (value is DateTime) {
      date = value;
    } else {
      date = DateTime.tryParse(value.toString());
    }

    if (date == null) {
      return value.toString();
    }

    const List<String> months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];

    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }
}

// ============================================================
// SECCIÓN DEL DETALLE
// ============================================================
class _DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _DetailSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.60),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ..._withDividers(children),
        ],
      ),
    );
  }

  List<Widget> _withDividers(List<Widget> widgets) {
    final List<Widget> result = [];

    for (int index = 0; index < widgets.length; index++) {
      result.add(widgets[index]);

      if (index < widgets.length - 1) {
        result.add(const Divider(height: 24));
      }
    }

    return result;
  }
}

// ============================================================
// ELEMENTO DEL DETALLE
// ============================================================
class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 21, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
