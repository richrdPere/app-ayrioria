import 'package:flutter/material.dart';

import 'categoria_icon_option.dart';

class CategoriaIconSelector extends StatelessWidget {
  final List<CategoriaIconOption> options;
  final String selectedValue;
  final Color selectedColor;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const CategoriaIconSelector({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.selectedColor,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Icono', style: TextStyle(fontWeight: FontWeight.w600)),

        const SizedBox(height: 10),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: options.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final option = options[index];
            final selected = selectedValue == option.value;

            return InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: enabled ? () => onChanged(option.value) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: selected
                      ? selectedColor.withOpacity(0.12)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected ? selectedColor : Colors.grey.shade300,
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      option.icon,
                      color: selected ? selectedColor : Colors.grey.shade700,
                    ),

                    const SizedBox(height: 5),

                    Text(
                      option.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: selected ? selectedColor : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
