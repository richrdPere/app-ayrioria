import 'package:flutter/material.dart';

import 'random_pin_input.dart';

class PinSelectorField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final int length;
  final IconData icon;

  const PinSelectorField({
    super.key,
    required this.controller,
    this.placeholder = 'Contraseña',
    this.length = 6,
    this.icon = Icons.lock_outline,
  });

  @override
  State<PinSelectorField> createState() => _PinSelectorFieldState();
}

class _PinSelectorFieldState extends State<PinSelectorField> {
  // ============================================================
  // ABRIR BOTTOM SHEET PARA CREAR CONTRASEÑA
  // ============================================================

  Future<void> _openPinBottomSheet(FormFieldState<String> field) async {
    final tempController = TextEditingController();
    FocusManager.instance.primaryFocus?.unfocus();

    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Align(
          alignment: Alignment.bottomCenter,

          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),

            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 18,
                bottom:
                    MediaQuery.of(bottomSheetContext).viewInsets.bottom + 24,
              ),

              decoration: const BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  // ============================================
                  // INDICADOR SUPERIOR
                  // ============================================
                  Container(
                    width: 42,
                    height: 4,

                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,

                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ============================================
                  // HEADER
                  // ============================================
                  // Row(
                  //   children: [
                  //     Container(
                  //       width: 42,
                  //       height: 42,

                  //       decoration: BoxDecoration(
                  //         color: Theme.of(
                  //           context,
                  //         ).colorScheme.primary.withOpacity(0.10),

                  //         shape: BoxShape.circle,
                  //       ),

                  //       child: Icon(
                  //         Icons.lock_outline,

                  //         color: Theme.of(context).colorScheme.primary,
                  //       ),
                  //     ),

                  //     const SizedBox(width: 12),

                  //     Expanded(
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,

                  //         children: [
                  //           Text(
                  //             'Crear contraseña',

                  //             style: Theme.of(context).textTheme.titleLarge
                  //                 ?.copyWith(fontWeight: FontWeight.bold),
                  //           ),

                  //           const SizedBox(height: 2),

                  //           Text(
                  //             'Selecciona ${widget.length} números',

                  //             style: TextStyle(
                  //               fontSize: 13,
                  //               color: Colors.grey.shade600,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),

                  //     IconButton(
                  //       tooltip: 'Cerrar',

                  //       onPressed: () {
                  //         Navigator.of(bottomSheetContext).pop();
                  //       },

                  //       icon: const Icon(Icons.close),
                  //     ),
                  //   ],
                  // ),

                  // ============================================
                  // RANDOM PIN
                  // ============================================
                  RandomPinInput(
                    controller: tempController,

                    length: widget.length,

                    title: 'Contraseña',

                    // ==========================================
                    // AL COMPLETAR 6 DÍGITOS:
                    // 1. Devuelve el PIN
                    // 2. Cierra el BottomSheet
                    // ==========================================
                    onCompleted: (pin) {
                      Navigator.of(bottomSheetContext).pop(pin);
                    },
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );

    // ==========================================================
    // RESULTADO DEL BOTTOM SHEET
    // ==========================================================
    if (!mounted) {
      tempController.dispose();
      return;
    }

    if (result != null) {
      setState(() {
        widget.controller.text = result;
      });

      // Actualizar FormField
      field.didChange(result);

      // Volver a validar.
      field.validate();
    }

    FocusManager.instance.primaryFocus?.unfocus();
    tempController.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

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
            // ==================================================
            // CAMPO CONTRASEÑA
            // ==================================================
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
                        // ========================================
                        // ICONO IZQUIERDO
                        // ========================================
                        SizedBox(
                          width: 40,

                          child: Icon(widget.icon, color: Colors.grey.shade700),
                        ),

                        // ========================================
                        // TEXTO
                        // ========================================
                        Expanded(
                          child: Text(
                            hasPassword
                                ? List.generate(
                                    widget.length,
                                    (_) => '●',
                                  ).join(' ')
                                : widget.placeholder,

                            style: TextStyle(
                              fontSize: 16,

                              color: hasPassword
                                  ? Colors.black87
                                  : Colors.grey.shade600,

                              fontWeight: hasPassword
                                  ? FontWeight.w500
                                  : FontWeight.normal,

                              letterSpacing: hasPassword ? 2 : 0,
                            ),
                          ),
                        ),

                        // ========================================
                        // ICONO DERECHO
                        // ========================================
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

            // ==================================================
            // ERROR VALIDACIÓN
            // ==================================================
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
