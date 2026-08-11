import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_sumary_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Modelos
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_paginated.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_query_params.dart';

// BloC's
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_event.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_state.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/view/widgets/movimiento_card.dart';
// import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_bloc.dart';

// Defaults
import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_context_unavailable.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_empty_state.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_error_state.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_list_loading.dart';
// import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_list_sumary_header.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_module_header.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_paginated_list.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/defaultds/app_search_filter_option.dart';

class MovimientoContent extends StatelessWidget {
  final int? idEmpresa;
  final int? idPeriodo;

  final TextEditingController searchController;
  final ScrollController scrollController;

  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final Future<void> Function() onRefresh;

  final VoidCallback onCreateMovimiento;
  final ValueChanged<int> onMovimientoSelected;
  final ValueChanged<int> onEditMovimiento;
  final ValueChanged<int> onDeleteMovimiento;

  final VoidCallback onRetry;

  const MovimientoContent({
    super.key,
    required this.idEmpresa,
    required this.idPeriodo,
    required this.searchController,
    required this.scrollController,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onRefresh,
    required this.onCreateMovimiento,
    required this.onMovimientoSelected,
    required this.onEditMovimiento,
    required this.onDeleteMovimiento,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    // ==========================================================
    // EMPRESA NO DISPONIBLE
    // ==========================================================
    if (idEmpresa == null) {
      return const AppContextUnavailable(
        icon: Icons.business_outlined,
        title: 'No hay una empresa activa',
        message:
            'Selecciona una empresa para consultar y registrar movimientos.',
      );
    }

    // ==========================================================
    // PERÍODO NO DISPONIBLE
    // ==========================================================
    if (idPeriodo == null) {
      return AppContextUnavailable(
        icon: Icons.calendar_month_outlined,
        title: 'No hay un período activo',
        message:
            'Debes abrir o seleccionar un período contable antes de '
            'registrar movimientos.',
        buttonText: 'Ir a períodos contables',
        buttonIcon: Icons.calendar_month_outlined,
        onPressed: () {
          context.pushNamed('periodos_contables');
        },
      );
    }

    // ==========================================================
    // MOVIMIENTOS
    // ==========================================================
    return BlocBuilder<MovimientoBloc, MovimientoState>(
      buildWhen: (previous, current) {
        return previous.movimientoResponse != current.movimientoResponse ||
            previous.movimientos != current.movimientos ||
            previous.isLoading != current.isLoading ||
            // previous.isLoadingMore != current.isLoadingMore ||
            // previous.hasMore != current.hasMore ||
            previous.total != current.total ||
            previous.queryParams != current.queryParams ||
            previous.actionResponse != current.actionResponse;
      },
      builder: (context, state) {
        final bool existenMovimientos = state.total > 0;

        final bool hayBusquedaActiva =
            searchController.text.trim().isNotEmpty || state.hasSearch;

        final bool mostrarHerramientas =
            existenMovimientos || hayBusquedaActiva;

        // final String? periodoNombre = context
        //     .select<PeriodoContableBloc, String?>(
        //       (bloc) => bloc.state.periodoActivo?.nombre,
        //     );

        return Stack(
          children: [
            Column(
              children: [
                // ==================================================
                // CABECERA
                // ==================================================
                const AppModuleHeader(
                  icon: Icons.receipt_long_outlined,
                  title: 'Controla tus operaciones',
                  description:
                      'Registra y administra los ingresos y egresos '
                      'de tu empresa.',
                ),

                // ==================================================
                // TOTAL + BÚSQUEDA
                // ==================================================
                if (mostrarHerramientas) ...[
                  // _MovimientoHeader(total: state.total),
                  // AppListSummaryHeader(
                  //   title: 'Movimientos del período',
                  //   total: state.total,
                  //   itemSingular: 'movimiento',
                  //   itemPlural: 'movimientos',
                  //   periodoNombre: periodoNombre,
                  // ),
                  AppSearchFilterBar<String>(
                    controller: searchController,
                    hintText: 'Buscar movimiento...',

                    selectedFilter: state.estado,

                    onSearch: onSearchChanged,

                    onFilterChanged: (estado) {
                      final updatedParams = state.queryParams.copyWith(
                        page: 1,

                        // Si tiene valor lo asigna.
                        estado: estado,

                        // Si seleccionó "Todos", lo elimina.
                        clearEstado: estado == null,
                      );

                      context.read<MovimientoBloc>().add(
                        GetMovimientosEvent(
                          idEmpresa: idEmpresa!,
                          queryParams: updatedParams,
                        ),
                      );
                    },

                    filterTooltip: 'Filtrar por estado',

                    filterOptions: const [
                      AppSearchFilterOption<String>(
                        value: null,
                        label: 'Todos los estados',
                      ),
                      AppSearchFilterOption<String>(
                        value: 'PAGADO',
                        label: 'Pagados',
                      ),
                      AppSearchFilterOption<String>(
                        value: 'PENDIENTE',
                        label: 'Pendientes',
                      ),
                      AppSearchFilterOption<String>(
                        value: 'ANULADO',
                        label: 'Anulados',
                      ),
                    ],
                  ),

                  AppSummaryChip(
                    total: state.total,
                    singularLabel: 'movimiento',
                    pluralLabel: 'movimientos',
                    icon: Icons.receipt_long_outlined,
                    isSearching: false,
                    search: '',
                  ),
                ],

                // ==================================================
                // CONTENIDO
                // ==================================================
                // Expanded(child: _buildBody(state)),
                Expanded(child: _buildBody(context, state)),
              ],
            ),

            // ==================================================
            // FAB - Crear movimiento
            // ==================================================
            if (existenMovimientos)
              Positioned(
                right: 20,
                bottom: 20,
                child: SafeArea(
                  minimum: const EdgeInsets.only(bottom: 8),
                  child: FloatingActionButton.extended(
                    onPressed: state.actionResponse is Loading
                        ? null
                        : onCreateMovimiento,
                    icon: const Icon(Icons.add),
                    label: const Text('Nuevo'),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // BODY
  // ==========================================================
  Widget _buildBody(BuildContext context, MovimientoState state) {
    // ========================================================
    // LOADING INICIAL
    // ========================================================
    if (state.isLoading && state.movimientos.isEmpty) {
      return const AppListLoading();
    }

    // ========================================================
    // ERROR
    // ========================================================
    if (state.movimientoResponse
            is ErrorData<ApiResponse<MovimientoPaginated>> &&
        state.movimientos.isEmpty) {
      final error =
          state.movimientoResponse
              as ErrorData<ApiResponse<MovimientoPaginated>>;

      return AppErrorState(
        title: 'No fue posible cargar los movimientos',
        message: error.displayMessage,
        onRetry: onRetry,
      );
    }

    // ========================================================
    // EMPTY
    // ========================================================

    if (state.movimientos.isEmpty) {
      final bool hasFilters =
          state.hasSearch ||
          state.tipo != null ||
          state.estado != null ||
          state.idCategoria != null ||
          state.idSubcategoria != null ||
          state.idCuenta != null ||
          state.fechaInicio != null ||
          state.fechaFin != null;

      return AppEmptyState(
        hasFilters: hasFilters,

        // Sin movimientos
        emptyIcon: Icons.receipt_long_outlined,
        emptyTitle: 'Aún no tienes movimientos',
        emptyMessage:
            'Registra tu primer ingreso o egreso para comenzar '
            'a llevar el control de tus operaciones.',

        // Filtros sin resultados
        filteredTitle: 'No se encontraron movimientos',
        filteredMessage:
            'Prueba cambiando el texto de búsqueda o los filtros aplicados.',

        createLabel: 'Registrar movimiento',

        onCreate: onCreateMovimiento,

        onClearFilters: () {
          _clearFilters(context, state);
        },
      );
    }

    // ========================================================
    // LISTADO
    // ========================================================
    return AppPaginatedList<MovimientoData>(
      items: state.movimientos,
      limit: state.limit,
      page: state.page,
      totalPages: state.totalPages,
      totalItems: state.total,
      isLoadingMore: false,
      isLoading: state.isLoading,
      scrollController: scrollController,
      onRefresh: onRefresh,
      onPreviousPage: state.canGoPrevious
          ? () {
              _goToPage(context, state, state.page - 1);
            }
          : null,

      onNextPage: state.canGoNext
          ? () {
              _goToPage(context, state, state.page + 1);
            }
          : null,

      itemBuilder: (context, movimiento, index) {
        return MovimientoCard(
          movimiento: movimiento,

          onTap: () {
            onMovimientoSelected(movimiento.idMovimiento);
          },

          onEdit: () {
            onEditMovimiento(movimiento.idMovimiento);
          },

          onDelete: () {
            onDeleteMovimiento(movimiento.idMovimiento);
          },
        );
      },
    );
  }

  void _goToPage(BuildContext context, MovimientoState state, int page) {
    if (idEmpresa == null) {
      return;
    }

    final updatedParams = state.queryParams.copyWith(page: page);

    context.read<MovimientoBloc>().add(
      GetMovimientosEvent(idEmpresa: idEmpresa!, queryParams: updatedParams),
    );
  }

  void _clearFilters(BuildContext context, MovimientoState state) {
    final int? empresaId = idEmpresa;
    final int? periodoId = idPeriodo;

    if (empresaId == null || periodoId == null) {
      return;
    }

    // ========================================================
    // LIMPIAR TEXTFIELD
    // ========================================================

    searchController.clear();

    // ========================================================
    // RECONSTRUIR QUERY SIN FILTROS
    // ========================================================

    final queryParams = MovimientoQueryParams(
      page: 1,
      limit: state.limit,
      idPeriodo: periodoId,
    );

    // ========================================================
    // RECARGAR
    // ========================================================
    context.read<MovimientoBloc>().add(
      GetMovimientosEvent(idEmpresa: empresaId, queryParams: queryParams),
    );
  }
}
