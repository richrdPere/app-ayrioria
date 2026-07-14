import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_request.dart';

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

  late final TextEditingController _categoriaController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _montoController;
  late final TextEditingController _observacionController;
  late final TextEditingController _fechaController;

  String _tipo = 'INGRESO';
  DateTime _fechaMovimiento = DateTime.now();

  @override
  void initState() {
    super.initState();

    final MovimientoData? movimiento = widget.movimiento;

    _categoriaController = TextEditingController(
      text: movimiento?.idCategoria.toString() ?? '',
    );

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

    // _fechaMovimiento = movimiento?.fecha ?? DateTime.now();

    _fechaController = TextEditingController(
      text: _formatDate(_fechaMovimiento),
    );
  }

  @override
  void dispose() {
    _categoriaController.dispose();
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

    if (selectedDate == null) {
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

    final int? idCategoria = int.tryParse(_categoriaController.text.trim());

    final double? monto = double.tryParse(
      _montoController.text.trim().replaceAll(',', '.'),
    );

    if (idCategoria == null || monto == null) {
      return;
    }

    final session = context.read<SessionBloc>().state;

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
      idUsuario: session.user!.data.usuario.idUsuario,
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
        SegmentedButton<String>(
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
                  setState(() {
                    _tipo = selected.first;
                  });
                },
        ),
      ],
    );
  }

  Widget _buildCategoriaField() {
    return TextFormField(
      controller: _categoriaController,
      enabled: !widget.isSubmitting,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        labelText: 'Categoría',
        hintText: 'ID de la categoría',
        prefixIcon: Icon(Icons.category_outlined),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        final String text = value?.trim() ?? '';

        if (text.isEmpty) {
          return 'Selecciona una categoría.';
        }

        if (int.tryParse(text) == null) {
          return 'La categoría no es válida.';
        }

        return null;
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
      onTap: _selectDate,
      decoration: const InputDecoration(
        labelText: 'Fecha del movimiento',
        prefixIcon: Icon(Icons.event_outlined),
        suffixIcon: Icon(Icons.calendar_today_outlined),
        border: OutlineInputBorder(),
      ),
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
