import 'package:app_aryoria/src/data/models/register/register_request.dart';
import 'package:app_aryoria/src/presentation/screens/auth/register/bloc/register_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_aryoria/src/presentation/screens/auth/register/bloc/register_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/auth/register/bloc/register_state.dart';

// Widgets
import 'package:app_aryoria/src/presentation/shared/widgets/custom_input.dart';
// import 'package:app_aryoria/src/presentation/shared/widgets/logo.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/boton_azul.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/labels.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/pin_selector_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final nombresCtrl = TextEditingController();
  final apellidosCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final documentoCtrl = TextEditingController();
  final celularCtrl = TextEditingController();
  final direccionCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  DateTime? fechaNacimiento;

  String genero = 'M';
  String tipoDocumento = 'DNI';

  final formKey = GlobalKey<FormState>();

  // =========================================================
  // SUBMIT
  // =========================================================
  void _submit() {
    final bloc = context.read<RegisterBloc>();

    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    final request = RegisterRequest(
      persona: PersonaRequest(
        nombres: nombresCtrl.text.trim(),
        apellidos: apellidosCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        tipoDocumento: tipoDocumento,
        numeroDocumento: documentoCtrl.text.trim(),
        fechaNacimiento: fechaNacimiento ?? DateTime(2000, 1, 1),
        celular: celularCtrl.text.trim(),
        direccion: direccionCtrl.text.trim(),
        genero: genero,
      ),
      usuario: UsuarioRequest(
        email: emailCtrl.text.trim(),
        username: documentoCtrl.text.trim(),
        password: passwordCtrl.text,
      ),
    );

    bloc.add(RegisterSubmitEvent(request: request));
  }

  // =========================================================
  // DISPOSE
  // =========================================================
  @override
  void dispose() {
    nombresCtrl.dispose();
    apellidosCtrl.dispose();
    emailCtrl.dispose();
    documentoCtrl.dispose();
    celularCtrl.dispose();
    direccionCtrl.dispose();
    passwordCtrl.dispose();

    super.dispose();
  }

  // =========================================================
  // BUILD
  // =========================================================
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(32, 20, 32, 32),

          child: Form(
            key: formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // =====================================================
                // HEADER
                // =====================================================
                // _buildHeader(),
             
                const SizedBox(height: 30),

                Text(
                  "Crea tu cuenta en Aryoria",
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                    height: 1.10,
                    letterSpacing: 0.1,
                  ),
                ),

                const SizedBox(height: 50),

                // =====================================================
                // FORM
                // =====================================================
                _buildForm(),

                const SizedBox(height: 12),

                // =====================================================
                // BUTTON
                // =====================================================
                _buildButton(),

                const SizedBox(height: 34),

                // =====================================================
                // FOOTER
                // =====================================================
                _buildFooter(context),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // HEADER
  // =========================================================

  // Widget _buildHeader() {
  //   return const Logo(titulo: 'REGISTRO - ARYORIA');
  // }

  // =========================================================
  // FORM
  // =========================================================

  Widget _buildForm() {
    return Column(
      children: [
        _buildNombresField(),
        _buildApellidosField(),
        _buildEmailField(),
        _buildDocumentoField(),
        _buildCelularField(),
        _buildDireccionField(),
        _buildPasswordField(),
      ],
    );
  }

  Widget _buildNombresField() {
    return CustomInput(
      icon: Icons.person_outline,
      placeholder: 'Nombres',
      textController: nombresCtrl,
      keyboardType: TextInputType.name,
      isPassword: false,
    );
  }

  Widget _buildApellidosField() {
    return CustomInput(
      icon: Icons.badge_outlined,
      placeholder: 'Apellidos',
      textController: apellidosCtrl,
      keyboardType: TextInputType.name,
      isPassword: false,
    );
  }

  Widget _buildEmailField() {
    return CustomInput(
      icon: Icons.email_outlined,
      placeholder: 'Correo',
      textController: emailCtrl,
      keyboardType: TextInputType.emailAddress,
      isPassword: false,
    );
  }

  Widget _buildDocumentoField() {
    return CustomInput(
      icon: Icons.credit_card_outlined,
      placeholder: 'Número de documento',
      textController: documentoCtrl,
      keyboardType: TextInputType.number,
      isPassword: false,
    );
  }

  Widget _buildCelularField() {
    return CustomInput(
      icon: Icons.phone_android_outlined,
      placeholder: 'Celular',
      textController: celularCtrl,
      keyboardType: TextInputType.phone,
      isPassword: false,
    );
  }

  Widget _buildDireccionField() {
    return CustomInput(
      icon: Icons.home_outlined,
      placeholder: 'Dirección',
      textController: direccionCtrl,
      keyboardType: TextInputType.streetAddress,
      isPassword: false,
    );
  }

  Widget _buildPasswordField() {
    return PinSelectorField(
      controller: passwordCtrl,
      placeholder: 'Contraseña',
      icon: Icons.lock_outline,
      length: 6,
    );
  }

  // =========================================================
  // BUTTON
  // =========================================================
  Widget _buildButton() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return BotonAzul(
          text: state.isLoading ? 'Registrando...' : 'Registrarse',
          onPressed: state.isLoading ? null : _submit,
        );
      },
    );
  }

  // =========================================================
  // FOOTER
  // =========================================================
  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        const Labels(
          ruta: 'login',
          titulo: '¿Ya tienes una cuenta?',
          subTitulo: '¡Ingresa ahora!',
        ),

        const SizedBox(height: 14),

        Text(
          'Términos y condiciones de uso',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
