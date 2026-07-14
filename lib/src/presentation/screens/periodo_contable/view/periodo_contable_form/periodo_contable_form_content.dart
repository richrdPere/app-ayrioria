import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PeriodoContableFormValue {
  final String nombre;
  final int anio;
  final int mes;
  final String fechaInicio;
  final String fechaFin;
  final double saldoInicial;
  final String? observacion;

  const PeriodoContableFormValue({
    required this.nombre,
    required this.anio,
    required this.mes,
    required this.fechaInicio,
    required this.fechaFin,
    required this.saldoInicial,
    this.observacion,
  });
}

class PeriodoContableFormContent extends StatefulWidget {
  final PeriodoContableData? periodo;
  final bool isEditing;
  final bool isSaving;
  final ValueChanged<PeriodoContableFormValue> onSubmit;

  const PeriodoContableFormContent({
    super.key,
    this.periodo,
    required this.isEditing,
    required this.isSaving,
    required this.onSubmit,
  });

  @override
  State<PeriodoContableFormContent> createState() =>
      _PeriodoContableFormContentState();
}

class _PeriodoContableFormContentState
    extends State<PeriodoContableFormContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();

  final TextEditingController _anioController = TextEditingController();

  final TextEditingController _saldoInicialController = TextEditingController();

  final TextEditingController _observacionController = TextEditingController();

  int? _mesSeleccionado;
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  bool _formInitialized = false;

  static const List<String> _meses = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  @override
  void initState() {
    super.initState();

    _initializeForm();
  }

  @override
  void didUpdateWidget(covariant PeriodoContableFormContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_formInitialized && widget.periodo != null) {
      _initializeForm();
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _anioController.dispose();
    _saldoInicialController.dispose();
    _observacionController.dispose();

    super.dispose();
  }

  // ==========================================================
  // INICIALIZAR FORMULARIO
  // ==========================================================
  void _initializeForm() {
    final PeriodoContableData? periodo = widget.periodo;

    if (widget.isEditing && periodo == null) {
      return;
    }

    if (periodo != null) {
      _nombreController.text = periodo.nombre;
      _anioController.text = periodo.anio.toString();
      _mesSeleccionado = periodo.mes;

      _fechaInicio = _parseDate(periodo.fechaInicio.toString());

      _fechaFin = _parseDate(periodo.fechaFin.toString());

      _saldoInicialController.text = periodo.saldoInicial.toStringAsFixed(2);

      _observacionController.text = periodo.observacion ?? '';
    } else {
      final DateTime now = DateTime.now();

      _anioController.text = now.year.toString();
      _mesSeleccionado = now.month;

      _fechaInicio = DateTime(now.year, now.month, 1);

      _fechaFin = DateTime(now.year, now.month + 1, 0);

      _saldoInicialController.text = '0.00';

      _nombreController.text = '${_meses[now.month - 1]} ${now.year}';
    }

    _formInitialized = true;
  }

  DateTime? _parseDate(String value) {
    if (value.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  // ==========================================================
  // CAMBIAR MES
  // ==========================================================
  void _onMonthChanged(int? month) {
    if (month == null) {
      return;
    }

    final int year =
        int.tryParse(_anioController.text.trim()) ?? DateTime.now().year;

    setState(() {
      _mesSeleccionado = month;

      _fechaInicio = DateTime(year, month, 1);

      _fechaFin = DateTime(year, month + 1, 0);
    });

    _updateSuggestedName();
  }

  void _onYearChanged(String value) {
    final int? year = int.tryParse(value);
    final int? month = _mesSeleccionado;

    if (year == null || month == null) {
      return;
    }

    setState(() {
      _fechaInicio = DateTime(year, month, 1);

      _fechaFin = DateTime(year, month + 1, 0);
    });

    _updateSuggestedName();
  }

  void _updateSuggestedName() {
    if (widget.isEditing) {
      return;
    }

    final int? month = _mesSeleccionado;
    final int? year = int.tryParse(_anioController.text.trim());

    if (month == null || year == null) {
      return;
    }

    _nombreController.text = '${_meses[month - 1]} $year';
  }

  // ==========================================================
  // SELECCIONAR FECHAS
  // ==========================================================
  Future<void> _selectFechaInicio() async {
    final DateTime initialDate = _fechaInicio ?? DateTime.now();

    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Seleccionar fecha de inicio',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _fechaInicio = selected;

      if (_fechaFin != null && _fechaFin!.isBefore(selected)) {
        _fechaFin = selected;
      }
    });
  }

  Future<void> _selectFechaFin() async {
    final DateTime initialDate = _fechaFin ?? _fechaInicio ?? DateTime.now();

    final DateTime firstDate = _fechaInicio ?? DateTime(2000);

    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
      helpText: 'Seleccionar fecha de fin',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _fechaFin = selected;
    });
  }

  // ==========================================================
  // ENVIAR FORMULARIO
  // ==========================================================
  void _submit() {
    FocusScope.of(context).unfocus();

    final bool valid = _formKey.currentState?.validate() ?? false;

    if (!valid) {
      return;
    }

    if (_mesSeleccionado == null) {
      _showMessage('Selecciona el mes del período.');

      return;
    }

    if (_fechaInicio == null || _fechaFin == null) {
      _showMessage('Selecciona las fechas del período.');

      return;
    }

    if (_fechaFin!.isBefore(_fechaInicio!)) {
      _showMessage('La fecha final no puede ser anterior a la fecha inicial.');

      return;
    }

    final String saldoText = _saldoInicialController.text.trim().replaceAll(
      ',',
      '.',
    );

    final double? saldoInicial = double.tryParse(saldoText);

    if (saldoInicial == null) {
      _showMessage('Ingresa un saldo inicial válido.');

      return;
    }

    final String observacion = _observacionController.text.trim();

    widget.onSubmit(
      PeriodoContableFormValue(
        nombre: _nombreController.text.trim(),
        anio: int.parse(_anioController.text.trim()),
        mes: _mesSeleccionado!,
        fechaInicio: _formatApiDate(_fechaInicio!),
        fechaFin: _formatApiDate(_fechaFin!),
        saldoInicial: saldoInicial,
        observacion: observacion.isEmpty ? null : observacion,
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

  String _formatApiDate(DateTime date) {
    final String month = date.month.toString().padLeft(2, '0');

    final String day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  String _formatDisplayDate(DateTime? date) {
    if (date == null) {
      return 'Seleccionar fecha';
    }

    final String day = date.day.toString().padLeft(2, '0');

    final String month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),

            _buildSectionTitle(
              title: 'Información general',
              icon: Icons.description_outlined,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _nombreController,
              enabled: !widget.isSaving,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nombre del período',
                hintText: 'Ejemplo: Julio 2026',
                prefixIcon: Icon(Icons.badge_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final String text = value?.trim() ?? '';

                if (text.isEmpty) {
                  return 'Ingresa el nombre del período.';
                }

                if (text.length < 3) {
                  return 'El nombre debe tener al menos 3 caracteres.';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _anioController,
                    enabled: !widget.isSaving,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    onChanged: _onYearChanged,
                    decoration: const InputDecoration(
                      labelText: 'Año',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final int? year = int.tryParse(value?.trim() ?? '');

                      if (year == null) {
                        return 'Año requerido.';
                      }

                      if (year < 2000 || year > 2100) {
                        return 'Año inválido.';
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _mesSeleccionado,
                    decoration: const InputDecoration(
                      labelText: 'Mes',
                      prefixIcon: Icon(Icons.date_range_outlined),
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(12, (index) {
                      final int month = index + 1;

                      return DropdownMenuItem<int>(
                        value: month,
                        child: Text(
                          _meses[index],
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }),
                    onChanged: widget.isSaving ? null : _onMonthChanged,
                    validator: (value) {
                      if (value == null) {
                        return 'Mes requerido.';
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildSectionTitle(
              title: 'Rango de fechas',
              icon: Icons.event_note_outlined,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _DateField(
                    label: 'Fecha de inicio',
                    value: _formatDisplayDate(_fechaInicio),
                    icon: Icons.event_outlined,
                    enabled: !widget.isSaving,
                    onTap: _selectFechaInicio,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateField(
                    label: 'Fecha de fin',
                    value: _formatDisplayDate(_fechaFin),
                    icon: Icons.event_available_outlined,
                    enabled: !widget.isSaving,
                    onTap: _selectFechaFin,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _buildSectionTitle(
              title: 'Información financiera',
              icon: Icons.account_balance_wallet_outlined,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _saldoInicialController,
              enabled: !widget.isSaving,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                labelText: 'Saldo inicial',
                hintText: '0.00',
                prefixText: 'S/ ',
                prefixIcon: Icon(Icons.payments_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final String text = value?.trim().replaceAll(',', '.') ?? '';

                if (text.isEmpty) {
                  return 'Ingresa el saldo inicial.';
                }

                final double? amount = double.tryParse(text);

                if (amount == null) {
                  return 'Ingresa un monto válido.';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _observacionController,
              enabled: !widget.isSaving,
              minLines: 3,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Observación',
                hintText: 'Información adicional del período...',
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 55),
                  child: Icon(Icons.notes_outlined),
                ),
                border: OutlineInputBorder(),
              ),
              maxLength: 500,
            ),

            const SizedBox(height: 26),

            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: widget.isSaving ? null : _submit,
                icon: widget.isSaving
                    ? const SizedBox(
                        width: 21,
                        height: 21,
                        child: CircularProgressIndicator(strokeWidth: 2.4),
                      )
                    : Icon(widget.isEditing ? Icons.save_outlined : Icons.add),
                label: Text(
                  widget.isSaving
                      ? 'Guardando...'
                      : widget.isEditing
                      ? 'Actualizar período'
                      : 'Crear período',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              widget.isEditing
                  ? Icons.edit_calendar_outlined
                  : Icons.add_task_outlined,
              color: colors.onPrimary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEditing
                      ? 'Actualizar período'
                      : 'Crear período contable',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.isEditing
                      ? 'Modifica la información del período seleccionado.'
                      : 'Define el mes, las fechas y el saldo inicial.',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.value,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          suffixIcon: const Icon(Icons.arrow_drop_down),
          enabled: enabled,
          border: const OutlineInputBorder(),
        ),
        child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
