import 'package:flutter/material.dart';

import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';

class CategoriaCard extends StatelessWidget {
  final CategoriaData categoria;

  /// Abrir detalle al tocar la card.
  final VoidCallback? onTap;

  /// Editar categoría.
  final VoidCallback? onEdit;

  /// Eliminar categoría.
  final VoidCallback? onDelete;

  const CategoriaCard({
    super.key,
    required this.categoria,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = _parseColor(categoria.color);

    final bool isIngreso =
        categoria.tipo.trim().toUpperCase() == 'INGRESO';

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // =================================================
              // ICONO
              // =================================================
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withValues(alpha: 0.12),
                child: Icon(
                  _getIcon(categoria.icono),
                  color: color,
                ),
              ),

              const SizedBox(width: 14),

              // =================================================
              // INFORMACIÓN
              // =================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoria.nombre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      categoria.descripcion?.trim().isNotEmpty == true
                          ? categoria.descripcion!
                          : 'Sin descripción',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _NaturalezaChip(
                          naturaleza: categoria.naturaleza,
                        ),
                        _EstadoChip(
                          estado: categoria.estado,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // =================================================
              // TIPO + MENÚ
              // =================================================
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // =================================================
                  // TIPO
                  // =================================================
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isIngreso
                          ? Colors.green.withValues(alpha: 0.12)
                          : Colors.red.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      categoria.tipo,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isIngreso
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // =================================================
                  // MENÚ 3 PUNTOS
                  // =================================================
                  PopupMenuButton<_CategoriaAction>(
                    tooltip: 'Opciones',
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.more_vert,
                    ),
                    onSelected: (action) {
                      switch (action) {
                        case _CategoriaAction.verDetalle:
                          onTap?.call();
                          break;

                        case _CategoriaAction.editar:
                          onEdit?.call();
                          break;

                        case _CategoriaAction.eliminar:
                          _confirmDelete(context);
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        if (onTap != null)
                          const PopupMenuItem<_CategoriaAction>(
                            value: _CategoriaAction.verDetalle,
                            child: _PopupOption(
                              icon: Icons.visibility_outlined,
                              label: 'Ver detalle',
                            ),
                          ),

                        if (onEdit != null)
                          const PopupMenuItem<_CategoriaAction>(
                            value: _CategoriaAction.editar,
                            child: _PopupOption(
                              icon: Icons.edit_outlined,
                              label: 'Editar',
                            ),
                          ),

                        if (onDelete != null)
                          const PopupMenuItem<_CategoriaAction>(
                            value: _CategoriaAction.eliminar,
                            child: _PopupOption(
                              icon: Icons.delete_outline,
                              label: 'Eliminar',
                              isDanger: true,
                            ),
                          ),
                      ];
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // CONFIRMAR ELIMINACIÓN
  // ==========================================================
  Future<void> _confirmDelete(
    BuildContext context,
  ) async {
    if (onDelete == null) {
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Eliminar categoría',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            '¿Estás seguro de eliminar la categoría '
            '"${categoria.nombre}"?\n\n'
            'Esta acción no se puede deshacer.',
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: const Text(
                'Cancelar',
              ),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(
                Icons.delete_outline,
                size: 19,
              ),
              label: const Text(
                'Eliminar',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      onDelete?.call();
    }
  }

  // ==========================================================
  // COLOR
  // ==========================================================
  Color _parseColor(
    String? hexColor,
  ) {
    if (hexColor == null ||
        hexColor.trim().isEmpty) {
      return Colors.blue;
    }

    try {
      String cleanColor =
          hexColor.trim().replaceAll('#', '');

      if (cleanColor.length == 6) {
        cleanColor = 'FF$cleanColor';
      }

      if (cleanColor.length != 8) {
        return Colors.blue;
      }

      return Color(
        int.parse(
          cleanColor,
          radix: 16,
        ),
      );
    } catch (_) {
      return Colors.blue;
    }
  }

  // ==========================================================
  // ICONOS
  // ==========================================================
  IconData _getIcon(
    String? icono,
  ) {
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
}

// ==========================================================
// ACCIONES DEL POPUP
// ==========================================================
enum _CategoriaAction {
  verDetalle,
  editar,
  eliminar,
}

// ==========================================================
// OPCIÓN DEL POPUP
// ==========================================================
class _PopupOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDanger;

  const _PopupOption({
    required this.icon,
    required this.label,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isDanger
        ? Colors.red.shade600
        : Theme.of(context).colorScheme.onSurface;

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: color,
          ),
        ),
      ],
    );
  }
}

// ==========================================================
// NATURALEZA
// ==========================================================
class _NaturalezaChip extends StatelessWidget {
  final String naturaleza;

  const _NaturalezaChip({
    required this.naturaleza,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        naturaleza,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Theme.of(context)
              .colorScheme
              .onSecondaryContainer,
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

  const _EstadoChip({
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: estado
            ? Colors.green.withValues(alpha: 0.10)
            : Colors.grey.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        estado
            ? 'Activa'
            : 'Inactiva',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: estado
              ? Colors.green.shade700
              : Colors.grey.shade700,
        ),
      ),
    );
  }
}