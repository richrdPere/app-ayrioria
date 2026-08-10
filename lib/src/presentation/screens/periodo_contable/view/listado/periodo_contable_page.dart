import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Session
import 'package:app_aryoria/src/config/core/session/session_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_query_params.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Bloc
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_event.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_state.dart';

// Content
import 'package:app_aryoria/src/presentation/screens/periodo_contable/view/listado/periodo_contable_content.dart';

class PeriodoContablePage extends StatefulWidget {
  const PeriodoContablePage({super.key});

  @override
  State<PeriodoContablePage> createState() => _PeriodoContablePageState();
}

class _PeriodoContablePageState extends State<PeriodoContablePage> {
  final TextEditingController _searchController = TextEditingController();

  // ==========================================================
  // FILTROS
  // ==========================================================
  String? _estadoSeleccionado;
  int? _anioSeleccionado;
  int? _mesSeleccionado;

  static const int _defaultLimit = 10;

  // ==========================================================
  // EMPRESA ACTIVA
  // ==========================================================
  int? get _idEmpresa {
    return context.read<SessionBloc>().state.empresaActiva?.idEmpresa;
  }

  // ==========================================================
  // INIT
  // ==========================================================
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (!mounted) {
        return;
      }

      _loadPeriodos(page: 1, refresh: true);
    });
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================
  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  // ==========================================================
  // CONSTRUIR QUERY PARAMS
  // ==========================================================
  PeriodosContablesParams _buildQueryParams({required int page, int? limit}) {
    final String search = _searchController.text.trim();

    return PeriodosContablesParams(
      page: page,
      limit: limit ?? _defaultLimit,
      search: search.isEmpty ? null : search,
      estado: _estadoSeleccionado,
      anio: _anioSeleccionado,
      mes: _mesSeleccionado,
    );
  }

  // ==========================================================
  // CARGAR PERÍODOS
  // ==========================================================
  void _loadPeriodos({int page = 1, int? limit, bool refresh = false}) {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      return;
    }

    final PeriodosContablesParams queryParams = _buildQueryParams(
      page: page,
      limit: limit,
    );

    context.read<PeriodoContableBloc>().add(
      GetPeriodosContablesEvent(
        idEmpresa: idEmpresa,
        queryParams: queryParams,
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
  // CAMBIAR ESTADO
  // ==========================================================
  void _onEstadoChanged(String? estado) {
    setState(() {
      _estadoSeleccionado = estado;
    });

    _loadPeriodos(page: 1, refresh: true);
  }

  // ==========================================================
  // CAMBIAR AÑO
  // ==========================================================
  void _onAnioChanged(int? anio) {
    setState(() {
      _anioSeleccionado = anio;
    });

    _loadPeriodos(page: 1, refresh: true);
  }

  // ==========================================================
  // CAMBIAR MES
  // ==========================================================
  void _onMesChanged(int? mes) {
    setState(() {
      _mesSeleccionado = mes;
    });

    _loadPeriodos(page: 1, refresh: true);
  }

  // ==========================================================
  // SIGUIENTE PÁGINA
  // ==========================================================
  void _onNextPage() {
    final PeriodoContableState state = context
        .read<PeriodoContableBloc>()
        .state;

    if (state.isLoadingMore || !state.hasNextPage) {
      return;
    }

    _loadPeriodos(page: state.page + 1, limit: state.limit);
  }

  // ==========================================================
  // PÁGINA ANTERIOR
  // ==========================================================
  void _onPreviousPage() {
    final PeriodoContableState state = context
        .read<PeriodoContableBloc>()
        .state;

    if (state.isLoadingMore || !state.hasPreviousPage) {
      return;
    }

    _loadPeriodos(page: state.page - 1, limit: state.limit);
  }

  // ==========================================================
  // REFRESH
  // ==========================================================
  Future<void> _onRefresh() async {
    _loadPeriodos(page: 1, refresh: true);
  }

  // ==========================================================
  // CREAR PERÍODO
  // ==========================================================
  Future<void> _onCreate() async {
    final result = await context.push('/periodos_contables/crear');

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
      '/periodos_contables/$idPeriodo',
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
      '/periodos_contables/$idPeriodo/editar',
      extra: {'idEmpresa': idEmpresa},
    );

    if (!mounted) {
      return;
    }

    if (result == true) {
      /*
       * Después de editar, mantenemos la página actual.
       */
      final state = context.read<PeriodoContableBloc>().state;

      _loadPeriodos(page: state.page, limit: state.limit, refresh: true);
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

    final String nuevoEstado = estadoActual.trim().toUpperCase() == 'ABIERTO'
        ? 'CERRADO'
        : 'ABIERTO';

    final bool cerrar = nuevoEstado == 'CERRADO';

    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(cerrar ? 'Cerrar período' : 'Abrir período'),
          content: Text(
            cerrar
                ? '¿Está seguro de cerrar este período contable? '
                      'Luego de cerrarlo no deberían registrarse '
                      'nuevos movimientos.'
                : '¿Está seguro de abrir nuevamente este '
                      'período contable?',
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
        // La respuesta puede no contener message.
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
  // BUILD
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    final int? idEmpresa = _idEmpresa;

    return BlocListener<PeriodoContableBloc, PeriodoContableState>(
      listenWhen: (previous, current) {
        return previous.actionResponse != current.actionResponse;
      },
      listener: (context, state) {
        final Resource? response = state.actionResponse;

        // ====================================================
        // SUCCESS
        // ====================================================
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

          return;
        }

        // ====================================================
        // ERROR
        // ====================================================
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
      child: BlocBuilder<PeriodoContableBloc, PeriodoContableState>(
        builder: (context, state) {
          final bool existenPeriodos = state.periodos.isNotEmpty;

          return Scaffold(
            body: idEmpresa == null
                ? const _EmpresaNoSeleccionada()
                : PeriodoContableContent(
                    searchController: _searchController,
                    estadoSeleccionado: _estadoSeleccionado,
                    anioSeleccionado: _anioSeleccionado,
                    mesSeleccionado: _mesSeleccionado,
                    onSearch: _onSearch,
                    onEstadoChanged: _onEstadoChanged,
                    onAnioChanged: _onAnioChanged,
                    onMesChanged: _onMesChanged,
                    onRefresh: _onRefresh,
                    onPreviousPage: state.hasPreviousPage
                        ? _onPreviousPage
                        : null,
                    onNextPage: state.hasNextPage ? _onNextPage : null,
                    onRetry: () {
                      _loadPeriodos(page: 1, refresh: true);
                    },
                    onCreate: _onCreate,
                    onViewDetail: _onViewDetail,
                    onEdit: _onEdit,
                    onDelete: _onDelete,
                    onChangeEstado: _onChangeEstado,
                  ),

            floatingActionButton: idEmpresa != null && existenPeriodos
                ? FloatingActionButton.extended(
                    onPressed: _onCreate,
                    icon: const Icon(Icons.add),
                    label: const Text('Nuevo'),
                  )
                : null,
          );
        },
      ),
    );
  }
}

// ==========================================================
// EMPRESA NO SELECCIONADA
// ==========================================================
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
              'Seleccione una empresa para consultar '
              'sus períodos contables.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
