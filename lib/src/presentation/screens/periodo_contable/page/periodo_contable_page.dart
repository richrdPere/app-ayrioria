import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_event.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_state.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/view/periodo_contable_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PeriodoContablePage extends StatefulWidget {
  const PeriodoContablePage({super.key});

  @override
  State<PeriodoContablePage> createState() => _PeriodoContablePageState();
}

class _PeriodoContablePageState extends State<PeriodoContablePage> {
  final TextEditingController _searchController = TextEditingController();

  String? _estadoSeleccionado;

  int? get _idEmpresa {
    return context.read<SessionBloc>().state.empresaActiva?.idEmpresa;
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(_loadPeriodos);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ==========================================================
  // CARGAR PERÍODOS
  // ==========================================================
  void _loadPeriodos({int page = 1, bool refresh = false}) {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      return;
    }

    context.read<PeriodoContableBloc>().add(
      GetPeriodosContablesEvent(
        idEmpresa: idEmpresa,
        page: page,
        limit: 10,
        search: _searchController.text.trim(),
        estado: _estadoSeleccionado,
        refresh: refresh,
      ),
    );
  }

  // ==========================================================
  // BUSCAR
  // ==========================================================
  void _onSearch(String value) {
    _loadPeriodos(page: 1, refresh: true);
  }

  // ==========================================================
  // CAMBIAR FILTRO
  // ==========================================================
  void _onEstadoChanged(String? estado) {
    setState(() {
      _estadoSeleccionado = estado;
    });

    _loadPeriodos(page: 1, refresh: true);
  }

  // ==========================================================
  // CARGAR SIGUIENTE PÁGINA
  // ==========================================================
  void _loadMore() {
    final PeriodoContableState state = context
        .read<PeriodoContableBloc>()
        .state;

    if (!state.hasMore || state.isLoadingMore) {
      return;
    }

    _loadPeriodos(page: state.page + 1);
  }

  // ==========================================================
  // ACTUALIZAR LISTA
  // ==========================================================
  Future<void> _onRefresh() async {
    _loadPeriodos(page: 1, refresh: true);
  }

  // ==========================================================
  // CREAR PERÍODO
  // ==========================================================
  Future<void> _onCreate() async {
    final result = await context.push('/periodos-contables/crear');

    if (!mounted) {
      return;
    }

    if (result == true) {
      _loadPeriodos(page: 1, refresh: true);
    }
  }

  // ==========================================================
  // VER DETALLE
  // ==========================================================
  void _onViewDetail(int idPeriodo) {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      return;
    }

    context.push(
      '/periodos-contables/$idPeriodo',
      extra: {'idEmpresa': idEmpresa},
    );
  }

  // ==========================================================
  // EDITAR
  // ==========================================================
  Future<void> _onEdit(int idPeriodo) async {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      return;
    }

    final result = await context.push(
      '/periodos-contables/$idPeriodo/editar',
      extra: {'idEmpresa': idEmpresa},
    );

    if (!mounted) {
      return;
    }

    if (result == true) {
      _loadPeriodos(page: 1, refresh: true);
    }
  }

  // ==========================================================
  // CAMBIAR ESTADO
  // ==========================================================
  Future<void> _onChangeEstado({
    required int idPeriodo,
    required String estadoActual,
  }) async {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      return;
    }

    final String nuevoEstado = estadoActual.toUpperCase() == 'ABIERTO'
        ? 'CERRADO'
        : 'ABIERTO';

    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final bool cerrar = nuevoEstado == 'CERRADO';

        return AlertDialog(
          title: Text(cerrar ? 'Cerrar período' : 'Abrir período'),
          content: Text(
            cerrar
                ? '¿Está seguro de cerrar este período contable? '
                      'Luego de cerrarlo no deberían registrarse nuevos movimientos.'
                : '¿Está seguro de abrir nuevamente este período contable?',
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
              child: Text(cerrar ? 'Cerrar período' : 'Abrir período'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) {
      return;
    }

    context.read<PeriodoContableBloc>().add(
      ChangeEstadoPeriodoContableEvent(
        idPeriodo: idPeriodo,
        idEmpresa: idEmpresa,
        estado: nuevoEstado,
      ),
    );
  }

  // ==========================================================
  // ELIMINAR
  // ==========================================================
  Future<void> _onDelete(int idPeriodo) async {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      return;
    }

    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar período'),
          content: const Text(
            '¿Está seguro de eliminar este período contable? '
            'Esta acción podría no estar permitida si el período '
            'tiene movimientos registrados.',
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
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmar != true || !mounted) {
      return;
    }

    context.read<PeriodoContableBloc>().add(
      DeletePeriodoContableEvent(idPeriodo: idPeriodo, idEmpresa: idEmpresa),
    );
  }

  // ==========================================================
  // MENSAJE DEL BACKEND
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
        // La respuesta podría no contener message.
      }
    }

    return 'Operación realizada correctamente.';
  }

  String _getErrorMessage(ErrorData response) {
    try {
      final dynamic message = response.error;

      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }
    } catch (_) {
      // Compatibilidad con versiones anteriores de ErrorData.
    }

    return response.error.toString();
  }

  @override
  Widget build(BuildContext context) {
    final int? idEmpresa = _idEmpresa;

    return BlocListener<PeriodoContableBloc, PeriodoContableState>(
      listenWhen: (previous, current) =>
          previous.actionResponse != current.actionResponse,
      listener: (context, state) {
        final Resource? response = state.actionResponse;

        if (response is Success) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(_getSuccessMessage(response)),
                backgroundColor: Colors.green,
              ),
            );

          context.read<PeriodoContableBloc>().add(
            const ClearPeriodoContableActionResponseEvent(),
          );
        }

        if (response is ErrorData) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(_getErrorMessage(response)),
                backgroundColor: Colors.red,
              ),
            );

          context.read<PeriodoContableBloc>().add(
            const ClearPeriodoContableActionResponseEvent(),
          );
        }
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Períodos contables'),
        //   actions: [
        //     IconButton(
        //       tooltip: 'Actualizar',
        //       onPressed: idEmpresa == null
        //           ? null
        //           : () {
        //               _loadPeriodos(page: 1, refresh: true);
        //             },
        //       icon: const Icon(Icons.refresh),
        //     ),
        //   ],
        // ),
        body: idEmpresa == null
            ? const _EmpresaNoSeleccionada()
            : PeriodoContableContent(
                searchController: _searchController,
                estadoSeleccionado: _estadoSeleccionado,
                onSearch: _onSearch,
                onEstadoChanged: _onEstadoChanged,
                onRefresh: _onRefresh,
                onLoadMore: _loadMore,
                onRetry: () {
                  _loadPeriodos(page: 1, refresh: true);
                },
                onCreate: _onCreate,
                onViewDetail: _onViewDetail,
                onEdit: _onEdit,
                onDelete: _onDelete,
                onChangeEstado: _onChangeEstado,
              ),
        floatingActionButton: idEmpresa == null
            ? null
            : FloatingActionButton.extended(
                onPressed: _onCreate,
                icon: const Icon(Icons.add),
                label: const Text('Nuevo período'),
              ),
      ),
    );
  }
}

class _EmpresaNoSeleccionada extends StatelessWidget {
  const _EmpresaNoSeleccionada();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.business_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay una empresa seleccionada.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Seleccione una empresa para consultar sus períodos contables.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
