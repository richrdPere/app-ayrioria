import 'package:app_aryoria/src/data/models/empresa/empresa_data.dart';
import 'package:app_aryoria/src/data/models/login/auth_response.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_event.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'empresa_create_content.dart';

class EmpresaCreatePage extends StatelessWidget {
  const EmpresaCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmpresaBloc, EmpresaState>(
      listenWhen: (previous, current) =>
          previous.createResponse != current.createResponse ||
          previous.selectResponse != current.selectResponse,

      listener: (context, state) {
        // Empresa creada correctamente
        if (state.createResponse is Success<EmpresaData>) {
          final response = state.createResponse as Success<EmpresaData>;
          final empresa = response.data;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Empresa creada satisfactoriamente"),
              backgroundColor: Colors.green,
            ),
          );

          context.read<EmpresaBloc>().add(
            SelectEmpresaEvent(empresa.idEmpresa),
          );
        }

        // Empresa seleccionada correctamente
        if (state.selectResponse is Success<AuthResponse>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed('home');
          });
        }

        // Error al crear
        if (state.createResponse is ErrorData) {
          final error = state.createResponse as ErrorData;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.error),
              backgroundColor: Colors.redAccent,
            ),
          );
        }

        // Error al seleccionar
        if (state.selectResponse is ErrorData) {
          final error = state.selectResponse as ErrorData;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.error),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: const EmpresaCreateContent(),
    );
  }
}
