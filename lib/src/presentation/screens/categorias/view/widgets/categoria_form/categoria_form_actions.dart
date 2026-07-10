import 'package:flutter/material.dart';

class CategoriaFormActions extends StatelessWidget {
  final bool isEditing;
  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const CategoriaFormActions({
    super.key,
    required this.isEditing,
    required this.isSubmitting,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final buttonText = isEditing ? 'Actualizar' : 'Crear categoría';

    return Container(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isSubmitting ? null : onCancel,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Cancelar'),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: FilledButton.icon(
              onPressed: isSubmitting ? null : onSubmit,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: isSubmitting
                  ? const SizedBox(
                      width: 19,
                      height: 19,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(isEditing ? Icons.save_outlined : Icons.add_rounded),
              label: Text(isSubmitting ? 'Procesando...' : buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
