import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Models
import 'package:app_aryoria/src/data/models/login/auth_response.dart';
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

    /// Cargar empresas al entrar
    Future.microtask(() {
      context.read<EmpresaBloc>().add(const GetEmpresasEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmpresaBloc, EmpresaState>(
      listenWhen: (previous, current) =>
          previous.selectResponse != current.selectResponse,

      listener: (context, state) {
        if (state.selectResponse is Success<AuthResponse>) {
          context.goNamed('home');
        }

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

      child: const EmpresaContent(),
    );
  }
}
