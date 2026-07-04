import 'package:app_aryoria/src/data/models/register/register_request.dart';
import 'package:app_aryoria/src/presentation/screens/auth/register/bloc/register_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/auth/register/bloc/register_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/auth/register/bloc/register_state.dart';

// Widgets
import 'package:app_aryoria/src/presentation/shared/widgets/custom_input.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/logo.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/boton_azul.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/labels.dart';

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

  String genero = "M";
  String tipoDocumento = "DNI";

  final formKey = GlobalKey<FormState>();

  void _submit() {
    final bloc = context.read<RegisterBloc>();

    if (!formKey.currentState!.validate()) return;

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
        password: passwordCtrl.text.trim(),
      ),
    );

    bloc.add(RegisterSubmitEvent(request: request));
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Form(
            key: formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),

                const SizedBox(height: 30),

                _buildForm(),

                const SizedBox(height: 30),

                _buildButton(),

                const SizedBox(height: 35),

                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Logo(titulo: "Registro");
  }

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
      icon: Icons.person,
      placeholder: "Nombres",
      textController: nombresCtrl,
      keyboardType: TextInputType.name,
      isPassword: false,
    );
  }

  Widget _buildApellidosField() {
    return CustomInput(
      icon: Icons.person_outline,
      placeholder: "Apellidos",
      textController: apellidosCtrl,
      keyboardType: TextInputType.name,
      isPassword: false,
    );
  }

  Widget _buildEmailField() {
    return CustomInput(
      icon: Icons.email_outlined,
      placeholder: "Correo",
      textController: emailCtrl,
      keyboardType: TextInputType.emailAddress,
      isPassword: false,
    );
  }

  Widget _buildDocumentoField() {
    return CustomInput(
      icon: Icons.badge_outlined,
      placeholder: "Número Documento",
      textController: documentoCtrl,
      keyboardType: TextInputType.number,
      isPassword: false,
    );
  }

  Widget _buildCelularField() {
    return CustomInput(
      icon: Icons.phone_android,
      placeholder: "Celular",
      textController: celularCtrl,
      keyboardType: TextInputType.phone,
      isPassword: false,
    );
  }

  Widget _buildDireccionField() {
    return CustomInput(
      icon: Icons.home_outlined,
      placeholder: "Dirección",
      textController: direccionCtrl,
      keyboardType: TextInputType.streetAddress,
      isPassword: false,
    );
  }

  Widget _buildPasswordField() {
    return CustomInput(
      icon: Icons.lock_outline,
      placeholder: "Contraseña",
      textController: passwordCtrl,
      keyboardType: TextInputType.visiblePassword,
      isPassword: true,
    );
  }

  Widget _buildButton() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (_, state) {
        return BotonAzul(
          text: state.isLoading ? "Registrando..." : "Registrarse",
          onPressed: state.isLoading ? null : _submit,
        );
      },
    );
  }

  Widget _buildFooter() {
    return Column(
      children: const [
        Labels(
          ruta: "login",
          titulo: "¿Ya tienes una cuenta?",
          subTitulo: "Ingresa ahora!",
        ),

        SizedBox(height: 10),

        Text(
          "Términos y condiciones de uso",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 12,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
