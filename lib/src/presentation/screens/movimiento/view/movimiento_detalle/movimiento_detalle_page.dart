import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_response.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_event.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_state.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/view/movimiento_detalle/movimiento_detalle_content.dart';

import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MovimientoDetailPage extends StatefulWidget {
  final int idMovimiento;

  const MovimientoDetailPage({super.key, required this.idMovimiento});

  @override
  State<MovimientoDetailPage> createState() => _MovimientoDetailPageState();
}

class _MovimientoDetailPageState extends State<MovimientoDetailPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _loadMovimiento();
    });
  }

  @override
  void dispose() {
    /*
     * No usamos context.read() aquí para evitar:
     *
     * Looking up a deactivated widget's ancestor is unsafe.
     *
     * La respuesta del detalle se limpiará antes de cargar otro
     * movimiento o al regresar correctamente.
     */
    super.dispose();
  }

  // ==========================================================
  // EMPRESA ACTIVA
  // ==========================================================
  int? get _idEmpresa {
    return context.read<SessionBloc>().state.empresaActiva?.idEmpresa;
  }

  // ==========================================================
  // PERÍODO ACTIVO
  // ==========================================================
  int? get _idPeriodo {
    return context.read<PeriodoContableBloc>().state.idPeriodoActivo;
  }

  // ==========================================================
  // CARGAR DETALLE
  // ==========================================================
  void _loadMovimiento() {
    context.read<MovimientoBloc>().add(
      GetMovimientoByIdEvent(idMovimiento: widget.idMovimiento),
    );
  }

  // ==========================================================
  // EDITAR MOVIMIENTO
  // ==========================================================
  Future<void> _onEditMovimiento() async {
    final bool? result = await context.push<bool>(
      '/movimientos/${widget.idMovimiento}/editar',
    );

    if (!mounted) {
      return;
    }

    if (result == true) {
      _loadMovimiento();
    }
  }

  // ==========================================================
  // ELIMINAR MOVIMIENTO
  // ==========================================================
  Future<void> _onDeleteMovimiento() async {
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
        idMovimiento: widget.idMovimiento,
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
    return MultiBlocListener(
      listeners: [
        // ======================================================
        // ESCUCHAR ERRORES DEL DETALLE
        // ======================================================
        BlocListener<MovimientoBloc, MovimientoState>(
          listenWhen: (previous, current) {
            return previous.detailResponse != current.detailResponse;
          },
          listener: (context, state) {
            final Resource? response = state.detailResponse;

            if (response is ErrorData) {
              _showError(response.error);
            }
          },
        ),

        // ======================================================
        // ESCUCHAR ELIMINACIÓN
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
                  : 'Movimiento eliminado correctamente.';

              _showSuccess(message);

              context.read<MovimientoBloc>().add(
                const ClearMovimientoActionResponseEvent(),
              );

              context.pop(true);
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
      child: BlocBuilder<MovimientoBloc, MovimientoState>(
        buildWhen: (previous, current) {
          return previous.detailResponse != current.detailResponse ||
              previous.actionResponse != current.actionResponse;
        },
        builder: (context, state) {
          final Resource? response = state.detailResponse;

          if (response is Loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (response is ErrorData) {
            return _MovimientoDetailError(
              message: response.error,
              onRetry: _loadMovimiento,
            );
          }

          if (response is Success<MovimientoResponse>) {
            final MovimientoData? movimiento = response.data.data;

            if (movimiento == null) {
              return _MovimientoDetailError(
                message: 'No se encontró la información del movimiento.',
                onRetry: _loadMovimiento,
              );
            }

            return MovimientoDetailContent(
              movimiento: movimiento,
              isDeleting: state.actionResponse is Loading,
              onEdit: _onEditMovimiento,
              onDelete: _onDeleteMovimiento,
            );
          }

          return _MovimientoDetailError(
            message: 'No se pudo cargar el movimiento.',
            onRetry: _loadMovimiento,
          );
        },
      ),
    );
  }
}

class _MovimientoDetailError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MovimientoDetailError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 70,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
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
