import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/categoria_form_dialog.dart';
import 'package:flutter/material.dart';

class CategoriaCard extends StatelessWidget {
  final CategoriaData categoria;

  /// Callback que se ejecutará cuando el usuario confirme la eliminación.
  final VoidCallback? onDelete;

  /// Callback opcional para editar.
  /// Si no se envía, se abrirá CategoriaFormDialog.
  final VoidCallback? onEdit;

  const CategoriaCard({
    super.key,
    required this.categoria,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(categoria.color);
    final isIngreso = categoria.tipo.toUpperCase() == 'INGRESO';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(_getIcon(categoria.icono), color: color),
          ),

          const SizedBox(width: 14),

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
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isIngreso
                      ? Colors.green.withOpacity(0.12)
                      : Colors.red.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  categoria.tipo,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isIngreso ? Colors.green : Colors.red,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Editar categoría',
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    onPressed: () {
                      if (onEdit != null) {
                        onEdit!();
                        return;
                      }

                      CategoriaFormDialog.show(context, categoria: categoria);
                    },
                    icon: Icon(Icons.edit_outlined, size: 21, color: color),
                  ),

                  IconButton(
                    tooltip: 'Eliminar categoría',
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    onPressed: onDelete == null
                        ? null
                        : () => _confirmDelete(context),
                    icon: Icon(
                      Icons.delete_outline,
                      size: 21,
                      color: onDelete == null
                          ? Colors.grey.shade400
                          : Colors.red.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Eliminar categoría',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          content: Text(
            '¿Estás seguro de eliminar la categoría '
            '"${categoria.nombre}"?\n\n'
            'Esta acción no se puede deshacer.',
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.delete_outline, size: 19),
              label: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      onDelete?.call();
    }
  }

  Color _parseColor(String? hexColor) {
    if (hexColor == null || hexColor.trim().isEmpty) {
      return Colors.blue;
    }

    try {
      var cleanColor = hexColor.trim().replaceAll('#', '');

      if (cleanColor.length == 6) {
        cleanColor = 'FF$cleanColor';
      }

      if (cleanColor.length != 8) {
        return Colors.blue;
      }

      return Color(int.parse(cleanColor, radix: 16));
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
        return Icons.shopping_bag_outlined;

      case 'light':
      case 'lightbulb':
      case 'electricity':
        return Icons.lightbulb_outline;

      default:
        return Icons.category_outlined;
    }
  }
}
