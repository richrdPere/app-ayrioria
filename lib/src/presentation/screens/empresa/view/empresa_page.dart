import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      listener: (context, state) {
        /// CREATE
        final create = state.createResponse;
        if (create != null && create is Success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Empresa creada correctamente")),
          );
        }

        /// DELETE
        final delete = state.deleteResponse;
        if (delete != null && delete is Success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Empresa eliminada")));
        }

        /// UPDATE
        final update = state.updateResponse;
        if (update != null && update is Success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Empresa actualizada")));
        }
      },

      child: const EmpresaContent(),
    );
  }
}
