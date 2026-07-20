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
// import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_content/categoria_search_field.dart';
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

  // void _clearSearch() {
  //   searchCtrl.clear();
  //   _onSearchChanged('');
  // }

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
                // Header
                _buildHeader(context),

                // Search
                _buildSearch(),
                // CategoriaSearchField(
                //   controller: searchCtrl,
                //   enabled: !state.isLoading,
                //   onChanged: _onSearchChanged,
                //   onClear: _clearSearch,
                // ),

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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            CategoriaFormDialog.show(context);
          },
          icon: const Icon(Icons.add),
          label: const Text('Categoria'),
        ),
      ),
    );
  }

  // ==========================================================
  // 1. HEADER
  // ==========================================================
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Categorías',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Administra tus categorias para representar tus ingresos y egresos de tu empresa.',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // BUSCADOR Y FILTRO
  // ==========================================================
  // CategoriaSearchField(
  //   controller: searchCtrl,
  //   enabled: !state.isLoading,
  //   onChanged: _onSearchChanged,
  //   onClear: _clearSearch,
  // ),
  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchCtrl,
              textInputAction: TextInputAction.search,
              onSubmitted: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Buscar período...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchCtrl.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpiar',
                        onPressed: () {
                          searchCtrl.clear();

                          setState(() {});

                          // widget.onSearch('');
                        },
                        icon: const Icon(Icons.clear),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),
          ),
          const SizedBox(width: 10),
          // PopupMenuButton<String?>(
          //   tooltip: 'Filtrar por estado',
          //   initialValue: estadoSeleccionado,
          //   onSelected: onEstadoChanged,
          //   itemBuilder: (context) => const [
          //     PopupMenuItem<String?>(
          //       value: null,
          //       child: Text('Todos los estados'),
          //     ),
          //     PopupMenuItem<String?>(value: 'ABIERTO', child: Text('Abiertos')),
          //     PopupMenuItem<String?>(value: 'CERRADO', child: Text('Cerrados')),
          //   ],
          //   child: Container(
          //     height: 56,
          //     width: 56,
          //     decoration: BoxDecoration(
          //       border: Border.all(
          //         color: Theme.of(context).colorScheme.outline,
          //       ),
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //     child: Stack(
          //       alignment: Alignment.center,
          //       children: [
          //         const Icon(Icons.filter_list),
          //         if (widget.estadoSeleccionado != null)
          //           Positioned(
          //             right: 9,
          //             top: 9,
          //             child: Container(
          //               width: 8,
          //               height: 8,
          //               decoration: const BoxDecoration(
          //                 color: Colors.red,
          //                 shape: BoxShape.circle,
          //               ),
          //             ),
          //           ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
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
