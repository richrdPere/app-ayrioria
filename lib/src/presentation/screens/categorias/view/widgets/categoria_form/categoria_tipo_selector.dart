import 'package:flutter/material.dart';

class CategoriaTipoSelector extends StatelessWidget {
  final String selectedValue;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const CategoriaTipoSelector({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    this.enabled = true,
  });

  static const List<String> tipos = ['INGRESO', 'EGRESO'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tipo de categoría',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 10),

        Row(
          children: tipos.map((tipo) {
            final selected = selectedValue == tipo;
            final isIngreso = tipo == 'INGRESO';

            final selectedColor = isIngreso ? Colors.green : Colors.red;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: tipo == tipos.first ? 8 : 0,
                  left: tipo == tipos.last ? 8 : 0,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: enabled ? () => onChanged(tipo) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? selectedColor.withOpacity(0.12)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? selectedColor : Colors.grey.shade300,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          isIngreso
                              ? Icons.arrow_downward_rounded
                              : Icons.arrow_upward_rounded,
                          color: selected ? selectedColor : Colors.grey,
                        ),

                        const SizedBox(height: 6),

                        Text(
                          tipo,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: selected
                                ? selectedColor
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
