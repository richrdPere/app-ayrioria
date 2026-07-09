import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/empresa/empresa_data.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_paginated.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Bloc's
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_event.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_state.dart';

// Widgets
import 'package:app_aryoria/src/presentation/screens/empresa/view/selected_empresa/widgets/buildHeader.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/view/selected_empresa/widgets/empresa_search.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/view/selected_empresa/widgets/empresa_empty_state.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/view/selected_empresa/widgets/empresa_error_state.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/view/selected_empresa/widgets/empresa_list.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/view/selected_empresa/widgets/empresa_loading.dart';
import 'package:go_router/go_router.dart';

class EmpresaContent extends StatefulWidget {
  const EmpresaContent({super.key});

  @override
  State<EmpresaContent> createState() => _EmpresaContentState();
}

class _EmpresaContentState extends State<EmpresaContent> {
  final searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    searchCtrl.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      body: Column(
        children: [
          // Header siempre visible
          buildHeader(context),

          Expanded(
            child: BlocBuilder<EmpresaBloc, EmpresaState>(
              builder: (context, state) {
                // Loading
                if (state.isLoading && state.empresasResponse == null) {
                  return const EmpresaLoading();
                }

                // Error
                if (state.empresasResponse is ErrorData) {
                  final error = state.empresasResponse as ErrorData;

                  return EmpresaErrorState(
                    message: error.error,

                    onRetry: () {
                      context.read<EmpresaBloc>().add(const GetEmpresasEvent());
                    },
                  );
                }

                final empresas =
                    state.empresasResponse is Success<EmpresaPaginatedResponse>
                    ? (state.empresasResponse
                              as Success<EmpresaPaginatedResponse>)
                          .data
                          .data
                    : <EmpresaData>[];

                // Usuario sin empresas
                if (empresas.isEmpty) {
                  return EmpresaEmptyState(
                    onCreate: () {
                      // abrir formulario
                      context.pushNamed('crear_empresa');
                    },
                  );
                }

                // Usuario con empresas
                return Column(
                  children: [
                    EmpresaSearch(controller: searchCtrl),

                    Expanded(
                      child: EmpresaList(
                        empresas: empresas,
                        searchCtrl: searchCtrl,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
