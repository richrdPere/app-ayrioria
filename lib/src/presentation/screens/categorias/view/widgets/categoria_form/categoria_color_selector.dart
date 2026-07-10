import 'package:flutter/material.dart';

import 'categoria_text_form_field.dart';

class CategoriaColorSelector extends StatelessWidget {
  final TextEditingController controller;
  final List<String> colors;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const CategoriaColorSelector({
    super.key,
    required this.controller,
    required this.colors,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final selectedHex = controller.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Color', style: TextStyle(fontWeight: FontWeight.w600)),

        const SizedBox(height: 10),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colors.map((colorHex) {
            final selected =
                selectedHex.toUpperCase() == colorHex.toUpperCase();

            final color = parseHexColor(colorHex);

            return InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: enabled ? () => onChanged(colorHex) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 42,
                height: 42,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? color : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: selected
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 12),

        CategoriaTextFormField(
          controller: controller,
          enabled: enabled,
          label: 'Código hexadecimal',
          hint: '#2196F3',
          icon: Icons.palette_outlined,
          onChanged: onChanged,
          validator: validateHexColor,
        ),
      ],
    );
  }

  static String? validateHexColor(String? value) {
    final color = value?.trim() ?? '';

    if (color.isEmpty) {
      return 'Seleccione o ingrese un color.';
    }

    final regex = RegExp(r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$');

    if (!regex.hasMatch(color)) {
      return 'Ingrese un color hexadecimal válido.';
    }

    return null;
  }

  static Color parseHexColor(String? value) {
    try {
      var hex = value?.trim().replaceAll('#', '') ?? '';

      if (hex.length == 6) {
        hex = 'FF$hex';
      }

      if (hex.length != 8) {
        return Colors.blue;
      }

      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return Colors.blue;
    }
  }
}
