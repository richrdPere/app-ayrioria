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
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (bottomSheetContext) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 500),

          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 20,
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 24,
          ),

          decoration: const BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // TITULO
              // ==================================================
              // Row(
              //   children: [
              //     Icon(
              //       Icons.lock_outline,
              //       color: Theme.of(context).colorScheme.primary,
              //     ),

              //     const SizedBox(width: 10),

              //     Expanded(
              //       child: Text(
              //         'Ingresa tu contraseña',

              //         style: Theme.of(context).textTheme.titleLarge?.copyWith(
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),

              //     IconButton(
              //       onPressed: () {
              //         Navigator.of(bottomSheetContext).pop();
              //       },

              //       icon: const Icon(Icons.close),
              //     ),
              //   ],
              // ),

              // const SizedBox(height: 8),

              // Align(
              //   alignment: Alignment.centerLeft,

              //   child: Text(
              //     'Selecciona los ${widget.length} dígitos de tu contraseña.',

              //     style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              //   ),
              // ),

              // const SizedBox(height: 20),

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

              const SizedBox(height: 50),

              // ==================================================
              // BOTON CONFIRMAR
              // ==================================================
              // SizedBox(
              //   width: double.infinity,

              //   child: FilledButton(
              //     onPressed: () {
              //       if (tempController.text.length != widget.length) {
              //         ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
              //           SnackBar(
              //             content: Text(
              //               'La contraseña debe tener ${widget.length} dígitos.',
              //             ),
              //           ),
              //         );

              //         return;
              //       }

              //       Navigator.of(bottomSheetContext).pop(tempController.text);
              //     },

              //     style: FilledButton.styleFrom(
              //       minimumSize: const Size.fromHeight(52),

              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(26),
              //       ),
              //     ),

              //     child: const Text('Continuar'),
              //   ),
              // ),
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
              margin: EdgeInsets.only(bottom: field.hasError ? 5 : 20),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(30),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),

                    offset: const Offset(0, 5),

                    blurRadius: 5,
                  ),
                ],
              ),

              child: Material(
                color: Colors.transparent,

                child: InkWell(
                  onTap: () => _openPinBottomSheet(field),

                  borderRadius: BorderRadius.circular(30),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),

                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,

                          child: Icon(widget.icon, color: Colors.grey.shade700),
                        ),

                        Expanded(
                          child: Text(
                            hasPassword ? '● ● ● ● ● ●' : widget.placeholder,

                            style: TextStyle(
                              fontSize: 16,

                              color: hasPassword
                                  ? Colors.black87
                                  : Colors.grey.shade600,

                              letterSpacing: hasPassword ? 2 : 0,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 12),

                          child: Icon(
                            hasPassword
                                ? Icons.check_circle_outline
                                : Icons.keyboard_arrow_up,

                            color: hasPassword
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (field.hasError) ...[
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 15),

                child: Text(
                  field.errorText!,

                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,

                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
