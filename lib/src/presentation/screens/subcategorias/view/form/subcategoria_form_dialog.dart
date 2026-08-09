import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/create_sub_categoria_req.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/update_sub_categoria_req.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Categoria
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_state.dart';

// Subcategoria
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_event.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_state.dart';

class SubcategoriaFormDialog extends StatefulWidget {
  final int idEmpresa;

  /// Si es null => Crear
  /// Si tiene valor => Editar
  final SubcategoriaData? subcategoria;

  const SubcategoriaFormDialog({
    super.key,
    required this.idEmpresa,
    this.subcategoria,
  });

  @override
  State<SubcategoriaFormDialog> createState() => _SubcategoriaFormDialogState();
}

class _SubcategoriaFormDialogState extends State<SubcategoriaFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _ordenController = TextEditingController();

  int? _idCategoria;
  bool _estado = true;
  bool _esPredeterminada = false;

  bool get isEditing => widget.subcategoria != null;

  @override
  void initState() {
    super.initState();

    final subcategoria = widget.subcategoria;

    if (subcategoria != null) {
      _idCategoria = subcategoria.idCategoria;
      _nombreController.text = subcategoria.nombre;
      _descripcionController.text = subcategoria.descripcion ?? '';
      _ordenController.text = subcategoria.orden.toString();

      _estado = subcategoria.estado;
      _esPredeterminada = subcategoria.esPredeterminada;
    } else {
      _estado = true;
      _esPredeterminada = false;
      _ordenController.text = '1';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _ordenController.dispose();

    super.dispose();
  }

  // ============================================================
  // GUARDAR
  // ============================================================

  void _guardar() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_idCategoria == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe seleccionar una categoría.'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    final orden = int.tryParse(_ordenController.text.trim()) ?? 0;

    // ==========================================================
    // CREAR
    // ==========================================================

    if (!isEditing) {
      final request = CreateSubcategoriaRequest(
        idCategoria: _idCategoria!,
        nombre: _nombreController.text.trim(),
        descripcion: _descripcionController.text.trim().isEmpty
            ? null
            : _descripcionController.text.trim(),
        orden: orden,
        estado: _estado,
      );

      context.read<SubcategoriaBloc>().add(
        CreateSubcategoriaEvent(idEmpresa: widget.idEmpresa, request: request),
      );

      return;
    }

    // ==========================================================
    // ACTUALIZAR
    // ==========================================================

    final request = UpdateSubcategoriaRequest(
      idCategoria: _idCategoria,
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim(),
      esPredeterminada: _esPredeterminada,
      orden: orden,
      estado: _estado,
    );

    context.read<SubcategoriaBloc>().add(
      UpdateSubcategoriaEvent(
        idEmpresa: widget.idEmpresa,
        idSubcategoria: widget.subcategoria!.idSubcategoria,
        request: request,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 8,
        leading: IconButton(
          tooltip: 'Cerrar',
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close_rounded),
        ),
        title: Text(isEditing ? 'Editar subcategoría' : 'Nueva subcategoría'),
        actions: [
          BlocBuilder<SubcategoriaBloc, SubcategoriaState>(
            buildWhen: (previous, current) =>
                previous.actionResponse != current.actionResponse,
            builder: (context, state) {
              final isLoading =
                  state.actionResponse
                      is Loading<ApiResponse<SubcategoriaData>>;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton.icon(
                  onPressed: isLoading ? null : _guardar,
                  icon: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(isLoading ? 'GUARDANDO' : 'GUARDAR'),
                ),
              );
            },
          ),
        ],
      ),

      // ========================================================
      // BODY + LISTENER
      // ========================================================
      body: BlocListener<SubcategoriaBloc, SubcategoriaState>(
        listenWhen: (previous, current) =>
            previous.actionResponse != current.actionResponse,
        listener: (context, state) {
          final response = state.actionResponse;

          // ====================================================
          // SUCCESS
          // ====================================================

          if (response is Success<ApiResponse<SubcategoriaData>>) {
            final apiResponse = response.data;

            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(apiResponse.message),
                backgroundColor: Colors.green,
              ),
            );

            context.read<SubcategoriaBloc>().add(
              const ClearSubcategoriaActionResponseEvent(),
            );

            // true indica que hubo cambios
            Navigator.pop(context, true);

            return;
          }

          // ====================================================
          // ERROR
          // ====================================================

          if (response is ErrorData<ApiResponse<SubcategoriaData>>) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(response.displayMessage),
                backgroundColor: Colors.red,
              ),
            );

            context.read<SubcategoriaBloc>().add(
              const ClearSubcategoriaActionResponseEvent(),
            );
          }
        },

        // ======================================================
        // FORM
        // ======================================================
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),

                  const SizedBox(height: 24),

                  // ============================================
                  // CATEGORÍA
                  // ============================================
                  _buildCategoriaField(),

                  const SizedBox(height: 18),

                  // ============================================
                  // NOMBRE
                  // ============================================
                  TextFormField(
                    controller: _nombreController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _inputDecoration(
                      label: 'Nombre',
                      hint: 'Ej. Ventas al Contado',
                      icon: Icons.label_outline_rounded,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre es obligatorio.';
                      }

                      if (value.trim().length < 3) {
                        return 'El nombre debe tener al menos 3 caracteres.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  // ============================================
                  // DESCRIPCIÓN
                  // ============================================
                  TextFormField(
                    controller: _descripcionController,
                    minLines: 3,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _inputDecoration(
                      label: 'Descripción',
                      hint: 'Describe brevemente esta subcategoría',
                      icon: Icons.notes_rounded,
                      alignLabelWithHint: true,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ============================================
                  // ORDEN
                  // ============================================
                  TextFormField(
                    controller: _ordenController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      label: 'Orden',
                      hint: 'Ej. 1',
                      icon: Icons.format_list_numbered_rounded,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El orden es obligatorio.';
                      }

                      final orden = int.tryParse(value.trim());

                      if (orden == null) {
                        return 'Ingrese un número válido.';
                      }

                      if (orden < 0) {
                        return 'El orden debe ser mayor o igual a cero.';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // ============================================
                  // ESTADO
                  // ============================================
                  _buildEstadoCard(),

                  // ============================================
                  // PREDETERMINADA
                  // Solo edición
                  // ============================================
                  if (isEditing) ...[
                    const SizedBox(height: 14),
                    _buildPredeterminadaCard(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.account_tree_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing
                      ? 'Actualizar subcategoría'
                      : 'Registrar subcategoría',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isEditing
                      ? 'Modifica la información contable de la subcategoría.'
                      : 'Completa los datos para crear una nueva subcategoría.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CATEGORIA
  // ============================================================

  Widget _buildCategoriaField() {
    return BlocBuilder<CategoriaBloc, CategoriaState>(
      builder: (context, state) {
        final categorias = state.categorias;

        return DropdownButtonFormField<int>(
          value: _idCategoria,
          isExpanded: true,
          decoration: _inputDecoration(
            label: 'Categoría',
            hint: 'Seleccione una categoría',
            icon: Icons.category_outlined,
          ),
          items: categorias
              .map(
                (categoria) => DropdownMenuItem<int>(
                  value: categoria.idCategoria,
                  child: Text(
                    categoria.nombre,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
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

  // ============================================================
  // ESTADO
  // ============================================================

  Widget _buildEstadoCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SwitchListTile(
        value: _estado,
        onChanged: (value) {
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
              ? 'La subcategoría se encuentra activa.'
              : 'La subcategoría se encuentra inactiva.',
        ),
      ),
    );
  }

  // ============================================================
  // PREDETERMINADA
  // ============================================================

  Widget _buildPredeterminadaCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SwitchListTile(
        value: _esPredeterminada,
        onChanged: (value) {
          setState(() {
            _esPredeterminada = value;
          });
        },
        secondary: const Icon(Icons.star_outline_rounded),
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

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      alignLabelWithHint: alignLabelWithHint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }
}
