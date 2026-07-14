import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_paginated.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
    required this.onDeleteMovimiento,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (idEmpresa == null) {
      return const _ContextoNoDisponible(
        icon: Icons.business_outlined,
        title: 'No hay una empresa activa',
        message:
            'Selecciona una empresa para consultar y registrar movimientos.',
      );
    }

    if (idPeriodo == null) {
      return const _ContextoNoDisponible(
        icon: Icons.calendar_month_outlined,
        title: 'No hay un período activo',
        message:
            'Debes abrir o seleccionar un período contable antes de '
            'registrar movimientos.',
      );
    }

    return BlocBuilder<MovimientoBloc, MovimientoState>(
      buildWhen: (previous, current) {
        return previous.movimientoResponse != current.movimientoResponse ||
            previous.movimientos != current.movimientos ||
            previous.isLoading != current.isLoading ||
            previous.isLoadingMore != current.isLoadingMore ||
            previous.hasMore != current.hasMore ||
            previous.total != current.total ||
            previous.search != current.search ||
            previous.actionResponse != current.actionResponse;
      },
      builder: (context, state) {
        return Stack(
          children: [
            Column(
              children: [
                _MovimientoHeader(total: state.total),

                _MovimientoSearch(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  onClear: onClearSearch,
                ),

                Expanded(child: _buildBody(state)),
              ],
            ),

            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton.extended(
                onPressed: state.actionResponse is Loading
                    ? null
                    : onCreateMovimiento,
                icon: const Icon(Icons.add),
                label: const Text('Nuevo'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(MovimientoState state) {
    if (state.isLoading && state.movimientos.isEmpty) {
      return const _MovimientoLoading();
    }

    if (state.movimientoResponse is ErrorData<MovimientoPaginatedResponse> &&
        state.movimientos.isEmpty) {
      final error =
          state.movimientoResponse as ErrorData<MovimientoPaginatedResponse>;

      return _MovimientoError(message: error.error, onRetry: onRetry);
    }

    if (state.movimientos.isEmpty) {
      return _MovimientoEmpty(
        hasSearch: state.search.trim().isNotEmpty,
        onCreateMovimiento: onCreateMovimiento,
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        itemCount: state.movimientos.length + (state.isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= state.movimientos.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final movimiento = state.movimientos[index];

          return MovimientoCard(
            movimiento: movimiento,
            onTap: () => onMovimientoSelected(movimiento.idMovimiento),
            onDelete: () => onDeleteMovimiento(movimiento.idMovimiento),
          );
        },
      ),
    );
  }
}

// ==========================================================
// HEADER
// ==========================================================
class _MovimientoHeader extends StatelessWidget {
  final int total;

  const _MovimientoHeader({required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Movimientos del período',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '$total movimiento${total == 1 ? '' : 's'} registrado'
                  '${total == 1 ? '' : 's'}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xffEAF6FC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 17,
                  color: Colors.blue,
                ),
                const SizedBox(width: 6),
                Text(
                  'Período activo',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// BUSCADOR
// ==========================================================
class _MovimientoSearch extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _MovimientoSearch({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) {
          return TextField(
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Buscar movimiento...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: value.text.isNotEmpty
                  ? IconButton(
                      onPressed: onClear,
                      icon: const Icon(Icons.close),
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==========================================================
// CARD
// ==========================================================
class MovimientoCard extends StatelessWidget {
  final MovimientoData movimiento;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const MovimientoCard({
    super.key,
    required this.movimiento,
    required this.onTap,
    required this.onDelete,
  });

  bool get isIngreso {
    return movimiento.tipo.toUpperCase() == 'INGRESO';
  }

  String get montoFormateado {
    final formatter = NumberFormat.currency(
      locale: 'es_PE',
      symbol: 'S/ ',
      decimalDigits: 2,
    );

    return formatter.format(movimiento.monto);
  }

  String get fechaFormateada {
    final date = DateTime.tryParse(movimiento.fecha);

    if (date == null) {
      return movimiento.fecha;
    }

    return DateFormat('dd MMM yyyy', 'es_PE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final categoriaNombre = movimiento.categoria?.nombre ?? 'Sin categoría';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isIngreso
                      ? Colors.green.withValues(alpha: 0.12)
                      : Colors.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  isIngreso
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: isIngreso ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movimiento.descripcion,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            categoriaNombre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            '•',
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                        ),
                        Text(
                          fechaFormateada,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isIngreso ? '+' : '-'} $montoFormateado',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isIngreso ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (value) {
                      if (value == 'detalle') {
                        onTap();
                      }

                      if (value == 'eliminar') {
                        onDelete();
                      }
                    },
                    itemBuilder: (_) {
                      return const [
                        PopupMenuItem(
                          value: 'detalle',
                          child: Row(
                            children: [
                              Icon(Icons.visibility_outlined),
                              SizedBox(width: 10),
                              Text('Ver detalle'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'eliminar',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, color: Colors.red),
                              SizedBox(width: 10),
                              Text(
                                'Eliminar',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// LOADING
// ==========================================================
class _MovimientoLoading extends StatelessWidget {
  const _MovimientoLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) {
        return Container(
          height: 82,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }
}

// ==========================================================
// EMPTY
// ==========================================================
class _MovimientoEmpty extends StatelessWidget {
  final bool hasSearch;
  final VoidCallback onCreateMovimiento;

  const _MovimientoEmpty({
    required this.hasSearch,
    required this.onCreateMovimiento,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(30, 70, 30, 120),
        children: [
          Icon(
            hasSearch ? Icons.search_off_rounded : Icons.receipt_long_outlined,
            size: 75,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            hasSearch
                ? 'No se encontraron movimientos'
                : 'Aún no hay movimientos',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(
            hasSearch
                ? 'Prueba con otro término de búsqueda.'
                : 'Registra tu primer ingreso o egreso para comenzar '
                      'a controlar las finanzas del período.',
            textAlign: TextAlign.center,
            style: TextStyle(height: 1.5, color: Colors.grey.shade600),
          ),
          if (!hasSearch) ...[
            const SizedBox(height: 24),
            Center(
              child: FilledButton.icon(
                onPressed: onCreateMovimiento,
                icon: const Icon(Icons.add),
                label: const Text('Registrar movimiento'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==========================================================
// ERROR
// ==========================================================
class _MovimientoError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MovimientoError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 65, color: Colors.red),
            const SizedBox(height: 18),
            const Text(
              'No fue posible cargar los movimientos',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 22),
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

// ==========================================================
// EMPRESA O PERÍODO NO DISPONIBLE
// ==========================================================
class _ContextoNoDisponible extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _ContextoNoDisponible({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 75, color: Colors.blueGrey.shade300),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.5, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
