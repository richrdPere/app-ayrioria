import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_event.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_state.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/view/form/movimiento_form_page.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_event.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_state.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_module_header.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovimientoFormContent extends StatefulWidget {
  final int idEmpresa;
  final int idPeriodo;
  final MovimientoData? movimiento;

  final bool isEditing;
  final bool isSubmitting;

  final ValueChanged<MovimientoFormValue> onSubmit;

  const MovimientoFormContent({
    super.key,
    required this.idEmpresa,
    required this.idPeriodo,
    required this.movimiento,
    required this.isEditing,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  State<MovimientoFormContent> createState() => _MovimientoFormContentState();
}

class _MovimientoFormContentState extends State<MovimientoFormContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _descripcionController;
  late final TextEditingController _montoController;
  late final TextEditingController _observacionController;
  late final TextEditingController _comprobanteController;
  late final TextEditingController _fechaController;

  int? _idCategoriaSeleccionada;
  int? _idSubcategoriaSeleccionada;
  int? _idCuentaSeleccionada;

  String _tipo = 'INGRESO';
  String _estado = 'PAGADO';

  DateTime _fechaMovimiento = DateTime.now();
  @override
  void initState() {
    super.initState();

    final MovimientoData? movimiento = widget.movimiento;
    _idCategoriaSeleccionada = movimiento?.idCategoria;
    _idSubcategoriaSeleccionada = movimiento?.idSubcategoria;
    _idCuentaSeleccionada = movimiento?.idCuenta;
    _descripcionController = TextEditingController(
      text: movimiento?.descripcion ?? '',
    );
    _montoController = TextEditingController(
      text: movimiento != null ? movimiento.monto.toStringAsFixed(2) : '',
    );
    _observacionController = TextEditingController(
      text: movimiento?.observacion ?? '',
    );
    _comprobanteController = TextEditingController(
      text: movimiento?.comprobante ?? '',
    );
    _tipo = movimiento?.tipo.toUpperCase() ?? 'INGRESO';
    _estado = movimiento?.estado.toUpperCase() ?? 'PAGADO';

    if (movimiento != null) {
      _fechaMovimiento = DateTime.tryParse(movimiento.fecha) ?? DateTime.now();
    }

    _fechaController = TextEditingController(
      text: _formatDate(_fechaMovimiento),
    );

    Future.microtask(() {
      _loadCategorias();

      if (_idCategoriaSeleccionada != null) {
        _loadSubcategorias(_idCategoriaSeleccionada!);
      }
    });
  }

  // ==========================================================
  // CARGAR CATEGORÍAS
  // ==========================================================
  void _loadCategorias() {
    if (!mounted) {
      return;
    }

    context.read<CategoriaBloc>().add(
      GetCategoriasEvent(idEmpresa: widget.idEmpresa, page: 1, limit: 100),
    );
  }

  // ==========================================================
  // CARGAR SUBCATEGORÍAS DE UNA CATEGORÍA
  // ==========================================================
  void _loadSubcategorias(int idCategoria) {
    if (!mounted) {
      return;
    }

    context.read<SubcategoriaBloc>().add(
      GetSubcategoriasByCategoriaEvent(
        idEmpresa: widget.idEmpresa,
        idCategoria: idCategoria,
      ),
    );
  }

  // ==========================================================
  // CAMBIAR TIPO
  // ==========================================================
  void _onTipoChanged(String tipo) {
    if (_tipo == tipo) {
      return;
    }

    setState(() {
      _tipo = tipo;

      _idCategoriaSeleccionada = null;
      _idSubcategoriaSeleccionada = null;
    });

    context.read<SubcategoriaBloc>().add(
      const ClearSubcategoriaAuxiliaryListsEvent(),
    );
  }

  // ==========================================================
  // CAMBIAR CATEGORÍA
  // ==========================================================
  void _onCategoriaChanged(int? idCategoria) {
    setState(() {
      _idCategoriaSeleccionada = idCategoria;
      _idSubcategoriaSeleccionada = null;
    });

    context.read<SubcategoriaBloc>().add(
      const ClearSubcategoriaAuxiliaryListsEvent(),
    );

    if (idCategoria != null) {
      _loadSubcategorias(idCategoria);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _fechaMovimiento,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    setState(() {
      _fechaMovimiento = selectedDate;
      _fechaController.text = _formatDate(selectedDate);
    });
  }

  String _formatDate(DateTime value) {
    final String year = value.year.toString().padLeft(4, '0');
    final String month = value.month.toString().padLeft(2, '0');
    final String day = value.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final int? idCategoria = _idCategoriaSeleccionada;

    final int? idSubcategoria = _idSubcategoriaSeleccionada;

    if (idCategoria == null || idSubcategoria == null) {
      return;
    }

    final double? monto = double.tryParse(
      _montoController.text.trim().replaceAll(',', '.'),
    );

    if (monto == null || monto <= 0) {
      _showMessage('Ingresa un monto válido mayor a cero.');
      return;
    }

    final usuario = context.read<SessionBloc>().state.user?.data.usuario;

    if (usuario == null) {
      _showMessage('No se pudo obtener el usuario de la sesión.');
      return;
    }

    final observacion = _observacionController.text.trim();

    final comprobante = _comprobanteController.text.trim();

    widget.onSubmit(
      MovimientoFormValue(
        idCategoria: idCategoria,
        idSubcategoria: idSubcategoria,
        idCuenta: _idCuentaSeleccionada,
        idUsuario: usuario.idUsuario,
        tipo: _tipo,
        fecha: _formatDate(_fechaMovimiento),
        descripcion: _descripcionController.text.trim(),
        monto: monto,
        observacion: observacion.isEmpty ? null : observacion,
        comprobante: comprobante.isEmpty ? null : comprobante,
        estado: _estado,
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _montoController.dispose();
    _observacionController.dispose();
    _comprobanteController.dispose();
    _fechaController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            // ==================================================
            // CABECERA
            // ==================================================
            AppModuleHeader(
              icon: widget.isEditing
                  ? Icons.edit_note_outlined
                  : Icons.receipt_long_outlined,
              title: widget.isEditing
                  ? 'Actualiza el movimiento'
                  : 'Registra una operación',
              description: widget.isEditing
                  ? 'Modifica la información necesaria del movimiento.'
                  : 'Registra un ingreso o egreso dentro del período contable activo.',
              margin: EdgeInsets.zero,
            ),

            const SizedBox(height: 22),

            // ==================================================
            // PERÍODO
            // ==================================================
            // _buildPeriodoInformation(),

            //   const SizedBox(height: 22),

            // ==================================================
            // TIPO
            // ==================================================
            _buildTipoSelector(),

            const SizedBox(height: 18),

            // ==================================================
            // CATEGORÍA
            // ==================================================
            _buildCategoriaField(),

            const SizedBox(height: 18),

            // ==================================================
            // SUBCATEGORÍA
            // ==================================================
            _buildSubcategoriaField(),

            const SizedBox(height: 18),

            // ==================================================
            // FECHA
            // ==================================================
            _buildFechaField(),

            const SizedBox(height: 18),

            // ==================================================
            // DESCRIPCIÓN
            // ==================================================
            _buildDescripcionField(),

            const SizedBox(height: 18),

            // ==================================================
            // MONTO
            // ==================================================
            _buildMontoField(),

            const SizedBox(height: 18),

            // ==================================================
            // ESTADO
            // ==================================================
            _buildEstadoField(),

            const SizedBox(height: 26),

            // ==================================================
            // ADICIONAL
            // ==================================================
            _buildOptionalInformation(),

            const SizedBox(height: 30),

            // ==================================================
            // GUARDAR
            // ==================================================
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTipoSelector() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de movimiento',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment<String>(
                value: 'INGRESO',
                icon: Icon(Icons.south_west_rounded),
                label: Text('Ingreso'),
              ),
              ButtonSegment<String>(
                value: 'EGRESO',
                icon: Icon(Icons.north_east_rounded),
                label: Text('Egreso'),
              ),
            ],
            selected: {_tipo},
            onSelectionChanged: widget.isSubmitting
                ? null
                : (selected) {
                    _onTipoChanged(selected.first);
                  },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriaField() {
    return BlocBuilder<CategoriaBloc, CategoriaState>(
      builder: (context, state) {
        final categoriasFiltradas = state.categorias.where((categoria) {
          return categoria.tipo.trim().toUpperCase() == _tipo;
        }).toList();

        final bool seleccionExiste =
            _idCategoriaSeleccionada != null &&
            categoriasFiltradas.any(
              (categoria) => categoria.idCategoria == _idCategoriaSeleccionada,
            );

        final int? selectedValue = seleccionExiste
            ? _idCategoriaSeleccionada
            : null;

        return DropdownButtonFormField<int>(
          initialValue: selectedValue,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Categoría',
            hintText: categoriasFiltradas.isEmpty
                ? 'No hay categorías para $_tipo'
                : 'Selecciona una categoría',
            prefixIcon: const Icon(Icons.category_outlined),
            suffixIcon: categoriasFiltradas.isEmpty
                ? IconButton(
                    tooltip: 'Actualizar',
                    onPressed: widget.isSubmitting ? null : _loadCategorias,
                    icon: const Icon(Icons.refresh),
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          items: categoriasFiltradas.map((categoria) {
            return DropdownMenuItem<int>(
              value: categoria.idCategoria,
              child: Text(categoria.nombre, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: widget.isSubmitting || categoriasFiltradas.isEmpty
              ? null
              : _onCategoriaChanged,
          validator: (_) {
            if (categoriasFiltradas.isEmpty) {
              return 'No existen categorías disponibles para $_tipo.';
            }

            if (_idCategoriaSeleccionada == null) {
              return 'Selecciona una categoría.';
            }

            return null;
          },
        );
      },
    );
  }

  Widget _buildSubcategoriaField() {
    return BlocBuilder<SubcategoriaBloc, SubcategoriaState>(
      buildWhen: (previous, current) {
        return previous.byCategoriaResponse != current.byCategoriaResponse;
      },
      builder: (context, state) {
        final response = state.byCategoriaResponse;

        // ======================================================
        // SIN CATEGORÍA
        // ======================================================
        if (_idCategoriaSeleccionada == null) {
          return DropdownButtonFormField<int>(
            items: const [],
            onChanged: null,
            decoration: InputDecoration(
              labelText: 'Subcategoría',
              hintText: 'Selecciona primero una categoría',
              prefixIcon: const Icon(Icons.account_tree_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          );
        }

        // ======================================================
        // LOADING
        // ======================================================
        if (response is Loading) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: 'Subcategoría',
              prefixIcon: const Icon(Icons.account_tree_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Cargando subcategorías...'),
              ],
            ),
          );
        }

        // ======================================================
        // OBTENER LISTA
        // ======================================================
        List<SubcategoriaData> subcategorias = const [];

        if (response is Success<ApiResponse<List<SubcategoriaData>>>) {
          final rawList = response.data.data;

          if (rawList != null) {
            subcategorias = rawList
                .whereType<SubcategoriaData>()
                .where((item) => item.estado)
                .toList();
          }
        }

        // ======================================================
        // ERROR
        // ======================================================
        if (response is ErrorData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<int>(
                items: const [],
                onChanged: null,
                decoration: InputDecoration(
                  labelText: 'Subcategoría',
                  hintText: 'No se pudieron cargar las subcategorías',
                  prefixIcon: const Icon(Icons.account_tree_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              TextButton.icon(
                onPressed: widget.isSubmitting
                    ? null
                    : () {
                        final id = _idCategoriaSeleccionada;

                        if (id != null) {
                          _loadSubcategorias(id);
                        }
                      },
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          );
        }

        final bool seleccionExiste =
            _idSubcategoriaSeleccionada != null &&
            subcategorias.any(
              (item) => item.idSubcategoria == _idSubcategoriaSeleccionada,
            );

        final int? selectedValue = seleccionExiste
            ? _idSubcategoriaSeleccionada
            : null;

        return DropdownButtonFormField<int>(
          initialValue: selectedValue,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Subcategoría',
            hintText: subcategorias.isEmpty
                ? 'No existen subcategorías'
                : 'Selecciona una subcategoría',
            prefixIcon: const Icon(Icons.account_tree_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          items: subcategorias.map((subcategoria) {
            return DropdownMenuItem<int>(
              value: subcategoria.idSubcategoria,
              child: Text(subcategoria.nombre, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: widget.isSubmitting || subcategorias.isEmpty
              ? null
              : (value) {
                  setState(() {
                    _idSubcategoriaSeleccionada = value;
                  });
                },
          validator: (_) {
            if (_idCategoriaSeleccionada == null) {
              return 'Selecciona primero una categoría.';
            }

            if (subcategorias.isEmpty) {
              return 'La categoría no tiene subcategorías disponibles.';
            }

            if (_idSubcategoriaSeleccionada == null) {
              return 'Selecciona una subcategoría.';
            }

            return null;
          },
        );
      },
    );
  }

  Widget _buildDescripcionField() {
    return TextFormField(
      controller: _descripcionController,
      enabled: !widget.isSubmitting,
      textCapitalization: TextCapitalization.sentences,
      // minLines: 2,
      // maxLines: 3,
      maxLength: 255,
      decoration: InputDecoration(
        labelText: 'Descripción',
        hintText: 'Ejemplo: Cobro de factura al cliente',
        prefixIcon: const Icon(Icons.description_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator: (value) {
        final text = value?.trim() ?? '';

        if (text.isEmpty) {
          return 'Ingresa una descripción.';
        }

        if (text.length < 2) {
          return 'La descripción debe tener al menos 2 caracteres.';
        }

        return null;
      },
    );
  }

  Widget _buildMontoField() {
    return TextFormField(
      controller: _montoController,
      enabled: !widget.isSubmitting,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d{0,2}')),
      ],
      decoration: InputDecoration(
        labelText: 'Monto',
        hintText: '0.00',
        prefixText: 'S/ ',
        prefixIcon: const Icon(Icons.payments_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator: (value) {
        final text = value?.trim().replaceAll(',', '.') ?? '';

        if (text.isEmpty) {
          return 'Ingresa el monto.';
        }

        final amount = double.tryParse(text);

        if (amount == null || amount <= 0) {
          return 'Ingresa un monto válido mayor a cero.';
        }

        return null;
      },
    );
  }

  Widget _buildEstadoField() {
    return DropdownButtonFormField<String>(
      initialValue: _estado,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Estado',
        prefixIcon: const Icon(Icons.fact_check_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      items: const [
        DropdownMenuItem<String>(
          value: 'PAGADO',
          child: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
              SizedBox(width: 10),
              Text('Pagado'),
            ],
          ),
        ),
        DropdownMenuItem<String>(
          value: 'PENDIENTE',
          child: Row(
            children: [
              Icon(Icons.schedule_outlined, color: Colors.orange, size: 20),
              SizedBox(width: 10),
              Text('Pendiente'),
            ],
          ),
        ),
        DropdownMenuItem<String>(
          value: 'ANULADO',
          child: Row(
            children: [
              Icon(Icons.cancel_outlined, color: Colors.red, size: 20),
              SizedBox(width: 10),
              Text('Anulado'),
            ],
          ),
        ),
      ],
      onChanged: widget.isSubmitting
          ? null
          : (value) {
              if (value == null) {
                return;
              }

              setState(() {
                _estado = value;
              });
            },
    );
  }

  Widget _buildFechaField() {
    return TextFormField(
      controller: _fechaController,
      readOnly: true,
      enabled: !widget.isSubmitting,
      onTap: widget.isSubmitting ? null : _selectDate,
      decoration: InputDecoration(
        labelText: 'Fecha',
        hintText: 'Selecciona una fecha',
        prefixIcon: const Icon(Icons.event_outlined),
        suffixIcon: const Icon(Icons.calendar_today_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Selecciona la fecha del movimiento.';
        }

        return null;
      },
    );
  }

  Widget _buildOptionalInformation() {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        leading: const Icon(Icons.more_horiz),
        title: const Text('Información adicional'),
        subtitle: const Text('Comprobante y observaciones'),
        childrenPadding: const EdgeInsets.fromLTRB(16, 4, 16, 18),
        children: [
          TextFormField(
            controller: _comprobanteController,
            enabled: !widget.isSubmitting,
            decoration: InputDecoration(
              labelText: 'Comprobante',
              hintText: 'Ejemplo: F001-000123',
              prefixIcon: const Icon(Icons.receipt_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: _observacionController,
            enabled: !widget.isSubmitting,
            textCapitalization: TextCapitalization.sentences,
            minLines: 3,
            maxLines: 5,
            maxLength: 500,
            decoration: InputDecoration(
              labelText: 'Observación',
              hintText: 'Información adicional opcional',
              alignLabelWithHint: true,
              prefixIcon: const Icon(Icons.notes_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 52,
      child: FilledButton.icon(
        onPressed: widget.isSubmitting ? null : _submit,
        icon: widget.isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                widget.isEditing
                    ? Icons.save_outlined
                    : Icons.add_circle_outline,
              ),
        label: Text(
          widget.isSubmitting
              ? 'Guardando...'
              : widget.isEditing
              ? 'Actualizar movimiento'
              : 'Registrar movimiento',
        ),
      ),
    );
  }

  // Widget _buildPeriodoInformation() {
  //   final theme = Theme.of(context);

  //   final colors = theme.colorScheme;

  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: colors.primaryContainer.withValues(alpha: 0.45),
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 42,
  //           height: 42,
  //           decoration: BoxDecoration(
  //             color: colors.primary.withValues(alpha: 0.10),
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Icon(Icons.calendar_month_outlined, color: colors.primary),
  //         ),

  //         const SizedBox(width: 12),

  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Período contable activo',
  //                 style: theme.textTheme.labelMedium?.copyWith(
  //                   color: colors.onSurfaceVariant,
  //                 ),
  //               ),

  //               const SizedBox(height: 2),

  //               Text(
  //                 'Período #${widget.idPeriodo}',
  //                 style: theme.textTheme.titleSmall?.copyWith(
  //                   fontWeight: FontWeight.w700,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
