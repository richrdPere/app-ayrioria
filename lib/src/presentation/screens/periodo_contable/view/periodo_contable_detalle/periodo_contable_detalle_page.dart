import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_data.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_event.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'periodo_contable_detalle_content.dart';

class PeriodoContableDetallePage extends StatefulWidget {
  final int idPeriodo;

  const PeriodoContableDetallePage({super.key, required this.idPeriodo});

  @override
  State<PeriodoContableDetallePage> createState() =>
      _PeriodoContableDetallePageState();
}

class _PeriodoContableDetallePageState
    extends State<PeriodoContableDetallePage> {
  bool _isDeleting = false;

  int? get _idEmpresa {
    return context.read<SessionBloc>().state.empresaActiva?.idEmpresa;
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(_loadPeriodo);
  }

  @override
  void dispose() {
    context.read<PeriodoContableBloc>().add(
      const ClearPeriodoContableSelectedEvent(),
    );

    super.dispose();
  }

  // ==========================================================
  // CARGAR DETALLE
  // ==========================================================
  void _loadPeriodo() {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      return;
    }

    context.read<PeriodoContableBloc>().add(
      GetPeriodoContableByIdEvent(
        idPeriodo: widget.idPeriodo,
        idEmpresa: idEmpresa,
      ),
    );
  }

  // ==========================================================
  // EDITAR
  // ==========================================================
  Future<void> _onEdit() async {
    final result = await context.push(
      '/periodos_contables/${widget.idPeriodo}/editar',
    );

    if (!mounted) {
      return;
    }

    if (result == true) {
      _loadPeriodo();
    }
  }

  // ==========================================================
  // CAMBIAR ESTADO
  // ==========================================================
  Future<void> _onChangeEstado(PeriodoContableData periodo) async {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      _showError('No se encontró la empresa activa.');

      return;
    }

    final bool isOpen = periodo.estado.toUpperCase() == 'ABIERTO';

    final String nuevoEstado = isOpen ? 'CERRADO' : 'ABIERTO';

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(isOpen ? 'Cerrar período' : 'Abrir período'),
          content: Text(
            isOpen
                ? '¿Está seguro de cerrar el período "${periodo.nombre}"?'
                : '¿Está seguro de abrir nuevamente el período "${periodo.nombre}"?',
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
              child: Text(isOpen ? 'Cerrar' : 'Abrir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    _isDeleting = false;

    context.read<PeriodoContableBloc>().add(
      ChangeEstadoPeriodoContableEvent(
        idPeriodo: periodo.idPeriodo,
        idEmpresa: idEmpresa,
        estado: nuevoEstado,
      ),
    );
  }

  // ==========================================================
  // ELIMINAR
  // ==========================================================
  Future<void> _onDelete(PeriodoContableData periodo) async {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      _showError('No se encontró la empresa activa.');

      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar período'),
          content: Text(
            '¿Está seguro de eliminar el período '
            '"${periodo.nombre}"?\n\n'
            'Esta acción podría no estar permitida si existen movimientos asociados.',
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

    _isDeleting = true;

    context.read<PeriodoContableBloc>().add(
      DeletePeriodoContableEvent(
        idPeriodo: periodo.idPeriodo,
        idEmpresa: idEmpresa,
      ),
    );
  }

  String _getSuccessMessage(Resource response) {
    if (response is Success) {
      final dynamic result = response.data;

      try {
        final String? message = result.message as String?;

        if (message != null && message.trim().isNotEmpty) {
          return message;
        }
      } catch (_) {
        // Respuesta sin message.
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
      // Compatibilidad con Resource anterior.
    }

    return response.error.toString();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
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
          final String message = _getSuccessMessage(response);

          context.read<PeriodoContableBloc>().add(
            const ClearPeriodoContableActionResponseEvent(),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.green),
            );

          if (_isDeleting) {
            context.pop(true);
            return;
          }

          _loadPeriodo();
        }

        if (response is ErrorData) {
          _isDeleting = false;

          _showError(_getErrorMessage(response));

          context.read<PeriodoContableBloc>().add(
            const ClearPeriodoContableActionResponseEvent(),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalle del período'),
          actions: [
            IconButton(
              tooltip: 'Actualizar',
              onPressed: idEmpresa == null ? null : _loadPeriodo,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: idEmpresa == null
            ? const _EmpresaNoSeleccionada()
            : BlocBuilder<PeriodoContableBloc, PeriodoContableState>(
                buildWhen: (previous, current) =>
                    previous.detailResponse != current.detailResponse ||
                    previous.periodoSelected != current.periodoSelected ||
                    previous.actionResponse != current.actionResponse,
                builder: (context, state) {
                  if (state.detailResponse is Loading) {
                    return const _PeriodoDetalleLoading();
                  }

                  if (state.detailResponse is ErrorData) {
                    final ErrorData error = state.detailResponse as ErrorData;

                    return _PeriodoDetalleError(
                      message: _getErrorMessage(error),
                      onRetry: _loadPeriodo,
                    );
                  }

                  final PeriodoContableData? periodo = state.periodoSelected;

                  if (periodo == null) {
                    return _PeriodoDetalleError(
                      message: 'No se encontró el período contable.',
                      onRetry: _loadPeriodo,
                    );
                  }

                  return PeriodoContableDetalleContent(
                    periodo: periodo,
                    isProcessing: state.actionResponse is Loading,
                    onEdit: _onEdit,
                    onDelete: () {
                      _onDelete(periodo);
                    },
                    onChangeEstado: () {
                      _onChangeEstado(periodo);
                    },
                  );
                },
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
            Icon(Icons.business_outlined, size: 70, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay una empresa activa.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Seleccione una empresa para consultar el período contable.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodoDetalleLoading extends StatelessWidget {
  const _PeriodoDetalleLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _PeriodoDetalleError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _PeriodoDetalleError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 70, color: Colors.red),
            const SizedBox(height: 18),
            const Text(
              'No se pudo cargar el período',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
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
