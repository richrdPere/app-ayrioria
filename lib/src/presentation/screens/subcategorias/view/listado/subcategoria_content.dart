import 'dart:async';

import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/view/detalle/subcategoria_detail_dialog.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/view/form/subcategoria_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Categoria
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_state.dart';

// Subcategoria
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_paginado.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_event.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_state.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class SubcategoriaContent extends StatefulWidget {
  final int idEmpresa;

  const SubcategoriaContent({super.key, required this.idEmpresa});

  @override
  State<SubcategoriaContent> createState() => _SubcategoriaContentState();
}

class _SubcategoriaContentState extends State<SubcategoriaContent> {
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;

  int _page = 1;
  final int _limit = 10;

  int? _idCategoria;
  String? _tipo;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();

    super.dispose();
  }

  // ===========================================================================
  // Buscar
  // ===========================================================================
  void _onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _page = 1;
      _loadSubcategorias();
    });
  }

  // ===========================================================================
  // Cargar subcategorias
  // ===========================================================================
  void _loadSubcategorias() {
    final queryParams = <String, dynamic>{
      'page': _page,
      'limit': _limit,
      'search': _searchController.text.trim(),
    };

    if (_idCategoria != null) {
      queryParams['id_categoria'] = _idCategoria;
    }

    if (_tipo != null && _tipo!.isNotEmpty) {
      queryParams['tipo'] = _tipo;
    }

    context.read<SubcategoriaBloc>().add(
      GetSubcategoriasPaginatedEvent(
        idEmpresa: widget.idEmpresa,
        queryParams: queryParams,
      ),
    );
  }

  // ===========================================================================
  // Limpiar filtros
  // ===========================================================================

  void _clearFilters() {
    _searchController.clear();

    setState(() {
      _page = 1;
      _idCategoria = null;
      _tipo = null;
    });

    _loadSubcategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _page = 1;
            _loadSubcategorias();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),

              SliverToBoxAdapter(child: _buildFilters()),

              SliverToBoxAdapter(child: _buildContent()),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createSubcategoria,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva'),
      ),
    );
  }

  // ===========================================================================
  // Header
  // ===========================================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.account_tree_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subcategorías',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
                Text(
                  'Administra las subcategorías contables.',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Filtros
  // ===========================================================================
  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Buscar subcategoría...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();

                            _page = 1;

                            _loadSubcategorias();

                            setState(() {});
                          },
                          icon: const Icon(Icons.close),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(child: _buildCategoriaFilter()),

                  const SizedBox(width: 10),

                  Expanded(child: _buildTipoFilter()),
                ],
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.filter_alt_off),
                  label: const Text('Limpiar filtros'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // Filtro categoria
  // ===========================================================================

  Widget _buildCategoriaFilter() {
    return BlocBuilder<CategoriaBloc, CategoriaState>(
      builder: (context, state) {
        final categorias = state.categorias;

        return DropdownButtonFormField<int?>(
          value: _idCategoria,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Categoría',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: [
            const DropdownMenuItem<int?>(value: null, child: Text('Todas')),
            ...categorias.map(
              (categoria) => DropdownMenuItem<int?>(
                value: categoria.idCategoria,
                child: Text(categoria.nombre, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _idCategoria = value;
              _page = 1;
            });

            _loadSubcategorias();
          },
        );
      },
    );
  }

  // ===========================================================================
  // Filtro tipo
  // ===========================================================================

  Widget _buildTipoFilter() {
    return DropdownButtonFormField<String?>(
      value: _tipo,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Tipo',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: const [
        DropdownMenuItem<String?>(value: null, child: Text('Todos')),
        DropdownMenuItem<String?>(value: 'INGRESO', child: Text('Ingreso')),
        DropdownMenuItem<String?>(value: 'EGRESO', child: Text('Egreso')),
      ],
      onChanged: (value) {
        setState(() {
          _tipo = value;
          _page = 1;
        });

        _loadSubcategorias();
      },
    );
  }

  // ===========================================================================
  // Contenido
  // ===========================================================================

  Widget _buildContent() {
    return BlocBuilder<SubcategoriaBloc, SubcategoriaState>(
      builder: (context, state) {
        final response = state.paginatedResponse;

        if (response is Loading) {
          return const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (response is ErrorData<ApiResponse<SubcategoriaPaginated>>) {
          return _buildError(response.displayMessage);
        }

        if (response is Success<ApiResponse<SubcategoriaPaginated>>) {
          final data = response.data.data;

          if (data!.data.isEmpty) {
            return _buildEmpty();
          }

          return Column(
            children: [
              _buildResultHeader(data),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                itemCount: data.data.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _buildSubcategoriaCard(data.data[index]);
                },
              ),

              _buildPagination(data),

              const SizedBox(height: 100),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  // ===========================================================================
  // Resultado
  // ===========================================================================

  Widget _buildResultHeader(SubcategoriaPaginated data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
      child: Row(
        children: [
          Text(
            '${data.total} subcategorías',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Card
  // ===========================================================================

  Widget _buildSubcategoriaCard(SubcategoriaData subcategoria) {
    final categoria = subcategoria.categoria;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(child: Icon(_iconByTipo(categoria?.tipo))),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subcategoria.nombre,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 4),

                      if (categoria != null)
                        Text(
                          categoria.nombre,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'detail':
                        _viewSubcategoria(subcategoria);
                        break;

                      case 'edit':
                        _editSubcategoria(subcategoria);
                        break;

                      case 'estado':
                        _changeEstado(subcategoria);
                        break;

                      case 'delete':
                        _deleteSubcategoria(subcategoria);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'detail',
                      child: ListTile(
                        leading: Icon(Icons.visibility_outlined),
                        title: Text('Ver detalle'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Editar'),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'estado',
                      child: ListTile(
                        leading: Icon(
                          subcategoria.estado
                              ? Icons.toggle_off_outlined
                              : Icons.toggle_on_outlined,
                        ),
                        title: Text(
                          subcategoria.estado ? 'Desactivar' : 'Activar',
                        ),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete_outline),
                        title: Text('Eliminar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            if (subcategoria.descripcion != null) ...[
              const SizedBox(height: 12),
              Text(
                subcategoria.descripcion!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 14),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChip(categoria?.tipo ?? 'SIN TIPO'),

                _buildChip(subcategoria.estado ? 'Activo' : 'Inactivo'),

                _buildChip('Orden ${subcategoria.orden}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String text) {
    return Chip(
      label: Text(text, style: const TextStyle(fontSize: 11)),
      visualDensity: VisualDensity.compact,
    );
  }

  IconData _iconByTipo(String? tipo) {
    switch (tipo) {
      case 'INGRESO':
        return Icons.arrow_downward_rounded;

      case 'EGRESO':
        return Icons.arrow_upward_rounded;

      default:
        return Icons.account_tree_outlined;
    }
  }

  // ===========================================================================
  // Paginación
  // ===========================================================================
  Widget _buildPagination(SubcategoriaPaginated data) {
    final pagination = data;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: pagination.hasPreviousPage
                ? () {
                    setState(() {
                      _page--;
                    });

                    _loadSubcategorias();
                  }
                : null,
  
            icon: const Icon(Icons.chevron_left_rounded),
          ),

          Text(
            'Página ${pagination.page} de ${pagination.totalPages}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),

          IconButton(
            onPressed: pagination.hasNextPage
                ? () {
                    setState(() {
                      _page++;
                    });

                    _loadSubcategorias();
                  }
                : null,
            // onPressed: () {},
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Empty
  // ===========================================================================
  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Column(
        children: [
          Icon(
            Icons.account_tree_outlined,
            size: 60,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 15),
          const Text(
            'No se encontraron subcategorías.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Error
  // ===========================================================================
  Widget _buildError(String message) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 50),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 15),
          FilledButton.icon(
            onPressed: _loadSubcategorias,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Acciones
  // ===========================================================================
  Future<void> _createSubcategoria() async {
    final subcategoriaBloc = context.read<SubcategoriaBloc>();

    final categoriaBloc = context.read<CategoriaBloc>();

    final result = await Navigator.of(context, rootNavigator: true).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<SubcategoriaBloc>.value(value: subcategoriaBloc),
            BlocProvider<CategoriaBloc>.value(value: categoriaBloc),
          ],
          child: SubcategoriaFormDialog(idEmpresa: widget.idEmpresa),
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      _page = 1;
      _loadSubcategorias();
    }
  }

  Future<void> _viewSubcategoria(SubcategoriaData subcategoria) async {
    final subcategoriaBloc = context.read<SubcategoriaBloc>();

    // Limpiar detalle anterior
    subcategoriaBloc.add(const ClearSubcategoriaDetailEvent());

    // Obtener detalle actualizado
    subcategoriaBloc.add(
      GetSubcategoriaByIdEvent(
        idEmpresa: widget.idEmpresa,
        idSubcategoria: subcategoria.idSubcategoria,
      ),
    );

    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => BlocProvider<SubcategoriaBloc>.value(
          value: subcategoriaBloc,
          child: SubcategoriaDetailDialog(
            idEmpresa: widget.idEmpresa,
            idSubcategoria: subcategoria.idSubcategoria,
          ),
        ),
      ),
    );

    if (!mounted) return;

    subcategoriaBloc.add(const ClearSubcategoriaDetailEvent());
  }

  Future<void> _editSubcategoria(SubcategoriaData subcategoria) async {
    final subcategoriaBloc = context.read<SubcategoriaBloc>();

    final categoriaBloc = context.read<CategoriaBloc>();

    final result = await Navigator.of(context, rootNavigator: true).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<SubcategoriaBloc>.value(value: subcategoriaBloc),
            BlocProvider<CategoriaBloc>.value(value: categoriaBloc),
          ],
          child: SubcategoriaFormDialog(
            idEmpresa: widget.idEmpresa,
            subcategoria: subcategoria,
          ),
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      _page = 1;
      _loadSubcategorias();
    }
  }

  void _changeEstado(SubcategoriaData subcategoria) {
    context.read<SubcategoriaBloc>().add(
      ChangeSubcategoriaEstadoEvent(
        idEmpresa: widget.idEmpresa,
        idSubcategoria: subcategoria.idSubcategoria,
        estado: !subcategoria.estado,
      ),
    );
  }

  Future<void> _deleteSubcategoria(SubcategoriaData subcategoria) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar subcategoría'),
          content: Text('¿Deseas eliminar "${subcategoria.nombre}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) {
      return;
    }

    context.read<SubcategoriaBloc>().add(
      DeleteSubcategoriaEvent(
        idEmpresa: widget.idEmpresa,
        idSubcategoria: subcategoria.idSubcategoria,
      ),
    );
  }
}
