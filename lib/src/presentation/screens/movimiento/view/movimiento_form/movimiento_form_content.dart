import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_request.dart';

import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_event.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovimientoFormContent extends StatefulWidget {
  final int idEmpresa;
  final int idPeriodo;
  final MovimientoData? movimiento;
  final bool isEditing;
  final bool isSubmitting;
  final ValueChanged<MovimientoRequest> onSubmit;

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
  late final TextEditingController _fechaController;

  int? _idCategoriaSeleccionada;

  String _tipo = 'INGRESO';
  DateTime _fechaMovimiento = DateTime.now();

  @override
  void initState() {
    super.initState();

    final MovimientoData? movimiento = widget.movimiento;

    _idCategoriaSeleccionada = movimiento?.idCategoria;

    _descripcionController = TextEditingController(
      text: movimiento?.descripcion ?? '',
    );

    _montoController = TextEditingController(
      text: movimiento?.monto.toString() ?? '',
    );

    _observacionController = TextEditingController(
      text: movimiento?.observacion ?? '',
    );

    _tipo = movimiento?.tipo.toUpperCase() ?? 'INGRESO';

    _fechaController = TextEditingController(
      text: _formatDate(_fechaMovimiento),
    );

    Future.microtask(_loadCategorias);
  }

  void _loadCategorias() {
    if (!mounted) return;

    context.read<CategoriaBloc>().add(
      GetCategoriasEvent(idEmpresa: widget.idEmpresa, page: 1),
    );
  }

  @override
  void dispose() {
    _descripcionController.dispose();
    _montoController.dispose();
    _observacionController.dispose();
    _fechaController.dispose();

    super.dispose();
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

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final int? idCategoria = _idCategoriaSeleccionada;

    final double? monto = double.tryParse(
      _montoController.text.trim().replaceAll(',', '.'),
    );

    if (idCategoria == null || monto == null) {
      return;
    }

    final session = context.read<SessionBloc>().state;
    final usuario = session.user?.data.usuario;

    if (usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo obtener el usuario de la sesión.'),
        ),
      );

      return;
    }

    final MovimientoRequest request = MovimientoRequest(
      idEmpresa: widget.idEmpresa,
      idPeriodo: widget.idPeriodo,
      idCategoria: idCategoria,
      tipo: _tipo,
      descripcion: _descripcionController.text.trim(),
      monto: monto,
      fecha: _formatDate(_fechaMovimiento),
      observacion: _observacionController.text.trim().isEmpty
          ? null
          : _observacionController.text.trim(),
      idUsuario: usuario.idUsuario,
    );

    widget.onSubmit(request);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: [
            _buildPeriodoInformation(),
            const SizedBox(height: 24),
            _buildTipoSelector(),
            const SizedBox(height: 20),
            _buildCategoriaField(),
            const SizedBox(height: 16),
            _buildDescripcionField(),
            const SizedBox(height: 16),
            _buildMontoField(),
            const SizedBox(height: 16),
            _buildFechaField(),
            const SizedBox(height: 16),
            _buildObservacionField(),
            const SizedBox(height: 28),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodoInformation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_month_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'El movimiento será registrado en el período '
              '#${widget.idPeriodo}.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de movimiento',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<String>(
            segments: const [
              ButtonSegment<String>(
                value: 'INGRESO',
                icon: Icon(Icons.arrow_downward),
                label: Text('Ingreso'),
              ),
              ButtonSegment<String>(
                value: 'EGRESO',
                icon: Icon(Icons.arrow_upward),
                label: Text('Egreso'),
              ),
            ],
            selected: {_tipo},
            onSelectionChanged: widget.isSubmitting
                ? null
                : (Set<String> selected) {
                    final String nuevoTipo = selected.first;

                    if (nuevoTipo == _tipo) {
                      return;
                    }

                    setState(() {
                      _tipo = nuevoTipo;

                      // La categoría anterior puede no pertenecer
                      // al nuevo tipo seleccionado.
                      _idCategoriaSeleccionada = null;
                    });
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

        debugPrint("CATEGORIAS: $categoriasFiltradas");

        final bool categoriaSeleccionadaExiste =
            _idCategoriaSeleccionada != null &&
            categoriasFiltradas.any(
              (categoria) => categoria.idCategoria == _idCategoriaSeleccionada,
            );

        final int? valorSeleccionado = categoriaSeleccionadaExiste
            ? _idCategoriaSeleccionada
            : null;

        if (_idCategoriaSeleccionada != null && !categoriaSeleccionadaExiste) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;

            setState(() {
              _idCategoriaSeleccionada = null;
            });
          });
        }

        return DropdownButtonFormField<int>(
          initialValue: valorSeleccionado,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Categoría',
            hintText: categoriasFiltradas.isEmpty
                ? 'No existen categorías de tipo $_tipo'
                : 'Selecciona una categoría',
            prefixIcon: const Icon(Icons.category_outlined),
            suffixIcon: categoriasFiltradas.isEmpty
                ? IconButton(
                    tooltip: 'Recargar categorías',
                    onPressed: widget.isSubmitting ? null : _loadCategorias,
                    icon: const Icon(Icons.refresh),
                  )
                : null,
            border: const OutlineInputBorder(),
          ),
          items: categoriasFiltradas.map((categoria) {
            return DropdownMenuItem<int>(
              value: categoria.idCategoria,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      categoria.nombre,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: widget.isSubmitting || categoriasFiltradas.isEmpty
              ? null
              : (int? value) {
                  setState(() {
                    _idCategoriaSeleccionada = value;
                  });
                },
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

  Widget _buildDescripcionField() {
    return TextFormField(
      controller: _descripcionController,
      enabled: !widget.isSubmitting,
      textCapitalization: TextCapitalization.sentences,
      maxLength: 150,
      decoration: const InputDecoration(
        labelText: 'Descripción',
        hintText: 'Ejemplo: Venta del día',
        prefixIcon: Icon(Icons.description_outlined),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        final String text = value?.trim() ?? '';

        if (text.isEmpty) {
          return 'Ingresa una descripción.';
        }

        if (text.length < 3) {
          return 'La descripción debe tener al menos 3 caracteres.';
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
      decoration: const InputDecoration(
        labelText: 'Monto',
        hintText: '0.00',
        prefixText: 'S/ ',
        prefixIcon: Icon(Icons.payments_outlined),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        final String text = value?.trim() ?? '';

        if (text.isEmpty) {
          return 'Ingresa el monto.';
        }

        final double? monto = double.tryParse(text.replaceAll(',', '.'));

        if (monto == null) {
          return 'Ingresa un monto válido.';
        }

        if (monto <= 0) {
          return 'El monto debe ser mayor que cero.';
        }

        return null;
      },
    );
  }

  Widget _buildFechaField() {
    return TextFormField(
      controller: _fechaController,
      readOnly: true,
      enabled: !widget.isSubmitting,
      onTap: widget.isSubmitting ? null : _selectDate,
      decoration: const InputDecoration(
        labelText: 'Fecha del movimiento',
        prefixIcon: Icon(Icons.event_outlined),
        suffixIcon: Icon(Icons.calendar_today_outlined),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Selecciona la fecha del movimiento.';
        }

        return null;
      },
    );
  }

  Widget _buildObservacionField() {
    return TextFormField(
      controller: _observacionController,
      enabled: !widget.isSubmitting,
      textCapitalization: TextCapitalization.sentences,
      minLines: 3,
      maxLines: 5,
      maxLength: 500,
      decoration: const InputDecoration(
        labelText: 'Observación',
        hintText: 'Información adicional opcional',
        alignLabelWithHint: true,
        prefixIcon: Icon(Icons.notes_outlined),
        border: OutlineInputBorder(),
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
}
