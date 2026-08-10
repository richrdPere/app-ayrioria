import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Models
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_data.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_query_params.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Categoria Bloc
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_state.dart';

// Subcategoria Bloc
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_event.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_state.dart';

// Widgets globales
import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_module_header.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_paginated_list.dart';

class SubcategoriaContent extends StatefulWidget {
  final int idEmpresa;

  const SubcategoriaContent({super.key, required this.idEmpresa});

  @override
  State<SubcategoriaContent> createState() => _SubcategoriaContentState();
}

class _SubcategoriaContentState extends State<SubcategoriaContent> {
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;

  String? _tipoSeleccionado;
  bool? _estadoSeleccionado;
  int? _idCategoriaSeleccionada;

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
  // CONSTRUIR PARAMS
  // ==========================================================
  SubcategoriasParams _buildParams({required int page, int? limit}) {
    final String search = _searchController.text.trim();

    return SubcategoriasParams(
      page: page,
      limit: limit ?? 10,
      search: search.isEmpty ? null : search,
      tipo: _tipoSeleccionado,
      estado: _estadoSeleccionado,
      idCategoria: _idCategoriaSeleccionada,
    );
  }

  // ==========================================================
  // CARGAR SUBCATEGORÍAS
  // ==========================================================
  void _loadSubcategorias({int page = 1, int? limit, bool refresh = false}) {
    context.read<SubcategoriaBloc>().add(
      GetSubcategoriasPaginatedEvent(
        idEmpresa: widget.idEmpresa,
        queryParams: _buildParams(page: page, limit: limit),
        refresh: refresh,
      ),
    );
  }

  // ==========================================================
  // SEARCH
  // ==========================================================
  void _onSearchChanged(String value) {
    setState(() {});

    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) {
        return;
      }

      _loadSubcategorias(page: 1, refresh: true);
    });
  }

  void _clearSearch() {
    _debounce?.cancel();

    _searchController.clear();

    setState(() {});

    _loadSubcategorias(page: 1, refresh: true);
  }

  // ==========================================================
  // FILTRO TIPO
  // ==========================================================
  void _onTipoChanged(String? value) {
    setState(() {
      _tipoSeleccionado = value;
    });

    _loadSubcategorias(page: 1, refresh: true);
  }

  // ==========================================================
  // FILTRO ESTADO
  // ==========================================================
  void _onEstadoChanged(bool? value) {
    setState(() {
      _estadoSeleccionado = value;
    });

    _loadSubcategorias(page: 1, refresh: true);
  }

  // ==========================================================
  // FILTRO CATEGORÍA
  // ==========================================================
  void _onCategoriaChanged(int? idCategoria) {
    setState(() {
      _idCategoriaSeleccionada = idCategoria;
    });

    _loadSubcategorias(page: 1, refresh: true);
  }

  // ==========================================================
  // LIMPIAR FILTROS
  // ==========================================================
  void _clearFilters() {
    _debounce?.cancel();

    setState(() {
      _searchController.clear();
      _tipoSeleccionado = null;
      _estadoSeleccionado = null;
      _idCategoriaSeleccionada = null;
    });

    _loadSubcategorias(page: 1, refresh: true);
  }

  bool get _hasFilters {
    return _searchController.text.trim().isNotEmpty ||
        _tipoSeleccionado != null ||
        _estadoSeleccionado != null ||
        _idCategoriaSeleccionada != null;
  }

  // ==========================================================
  // PAGINACIÓN
  // ==========================================================
  void _onNextPage() {
    final state = context.read<SubcategoriaBloc>().state;

    if (state.isLoadingMore || !state.hasNextPage) {
      return;
    }

    _loadSubcategorias(page: state.page + 1, limit: state.limit);
  }

  void _onPreviousPage() {
    final state = context.read<SubcategoriaBloc>().state;

    if (state.isLoadingMore || !state.hasPreviousPage) {
      return;
    }

    _loadSubcategorias(page: state.page - 1, limit: state.limit);
  }

  Future<void> _onRefresh() async {
    _loadSubcategorias(page: 1, refresh: true);
  }

  // ==========================================================
  // FULL SCREEN - CREAR
  // ==========================================================
  Future<void> _createSubcategoria() async {
    final result = await context.push('/subcategorias/crear');

    if (!mounted) {
      return;
    }

    if (result == true) {
      _loadSubcategorias(page: 1, refresh: true);
    }
  }

  // ==========================================================
  // FULL SCREEN - DETALLE
  // ==========================================================
  Future<void> _viewSubcategoria(SubcategoriaData subcategoria) async {
    final result = await context.push(
      '/subcategorias/${subcategoria.idSubcategoria}',
    );

    if (!mounted) {
      return;
    }

    if (result == true) {
      final state = context.read<SubcategoriaBloc>().state;

      _loadSubcategorias(page: state.page, limit: state.limit, refresh: true);
    }
  }

  // ==========================================================
  // FULL SCREEN - EDITAR
  // ==========================================================
  Future<void> _editSubcategoria(SubcategoriaData subcategoria) async {
    final result = await context.push(
      '/subcategorias/${subcategoria.idSubcategoria}/editar',
    );

    if (!mounted) {
      return;
    }

    if (result == true) {
      final state = context.read<SubcategoriaBloc>().state;

      _loadSubcategorias(page: state.page, limit: state.limit, refresh: true);
    }
  }

  // ==========================================================
  // CAMBIAR ESTADO
  // ==========================================================
  Future<void> _changeEstado(SubcategoriaData subcategoria) async {
    final bool nuevoEstado = !subcategoria.estado;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            nuevoEstado ? 'Activar subcategoría' : 'Desactivar subcategoría',
          ),
          content: Text(
            nuevoEstado
                ? '¿Deseas activar "${subcategoria.nombre}"?'
                : '¿Deseas desactivar "${subcategoria.nombre}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: Text(nuevoEstado ? 'Activar' : 'Desactivar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    context.read<SubcategoriaBloc>().add(
      ChangeSubcategoriaEstadoEvent(
        idEmpresa: widget.idEmpresa,
        idSubcategoria: subcategoria.idSubcategoria,
        estado: nuevoEstado,
      ),
    );
  }

  // ==========================================================
  // ELIMINAR
  // ==========================================================
  Future<void> _deleteSubcategoria(SubcategoriaData subcategoria) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 10),
              Expanded(child: Text('Eliminar subcategoría')),
            ],
          ),
          content: Text(
            '¿Estás seguro de eliminar '
            '"${subcategoria.nombre}"?\n\n'
            'Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    context.read<SubcategoriaBloc>().add(
      DeleteSubcategoriaEvent(
        idEmpresa: widget.idEmpresa,
        idSubcategoria: subcategoria.idSubcategoria,
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcategoriaBloc, SubcategoriaState>(
      builder: (context, state) {
        final bool existen = state.subcategorias.isNotEmpty;

        return Scaffold(
          body: Column(
            children: [
              // =================================================
              // HEADER GLOBAL
              // =================================================
              const AppModuleHeader(
                icon: Icons.account_tree_outlined,
                title: 'Gestiona tus subcategorías',
                description:
                    'Organiza tus categorías en conceptos más específicos para clasificar mejor tus movimientos.',
              ),

              // =================================================
              // FILTROS
              // =================================================
              if (existen || _hasFilters) _buildFilters(),

              // =================================================
              // CONTENT
              // =================================================
              Expanded(child: _buildBody(state)),
            ],
          ),

          // =====================================================
          // CREAR
          // =====================================================
          floatingActionButton: existen
              ? FloatingActionButton.extended(
                  onPressed: _createSubcategoria,
                  icon: const Icon(Icons.add),
                  label: const Text('Nueva'),
                )
              : null,
        );
      },
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
                  onChanged: _onSearchChanged,
                  onSubmitted: (_) {
                    _debounce?.cancel();

                    _loadSubcategorias(page: 1, refresh: true);
                  },
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Buscar subcategoría...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
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
              // MÁS FILTROS
              // =================================================
              PopupMenuButton<String>(
                tooltip: 'Filtros',
                onSelected: (value) {
                  switch (value) {
                    case 'todos':
                      _clearFilters();
                      break;

                    case 'ingreso':
                      _onTipoChanged('INGRESO');
                      break;

                    case 'egreso':
                      _onTipoChanged('EGRESO');
                      break;

                    case 'activos':
                      _onEstadoChanged(true);
                      break;

                    case 'inactivos':
                      _onEstadoChanged(false);
                      break;
                  }
                },
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem(
                      value: 'todos',
                      child: Text('Limpiar filtros'),
                    ),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'ingreso',
                      child: Text('Tipo: Ingreso'),
                    ),
                    PopupMenuItem(value: 'egreso', child: Text('Tipo: Egreso')),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'activos',
                      child: Text('Solo activos'),
                    ),
                    PopupMenuItem(
                      value: 'inactivos',
                      child: Text('Solo inactivos'),
                    ),
                  ];
                },
                child: _FilterButton(
                  active:
                      _tipoSeleccionado != null ||
                      _estadoSeleccionado != null ||
                      _idCategoriaSeleccionada != null,
                ),
              ),
            ],
          ),

          // ====================================================
          // FILTRO CATEGORÍA
          // ====================================================
          const SizedBox(height: 10),

          _buildCategoriaFilter(),

          // ====================================================
          // CHIPS ACTIVOS
          // ====================================================
          if (_tipoSeleccionado != null ||
              _estadoSeleccionado != null ||
              _idCategoriaSeleccionada != null) ...[
            const SizedBox(height: 10),
            _buildActiveFilters(),
          ],
        ],
      ),
    );
  }

  // ==========================================================
  // SELECT CATEGORÍA
  // ==========================================================
  Widget _buildCategoriaFilter() {
    return BlocBuilder<CategoriaBloc, CategoriaState>(
      builder: (context, categoriaState) {
        final categorias = categoriaState.categorias;

        return DropdownButtonFormField<int?>(
          value: _idCategoriaSeleccionada,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Categoría',
            prefixIcon: const Icon(Icons.category_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
          items: [
            const DropdownMenuItem<int?>(
              value: null,
              child: Text('Todas las categorías'),
            ),
            ...categorias.map((categoria) {
              return DropdownMenuItem<int?>(
                value: categoria.idCategoria,
                child: Text(
                  categoria.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
          ],
          onChanged: _onCategoriaChanged,
        );
      },
    );
  }

  // ==========================================================
  // FILTROS ACTIVOS
  // ==========================================================
  Widget _buildActiveFilters() {
    return Align(
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
                _estadoSeleccionado == true ? 'Activos' : 'Inactivos',
              ),
              onDeleted: () {
                _onEstadoChanged(null);
              },
            ),

          if (_idCategoriaSeleccionada != null)
            InputChip(
              label: const Text('Categoría'),
              onDeleted: () {
                _onCategoriaChanged(null);
              },
            ),
        ],
      ),
    );
  }

  // ==========================================================
  // BODY
  // ==========================================================
  Widget _buildBody(SubcategoriaState state) {
    final Resource? response = state.response;

    // ========================================================
    // LOADING
    // ========================================================
    if (response is Loading && state.subcategorias.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // ========================================================
    // ERROR
    // ========================================================
    if (response is ErrorData && state.subcategorias.isEmpty) {
      return _SubcategoriaError(
        message: _getErrorMessage(response),
        onRetry: () {
          _loadSubcategorias(page: 1, refresh: true);
        },
      );
    }

    // ========================================================
    // EMPTY
    // ========================================================
    if (state.subcategorias.isEmpty) {
      return _SubcategoriaEmpty(
        hasFilters: _hasFilters,
        onCreate: _createSubcategoria,
        onClearFilters: _clearFilters,
      );
    }

    // ========================================================
    // LIST
    // ========================================================
    return AppPaginatedList<SubcategoriaData>(
      items: state.subcategorias,
      limit: state.limit,
      page: state.page,
      totalPages: state.totalPages,
      totalItems: state.total,
      isLoading: state.response is Loading,
      isLoadingMore: state.isLoadingMore,
      onRefresh: _onRefresh,
      onPreviousPage: state.hasPreviousPage ? _onPreviousPage : null,
      onNextPage: state.hasNextPage ? _onNextPage : null,
      itemBuilder: (context, subcategoria, index) {
        return _buildSubcategoriaCard(subcategoria);
      },
    );
  }

  // ==========================================================
  // CARD
  // ==========================================================
  Widget _buildSubcategoriaCard(SubcategoriaData subcategoria) {
    final categoria = subcategoria.categoria;

    final Color categoryColor = _parseColor(categoria?.color);

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: () {
          _viewSubcategoria(subcategoria);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ============================================
                  // ICONO
                  // ============================================
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: categoryColor.withValues(alpha: 0.12),
                    child: Icon(
                      _iconByTipo(categoria?.tipo),
                      color: categoryColor,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // ============================================
                  // NOMBRE / CATEGORÍA
                  // ============================================
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subcategoria.nombre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        if (categoria != null)
                          Text(
                            categoria.nombre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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

                  // ============================================
                  // OPCIONES
                  // ============================================
                  PopupMenuButton<_SubcategoriaAction>(
                    tooltip: 'Opciones',
                    onSelected: (value) {
                      switch (value) {
                        case _SubcategoriaAction.detail:
                          _viewSubcategoria(subcategoria);
                          break;

                        case _SubcategoriaAction.edit:
                          _editSubcategoria(subcategoria);
                          break;

                        case _SubcategoriaAction.estado:
                          _changeEstado(subcategoria);
                          break;

                        case _SubcategoriaAction.delete:
                          _deleteSubcategoria(subcategoria);
                          break;
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        const PopupMenuItem(
                          value: _SubcategoriaAction.detail,
                          child: _PopupOption(
                            icon: Icons.visibility_outlined,
                            label: 'Ver detalle',
                          ),
                        ),

                        const PopupMenuItem(
                          value: _SubcategoriaAction.edit,
                          child: _PopupOption(
                            icon: Icons.edit_outlined,
                            label: 'Editar',
                          ),
                        ),

                        PopupMenuItem(
                          value: _SubcategoriaAction.estado,
                          child: _PopupOption(
                            icon: subcategoria.estado
                                ? Icons.toggle_off_outlined
                                : Icons.toggle_on_outlined,
                            label: subcategoria.estado
                                ? 'Desactivar'
                                : 'Activar',
                          ),
                        ),

                        const PopupMenuDivider(),

                        const PopupMenuItem(
                          value: _SubcategoriaAction.delete,
                          child: _PopupOption(
                            icon: Icons.delete_outline,
                            label: 'Eliminar',
                            danger: true,
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),

              // ================================================
              // DESCRIPCIÓN
              // ================================================
              if (subcategoria.descripcion?.trim().isNotEmpty == true) ...[
                const SizedBox(height: 12),
                Text(
                  subcategoria.descripcion!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],

              const SizedBox(height: 14),

              // ================================================
              // CHIPS
              // ================================================
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildChip(
                    context,
                    categoria?.tipo ?? 'SIN TIPO',
                    type: _ChipType.tipo,
                  ),

                  if (subcategoria.naturaleza != null)
                    _buildChip(context, subcategoria.naturaleza!),

                  _buildChip(
                    context,
                    subcategoria.estado ? 'Activo' : 'Inactivo',
                    type: subcategoria.estado
                        ? _ChipType.active
                        : _ChipType.inactive,
                  ),

                  _buildChip(context, 'Orden ${subcategoria.orden}'),

                  if (subcategoria.esPredeterminada)
                    _buildChip(context, 'Predeterminada'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // CHIP
  // ==========================================================
  Widget _buildChip(
    BuildContext context,
    String label, {
    _ChipType type = _ChipType.normal,
  }) {
    Color background;
    Color foreground;

    final scheme = Theme.of(context).colorScheme;

    switch (type) {
      case _ChipType.tipo:
        final bool ingreso = label.toUpperCase() == 'INGRESO';

        background = ingreso
            ? Colors.green.withValues(alpha: 0.12)
            : Colors.red.withValues(alpha: 0.12);

        foreground = ingreso ? Colors.green.shade700 : Colors.red.shade700;
        break;

      case _ChipType.active:
        background = Colors.green.withValues(alpha: 0.10);
        foreground = Colors.green.shade700;
        break;

      case _ChipType.inactive:
        background = Colors.grey.withValues(alpha: 0.15);
        foreground = Colors.grey.shade700;
        break;

      case _ChipType.normal:
        background = scheme.secondaryContainer;
        foreground = scheme.onSecondaryContainer;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }

  // ==========================================================
  // ICONO SEGÚN TIPO
  // ==========================================================
  IconData _iconByTipo(String? tipo) {
    switch (tipo?.trim().toUpperCase()) {
      case 'INGRESO':
        return Icons.south_west_rounded;

      case 'EGRESO':
        return Icons.north_east_rounded;

      default:
        return Icons.account_tree_outlined;
    }
  }

  // ==========================================================
  // COLOR
  // ==========================================================
  Color _parseColor(String? hexColor) {
    if (hexColor == null || hexColor.trim().isEmpty) {
      return Theme.of(context).colorScheme.primary;
    }

    try {
      String clean = hexColor.trim().replaceAll('#', '');

      if (clean.length == 6) {
        clean = 'FF$clean';
      }

      if (clean.length != 8) {
        return Theme.of(context).colorScheme.primary;
      }

      return Color(int.parse(clean, radix: 16));
    } catch (_) {
      return Theme.of(context).colorScheme.primary;
    }
  }

  String _getErrorMessage(ErrorData response) {
    final dynamic error = response.error;

    if (error != null && error.toString().trim().isNotEmpty) {
      return error.toString();
    }

    return 'No se pudieron obtener las subcategorías.';
  }
}

// ==========================================================
// ENUM MENU
// ==========================================================
enum _SubcategoriaAction { detail, edit, estado, delete }

// ==========================================================
// CHIP TYPE
// ==========================================================
enum _ChipType { normal, tipo, active, inactive }

// ==========================================================
// POPUP OPTION
// ==========================================================
class _PopupOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool danger;

  const _PopupOption({
    required this.icon,
    required this.label,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = danger
        ? Colors.red.shade600
        : Theme.of(context).colorScheme.onSurface;

    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}

// ==========================================================
// FILTER BUTTON
// ==========================================================
class _FilterButton extends StatelessWidget {
  final bool active;

  const _FilterButton({required this.active});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(Icons.filter_list),

          if (active)
            Positioned(
              top: 9,
              right: 9,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: scheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ==========================================================
// EMPTY
// ==========================================================
class _SubcategoriaEmpty extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback onCreate;
  final VoidCallback onClearFilters;

  const _SubcategoriaEmpty({
    required this.hasFilters,
    required this.onCreate,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasFilters
                  ? Icons.search_off_outlined
                  : Icons.account_tree_outlined,
              size: 68,
              color: Colors.grey,
            ),

            const SizedBox(height: 16),

            Text(
              hasFilters
                  ? 'No encontramos resultados'
                  : 'Aún no tienes subcategorías',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              hasFilters
                  ? 'Prueba modificando o eliminando los filtros.'
                  : 'Crea una subcategoría para clasificar con mayor detalle tus movimientos.',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 22),

            if (hasFilters)
              OutlinedButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.filter_alt_off_outlined),
                label: const Text('Limpiar filtros'),
              )
            else
              FilledButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add),
                label: const Text('Nueva subcategoría'),
              ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// ERROR
// ==========================================================
class _SubcategoriaError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _SubcategoriaError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 68, color: Colors.red),

            const SizedBox(height: 16),

            const Text(
              'No se pudieron cargar las subcategorías',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(message, textAlign: TextAlign.center),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
