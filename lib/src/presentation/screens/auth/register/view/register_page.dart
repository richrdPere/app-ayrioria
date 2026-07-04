import 'package:app_aryoria/src/data/models/register/register_response.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/presentation/screens/auth/register/bloc/register_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/auth/register/bloc/register_state.dart';
import 'package:app_aryoria/src/presentation/screens/auth/register/view/register_form.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.response is Success<RegisterResponse>) {
          final response = (state.response as Success<RegisterResponse>).data;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
            ),
          );

          context.goNamed('login');
        }

        if (state.response is ErrorData) {
          final error = state.response as ErrorData;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.error), backgroundColor: Colors.red),
          );
        }
      },

      child: const RegisterForm(),
    );
  }
}
