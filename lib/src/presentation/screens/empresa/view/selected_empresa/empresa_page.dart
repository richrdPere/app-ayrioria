import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/login/login_data_model.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Bloc's
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_state.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_event.dart';

import 'empresa_content.dart';

class EmpresaPage extends StatefulWidget {
  const EmpresaPage({super.key});

  @override
  State<EmpresaPage> createState() => _EmpresaPageState();
}

class _EmpresaPageState extends State<EmpresaPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) return;

      context.read<EmpresaBloc>().add(const GetEmpresasEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmpresaBloc, EmpresaState>(
      listenWhen: (previous, current) =>
          previous.selectResponse != current.selectResponse,

      listener: (context, state) {
        final response = state.selectResponse;

        // ======================================================
        // EMPRESA SELECCIONADA
        // ======================================================
        if (response is Success<ApiResponse<LoginDataModel>>) {
          final apiResponse = response.data;

          final loginData = apiResponse.data;

          if (loginData == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No se pudieron obtener los datos de la sesión.'),
                backgroundColor: Colors.redAccent,
              ),
            );

            return;
          }

          if (loginData.empresa == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No se pudo establecer la empresa activa.'),
                backgroundColor: Colors.redAccent,
              ),
            );

            return;
          }

          context.goNamed('home');

          return;
        }

        // ======================================================
        // ERROR
        // ======================================================

        if (response is ErrorData<ApiResponse<LoginDataModel>>) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.displayMessage),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },

      child: const EmpresaContent(),
    );
  }
}
