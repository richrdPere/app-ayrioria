import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_aryoria/src/config/core/session/session_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_request.dart';

// Bloc
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_event.dart';

// Widgets
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_form/categoria_color_selector.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_form/categoria_form_actions.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_form/categoria_form_header.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_form/categoria_icon_option.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_form/categoria_icon_selector.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_form/categoria_text_form_field.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_form/categoria_tipo_selector.dart';

class CategoriaFormDialog extends StatefulWidget {
  final CategoriaData? categoria;

  const CategoriaFormDialog({super.key, this.categoria});

  bool get isEditing => categoria != null;

  static Future<void> show(BuildContext context, {CategoriaData? categoria}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<CategoriaBloc>()),
            BlocProvider.value(value: context.read<SessionBloc>()),
          ],
          child: CategoriaFormDialog(categoria: categoria),
        );
      },
    );
  }

  @override
  State<CategoriaFormDialog> createState() {
    return _CategoriaFormDialogState();
  }
}

class _CategoriaFormDialogState extends State<CategoriaFormDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController nombreCtrl;
  late final TextEditingController descripcionCtrl;
  late final TextEditingController colorCtrl;

  String tipoSeleccionado = 'EGRESO';
  String iconoSeleccionado = 'category';

  bool isSubmitting = false;

  static const List<CategoriaIconOption> iconos = [
    CategoriaIconOption(
      value: 'category',
      label: 'General',
      icon: Icons.category_outlined,
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
      value: 'shopping',
      label: 'Compras',
      icon: Icons.shopping_bag_outlined,
    ),
    CategoriaIconOption(
      value: 'lightbulb',
      label: 'Servicios',
      icon: Icons.lightbulb_outline,
    ),
  ];

  static const List<String> colores = [
    '#2196F3',
    '#4CAF50',
    '#F44336',
    '#FF9800',
    '#9C27B0',
    '#00BCD4',
    '#795548',
    '#607D8B',
  ];

  @override
  void initState() {
    super.initState();

    final categoria = widget.categoria;

    nombreCtrl = TextEditingController(text: categoria?.nombre ?? '');

    descripcionCtrl = TextEditingController(text: categoria?.descripcion ?? '');

    colorCtrl = TextEditingController(text: categoria?.color ?? '#2196F3');

    tipoSeleccionado = categoria?.tipo.toUpperCase() ?? 'EGRESO';

    iconoSeleccionado = categoria?.icono ?? 'category';

    final existeIcono = iconos.any((item) => item.value == iconoSeleccionado);

    if (!existeIcono) {
      iconoSeleccionado = 'category';
    }
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    descripcionCtrl.dispose();
    colorCtrl.dispose();
    super.dispose();
  }

  void _changeTipo(String value) {
    setState(() {
      tipoSeleccionado = value;
    });
  }

  void _changeColor(String value) {
    setState(() {
      colorCtrl.text = value;
    });
  }

  void _changeIcon(String value) {
    setState(() {
      iconoSeleccionado = value;
    });
  }

  void _close() {
    if (isSubmitting) return;

    Navigator.of(context).pop();
  }

  void _submit() {
    if (isSubmitting) return;

    FocusScope.of(context).unfocus();

    final valid = formKey.currentState?.validate() ?? false;

    if (!valid) return;

    final idEmpresa = context
        .read<SessionBloc>()
        .state
        .empresaActiva
        ?.idEmpresa;

    if (idEmpresa == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No existe una empresa activa seleccionada.'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    final descripcion = descripcionCtrl.text.trim();

    final request = CategoriaRequest(
      idEmpresa: idEmpresa,
      nombre: nombreCtrl.text.trim(),
      tipo: tipoSeleccionado,
      descripcion: descripcion.isEmpty ? null : descripcion,
      color: colorCtrl.text.trim(),
      icono: iconoSeleccionado,
    );

    setState(() {
      isSubmitting = true;
    });

    final categoriaBloc = context.read<CategoriaBloc>();

    if (widget.isEditing) {
      categoriaBloc.add(
        UpdateCategoriaEvent(
          idCategoria: widget.categoria!.idCategoria,
          request: request,
        ),
      );
    } else {
      categoriaBloc.add(CreateCategoriaEvent(request: request));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isEditing ? 'Actualizar categoría' : 'Nueva categoría';

    final selectedColor = CategoriaColorSelector.parseHexColor(colorCtrl.text);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 720),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CategoriaFormHeader(
              title: title,
              color: selectedColor,
              icon: _getSelectedIcon(),
              onClose: _close,
            ),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 10),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategoriaTextFormField(
                        controller: nombreCtrl,
                        enabled: !isSubmitting,
                        label: 'Nombre',
                        hint: 'Ejemplo: Luz',
                        icon: Icons.label_outline,
                        textCapitalization: TextCapitalization.characters,
                        validator: _validateNombre,
                      ),

                      const SizedBox(height: 18),

                      CategoriaTipoSelector(
                        selectedValue: tipoSeleccionado,
                        enabled: !isSubmitting,
                        onChanged: _changeTipo,
                      ),

                      const SizedBox(height: 18),

                      CategoriaTextFormField(
                        controller: descripcionCtrl,
                        enabled: !isSubmitting,
                        label: 'Descripción',
                        hint: 'Descripción opcional de la categoría',
                        icon: Icons.description_outlined,
                        minLines: 3,
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                        validator: _validateDescripcion,
                      ),

                      const SizedBox(height: 18),

                      CategoriaColorSelector(
                        controller: colorCtrl,
                        colors: colores,
                        enabled: !isSubmitting,
                        onChanged: _changeColor,
                      ),

                      const SizedBox(height: 18),

                      CategoriaIconSelector(
                        options: iconos,
                        selectedValue: iconoSeleccionado,
                        selectedColor: selectedColor,
                        enabled: !isSubmitting,
                        onChanged: _changeIcon,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            CategoriaFormActions(
              isEditing: widget.isEditing,
              isSubmitting: isSubmitting,
              onCancel: _close,
              onSubmit: _submit,
            ),
          ],
        ),
      ),
    );
  }

  String? _validateNombre(String? value) {
    final nombre = value?.trim() ?? '';

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
    final descripcion = value?.trim() ?? '';

    if (descripcion.length > 255) {
      return 'La descripción no puede superar los 255 caracteres.';
    }

    return null;
  }

  IconData _getSelectedIcon() {
    return iconos
        .firstWhere(
          (item) => item.value == iconoSeleccionado,
          orElse: () => iconos.first,
        )
        .icon;
  }
}
