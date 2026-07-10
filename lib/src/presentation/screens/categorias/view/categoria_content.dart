import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_aryoria/src/config/core/session/session_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/categoria/categoria_paginated.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_response.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Bloc
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_event.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_state.dart';

// Views
import 'package:app_aryoria/src/presentation/screens/categorias/view/categoria_form_dialog.dart';

// Widgets
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_content/categoria_card.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_content/categoria_empty_state.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_content/categoria_error_state.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_content/categoria_loading_more.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_content/categoria_search_field.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_content/categoria_summary.dart';

class CategoriaContent extends StatefulWidget {
  const CategoriaContent({super.key});

  @override
  State<CategoriaContent> createState() => _CategoriaContentState();
}

class _CategoriaContentState extends State<CategoriaContent> {
  final TextEditingController searchCtrl = TextEditingController();
  final ScrollController scrollCtrl = ScrollController();

  Timer? _debounce;

  int? get idEmpresa {
    return context.read<SessionBloc>().state.empresaActiva?.idEmpresa;
  }

  @override
  void initState() {
    super.initState();
    scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchCtrl.dispose();

    scrollCtrl
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {});

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      final empresaId = idEmpresa;

      if (empresaId == null) {
        _showEmpresaError();
        return;
      }

      final categoriaBloc = context.read<CategoriaBloc>();
      final state = categoriaBloc.state;

      categoriaBloc.add(
        GetCategoriasEvent(
          page: 1,
          limit: state.limit,
          idEmpresa: empresaId,
          search: value.trim(),
        ),
      );
    });
  }

  void _clearSearch() {
    searchCtrl.clear();
    _onSearchChanged('');
  }

  void _onScroll() {
    if (!scrollCtrl.hasClients) return;

    final state = context.read<CategoriaBloc>().state;

    final isNearBottom =
        scrollCtrl.position.pixels >= scrollCtrl.position.maxScrollExtent - 200;

    if (!isNearBottom) return;

    if (!state.hasMore || state.isLoading || state.isLoadingMore) {
      return;
    }

    final empresaId = idEmpresa;

    if (empresaId == null) return;

    context.read<CategoriaBloc>().add(
      GetCategoriasEvent(
        page: state.page + 1,
        limit: state.limit,
        idEmpresa: empresaId,
        search: state.search,
      ),
    );
  }

  Future<void> _onRefresh() async {
    final empresaId = idEmpresa;

    if (empresaId == null) {
      _showEmpresaError();
      return;
    }

    final categoriaBloc = context.read<CategoriaBloc>();

    categoriaBloc.add(
      GetCategoriasEvent(
        page: 1,
        limit: categoriaBloc.state.limit,
        idEmpresa: empresaId,
        search: searchCtrl.text.trim(),
      ),
    );

    await categoriaBloc.stream.firstWhere(
      (state) => !state.isLoading && !state.isLoadingMore,
    );
  }

  void _reloadCategorias() {
    final empresaId = idEmpresa;

    if (empresaId == null) {
      _showEmpresaError();
      return;
    }

    final categoriaBloc = context.read<CategoriaBloc>();

    categoriaBloc.add(
      GetCategoriasEvent(
        page: 1,
        limit: categoriaBloc.state.limit,
        idEmpresa: empresaId,
        search: searchCtrl.text.trim(),
      ),
    );
  }

  void _deleteCategoria(int idCategoria) {
    context.read<CategoriaBloc>().add(
      DeleteCategoriaEvent(idCategoria: idCategoria),
    );
  }

  void _showEmpresaError() {
    if (!mounted) return;

    _showError('No existe una empresa activa seleccionada.');
  }

  void _showSuccess(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CategoriaBloc, CategoriaState>(
          listenWhen: (previous, current) =>
              previous.actionResponse != current.actionResponse,
          listener: (context, state) {
            final response = state.actionResponse;

            if (response is Success<CategoriaResponse>) {
              _showSuccess(response.data.message);
              _reloadCategorias();
            }

            if (response is ErrorData<CategoriaResponse>) {
              _showError(response.error);
            }
          },
        ),

        BlocListener<CategoriaBloc, CategoriaState>(
          listenWhen: (previous, current) =>
              previous.categoriaResponse != current.categoriaResponse,
          listener: (context, state) {
            final response = state.categoriaResponse;

            if (response is ErrorData<CategoriaPaginatedResponse>) {
              _showError(response.error);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xffF7F8FA),
        body: BlocBuilder<CategoriaBloc, CategoriaState>(
          builder: (context, state) {
            return Column(
              children: [
                // Search
                CategoriaSearchField(
                  controller: searchCtrl,
                  enabled: !state.isLoading,
                  onChanged: _onSearchChanged,
                  onClear: _clearSearch,
                ),

                // Nro de categorias
                CategoriaSummary(
                  total: state.categorias.length,
                  isSearching: state.search.trim().isNotEmpty,
                  search: state.search,
                ),

                // Lista de Categorias
                Expanded(child: _buildBody(state)),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            CategoriaFormDialog.show(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildBody(CategoriaState state) {
    if (state.isLoading && state.categorias.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final response = state.categoriaResponse;

    if (response is ErrorData<CategoriaPaginatedResponse> &&
        state.categorias.isEmpty) {
      return CategoriaErrorState(
        message: response.error,
        onRefresh: _onRefresh,
        onRetry: _reloadCategorias,
      );
    }

    if (state.categorias.isEmpty) {
      return CategoriaEmptyState(search: state.search, onRefresh: _onRefresh);
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
        controller: scrollCtrl,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.categorias.length + (state.isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          if (index >= state.categorias.length) {
            return const CategoriaLoadingMore();
          }

          final categoria = state.categorias[index];

          return CategoriaCard(
            categoria: categoria,
            onDelete: () {
              _deleteCategoria(categoria.idCategoria);
            },
          );
        },
      ),
    );
  }
}
