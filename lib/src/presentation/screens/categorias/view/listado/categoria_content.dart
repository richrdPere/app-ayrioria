import 'dart:async';

import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_sumary_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Session
import 'package:app_aryoria/src/config/core/session/session_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_query_params.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Bloc
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_event.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_state.dart';

// Widgets categoría
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_content/categoria_card.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_content/categoria_empty_state.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_content/categoria_error_state.dart';
// import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_content/categoria_summary.dart';

// Widgets globales
import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_module_header.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_paginated_list.dart';

class CategoriaContent extends StatefulWidget {
  const CategoriaContent({super.key});

  @override
  State<CategoriaContent> createState() => _CategoriaContentState();
}

class _CategoriaContentState extends State<CategoriaContent> {
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;

  String? _tipoSeleccionado;
  bool? _estadoSeleccionado;

  // ==========================================================
  // EMPRESA ACTIVA
  // ==========================================================
  int? get _idEmpresa {
    return context.read<SessionBloc>().state.empresaActiva?.idEmpresa;
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================
  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();

    super.dispose();
  }

  // ==========================================================
  // CREAR QUERY PARAMS
  // ==========================================================
  CategoriasParams _buildParams({required int page, int? limit}) {
    final String search = _searchController.text.trim();

    return CategoriasParams(
      page: page,
      limit: limit ?? 10,
      search: search.isEmpty ? null : search,
      tipo: _tipoSeleccionado,
      estado: _estadoSeleccionado,
    );
  }

  // ==========================================================
  // CARGAR CATEGORÍAS
  // ==========================================================
  void _loadCategorias({int page = 1, int? limit, bool refresh = false}) {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      _showError('No existe una empresa activa seleccionada.');

      return;
    }

    final CategoriasParams queryParams = _buildParams(page: page, limit: limit);

    context.read<CategoriaBloc>().add(
      GetCategoriasEvent(
        idEmpresa: idEmpresa,
        queryParams: queryParams,
        refresh: refresh,
      ),
    );
  }

  // ==========================================================
  // BÚSQUEDA
  // ==========================================================
  void _onSearchChanged(String value) {
    setState(() {});

    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) {
        return;
      }

      _loadCategorias(page: 1, refresh: true);
    });
  }

  // ==========================================================
  // LIMPIAR BÚSQUEDA
  // ==========================================================
  void _clearSearch() {
    _debounce?.cancel();

    _searchController.clear();

    setState(() {});

    _loadCategorias(page: 1, refresh: true);
  }

  // ==========================================================
  // FILTRAR TIPO
  // ==========================================================
  void _onTipoChanged(String? tipo) {
    setState(() {
      _tipoSeleccionado = tipo;
    });

    _loadCategorias(page: 1, refresh: true);
  }

  // ==========================================================
  // FILTRAR ESTADO
  // ==========================================================
  void _onEstadoChanged(bool? estado) {
    setState(() {
      _estadoSeleccionado = estado;
    });

    _loadCategorias(page: 1, refresh: true);
  }

  // ==========================================================
  // LIMPIAR TODOS LOS FILTROS
  // ==========================================================
  void _clearFilters() {
    _debounce?.cancel();

    setState(() {
      _searchController.clear();
      _tipoSeleccionado = null;
      _estadoSeleccionado = null;
    });

    _loadCategorias(page: 1, refresh: true);
  }

  // ==========================================================
  // SIGUIENTE PÁGINA
  // ==========================================================
  void _onNextPage() {
    final CategoriaState state = context.read<CategoriaBloc>().state;

    if (state.isLoadingMore || !state.hasNextPage) {
      return;
    }

    _loadCategorias(page: state.page + 1, limit: state.limit);
  }

  // ==========================================================
  // PÁGINA ANTERIOR
  // ==========================================================
  void _onPreviousPage() {
    final CategoriaState state = context.read<CategoriaBloc>().state;

    if (state.isLoadingMore || !state.hasPreviousPage) {
      return;
    }

    _loadCategorias(page: state.page - 1, limit: state.limit);
  }

  // ==========================================================
  // REFRESH
  // ==========================================================
  Future<void> _onRefresh() async {
    _loadCategorias(page: 1, refresh: true);
  }

  // ==========================================================
  // CREAR
  // ==========================================================
  Future<void> _onCreate() async {
    final result = await context.push('/categorias/crear');

    if (!mounted) {
      return;
    }

    if (result == true) {
      _loadCategorias(page: 1, refresh: true);
    }
  }

  // ==========================================================
  // DETALLE
  // ==========================================================
  Future<void> _onViewDetail(int idCategoria) async {
    final result = await context.push('/categorias/$idCategoria');

    if (!mounted) {
      return;
    }

    if (result == true) {
      final CategoriaState state = context.read<CategoriaBloc>().state;

      _loadCategorias(page: state.page, limit: state.limit, refresh: true);
    }
  }

  // ==========================================================
  // EDITAR
  // ==========================================================
  Future<void> _onEdit(int idCategoria) async {
    final result = await context.push('/categorias/$idCategoria/editar');

    if (!mounted) {
      return;
    }

    if (result == true) {
      final CategoriaState state = context.read<CategoriaBloc>().state;

      _loadCategorias(page: state.page, limit: state.limit, refresh: true);
    }
  }

  // ==========================================================
  // ELIMINAR
  // ==========================================================
  Future<void> _onDelete(CategoriaData categoria) async {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      _showError('No existe una empresa activa seleccionada.');

      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar categoría'),
          content: Text(
            '¿Está seguro de eliminar la categoría '
            '"${categoria.nombre}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    context.read<CategoriaBloc>().add(
      DeleteCategoriaEvent(
        idCategoria: categoria.idCategoria,
        idEmpresa: idEmpresa,
      ),
    );
  }

  // ==========================================================
  // MENSAJE SUCCESS
  // ==========================================================
  String _getSuccessMessage(Resource response) {
    if (response is Success) {
      final dynamic data = response.data;

      try {
        final String? message = data.message as String?;

        if (message != null && message.trim().isNotEmpty) {
          return message;
        }
      } catch (_) {
        // Respuesta sin message.
      }
    }

    return 'Operación realizada correctamente.';
  }

  // ==========================================================
  // MENSAJE ERROR
  // ==========================================================
  String _getErrorMessage(ErrorData response) {
    final dynamic error = response.error;

    if (error != null && error.toString().trim().isNotEmpty) {
      return error.toString();
    }

    return 'Ocurrió un error inesperado.';
  }

  // ==========================================================
  // SNACKBAR ERROR
  // ==========================================================
  void _showError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
  }

  // ==========================================================
  // FILTROS ACTIVOS
  // ==========================================================
  bool get _hasFilters {
    return _searchController.text.trim().isNotEmpty ||
        _tipoSeleccionado != null ||
        _estadoSeleccionado != null;
  }

  // ==========================================================
  // BUILD
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoriaBloc, CategoriaState>(
      listenWhen: (previous, current) {
        return previous.actionResponse != current.actionResponse;
      },
      listener: (context, state) {
        final Resource? response = state.actionResponse;

        // ====================================================
        // SUCCESS
        // ====================================================
        if (response is Success) {
          final String message = _getSuccessMessage(response);

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.green),
            );

          context.read<CategoriaBloc>().add(
            const ClearCategoriaActionResponseEvent(),
          );

          return;
        }

        // ====================================================
        // ERROR
        // ====================================================
        if (response is ErrorData) {
          _showError(_getErrorMessage(response));

          context.read<CategoriaBloc>().add(
            const ClearCategoriaActionResponseEvent(),
          );
        }
      },
      child: BlocBuilder<CategoriaBloc, CategoriaState>(
        builder: (context, state) {
          final bool existenCategorias = state.categorias.isNotEmpty;

          return Scaffold(
            body: Column(
              children: [
                // ==============================================
                // HEADER GLOBAL
                // ==============================================
                const AppModuleHeader(
                  icon: Icons.category_outlined,
                  title: 'Gestiona tus categorías',
                  description:
                      'Organiza los ingresos y egresos de tu empresa mediante categorías contables.',
                ),

                // ==============================================
                // BUSCADOR Y FILTROS
                // ==============================================
                if (existenCategorias || _hasFilters) _buildFilters(),

                // ==============================================
                // RESUMEN
                // ==============================================
                if (existenCategorias)
                  AppSummaryChip(
                    total: state.total,
                    singularLabel: 'categoría',
                    pluralLabel: 'categorías',
                    icon: Icons.category_outlined,
                    isSearching: _hasFilters,
                    search: _searchController.text.trim(),
                  ),
                // CategoriaSummary(
                //   total: state.total,
                //   isSearching: _hasFilters,
                //   search: _searchController.text.trim(),
                // ),

                // ==============================================
                // BODY
                // ==============================================
                Expanded(child: _buildBody(state)),
              ],
            ),

            // ================================================
            // CREAR
            // ================================================
            floatingActionButton: existenCategorias
                ? FloatingActionButton.extended(
                    onPressed: _onCreate,
                    icon: const Icon(Icons.add),
                    label: const Text('Nueva'),
                  )
                : null,
          );
        },
      ),
    );
  }

  // ==========================================================
  // FILTROS
  // ==========================================================
  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        children: [
          Row(
            children: [
              // =================================================
              // BUSCADOR
              // =================================================
              Expanded(
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onChanged: _onSearchChanged,
                  onSubmitted: (_) {
                    _debounce?.cancel();

                    _loadCategorias(page: 1, refresh: true);
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar categoría...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Limpiar',
                            onPressed: _clearSearch,
                            icon: const Icon(Icons.clear),
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // =================================================
              // FILTROS
              // =================================================
              PopupMenuButton<String>(
                tooltip: 'Filtrar categorías',
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem(
                      value: 'TODOS',
                      child: Text('Todas las categorías'),
                    ),
                    PopupMenuItem(
                      value: 'INGRESO',
                      child: Text('Solo ingresos'),
                    ),
                    PopupMenuItem(value: 'EGRESO', child: Text('Solo egresos')),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'ACTIVAS',
                      child: Text('Solo activas'),
                    ),
                    PopupMenuItem(
                      value: 'INACTIVAS',
                      child: Text('Solo inactivas'),
                    ),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'LIMPIAR',
                      child: Text('Limpiar filtros'),
                    ),
                  ];
                },
                onSelected: (value) {
                  switch (value) {
                    case 'TODOS':
                    case 'LIMPIAR':
                      _clearFilters();
                      break;

                    case 'INGRESO':
                      _onTipoChanged('INGRESO');
                      break;

                    case 'EGRESO':
                      _onTipoChanged('EGRESO');
                      break;

                    case 'ACTIVAS':
                      _onEstadoChanged(true);
                      break;

                    case 'INACTIVAS':
                      _onEstadoChanged(false);
                      break;
                  }
                },
                child: _FilterButton(
                  active:
                      _tipoSeleccionado != null || _estadoSeleccionado != null,
                ),
              ),
            ],
          ),

          // ====================================================
          // FILTROS ACTIVOS
          // ====================================================
          if (_tipoSeleccionado != null || _estadoSeleccionado != null) ...[
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (_tipoSeleccionado != null)
                    InputChip(
                      label: Text(
                        _tipoSeleccionado == 'INGRESO' ? 'Ingresos' : 'Egresos',
                      ),
                      onDeleted: () {
                        _onTipoChanged(null);
                      },
                    ),

                  if (_estadoSeleccionado != null)
                    InputChip(
                      label: Text(
                        _estadoSeleccionado == true ? 'Activas' : 'Inactivas',
                      ),
                      onDeleted: () {
                        _onEstadoChanged(null);
                      },
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================================
  // BODY
  // ==========================================================
  Widget _buildBody(CategoriaState state) {
    final Resource? response = state.response;

    // ========================================================
    // LOADING INICIAL
    // ========================================================
    if (response is Loading && state.categorias.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // ========================================================
    // ERROR
    // ========================================================
    if (response is ErrorData && state.categorias.isEmpty) {
      return CategoriaErrorState(
        message: _getErrorMessage(response),
        onRefresh: _onRefresh,
        onRetry: () {
          _loadCategorias(page: 1, refresh: true);
        },
      );
    }

    // ========================================================
    // EMPTY
    // ========================================================
    if (state.categorias.isEmpty) {
      return CategoriaEmptyState(
        search: _searchController.text.trim(),
        onRefresh: _onRefresh,
      );
    }

    // ========================================================
    // LISTADO
    // ========================================================
    return _buildCategoriaList(state);
  }

  // ==========================================================
  // LISTADO PAGINADO
  // ==========================================================
  Widget _buildCategoriaList(CategoriaState state) {
    return AppPaginatedList<CategoriaData>(
      items: state.categorias,
      limit: state.limit,
      page: state.page,
      totalPages: state.totalPages,
      totalItems: state.total,
      isLoading: state.response is Loading,
      isLoadingMore: state.isLoadingMore,
      onRefresh: _onRefresh,
      onPreviousPage: state.hasPreviousPage ? _onPreviousPage : null,
      onNextPage: state.hasNextPage ? _onNextPage : null,
      itemBuilder: (context, categoria, index) {
        return CategoriaCard(
          categoria: categoria,

          // Si tu CategoriaCard ya tiene onTap:
          onTap: () {
            _onViewDetail(categoria.idCategoria);
          },

          // Si ya soporta editar:
          onEdit: () {
            _onEdit(categoria.idCategoria);
          },

          onDelete: () {
            _onDelete(categoria);
          },
        );
      },
    );
  }
}

// ==========================================================
// BOTÓN FILTROS
// ==========================================================
class _FilterButton extends StatelessWidget {
  final bool active;

  const _FilterButton({required this.active});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        border: Border.all(color: colors.outline),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.filter_list),

          if (active)
            Positioned(
              right: 9,
              top: 9,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:app_aryoria/src/config/core/session/session_bloc.dart';

// // Models
// import 'package:app_aryoria/src/data/models/categoria/categoria_paginated.dart';
// import 'package:app_aryoria/src/data/models/categoria/categoria_response.dart';
// import 'package:app_aryoria/src/domain/utils/Resource.dart';

// // Bloc
// import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_bloc.dart';
// import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_event.dart';
// import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_state.dart';

// // Views
// import 'package:app_aryoria/src/presentation/screens/categorias/view/categoria_form_dialog.dart';

// // Widgets
// import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_content/categoria_card.dart';
// import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_content/categoria_empty_state.dart';
// import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_content/categoria_error_state.dart';
// import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_content/categoria_loading_more.dart';
// // import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_content/categoria_search_field.dart';
// import 'package:app_aryoria/src/presentation/screens/categorias/view/widgets/categoria_content/categoria_summary.dart';

// class CategoriaContent extends StatefulWidget {
//   const CategoriaContent({super.key});

//   @override
//   State<CategoriaContent> createState() => _CategoriaContentState();
// }

// class _CategoriaContentState extends State<CategoriaContent> {
//   final TextEditingController searchCtrl = TextEditingController();
//   final ScrollController scrollCtrl = ScrollController();

//   Timer? _debounce;

//   int? get idEmpresa {
//     return context.read<SessionBloc>().state.empresaActiva?.idEmpresa;
//   }

//   @override
//   void initState() {
//     super.initState();
//     scrollCtrl.addListener(_onScroll);
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     searchCtrl.dispose();

//     scrollCtrl
//       ..removeListener(_onScroll)
//       ..dispose();

//     super.dispose();
//   }

//   void _onSearchChanged(String value) {
//     setState(() {});

//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       if (!mounted) return;
//       final empresaId = idEmpresa;

//       if (empresaId == null) {
//         _showEmpresaError();
//         return;
//       }

//       final categoriaBloc = context.read<CategoriaBloc>();
//       final state = categoriaBloc.state;

//       categoriaBloc.add(
//         GetCategoriasEvent(
//           page: 1,
//           limit: state.limit,
//           idEmpresa: empresaId,
//           search: value.trim(),
//         ),
//       );
//     });
//   }

//   // void _clearSearch() {
//   //   searchCtrl.clear();
//   //   _onSearchChanged('');
//   // }

//   void _onScroll() {
//     if (!scrollCtrl.hasClients) return;

//     final state = context.read<CategoriaBloc>().state;

//     final isNearBottom =
//         scrollCtrl.position.pixels >= scrollCtrl.position.maxScrollExtent - 200;

//     if (!isNearBottom) return;

//     if (!state.hasMore || state.isLoading || state.isLoadingMore) {
//       return;
//     }

//     final empresaId = idEmpresa;

//     if (empresaId == null) return;

//     context.read<CategoriaBloc>().add(
//       GetCategoriasEvent(
//         page: state.page + 1,
//         limit: state.limit,
//         idEmpresa: empresaId,
//         search: state.search,
//       ),
//     );
//   }

//   Future<void> _onRefresh() async {
//     final empresaId = idEmpresa;

//     if (empresaId == null) {
//       _showEmpresaError();
//       return;
//     }

//     final categoriaBloc = context.read<CategoriaBloc>();

//     categoriaBloc.add(
//       GetCategoriasEvent(
//         page: 1,
//         limit: categoriaBloc.state.limit,
//         idEmpresa: empresaId,
//         search: searchCtrl.text.trim(),
//       ),
//     );

//     await categoriaBloc.stream.firstWhere(
//       (state) => !state.isLoading && !state.isLoadingMore,
//     );
//   }

//   void _reloadCategorias() {
//     final empresaId = idEmpresa;

//     if (empresaId == null) {
//       _showEmpresaError();
//       return;
//     }

//     final categoriaBloc = context.read<CategoriaBloc>();

//     categoriaBloc.add(
//       GetCategoriasEvent(
//         page: 1,
//         limit: categoriaBloc.state.limit,
//         idEmpresa: empresaId,
//         search: searchCtrl.text.trim(),
//       ),
//     );
//   }

//   void _deleteCategoria(int idCategoria) {
//     context.read<CategoriaBloc>().add(
//       DeleteCategoriaEvent(idCategoria: idCategoria),
//     );
//   }

//   void _showEmpresaError() {
//     if (!mounted) return;

//     _showError('No existe una empresa activa seleccionada.');
//   }

//   void _showSuccess(String message) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(content: Text(message), backgroundColor: Colors.green),
//       );
//   }

//   void _showError(String message) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(content: Text(message), backgroundColor: Colors.red),
//       );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<CategoriaBloc, CategoriaState>(
//           listenWhen: (previous, current) =>
//               previous.actionResponse != current.actionResponse,
//           listener: (context, state) {
//             final response = state.actionResponse;

//             if (response is Success<CategoriaResponse>) {
//               _showSuccess(response.data.message);
//               _reloadCategorias();
//             }

//             if (response is ErrorData<CategoriaResponse>) {
//               _showError(response.displayMessage);
//             }
//           },
//         ),

//         BlocListener<CategoriaBloc, CategoriaState>(
//           listenWhen: (previous, current) =>
//               previous.categoriaResponse != current.categoriaResponse,
//           listener: (context, state) {
//             final response = state.categoriaResponse;

//             if (response is ErrorData<CategoriaPaginatedResponse>) {
//               _showError(response.displayMessage);
//             }
//           },
//         ),
//       ],
//       child: Scaffold(
//         backgroundColor: const Color(0xffF7F8FA),
//         body: BlocBuilder<CategoriaBloc, CategoriaState>(
//           builder: (context, state) {
//             return Column(
//               children: [
//                 // Header
//                 _buildHeader(context),

//                 // Search
//                 _buildSearch(),
//                 // CategoriaSearchField(
//                 //   controller: searchCtrl,
//                 //   enabled: !state.isLoading,
//                 //   onChanged: _onSearchChanged,
//                 //   onClear: _clearSearch,
//                 // ),

//                 // Nro de categorias
//                 CategoriaSummary(
//                   total: state.categorias.length,
//                   isSearching: state.search.trim().isNotEmpty,
//                   search: state.search,
//                 ),

//                 // Lista de Categorias
//                 Expanded(child: _buildBody(state)),
//               ],
//             );
//           },
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//           onPressed: () {
//             CategoriaFormDialog.show(context);
//           },
//           icon: const Icon(Icons.add),
//           label: const Text('Categoria'),
//         ),
//       ),
//     );
//   }

//   // ==========================================================
//   // 1. HEADER
//   // ==========================================================
//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.primaryContainer,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 52,
//             height: 52,
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.primary,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Icon(
//               Icons.calendar_month_outlined,
//               color: Theme.of(context).colorScheme.onPrimary,
//             ),
//           ),
//           const SizedBox(width: 14),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Categorías',
//                   style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   'Administra tus categorias para representar tus ingresos y egresos de tu empresa.',
//                   style: TextStyle(fontSize: 13),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================================================
//   // BUSCADOR Y FILTRO
//   // ==========================================================
//   // CategoriaSearchField(
//   //   controller: searchCtrl,
//   //   enabled: !state.isLoading,
//   //   onChanged: _onSearchChanged,
//   //   onClear: _clearSearch,
//   // ),
//   Widget _buildSearch() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: searchCtrl,
//               textInputAction: TextInputAction.search,
//               onSubmitted: _onSearchChanged,
//               decoration: InputDecoration(
//                 hintText: 'Buscar período...',
//                 prefixIcon: const Icon(Icons.search),
//                 suffixIcon: searchCtrl.text.isEmpty
//                     ? null
//                     : IconButton(
//                         tooltip: 'Limpiar',
//                         onPressed: () {
//                           searchCtrl.clear();

//                           setState(() {});

//                           // widget.onSearch('');
//                         },
//                         icon: const Icon(Icons.clear),
//                       ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//               ),
//               onChanged: (_) {
//                 setState(() {});
//               },
//             ),
//           ),
//           const SizedBox(width: 10),

//         ],
//       ),
//     );
//   }

//   Widget _buildBody(CategoriaState state) {
//     if (state.isLoading && state.categorias.isEmpty) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     final response = state.categoriaResponse;

//     if (response is ErrorData<CategoriaPaginatedResponse> &&
//         state.categorias.isEmpty) {
//       return CategoriaErrorState(
//         message: response.displayMessage,
//         onRefresh: _onRefresh,
//         onRetry: _reloadCategorias,
//       );
//     }

//     if (state.categorias.isEmpty) {
//       return CategoriaEmptyState(search: state.search, onRefresh: _onRefresh);
//     }

//     return RefreshIndicator(
//       onRefresh: _onRefresh,
//       child: ListView.separated(
//         controller: scrollCtrl,
//         padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
//         physics: const AlwaysScrollableScrollPhysics(),
//         itemCount: state.categorias.length + (state.isLoadingMore ? 1 : 0),
//         separatorBuilder: (_, __) {
//           return const SizedBox(height: 12);
//         },
//         itemBuilder: (context, index) {
//           if (index >= state.categorias.length) {
//             return const CategoriaLoadingMore();
//           }

//           final categoria = state.categorias[index];

//           return CategoriaCard(
//             categoria: categoria,
//             onDelete: () {
//               _deleteCategoria(categoria.idCategoria);
//             },
//           );
//         },
//       ),
//     );
//   }
// }
