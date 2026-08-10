import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_data.dart';

// Categoria
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_state.dart';

// ==========================================================
// VALUE DEL FORMULARIO
// ==========================================================
class SubcategoriaFormValue {
  final int idCategoria;
  final String nombre;
  final String? descripcion;
  final int orden;
  final bool estado;
  final bool? esPredeterminada;

  const SubcategoriaFormValue({
    required this.idCategoria,
    required this.nombre,
    this.descripcion,
    required this.orden,
    required this.estado,
    this.esPredeterminada,
  });
}

// ==========================================================
// CONTENT
// ==========================================================
class SubcategoriaFormContent extends StatefulWidget {
  final SubcategoriaData? subcategoria;

  final bool isEditing;
  final bool isSaving;

  final ValueChanged<SubcategoriaFormValue> onSubmit;

  const SubcategoriaFormContent({
    super.key,
    required this.subcategoria,
    required this.isEditing,
    required this.isSaving,
    required this.onSubmit,
  });

  @override
  State<SubcategoriaFormContent> createState() =>
      _SubcategoriaFormContentState();
}

class _SubcategoriaFormContentState extends State<SubcategoriaFormContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _ordenController;

  int? _idCategoria;

  bool _estado = true;
  bool _esPredeterminada = false;

  // ==========================================================
  // INIT
  // ==========================================================
  @override
  void initState() {
    super.initState();

    _initializeForm();
  }

  void _initializeForm() {
    final SubcategoriaData? subcategoria = widget.subcategoria;

    _nombreController = TextEditingController(text: subcategoria?.nombre ?? '');

    _descripcionController = TextEditingController(
      text: subcategoria?.descripcion ?? '',
    );

    _ordenController = TextEditingController(
      text: subcategoria?.orden.toString() ?? '1',
    );

    _idCategoria = subcategoria?.idCategoria;

    _estado = subcategoria?.estado ?? true;

    _esPredeterminada = subcategoria?.esPredeterminada ?? false;
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================
  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _ordenController.dispose();

    super.dispose();
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

    if (_idCategoria == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Debe seleccionar una categoría.'),
            backgroundColor: Colors.red,
          ),
        );

      return;
    }

    final int? orden = int.tryParse(_ordenController.text.trim());

    if (orden == null) {
      return;
    }

    final String descripcion = _descripcionController.text.trim();

    widget.onSubmit(
      SubcategoriaFormValue(
        idCategoria: _idCategoria!,
        nombre: _nombreController.text.trim(),
        descripcion: descripcion.isEmpty ? null : descripcion,
        orden: orden,
        estado: _estado,
        esPredeterminada: widget.isEditing ? _esPredeterminada : null,
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          // ====================================================
          // FORM
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
                    // HEADER
                    // ==========================================
                    _buildHeader(),

                    const SizedBox(height: 20),

                    // ==========================================
                    // CLASIFICACIÓN
                    // ==========================================
                    _FormSection(
                      title: 'Clasificación',
                      icon: Icons.account_tree_outlined,
                      child: _buildCategoriaField(),
                    ),

                    const SizedBox(height: 18),

                    // ==========================================
                    // INFORMACIÓN PRINCIPAL
                    // ==========================================
                    _FormSection(
                      title: 'Información principal',
                      icon: Icons.description_outlined,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nombreController,
                            enabled: !widget.isSaving,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: _inputDecoration(
                              label: 'Nombre',
                              hint: 'Ej. Ventas al Contado',
                              icon: Icons.label_outline_rounded,
                            ),
                            validator: _validateNombre,
                          ),

                          const SizedBox(height: 18),

                          TextFormField(
                            controller: _descripcionController,
                            enabled: !widget.isSaving,
                            minLines: 3,
                            maxLines: 5,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: _inputDecoration(
                              label: 'Descripción',
                              hint: 'Describe brevemente esta subcategoría',
                              icon: Icons.notes_rounded,
                              alignLabelWithHint: true,
                            ),
                            validator: _validateDescripcion,
                          ),

                          const SizedBox(height: 18),

                          TextFormField(
                            controller: _ordenController,
                            enabled: !widget.isSaving,
                            keyboardType: TextInputType.number,
                            decoration: _inputDecoration(
                              label: 'Orden',
                              hint: 'Ej. 1',
                              icon: Icons.format_list_numbered_rounded,
                            ),
                            validator: _validateOrden,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ==========================================
                    // CONFIGURACIÓN
                    // ==========================================
                    _FormSection(
                      title: 'Configuración',
                      icon: Icons.settings_outlined,
                      child: Column(
                        children: [
                          _buildEstadoCard(),

                          if (widget.isEditing) ...[
                            const SizedBox(height: 14),
                            _buildPredeterminadaCard(),
                          ],
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
          // BOTÓN FIJO INFERIOR
          // ====================================================
          _buildBottomActions(),
        ],
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================
  Widget _buildHeader() {
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
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.account_tree_outlined,
                color: colors.primary,
                size: 27,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isEditing
                        ? 'Actualizar subcategoría'
                        : 'Registrar subcategoría',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    widget.isEditing
                        ? 'Modifica la clasificación y configuración de esta subcategoría.'
                        : 'Crea una clasificación más específica para tus movimientos.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: colors.onSurfaceVariant,
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
  // CATEGORÍA
  // ==========================================================
  Widget _buildCategoriaField() {
    return BlocBuilder<CategoriaBloc, CategoriaState>(
      builder: (context, state) {
        final categorias = state.categorias;

        if (categorias.isEmpty) {
          return _CategoriasEmpty(isSaving: widget.isSaving);
        }

        /*
         * Puede ocurrir que la categoría de la subcategoría
         * editada no esté en la página cargada actualmente.
         *
         * En ese caso evitamos enviar un value que no exista
         * dentro de items del DropdownButton.
         */
        final bool selectedExists =
            _idCategoria == null ||
            categorias.any(
              (categoria) => categoria.idCategoria == _idCategoria,
            );

        final int? currentValue = selectedExists ? _idCategoria : null;

        return DropdownButtonFormField<int>(
          value: currentValue,
          isExpanded: true,
          decoration: _inputDecoration(
            label: 'Categoría',
            hint: 'Seleccione una categoría',
            icon: Icons.category_outlined,
          ),
          items: categorias.map((categoria) {
            return DropdownMenuItem<int>(
              value: categoria.idCategoria,
              child: Row(
                children: [
                  Icon(
                    categoria.tipo.trim().toUpperCase() == 'INGRESO'
                        ? Icons.south_west_rounded
                        : Icons.north_east_rounded,
                    size: 18,
                    color: categoria.tipo.trim().toUpperCase() == 'INGRESO'
                        ? Colors.green
                        : Colors.red,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      categoria.nombre,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    categoria.tipo,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: widget.isSaving
              ? null
              : (value) {
                  setState(() {
                    _idCategoria = value;
                  });
                },
          validator: (value) {
            if (value == null) {
              return 'Debe seleccionar una categoría.';
            }

            return null;
          },
        );
      },
    );
  }

  // ==========================================================
  // ESTADO
  // ==========================================================
  Widget _buildEstadoCard() {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SwitchListTile(
        value: _estado,
        onChanged: widget.isSaving
            ? null
            : (value) {
                setState(() {
                  _estado = value;
                });
              },
        secondary: Icon(
          _estado ? Icons.check_circle_outline : Icons.block_outlined,
          color: _estado ? Colors.green : Colors.red,
        ),
        title: const Text(
          'Estado',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          _estado
              ? 'La subcategoría estará disponible para su uso.'
              : 'La subcategoría no estará disponible para nuevos registros.',
        ),
      ),
    );
  }

  // ==========================================================
  // PREDETERMINADA
  // ==========================================================
  Widget _buildPredeterminadaCard() {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SwitchListTile(
        value: _esPredeterminada,
        onChanged: widget.isSaving
            ? null
            : (value) {
                setState(() {
                  _esPredeterminada = value;
                });
              },
        secondary: Icon(
          _esPredeterminada ? Icons.star_rounded : Icons.star_outline_rounded,
          color: _esPredeterminada ? Colors.amber.shade700 : null,
        ),
        title: const Text(
          'Predeterminada',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          _esPredeterminada
              ? 'Esta subcategoría está configurada como predeterminada.'
              : 'Esta subcategoría no es predeterminada.',
        ),
      ),
    );
  }

  // ==========================================================
  // BOTÓN INFERIOR
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
                    : 'Crear subcategoría',
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
      return 'El nombre es obligatorio.';
    }

    if (nombre.length < 3) {
      return 'El nombre debe tener al menos 3 caracteres.';
    }

    if (nombre.length > 150) {
      return 'El nombre es demasiado largo.';
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

  String? _validateOrden(String? value) {
    final String text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'El orden es obligatorio.';
    }

    final int? orden = int.tryParse(text);

    if (orden == null) {
      return 'Ingrese un número válido.';
    }

    if (orden < 0) {
      return 'El orden debe ser mayor o igual a cero.';
    }

    return null;
  }

  // ==========================================================
  // INPUT DECORATION
  // ==========================================================
  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    bool alignLabelWithHint = false,
  }) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      alignLabelWithHint: alignLabelWithHint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: colors.surfaceContainerLowest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.outlineVariant),
      ),
    );
  }
}

// ==========================================================
// SECCIÓN
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

// ==========================================================
// CATEGORÍAS VACÍAS
// ==========================================================
class _CategoriasEmpty extends StatelessWidget {
  final bool isSaving;

  const _CategoriasEmpty({required this.isSaving});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.error.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.category_outlined, color: colors.error),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              'No existen categorías disponibles. '
              'Primero debes registrar una categoría.',
              style: TextStyle(color: colors.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}
