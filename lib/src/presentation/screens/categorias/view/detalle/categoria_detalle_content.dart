import 'package:flutter/material.dart';

import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';

class CategoriaDetalleContent extends StatelessWidget {
  final CategoriaData categoria;

  const CategoriaDetalleContent({super.key, required this.categoria});

  bool get _isIngreso => categoria.tipo.trim().toUpperCase() == 'INGRESO';

  bool get _isActiva => categoria.estado;

  @override
  Widget build(BuildContext context) {
    final Color categoryColor = _parseColor(categoria.color);

    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 35),
        children: [
          // ====================================================
          // HEADER
          // ====================================================
          _buildHeader(context, categoryColor),

          const SizedBox(height: 18),

          // ====================================================
          // INFORMACIÓN GENERAL
          // ====================================================
          _buildSection(
            context: context,
            title: 'Información general',
            icon: Icons.description_outlined,
            children: [
              _DetailRow(
                label: 'Nombre',
                value: categoria.nombre,
                icon: Icons.label_outline,
              ),

              _DetailRow(
                label: 'Tipo',
                value: categoria.tipo,
                icon: _isIngreso
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                valueWidget: _TipoChip(tipo: categoria.tipo),
              ),

              _DetailRow(
                label: 'Naturaleza',
                value: categoria.naturaleza,
                icon: Icons.account_tree_outlined,
                valueWidget: _NaturalezaChip(naturaleza: categoria.naturaleza),
              ),

              _DetailRow(
                label: 'Estado',
                value: _isActiva ? 'ACTIVA' : 'INACTIVA',
                icon: _isActiva
                    ? Icons.check_circle_outline
                    : Icons.cancel_outlined,
                valueWidget: _EstadoChip(estado: categoria.estado),
              ),
            ],
          ),

          // ====================================================
          // DESCRIPCIÓN
          // ====================================================
          if (categoria.descripcion != null &&
              categoria.descripcion!.trim().isNotEmpty) ...[
            const SizedBox(height: 18),

            _buildSection(
              context: context,
              title: 'Descripción',
              icon: Icons.notes_outlined,
              children: [
                Text(
                  categoria.descripcion!,
                  style: TextStyle(
                    height: 1.5,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 18),

          // ====================================================
          // APARIENCIA
          // ====================================================
          _buildSection(
            context: context,
            title: 'Apariencia',
            icon: Icons.palette_outlined,
            children: [
              _AppearanceRow(
                label: 'Color',
                value: categoria.color ?? 'Sin color',
                child: _ColorPreview(
                  color: categoryColor,
                  value: categoria.color,
                ),
              ),

              _AppearanceRow(
                label: 'Icono',
                value: categoria.icono ?? 'category',
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIcon(categoria.icono),
                        color: categoryColor,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Flexible(
                      child: Text(
                        categoria.icono ?? 'category',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ====================================================
          // METADATOS
          // ====================================================
          if (categoria.createdAt != null || categoria.updatedAt != null) ...[
            const SizedBox(height: 18),

            _buildSection(
              context: context,
              title: 'Registro',
              icon: Icons.history_outlined,
              children: [
                if (categoria.createdAt != null)
                  _DetailRow(
                    label: 'Creada',
                    value: _formatDateTime(categoria.createdAt!),
                    icon: Icons.add_circle_outline,
                  ),

                if (categoria.updatedAt != null)
                  _DetailRow(
                    label: 'Última actualización',
                    value: _formatDateTime(categoria.updatedAt!),
                    icon: Icons.update_outlined,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================
  Widget _buildHeader(BuildContext context, Color categoryColor) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                _getIcon(categoria.icono),
                color: categoryColor,
                size: 30,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoria.nombre,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    _isIngreso ? 'Categoría de ingreso' : 'Categoría de egreso',
                    style: TextStyle(color: colors.onSurfaceVariant),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            _EstadoChip(estado: categoria.estado),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SECTION
  // ==========================================================
  Widget _buildSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
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

            const SizedBox(height: 16),

            ..._separateChildren(children),
          ],
        ),
      ),
    );
  }

  List<Widget> _separateChildren(List<Widget> children) {
    final List<Widget> result = [];

    for (int index = 0; index < children.length; index++) {
      result.add(children[index]);

      if (index < children.length - 1) {
        result.add(const Divider(height: 26));
      }
    }

    return result;
  }

  // ==========================================================
  // HELPERS
  // ==========================================================
  Color _parseColor(String? hexColor) {
    if (hexColor == null || hexColor.trim().isEmpty) {
      return Colors.blue;
    }

    try {
      String clean = hexColor.trim().replaceAll('#', '');

      if (clean.length == 6) {
        clean = 'FF$clean';
      }

      if (clean.length != 8) {
        return Colors.blue;
      }

      return Color(int.parse(clean, radix: 16));
    } catch (_) {
      return Colors.blue;
    }
  }

  IconData _getIcon(String? icono) {
    switch (icono?.trim().toLowerCase()) {
      case 'wifi':
        return Icons.wifi;

      case 'home':
        return Icons.home_outlined;

      case 'food':
        return Icons.restaurant_outlined;

      case 'money':
        return Icons.attach_money;

      case 'car':
        return Icons.directions_car_outlined;

      case 'shopping':
      case 'shopping_bag':
        return Icons.shopping_bag_outlined;

      case 'account_balance':
        return Icons.account_balance_outlined;

      case 'account_balance_wallet':
        return Icons.account_balance_wallet_outlined;

      case 'business':
        return Icons.business_outlined;

      case 'admin_panel_settings':
        return Icons.admin_panel_settings_outlined;

      case 'light':
      case 'lightbulb':
      case 'electricity':
        return Icons.lightbulb_outline;

      default:
        return Icons.category_outlined;
    }
  }

  String _formatDateTime(String value) {
    final DateTime? date = DateTime.tryParse(value);

    if (date == null) {
      return value;
    }

    final DateTime local = date.toLocal();

    String twoDigits(int value) {
      return value.toString().padLeft(2, '0');
    }

    return '${twoDigits(local.day)}/'
        '${twoDigits(local.month)}/'
        '${local.year} '
        '${twoDigits(local.hour)}:'
        '${twoDigits(local.minute)}';
  }
}

// ==========================================================
// DETAIL ROW
// ==========================================================
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Widget? valueWidget;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueWidget,
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
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================================
// APPEARANCE ROW
// ==========================================================
class _AppearanceRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget child;

  const _AppearanceRow({
    required this.label,
    required this.value,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
        ),

        const SizedBox(height: 8),

        child,
      ],
    );
  }
}

// ==========================================================
// COLOR PREVIEW
// ==========================================================
class _ColorPreview extends StatelessWidget {
  final Color color;
  final String? value;

  const _ColorPreview({required this.color, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        const SizedBox(width: 10),

        Text(
          value ?? 'Sin color',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

// ==========================================================
// TIPO CHIP
// ==========================================================
class _TipoChip extends StatelessWidget {
  final String tipo;

  const _TipoChip({required this.tipo});

  @override
  Widget build(BuildContext context) {
    final bool ingreso = tipo.trim().toUpperCase() == 'INGRESO';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ingreso
            ? Colors.green.withValues(alpha: 0.12)
            : Colors.red.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tipo,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: ingreso ? Colors.green.shade700 : Colors.red.shade700,
        ),
      ),
    );
  }
}

// ==========================================================
// NATURALEZA CHIP
// ==========================================================
class _NaturalezaChip extends StatelessWidget {
  final String naturaleza;

  const _NaturalezaChip({required this.naturaleza});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        naturaleza,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}

// ==========================================================
// ESTADO CHIP
// ==========================================================
class _EstadoChip extends StatelessWidget {
  final bool estado;

  const _EstadoChip({required this.estado});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: estado
            ? Colors.green.withValues(alpha: 0.12)
            : Colors.grey.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        estado ? 'ACTIVA' : 'INACTIVA',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: estado ? Colors.green.shade700 : Colors.grey.shade700,
        ),
      ),
    );
  }
}
