import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_request.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_event.dart';

class EmpresaCreateContent extends StatefulWidget {
  const EmpresaCreateContent({super.key});

  @override
  State<EmpresaCreateContent> createState() => _EmpresaCreateContentState();
}

class _EmpresaCreateContentState extends State<EmpresaCreateContent> {
  final _formKey = GlobalKey<FormState>();

  final razonSocialCtrl = TextEditingController();
  final nombreComercialCtrl = TextEditingController();
  final rucCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final direccionFiscalCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();

  String tipoEmpresa = 'PRIVADA';

  final tiposEmpresa = const [
    'PRIVADA',
    'PUBLICA',
    'ONG',
    'INDEPENDIENTE',
    'OTRA',
  ];

  @override
  void dispose() {
    razonSocialCtrl.dispose();
    nombreComercialCtrl.dispose();
    rucCtrl.dispose();
    emailCtrl.dispose();
    direccionFiscalCtrl.dispose();
    telefonoCtrl.dispose();

    super.dispose();
  }

  // ==========================================================
  // CREAR EMPRESA
  // ==========================================================
  void _crearEmpresa() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final sessionState = context.read<SessionBloc>().state;

    final usuario = sessionState.user;

    if (usuario == null) {
      return;
    }

    final request = EmpresaRequest(
      idUsuario: usuario.data.usuario.idUsuario,

      razonSocial: razonSocialCtrl.text.trim(),

      nombreComercial: nombreComercialCtrl.text.trim(),

      ruc: rucCtrl.text.trim(),

      tipoEmpresa: tipoEmpresa,

      direccionFiscal: direccionFiscalCtrl.text.trim(),

      telefono: telefonoCtrl.text.trim(),

      email: emailCtrl.text.trim(),

      paginaWeb: '',
      logoUrl: '',
    );

    context.read<EmpresaBloc>().add(CreateEmpresaEvent(request));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,

      appBar: AppBar(
        elevation: 0,

        backgroundColor: colors.surface,

        foregroundColor: colors.onSurface,

        surfaceTintColor: Colors.transparent,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ==================================================
                // HEADER
                // ==================================================
                Text(
                  'Registra tu primera empresa',

                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colors.onSurface,

                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Completa los datos principales para comenzar a usar Aryoria.',

                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,

                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 28),

                // ==================================================
                // TIPO EMPRESA
                // ==================================================
                _buildTipoEmpresaDropdown(),

                const SizedBox(height: 16),

                // ==================================================
                // RAZÓN SOCIAL
                // ==================================================
                _buildInput(
                  controller: razonSocialCtrl,

                  label: 'Razón social',

                  icon: Icons.apartment_rounded,

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La razón social es obligatoria';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // NOMBRE COMERCIAL
                // ==================================================
                _buildInput(
                  controller: nombreComercialCtrl,

                  label: 'Nombre comercial',

                  icon: Icons.business_rounded,

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre comercial es obligatorio';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // RUC
                // ==================================================
                _buildInput(
                  controller: rucCtrl,

                  label: 'RUC',

                  icon: Icons.badge_outlined,

                  keyboardType: TextInputType.number,

                  maxLength: 11,

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El RUC es obligatorio';
                    }

                    if (value.trim().length != 11) {
                      return 'El RUC debe tener 11 dígitos';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // EMAIL
                // ==================================================
                _buildInput(
                  controller: emailCtrl,

                  label: 'Email',

                  icon: Icons.email_outlined,

                  keyboardType: TextInputType.emailAddress,

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El email es obligatorio';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // TELÉFONO
                // ==================================================
                _buildInput(
                  controller: telefonoCtrl,

                  label: 'Teléfono',

                  icon: Icons.phone_outlined,

                  keyboardType: TextInputType.phone,

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El teléfono es obligatorio';
                    }

                    if (value.trim().length < 6) {
                      return 'Ingrese un teléfono válido';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // DIRECCIÓN
                // ==================================================
                _buildInput(
                  controller: direccionFiscalCtrl,

                  label: 'Dirección fiscal',

                  icon: Icons.location_on_outlined,

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La dirección fiscal es obligatoria';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 35),

                // ==================================================
                // BOTÓN
                // ==================================================
                SizedBox(
                  width: double.infinity,

                  height: 54,

                  child: FilledButton.icon(
                    onPressed: _crearEmpresa,

                    icon: const Icon(Icons.add_business),

                    label: const Text('Crear empresa'),

                    style: FilledButton.styleFrom(
                      textStyle: theme.textTheme.labelLarge?.copyWith(
                        fontSize: 16,

                        fontWeight: FontWeight.w600,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // DROPDOWN TIPO EMPRESA
  // ==========================================================
  Widget _buildTipoEmpresaDropdown() {
    final theme = Theme.of(context);

    final colors = theme.colorScheme;

    return DropdownButtonFormField<String>(
      initialValue: tipoEmpresa,

      isExpanded: true,

      dropdownColor: colors.surfaceContainer,

      style: theme.textTheme.bodyLarge?.copyWith(color: colors.onSurface),

      items: tiposEmpresa.map((tipo) {
        return DropdownMenuItem<String>(value: tipo, child: Text(tipo));
      }).toList(),

      onChanged: (value) {
        if (value == null) {
          return;
        }

        setState(() {
          tipoEmpresa = value;
        });
      },

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'El tipo de empresa es obligatorio';
        }

        return null;
      },

      decoration: _inputDecoration(
        label: 'Tipo de empresa',

        icon: Icons.category_outlined,
      ),
    );
  }

  // ==========================================================
  // INPUT
  // ==========================================================
  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,

    String? Function(String?)? validator,

    TextInputType keyboardType = TextInputType.text,

    int? maxLength,
  }) {
    final theme = Theme.of(context);

    final colors = theme.colorScheme;

    return TextFormField(
      controller: controller,

      validator: validator,

      keyboardType: keyboardType,

      maxLength: maxLength,

      style: theme.textTheme.bodyLarge?.copyWith(color: colors.onSurface),

      cursorColor: colors.primary,

      decoration: _inputDecoration(label: label, icon: icon, hideCounter: true),
    );
  }

  // ==========================================================
  // INPUT DECORATION
  // ==========================================================
  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,

    bool hideCounter = false,
  }) {
    final theme = Theme.of(context);

    final colors = theme.colorScheme;

    final borderRadius = BorderRadius.circular(16);

    return InputDecoration(
      counterText: hideCounter ? '' : null,

      labelText: label,

      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: colors.onSurfaceVariant,
      ),

      prefixIcon: Icon(icon, color: colors.primary),

      filled: true,

      fillColor: colors.surfaceContainerLow,

      border: OutlineInputBorder(
        borderRadius: borderRadius,

        borderSide: BorderSide(color: colors.outlineVariant),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,

        borderSide: BorderSide(
          color: colors.outlineVariant.withValues(alpha: 0.6),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,

        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius,

        borderSide: BorderSide(color: colors.error),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: borderRadius,

        borderSide: BorderSide(color: colors.error, width: 1.5),
      ),

      errorStyle: theme.textTheme.bodySmall?.copyWith(color: colors.error),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }
}
