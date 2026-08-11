import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;

  final ValueChanged<String>? onChanged;

  const CustomInput({
    super.key,
    required this.icon,
    required this.placeholder,
    required this.textController,
    required this.keyboardType,
    required this.isPassword,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),

        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),

      child: TextFormField(
        controller: textController,

        autocorrect: false,
        keyboardType: keyboardType,
        obscureText: isPassword,
        onChanged: onChanged,

        style: theme.textTheme.bodyLarge?.copyWith(color: colors.onSurface),

        cursorColor: colors.primary,

        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Campo requerido';
          }

          return null;
        },

        textAlignVertical: TextAlignVertical.center,

        decoration: InputDecoration(
          hintText: placeholder,

          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
          ),

          prefixIcon: Icon(icon, color: colors.primary),

          prefixIconConstraints: const BoxConstraints(
            minWidth: 52,
            minHeight: 52,
          ),

          border: InputBorder.none,
          // enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,

          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,

          isDense: true,

          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 12,
          ),

          errorStyle: theme.textTheme.bodySmall?.copyWith(color: colors.error),
        ),
      ),
    );
  }
}
