import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

    searchCtrl.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (!mounted) return;

    setState(() {});
  }

  @override
  void dispose() {
    searchCtrl.removeListener(_onSearchChanged);

    searchCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      // ========================================================
      // BACKGROUND
      // ========================================================
      backgroundColor: colors.surface,

      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // HEADER
            // ==================================================
            buildHeader(context),

            // ==================================================
            // CONTENT
            // ==================================================
            Expanded(
              child: BlocBuilder<EmpresaBloc, EmpresaState>(
                builder: (context, state) {
                  // ============================================
                  // LOADING
                  // ============================================
                  if (state.isLoading && state.empresasResponse == null) {
                    return const EmpresaLoading();
                  }

                  final response = state.empresasResponse;

                  // ============================================
                  // ERROR
                  // ============================================
                  if (response is ErrorData<ApiResponse<EmpresaPaginated>>) {
                    return EmpresaErrorState(
                      message: response.displayMessage,

                      onRetry: () {
                        context.read<EmpresaBloc>().add(
                          const GetEmpresasEvent(),
                        );
                      },
                    );
                  }

                  // ============================================
                  // EMPRESAS
                  // ============================================
                  final empresas =
                      response is Success<ApiResponse<EmpresaPaginated>>
                      ? response.data.data?.data ?? <EmpresaData>[]
                      : <EmpresaData>[];

                  // ============================================
                  // EMPTY
                  // ============================================
                  if (empresas.isEmpty) {
                    return EmpresaEmptyState(
                      onCreate: () {
                        context.pushNamed('crear_empresa');
                      },
                    );
                  }

                  // ============================================
                  // DATA
                  // ============================================
                  return ColoredBox(
                    color: colors.surface,

                    child: Column(
                      children: [
                        EmpresaSearch(controller: searchCtrl),

                        Expanded(
                          child: EmpresaList(
                            empresas: empresas,

                            searchCtrl: searchCtrl,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
