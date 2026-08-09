import 'dart:math';

import 'package:flutter/material.dart';

class RandomPinInput extends StatefulWidget {
  final TextEditingController controller;

  final int length;

  final String title;

  final String? Function(String?)? validator;

  /// Se ejecuta automáticamente
  /// cuando el usuario completa todos los dígitos.
  final ValueChanged<String>? onCompleted;

  const RandomPinInput({
    super.key,
    required this.controller,
    this.length = 6,
    this.title = 'Contraseña',
    this.validator,
    this.onCompleted,
  });

  @override
  State<RandomPinInput> createState() => _RandomPinInputState();
}

class _RandomPinInputState extends State<RandomPinInput> {
  late List<int> _numbers;

  bool _completed = false;

  @override
  void initState() {
    super.initState();

    _generateRandomNumbers();

    _completed = widget.controller.text.length == widget.length;
  }

  // ============================================================
  // GENERAR NÚMEROS ALEATORIOS
  // ============================================================

  void _generateRandomNumbers() {
    _numbers = List.generate(10, (index) => index);

    _numbers.shuffle(Random.secure());
  }

  // ============================================================
  // AGREGAR NÚMERO
  // ============================================================

  void _addNumber(int number, FormFieldState<String> field) {
    if (widget.controller.text.length >= widget.length) {
      return;
    }

    final newValue = '${widget.controller.text}$number';

    setState(() {
      widget.controller.text = newValue;
    });

    field.didChange(newValue);

    // ==========================================================
    // PIN COMPLETADO
    // ==========================================================

    if (newValue.length == widget.length && !_completed) {
      _completed = true;

      // Esperamos al siguiente frame para
      // evitar cerrar el dialog/bottomSheet
      // mientras Flutter todavía está reconstruyendo.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        widget.onCompleted?.call(newValue);
      });
    }
  }

  // ============================================================
  // ELIMINAR ÚLTIMO NÚMERO
  // ============================================================

  void _removeNumber(FormFieldState<String> field) {
    if (widget.controller.text.isEmpty) {
      return;
    }

    final newValue = widget.controller.text.substring(
      0,
      widget.controller.text.length - 1,
    );

    setState(() {
      widget.controller.text = newValue;

      _completed = false;
    });

    field.didChange(newValue);
  }

  // ============================================================
  // LIMPIAR
  // ============================================================

  void _clearPin(FormFieldState<String> field) {
    setState(() {
      widget.controller.clear();

      _completed = false;

      _generateRandomNumbers();
    });

    field.didChange('');
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<String>(
      initialValue: widget.controller.text,

      validator: (_) {
        final value = widget.controller.text;

        if (widget.validator != null) {
          return widget.validator!(value);
        }

        if (value.isEmpty) {
          return 'La contraseña es obligatoria.';
        }

        if (value.length != widget.length) {
          return 'La contraseña debe tener ${widget.length} dígitos.';
        }

        if (!RegExp(r'^\d+$').hasMatch(value)) {
          return 'La contraseña solo puede contener números.';
        }

        return null;
      },

      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==================================================
            // INDICADORES
            // ==================================================
            Center(
              child: Wrap(
                spacing: 12,

                children: List.generate(widget.length, (index) {
                  final filled = index < widget.controller.text.length;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),

                    width: 18,

                    height: 18,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: filled
                          ? theme.colorScheme.primary
                          : Colors.transparent,

                      border: Border.all(
                        color: filled
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,

                        width: 2,
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            // ==================================================
            // TECLADO ALEATORIO
            // ==================================================
            LayoutBuilder(
              builder: (context, constraints) {
                const spacing = 12.0;

                final itemWidth = (constraints.maxWidth - spacing * 2) / 3;

                // Primeros 9 números
                final firstNine = _numbers.take(9).toList();

                // Último número para colocarlo
                // al centro de la última fila
                final lastNumber = _numbers.length > 9 ? _numbers[9] : null;

                return Column(
                  children: [
                    // ============================================
                    // PRIMEROS 9 NÚMEROS
                    // ============================================
                    Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        ...firstNine.map((number) {
                          return SizedBox(
                            width: itemWidth,
                            height: 55,
                            child: OutlinedButton(
                              onPressed: () {
                                _addNumber(number, field);
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                number.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),

                    const SizedBox(height: spacing),

                    // ============================================
                    // ÚLTIMA FILA
                    // LIMPIAR | NÚMERO | BORRAR
                    // ============================================
                    Row(
                      children: [
                        // ========================================
                        // LIMPIAR - IZQUIERDA
                        // ========================================
                        SizedBox(
                          width: itemWidth,
                          height: 55,
                          child: TextButton(
                            onPressed: widget.controller.text.isEmpty
                                ? null
                                : () {
                                    _clearPin(field);
                                  },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text('Limpiar'),
                          ),
                        ),

                        const SizedBox(width: spacing),

                        // ========================================
                        // ÚLTIMO NÚMERO - CENTRO
                        // ========================================
                        SizedBox(
                          width: itemWidth,
                          height: 55,
                          child: lastNumber != null
                              ? OutlinedButton(
                                  onPressed: () {
                                    _addNumber(lastNumber, field);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Text(
                                    lastNumber.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        const SizedBox(width: spacing),

                        // ========================================
                        // BORRAR - DERECHA
                        // ========================================
                        SizedBox(
                          width: itemWidth,
                          height: 55,
                          child: OutlinedButton(
                            onPressed: widget.controller.text.isEmpty
                                ? null
                                : () {
                                    _removeNumber(field);
                                  },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Icon(Icons.backspace_outlined),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

            // ==================================================
            // ERROR
            // ==================================================
            if (field.hasError) ...[
              const SizedBox(height: 10),

              Text(
                field.errorText!,

                style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
              ),
            ],
          ],
        );
      },
    );
  }
}
