import 'package:app_aryoria/src/presentation/shared/widgets/login_pin_selector_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app_aryoria/src/presentation/screens/auth/login/bloc/login_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/auth/login/bloc/login_event.dart';
import 'package:app_aryoria/src/presentation/shared/utils/BlocFormItem.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/boton_azul.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/custom_input.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/labels.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/logo.dart';

class LoginContent extends StatelessWidget {
  const LoginContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ColoredBox(
      color: colors.surface,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ========================================================
                  // LOGO
                  // ========================================================
                  const Logo(titulo: 'Iniciar Sesión', logoSize: 220),

                  // ========================================================
                  // FORM
                  // ========================================================
                  _Form(),

                  // ========================================================
                  // REGISTER
                  // ========================================================
                  const Labels(
                    ruta: 'register',
                    titulo: '¿No tienes cuenta?',
                    subTitulo: '¡Crea una ahora!',
                  ),

                  // ========================================================
                  // TERMS
                  // ========================================================
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Términos y condiciones de uso',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoginBloc>();

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 30),

      child: Form(
        key: _formKey,

        child: Column(
          children: [
            // ============================================================
            // USERNAME
            // ============================================================
            CustomInput(
              icon: Icons.person_outline,
              placeholder: 'Username',
              textController: emailCtrl,
              keyboardType: TextInputType.number,
              isPassword: false,

              onChanged: (value) {
                bloc.add(UsernameChanged(username: BlocFormItem(value: value)));
              },
            ),

            // ============================================================
            // PASSWORD / PIN
            // ============================================================
            LoginPinSelectorField(
              controller: passCtrl,
              length: 6,
              placeholder: 'Contraseña',
              icon: Icons.lock_outline,

              onChanged: (value) {
                bloc.add(PasswordChanged(password: BlocFormItem(value: value)));
              },
            ),

            const SizedBox(height: 8),

            // ============================================================
            // LOGIN
            // ============================================================
            BotonAzul(
              text: 'Ingresar',
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  bloc.add(LoginSubmit());

                  return;
                }

                Fluttertoast.showToast(
                  msg: 'El formulario no es válido',
                  toastLength: Toast.LENGTH_SHORT,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
