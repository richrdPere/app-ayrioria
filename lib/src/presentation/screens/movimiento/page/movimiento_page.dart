import 'dart:async';

import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_response.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_event.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_state.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/view/movimiento_content.dart';

import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_event.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MovimientoPage extends StatefulWidget {
  const MovimientoPage({super.key});

  @override
  State<MovimientoPage> createState() => _MovimientoPageState();
}

class _MovimientoPageState extends State<MovimientoPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Timer? _searchDebounce;

  // Evita solicitar varias veces el período activo.
  bool _isLoadingPeriodoActivo = false;

  // ==========================================================
  // EMPRESA ACTIVA
  // ==========================================================
  int? get _idEmpresa {
    return context.read<SessionBloc>().state.empresaActiva?.idEmpresa;
  }

  // ==========================================================
  // PERÍODO CONTABLE ACTIVO
  // ==========================================================
  int? get _idPeriodo {
    return context.read<PeriodoContableBloc>().state.idPeriodoActivo;
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _initializeMovimientos();
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();

    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  // ==========================================================
  // INICIALIZAR MOVIMIENTOS
  // ==========================================================
  void _initializeMovimientos() {
    final int? idEmpresa = _idEmpresa;
    final int? idPeriodo = _idPeriodo;

    if (idEmpresa == null) {
      _showError('No existe una empresa activa.');
      return;
    }

    // El período activo ya se encuentra cargado.
    if (idPeriodo != null) {
      _loadMovimientos(idEmpresa: idEmpresa, idPeriodo: idPeriodo, page: 1);

      return;
    }

    // Si aún no está cargado, solicitamos únicamente el período abierto.
    _loadPeriodoActivo(idEmpresa);
  }

  // ==========================================================
  // CARGAR PERÍODO ACTIVO
  // ==========================================================
  void _loadPeriodoActivo(int idEmpresa) {
    if (_isLoadingPeriodoActivo) {
      return;
    }

    _isLoadingPeriodoActivo = true;

    context.read<PeriodoContableBloc>().add(
      GetPeriodosContablesEvent(
        idEmpresa: idEmpresa,
        page: 1,
        limit: 10,
        estado: 'ABIERTO',
        refresh: true,
      ),
    );
  }

  // ==========================================================
  // CARGAR MOVIMIENTOS
  // ==========================================================
  void _loadMovimientos({
    int? idEmpresa,
    int? idPeriodo,
    int page = 1,
    String? search,
  }) {
    final int? empresaId = idEmpresa ?? _idEmpresa;
    final int? periodoId = idPeriodo ?? _idPeriodo;

    if (empresaId == null || periodoId == null) {
      return;
    }

    context.read<MovimientoBloc>().add(
      GetMovimientosEvent(
        idEmpresa: empresaId,
        idPeriodo: periodoId,
        page: page,
        limit: 10,
        search: search ?? _searchController.text.trim(),
      ),
    );
  }

  // ==========================================================
  // PAGINACIÓN
  // ==========================================================
  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final ScrollPosition position = _scrollController.position;

    if (position.pixels < position.maxScrollExtent - 200) {
      return;
    }

    final MovimientoState state = context.read<MovimientoBloc>().state;

    if (state.isLoading ||
        state.isLoadingMore ||
        !state.hasMore ||
        state.idEmpresa == null ||
        state.idPeriodo == null) {
      return;
    }

    context.read<MovimientoBloc>().add(
      GetMovimientosEvent(
        idEmpresa: state.idEmpresa!,
        idPeriodo: state.idPeriodo!,
        page: state.page + 1,
        limit: state.limit,
        search: state.search,
      ),
    );
  }

  // ==========================================================
  // BUSCADOR
  // ==========================================================
  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      final int? idEmpresa = _idEmpresa;
      final int? idPeriodo = _idPeriodo;

      if (idEmpresa == null || idPeriodo == null) {
        return;
      }

      context.read<MovimientoBloc>().add(
        SearchMovimientosEvent(
          idEmpresa: idEmpresa,
          idPeriodo: idPeriodo,
          search: value.trim(),
        ),
      );
    });
  }

  void _clearSearch() {
    _searchController.clear();

    final int? idEmpresa = _idEmpresa;
    final int? idPeriodo = _idPeriodo;

    if (idEmpresa == null || idPeriodo == null) {
      return;
    }

    context.read<MovimientoBloc>().add(
      SearchMovimientosEvent(
        idEmpresa: idEmpresa,
        idPeriodo: idPeriodo,
        search: '',
      ),
    );
  }

  // ==========================================================
  // REFRESCAR
  // ==========================================================
  Future<void> _onRefresh() async {
    final int? idEmpresa = _idEmpresa;
    final int? idPeriodo = _idPeriodo;

    if (idEmpresa == null || idPeriodo == null) {
      return;
    }

    final MovimientoBloc bloc = context.read<MovimientoBloc>();

    final Future<MovimientoState> refreshCompleted = bloc.stream.firstWhere(
      (state) => !state.isLoading && !state.isLoadingMore,
    );

    bloc.add(
      RefreshMovimientosEvent(
        idEmpresa: idEmpresa,
        idPeriodo: idPeriodo,
        search: _searchController.text.trim(),
      ),
    );

    await refreshCompleted;
  }

  // ==========================================================
  // CREAR MOVIMIENTO
  // ==========================================================
  Future<void> _onCreateMovimiento() async {
    final int? idEmpresa = _idEmpresa;
    final int? idPeriodo = _idPeriodo;

    if (idEmpresa == null) {
      _showError('Debes seleccionar una empresa.');
      return;
    }

    if (idPeriodo == null) {
      _showError('Debes tener un período contable abierto.');
      return;
    }

    final bool? result = await context.push<bool>(
      '/movimientos/crear',
      extra: {'idEmpresa': idEmpresa, 'idPeriodo': idPeriodo},
    );

    if (!mounted) {
      return;
    }

    if (result == true) {
      _loadMovimientos(page: 1);
    }
  }

  // ==========================================================
  // VER DETALLE
  // ==========================================================
  Future<void> _onMovimientoSelected(int idMovimiento) async {
    final bool? result = await context.push<bool>('/movimientos/$idMovimiento');

    if (!mounted) {
      return;
    }

    if (result == true) {
      _loadMovimientos(page: 1);
    }
  }

  // ==========================================================
  // ELIMINAR
  // ==========================================================
  Future<void> _onDeleteMovimiento(int idMovimiento) async {
    final int? idEmpresa = _idEmpresa;
    final int? idPeriodo = _idPeriodo;

    if (idEmpresa == null || idPeriodo == null) {
      _showError('No existe una empresa o período contable activo.');
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar movimiento'),
          content: const Text(
            '¿Estás seguro de eliminar este movimiento? '
            'Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    context.read<MovimientoBloc>().add(
      DeleteMovimientoEvent(
        idMovimiento: idMovimiento,
        idEmpresa: idEmpresa,
        idPeriodo: idPeriodo,
      ),
    );
  }

  // ==========================================================
  // MENSAJES
  // ==========================================================
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
    final int? idEmpresa = context.select<SessionBloc, int?>(
      (bloc) => bloc.state.empresaActiva?.idEmpresa,
    );

    final int? idPeriodo = context.select<PeriodoContableBloc, int?>(
      (bloc) => bloc.state.idPeriodoActivo,
    );

    return MultiBlocListener(
      listeners: [
        // ======================================================
        // ESCUCHAR PERÍODO CONTABLE ACTIVO
        // ======================================================
        BlocListener<PeriodoContableBloc, PeriodoContableState>(
          listenWhen: (previous, current) {
            return previous.response != current.response ||
                previous.idPeriodoActivo != current.idPeriodoActivo;
          },
          listener: (context, state) {
            final Resource? response = state.response;

            if (response is Loading) {
              return;
            }

            _isLoadingPeriodoActivo = false;

            if (response is Success) {
              final int? empresaId = _idEmpresa;
              final int? periodoId = state.idPeriodoActivo;

              if (empresaId == null) {
                _showError('No existe una empresa activa.');
                return;
              }

              if (periodoId == null) {
                _showError(
                  'No existe un período contable abierto para esta empresa.',
                );
                return;
              }

              _loadMovimientos(
                idEmpresa: empresaId,
                idPeriodo: periodoId,
                page: 1,
              );
            }

            if (response is ErrorData) {
              _showError(response.error);
            }
          },
        ),

        // ======================================================
        // ESCUCHAR ACCIONES DE MOVIMIENTOS
        // ======================================================
        BlocListener<MovimientoBloc, MovimientoState>(
          listenWhen: (previous, current) {
            return previous.actionResponse != current.actionResponse;
          },
          listener: (context, state) {
            final Resource<MovimientoResponse>? response = state.actionResponse;

            if (response is Success<MovimientoResponse>) {
              final String message = response.data.message.isNotEmpty
                  ? response.data.message
                  : 'Operación realizada correctamente.';

              _showSuccess(message);

              context.read<MovimientoBloc>().add(
                const ClearMovimientoActionResponseEvent(),
              );
            }

            if (response is ErrorData<MovimientoResponse>) {
              _showError(response.error);

              context.read<MovimientoBloc>().add(
                const ClearMovimientoActionResponseEvent(),
              );
            }
          },
        ),
      ],
      child: MovimientoContent(
        idEmpresa: idEmpresa,
        idPeriodo: idPeriodo,
        searchController: _searchController,
        scrollController: _scrollController,
        onSearchChanged: _onSearchChanged,
        onClearSearch: _clearSearch,
        onRefresh: _onRefresh,
        onCreateMovimiento: _onCreateMovimiento,
        onMovimientoSelected: _onMovimientoSelected,
        onDeleteMovimiento: _onDeleteMovimiento,
        onRetry: () {
          if (_idPeriodo != null) {
            _loadMovimientos(page: 1);
          } else if (_idEmpresa != null) {
            _loadPeriodoActivo(_idEmpresa!);
          }
        },
      ),
    );
  }
}
