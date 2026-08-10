import 'package:flutter/material.dart';

// Models
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_data.dart';

class SubcategoriaDetalleContent extends StatelessWidget {
  final SubcategoriaData subcategoria;

  const SubcategoriaDetalleContent({super.key, required this.subcategoria});

  @override
  Widget build(BuildContext context) {
    final categoria = subcategoria.categoria;

    final Color categoryColor = _parseColor(
      categoria?.color,
      Theme.of(context).colorScheme.primary,
    );

    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 36),
        children: [
          // ====================================================
          // CABECERA
          // ====================================================
          _buildHeader(context, categoryColor),

          const SizedBox(height: 18),

          // ====================================================
          // INFORMACIÓN GENERAL
          // ====================================================
          _DetailSection(
            title: 'Información general',
            icon: Icons.info_outline_rounded,
            children: [
              _DetailRow(
                icon: Icons.category_outlined,
                title: 'Categoría',
                value: categoria?.nombre ?? 'No disponible',
              ),

              _DetailRow(
                icon: _iconByTipo(categoria?.tipo),
                title: 'Tipo',
                valueWidget: _TipoChip(tipo: categoria?.tipo ?? 'SIN TIPO'),
              ),

              _DetailRow(
                icon: Icons.sort_rounded,
                title: 'Orden',
                value: subcategoria.orden.toString(),
              ),

              _DetailRow(
                icon: Icons.account_tree_outlined,
                title: 'Naturaleza',
                valueWidget: _NaturalezaChip(
                  naturaleza: subcategoria.naturaleza ?? 'NO DEFINIDA',
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ====================================================
          // DESCRIPCIÓN
          // ====================================================
          _DetailSection(
            title: 'Descripción',
            icon: Icons.notes_rounded,
            children: [
              Text(
                subcategoria.descripcion?.trim().isNotEmpty == true
                    ? subcategoria.descripcion!
                    : 'Sin descripción.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ====================================================
          // CONFIGURACIÓN
          // ====================================================
          _DetailSection(
            title: 'Configuración',
            icon: Icons.settings_outlined,
            children: [
              _StatusRow(
                title: 'Estado',
                active: subcategoria.estado,
                activeText: 'Activa',
                inactiveText: 'Inactiva',
                activeIcon: Icons.check_circle_outline,
                inactiveIcon: Icons.block_outlined,
              ),

              _StatusRow(
                title: 'Predeterminada',
                active: subcategoria.esPredeterminada,
                activeText: 'Sí',
                inactiveText: 'No',
                activeIcon: Icons.star_rounded,
                inactiveIcon: Icons.star_outline_rounded,
              ),
            ],
          ),

          // ====================================================
          // CATEGORÍA ASOCIADA
          // ====================================================
          if (categoria != null) ...[
            const SizedBox(height: 18),

            _DetailSection(
              title: 'Categoría asociada',
              icon: Icons.category_outlined,
              children: [
                _DetailRow(
                  icon: Icons.label_outline,
                  title: 'Nombre',
                  value: categoria.nombre,
                ),

                _DetailRow(
                  icon: _iconByTipo(categoria.tipo),
                  title: 'Tipo',
                  valueWidget: _TipoChip(tipo: categoria.tipo),
                ),

                if (categoria.descripcion?.trim().isNotEmpty == true)
                  _DetailRow(
                    icon: Icons.notes_rounded,
                    title: 'Descripción',
                    value: categoria.descripcion!,
                  ),

                if (categoria.estado != null)
                  _StatusRow(
                    title: 'Estado de categoría',
                    active: categoria.estado!,
                    activeText: 'Activa',
                    inactiveText: 'Inactiva',
                    activeIcon: Icons.check_circle_outline,
                    inactiveIcon: Icons.block_outlined,
                  ),
              ],
            ),
          ],

          // ====================================================
          // REGISTRO
          // ====================================================
          if (subcategoria.createdAt != null ||
              subcategoria.updatedAt != null) ...[
            const SizedBox(height: 18),

            _DetailSection(
              title: 'Registro',
              icon: Icons.history_outlined,
              children: [
                if (subcategoria.createdAt != null)
                  _DetailRow(
                    icon: Icons.add_circle_outline,
                    title: 'Creada',
                    value: _formatDateTime(subcategoria.createdAt!),
                  ),

                if (subcategoria.updatedAt != null)
                  _DetailRow(
                    icon: Icons.update_outlined,
                    title: 'Última actualización',
                    value: _formatDateTime(subcategoria.updatedAt!),
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
    final categoria = subcategoria.categoria;

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
            // =================================================
            // ICONO
            // =================================================
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                _iconByTipo(categoria?.tipo),
                color: categoryColor,
                size: 30,
              ),
            ),

            const SizedBox(width: 15),

            // =================================================
            // INFORMACIÓN
            // =================================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subcategoria.nombre,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    categoria?.nombre ?? 'Sin categoría',
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.onSurfaceVariant,
                    ),
                  ),

                  // if (subcategoria.esPredeterminada) ...[
                  //   const SizedBox(height: 7),

                  //   Row(
                  //     children: [
                  //       Icon(
                  //         Icons.star_rounded,
                  //         size: 16,
                  //         color: Colors.amber.shade700,
                  //       ),
                  //       const SizedBox(width: 5),
                  //       Text(
                  //         'Subcategoría predeterminada',
                  //         style: TextStyle(
                  //           fontSize: 12,
                  //           fontWeight: FontWeight.w600,
                  //           color: colors.onSurfaceVariant,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ],
                ],
              ),
            ),

            const SizedBox(width: 10),

            // =================================================
            // ESTADO
            // =================================================
            _EstadoChip(estado: subcategoria.estado),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // ICONO POR TIPO
  // ==========================================================
  static IconData _iconByTipo(String? tipo) {
    switch (tipo?.trim().toUpperCase()) {
      case 'INGRESO':
        return Icons.south_west_rounded;

      case 'EGRESO':
        return Icons.north_east_rounded;

      default:
        return Icons.account_tree_outlined;
    }
  }

  // ==========================================================
  // COLOR
  // ==========================================================
  Color _parseColor(String? hexColor, Color fallback) {
    if (hexColor == null || hexColor.trim().isEmpty) {
      return fallback;
    }

    try {
      String clean = hexColor.trim().replaceAll('#', '');

      if (clean.length == 6) {
        clean = 'FF$clean';
      }

      if (clean.length != 8) {
        return fallback;
      }

      return Color(int.parse(clean, radix: 16));
    } catch (_) {
      return fallback;
    }
  }

  // ==========================================================
  // FECHA
  // ==========================================================
  String _formatDateTime(DateTime date) {
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
// SECCIÓN
// ==========================================================
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

            ..._withSeparators(children),
          ],
        ),
      ),
    );
  }

  List<Widget> _withSeparators(List<Widget> children) {
    final List<Widget> result = [];

    for (int index = 0; index < children.length; index++) {
      result.add(children[index]);

      if (index < children.length - 1) {
        result.add(const Divider(height: 26));
      }
    }

    return result;
  }
}

// ==========================================================
// FILA DE DETALLE
// ==========================================================
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;

  final String? value;
  final Widget? valueWidget;

  const _DetailRow({
    required this.icon,
    required this.title,
    this.value,
    this.valueWidget,
  }) : assert(value != null || valueWidget != null);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                title,
                style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
              ),

              const SizedBox(height: 4),

              valueWidget ??
                  Text(
                    value!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
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
// STATUS ROW
// ==========================================================
class _StatusRow extends StatelessWidget {
  final String title;
  final bool active;

  final String activeText;
  final String inactiveText;

  final IconData activeIcon;
  final IconData inactiveIcon;

  const _StatusRow({
    required this.title,
    required this.active,
    required this.activeText,
    required this.inactiveText,
    required this.activeIcon,
    required this.inactiveIcon,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: active
                ? Colors.green.withValues(alpha: 0.12)
                : Colors.grey.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                active ? activeIcon : inactiveIcon,
                size: 16,
                color: active ? Colors.green.shade700 : colors.onSurfaceVariant,
              ),

              const SizedBox(width: 6),

              Text(
                active ? activeText : inactiveText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: active
                      ? Colors.green.shade700
                      : colors.onSurfaceVariant,
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
// TIPO
// ==========================================================
class _TipoChip extends StatelessWidget {
  final String tipo;

  const _TipoChip({required this.tipo});

  @override
  Widget build(BuildContext context) {
    final bool ingreso = tipo.trim().toUpperCase() == 'INGRESO';

    final bool egreso = tipo.trim().toUpperCase() == 'EGRESO';

    final ColorScheme colors = Theme.of(context).colorScheme;

    final Color background = ingreso
        ? Colors.green.withValues(alpha: 0.12)
        : egreso
        ? Colors.red.withValues(alpha: 0.12)
        : colors.secondaryContainer;

    final Color foreground = ingreso
        ? Colors.green.shade700
        : egreso
        ? Colors.red.shade700
        : colors.onSecondaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tipo,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: foreground,
        ),
      ),
    );
  }
}

// ==========================================================
// NATURALEZA
// ==========================================================
class _NaturalezaChip extends StatelessWidget {
  final String naturaleza;

  const _NaturalezaChip({required this.naturaleza});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        naturaleza,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: colors.onSecondaryContainer,
        ),
      ),
    );
  }
}

// ==========================================================
// ESTADO
// ==========================================================
class _EstadoChip extends StatelessWidget {
  final bool estado;

  const _EstadoChip({required this.estado});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

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
          color: estado ? Colors.green.shade700 : colors.onSurfaceVariant,
        ),
      ),
    );
  }
}
