import 'package:flutter/material.dart';

import 'random_pin_input.dart';

class LoginPinSelectorField extends StatefulWidget {
  final TextEditingController controller;
  final int length;
  final IconData icon;
  final String placeholder;
  final ValueChanged<String>? onChanged;

  const LoginPinSelectorField({
    super.key,
    required this.controller,
    this.length = 6,
    this.icon = Icons.lock_outline,
    this.placeholder = 'Contraseña',
    this.onChanged,
  });

  @override
  State<LoginPinSelectorField> createState() => _LoginPinSelectorFieldState();
}

class _LoginPinSelectorFieldState extends State<LoginPinSelectorField> {
  Future<void> _openPinBottomSheet(FormFieldState<String> field) async {
    final tempController = TextEditingController(text: widget.controller.text);

    FocusManager.instance.primaryFocus?.unfocus();

    final result = await showModalBottomSheet<String>(
      context: context,

      isScrollControlled: true,
      useSafeArea: true,

      backgroundColor: Colors.transparent,

      builder: (bottomSheetContext) {
        final theme = Theme.of(bottomSheetContext);
        final colors = theme.colorScheme;

        return Container(
          constraints: const BoxConstraints(maxWidth: 500),

          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 24,
          ),

          decoration: BoxDecoration(
            color: colors.surface,

            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),

            border: Border(
              top: BorderSide(
                color: colors.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ==================================================
              // INDICADOR SUPERIOR
              // ==================================================
              Container(
                width: 42,
                height: 4,

                decoration: BoxDecoration(
                  color: colors.outlineVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // TECLADO RANDOM
              // ==================================================
              RandomPinInput(
                controller: tempController,
                length: widget.length,
                title: 'Contraseña',

                onCompleted: (pin) {
                  Navigator.of(bottomSheetContext).pop(pin);
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );

    if (!mounted) {
      tempController.dispose();
      return;
    }

    if (result != null) {
      setState(() {
        widget.controller.text = result;
      });

      field.didChange(result);

      widget.onChanged?.call(result);

      field.validate();
    }

    FocusManager.instance.primaryFocus?.unfocus();

    tempController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return FormField<String>(
      initialValue: widget.controller.text,

      validator: (_) {
        final value = widget.controller.text.trim();

        if (value.isEmpty) {
          return 'Campo requerido';
        }

        if (value.length != widget.length) {
          return 'La contraseña debe tener ${widget.length} dígitos';
        }

        if (!RegExp(r'^\d+$').hasMatch(value)) {
          return 'La contraseña solo puede contener números';
        }

        return null;
      },

      builder: (field) {
        final hasPassword = widget.controller.text.length == widget.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: field.hasError ? 5 : 18),

              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,

                borderRadius: BorderRadius.circular(18),

                border: Border.all(
                  color: field.hasError
                      ? colors.error
                      : colors.outlineVariant.withValues(alpha: 0.6),
                ),

                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: 0.05),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),

              child: Material(
                color: Colors.transparent,

                child: InkWell(
                  onTap: () {
                    _openPinBottomSheet(field);
                  },

                  borderRadius: BorderRadius.circular(18),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),

                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,

                          child: Icon(widget.icon, color: colors.primary),
                        ),

                        const SizedBox(width: 2),

                        Expanded(
                          child: Text(
                            hasPassword
                                ? List.generate(
                                    widget.length,
                                    (_) => '●',
                                  ).join(' ')
                                : widget.placeholder,

                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: hasPassword
                                  ? colors.onSurface
                                  : colors.onSurfaceVariant,

                              fontWeight: hasPassword
                                  ? FontWeight.w500
                                  : FontWeight.w400,

                              letterSpacing: hasPassword ? 2 : 0,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Icon(
                          hasPassword
                              ? Icons.check_circle_outline
                              : Icons.keyboard_arrow_up_rounded,

                          color: hasPassword
                              ? colors.primary
                              : colors.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 18, bottom: 15),

                child: Text(
                  field.errorText!,

                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.error,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
