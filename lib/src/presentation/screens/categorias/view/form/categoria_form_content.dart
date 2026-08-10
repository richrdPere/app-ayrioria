import 'package:flutter/material.dart';

// Models
import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';

// Widgets
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_form/categoria_color_selector.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_form/categoria_icon_option.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_form/categoria_icon_selector.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_form/categoria_text_form_field.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_form/categoria_tipo_selector.dart';

// ==========================================================
// VALUE DEL FORMULARIO
// ==========================================================
class CategoriaFormValue {
  final String nombre;
  final String tipo;
  final String naturaleza;
  final String? descripcion;
  final String? color;
  final String? icono;

  const CategoriaFormValue({
    required this.nombre,
    required this.tipo,
    required this.naturaleza,
    this.descripcion,
    this.color,
    this.icono,
  });
}

// ==========================================================
// CONTENT
// ==========================================================
class CategoriaFormContent extends StatefulWidget {
  final CategoriaData? categoria;

  final bool isEditing;
  final bool isSaving;

  final ValueChanged<CategoriaFormValue> onSubmit;

  const CategoriaFormContent({
    super.key,
    required this.categoria,
    required this.isEditing,
    required this.isSaving,
    required this.onSubmit,
  });

  @override
  State<CategoriaFormContent> createState() => _CategoriaFormContentState();
}

class _CategoriaFormContentState extends State<CategoriaFormContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _colorController;

  String _tipoSeleccionado = 'EGRESO';
  String _naturalezaSeleccionada = 'OTRO';
  String _iconoSeleccionado = 'category';

  // ==========================================================
  // ICONOS
  // ==========================================================
  static const List<CategoriaIconOption> _iconos = [
    CategoriaIconOption(
      value: 'category',
      label: 'General',
      icon: Icons.category_outlined,
    ),
    CategoriaIconOption(
      value: 'shopping_bag',
      label: 'Compras',
      icon: Icons.shopping_bag_outlined,
    ),
    CategoriaIconOption(
      value: 'account_balance',
      label: 'Finanzas',
      icon: Icons.account_balance_outlined,
    ),
    CategoriaIconOption(
      value: 'account_balance_wallet',
      label: 'Billetera',
      icon: Icons.account_balance_wallet_outlined,
    ),
    CategoriaIconOption(
      value: 'business',
      label: 'Empresa',
      icon: Icons.business_outlined,
    ),
    CategoriaIconOption(
      value: 'admin_panel_settings',
      label: 'Administración',
      icon: Icons.admin_panel_settings_outlined,
    ),
    CategoriaIconOption(value: 'wifi', label: 'Internet', icon: Icons.wifi),
    CategoriaIconOption(
      value: 'home',
      label: 'Hogar',
      icon: Icons.home_outlined,
    ),
    CategoriaIconOption(
      value: 'food',
      label: 'Alimentos',
      icon: Icons.restaurant_outlined,
    ),
    CategoriaIconOption(
      value: 'money',
      label: 'Dinero',
      icon: Icons.attach_money,
    ),
    CategoriaIconOption(
      value: 'car',
      label: 'Transporte',
      icon: Icons.directions_car_outlined,
    ),
    CategoriaIconOption(
      value: 'lightbulb',
      label: 'Servicios',
      icon: Icons.lightbulb_outline,
    ),
  ];

  // ==========================================================
  // COLORES
  // ==========================================================
  static const List<String> _colores = [
    '#2196F3',
    '#4CAF50',
    '#F44336',
    '#FF9800',
    '#9C27B0',
    '#00BCD4',
    '#795548',
    '#607D8B',
    '#22C55E',
    '#EF4444',
    '#3B82F6',
    '#F97316',
    '#64748B',
    '#78716C',
  ];

  // ==========================================================
  // INIT
  // ==========================================================
  @override
  void initState() {
    super.initState();

    _initializeForm();
  }

  void _initializeForm() {
    final CategoriaData? categoria = widget.categoria;

    _nombreController = TextEditingController(text: categoria?.nombre ?? '');

    _descripcionController = TextEditingController(
      text: categoria?.descripcion ?? '',
    );

    _colorController = TextEditingController(
      text: categoria?.color ?? '#2196F3',
    );

    _tipoSeleccionado = categoria?.tipo.trim().toUpperCase() ?? 'EGRESO';

    _naturalezaSeleccionada =
        categoria?.naturaleza.trim().toUpperCase() ?? 'OTRO';

    _iconoSeleccionado = categoria?.icono?.trim().isNotEmpty == true
        ? categoria!.icono!
        : 'category';

    // Verificar icono válido.
    final bool iconExists = _iconos.any(
      (item) => item.value == _iconoSeleccionado,
    );

    if (!iconExists) {
      _iconoSeleccionado = 'category';
    }

    // Asegurar coherencia tipo/naturaleza.
    _normalizeNaturaleza();
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================
  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _colorController.dispose();

    super.dispose();
  }

  // ==========================================================
  // CAMBIO DE TIPO
  // ==========================================================
  void _onTipoChanged(String value) {
    setState(() {
      _tipoSeleccionado = value.trim().toUpperCase();

      _normalizeNaturaleza();
    });
  }

  // ==========================================================
  // NORMALIZAR NATURALEZA
  // ==========================================================
  void _normalizeNaturaleza() {
    if (_tipoSeleccionado == 'INGRESO' && _naturalezaSeleccionada == 'COMPRA') {
      _naturalezaSeleccionada = 'OTRO';
    }

    if (_tipoSeleccionado == 'EGRESO' && _naturalezaSeleccionada == 'VENTA') {
      _naturalezaSeleccionada = 'OTRO';
    }
  }

  // ==========================================================
  // NATURALEZAS DISPONIBLES
  // ==========================================================
  List<String> get _naturalezasDisponibles {
    if (_tipoSeleccionado == 'INGRESO') {
      return const ['VENTA', 'OTRO'];
    }

    return const ['COMPRA', 'OTRO'];
  }

  // ==========================================================
  // COLOR
  // ==========================================================
  void _onColorChanged(String value) {
    setState(() {
      _colorController.text = value;
    });
  }

  // ==========================================================
  // ICONO
  // ==========================================================
  void _onIconChanged(String value) {
    setState(() {
      _iconoSeleccionado = value;
    });
  }

  // ==========================================================
  // SUBMIT
  // ==========================================================
  void _submit() {
    if (widget.isSaving) {
      return;
    }

    FocusScope.of(context).unfocus();

    final bool valid = _formKey.currentState?.validate() ?? false;

    if (!valid) {
      return;
    }

    final String descripcion = _descripcionController.text.trim();

    final String color = _colorController.text.trim();

    widget.onSubmit(
      CategoriaFormValue(
        nombre: _nombreController.text.trim(),
        tipo: _tipoSeleccionado,
        naturaleza: _naturalezaSeleccionada,
        descripcion: descripcion.isEmpty ? null : descripcion,
        color: color.isEmpty ? null : color,
        icono: _iconoSeleccionado,
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    final Color selectedColor = CategoriaColorSelector.parseHexColor(
      _colorController.text,
    );

    return SafeArea(
      top: false,
      child: Column(
        children: [
          // ====================================================
          // FORMULARIO
          // ====================================================
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==========================================
                    // INTRO
                    // ==========================================
                    _buildIntro(context, selectedColor),

                    const SizedBox(height: 24),

                    // ==========================================
                    // INFORMACIÓN PRINCIPAL
                    // ==========================================
                    _FormSection(
                      title: 'Información principal',
                      icon: Icons.description_outlined,
                      child: Column(
                        children: [
                          CategoriaTextFormField(
                            controller: _nombreController,
                            enabled: !widget.isSaving,
                            label: 'Nombre',
                            hint: 'Ejemplo: Ventas',
                            icon: Icons.label_outline,
                            textCapitalization: TextCapitalization.words,
                            validator: _validateNombre,
                          ),

                          const SizedBox(height: 18),

                          CategoriaTextFormField(
                            controller: _descripcionController,
                            enabled: !widget.isSaving,
                            label: 'Descripción',
                            hint: 'Describe el propósito de la categoría',
                            icon: Icons.description_outlined,
                            minLines: 3,
                            maxLines: 5,
                            textCapitalization: TextCapitalization.sentences,
                            validator: _validateDescripcion,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ==========================================
                    // CLASIFICACIÓN CONTABLE
                    // ==========================================
                    _FormSection(
                      title: 'Clasificación contable',
                      icon: Icons.account_tree_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CategoriaTipoSelector(
                            selectedValue: _tipoSeleccionado,
                            enabled: !widget.isSaving,
                            onChanged: _onTipoChanged,
                          ),

                          const SizedBox(height: 18),

                          _buildNaturalezaSelector(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ==========================================
                    // APARIENCIA
                    // ==========================================
                    _FormSection(
                      title: 'Apariencia',
                      icon: Icons.palette_outlined,
                      child: Column(
                        children: [
                          CategoriaColorSelector(
                            controller: _colorController,
                            colors: _colores,
                            enabled: !widget.isSaving,
                            onChanged: _onColorChanged,
                          ),

                          const SizedBox(height: 22),

                          CategoriaIconSelector(
                            options: _iconos,
                            selectedValue: _iconoSeleccionado,
                            selectedColor: selectedColor,
                            enabled: !widget.isSaving,
                            onChanged: _onIconChanged,
                          ),
                        ],
                      ),
                    ),

                    // Espacio para la barra inferior.
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ),

          // ====================================================
          // ACCIONES
          // ====================================================
          _buildBottomActions(),
        ],
      ),
    );
  }

  // ==========================================================
  // INTRO
  // ==========================================================
  Widget _buildIntro(BuildContext context, Color selectedColor) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: selectedColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(_getSelectedIcon(), color: selectedColor),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isEditing
                        ? 'Actualiza la categoría'
                        : 'Crea una nueva categoría',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    widget.isEditing
                        ? 'Modifica su clasificación, descripción y apariencia.'
                        : 'Define cómo clasificarás tus ingresos o egresos.',
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // NATURALEZA
  // ==========================================================
  Widget _buildNaturalezaSelector() {
    return DropdownButtonFormField<String>(
      value: _naturalezaSeleccionada,
      decoration: InputDecoration(
        labelText: 'Naturaleza',
        prefixIcon: const Icon(Icons.account_balance_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      items: _naturalezasDisponibles.map((naturaleza) {
        return DropdownMenuItem<String>(
          value: naturaleza,
          child: Text(_naturalezaLabel(naturaleza)),
        );
      }).toList(),
      onChanged: widget.isSaving
          ? null
          : (value) {
              if (value == null) {
                return;
              }

              setState(() {
                _naturalezaSeleccionada = value;
              });
            },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Seleccione la naturaleza.';
        }

        return null;
      },
    );
  }

  // ==========================================================
  // ACCIONES INFERIORES
  // ==========================================================
  Widget _buildBottomActions() {
    return Material(
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: widget.isSaving ? null : _submit,
              icon: widget.isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      widget.isEditing
                          ? Icons.save_outlined
                          : Icons.add_outlined,
                    ),
              label: Text(
                widget.isSaving
                    ? 'Guardando...'
                    : widget.isEditing
                    ? 'Guardar cambios'
                    : 'Crear categoría',
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // VALIDACIONES
  // ==========================================================
  String? _validateNombre(String? value) {
    final String nombre = value?.trim() ?? '';

    if (nombre.isEmpty) {
      return 'Ingrese el nombre de la categoría.';
    }

    if (nombre.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres.';
    }

    if (nombre.length > 100) {
      return 'El nombre no puede superar los 100 caracteres.';
    }

    return null;
  }

  String? _validateDescripcion(String? value) {
    final String descripcion = value?.trim() ?? '';

    if (descripcion.length > 255) {
      return 'La descripción no puede superar los 255 caracteres.';
    }

    return null;
  }

  // ==========================================================
  // LABEL NATURALEZA
  // ==========================================================
  String _naturalezaLabel(String naturaleza) {
    switch (naturaleza) {
      case 'VENTA':
        return 'Venta';

      case 'COMPRA':
        return 'Compra';

      default:
        return 'Otro';
    }
  }

  // ==========================================================
  // ICONO SELECCIONADO
  // ==========================================================
  IconData _getSelectedIcon() {
    return _iconos
        .firstWhere(
          (item) => item.value == _iconoSeleccionado,
          orElse: () => _iconos.first,
        )
        .icon;
  }
}

// ==========================================================
// SECCIÓN DEL FORMULARIO
// ==========================================================
class _FormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _FormSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 21, color: colors.primary),

                const SizedBox(width: 9),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            child,
          ],
        ),
      ),
    );
  }
}
