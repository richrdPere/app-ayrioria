import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Session
import 'package:app_aryoria/src/config/core/session/session_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_data.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Bloc
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_event.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_state.dart';

// Content
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

  late PeriodoContableBloc _periodoContableBloc;

  // ==========================================================
  // EMPRESA ACTIVA
  // ==========================================================
  int? get _idEmpresa {
    return context.read<SessionBloc>().state.empresaActiva?.idEmpresa;
  }

  // ==========================================================
  // DEPENDENCIAS
  // ==========================================================
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _periodoContableBloc = context.read<PeriodoContableBloc>();
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

      // Limpiar cualquier detalle anterior.
      context.read<PeriodoContableBloc>().add(
        const ClearPeriodoContableSelectedEvent(),
      );

      _loadPeriodo();
    });
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================
  @override
  void dispose() {
    _periodoContableBloc.add(const ClearPeriodoContableSelectedEvent());

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
  // CERRAR FULLSCREEN DIALOG
  // ==========================================================
  void _close({bool result = false}) {
    if (!mounted) {
      return;
    }

    context.pop(result);
  }

  // ==========================================================
  // MENSAJE SUCCESS
  // ==========================================================
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
  // MOSTRAR ERROR
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
  // BUILD
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    final int? idEmpresa = _idEmpresa;

    return BlocListener<PeriodoContableBloc, PeriodoContableState>(
      listenWhen: (previous, current) {
        return previous.actionResponse != current.actionResponse;
      },

      // ========================================================
      // LISTENER DE ACCIONES
      // ========================================================
      listener: (context, state) {
        final Resource? response = state.actionResponse;

        // ======================================================
        // SUCCESS
        // ======================================================
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

          // ====================================================
          // ELIMINADO
          // ====================================================
          if (_isDeleting) {
            _isDeleting = false;

            _close(result: true);

            return;
          }

          // ====================================================
          // CAMBIO DE ESTADO
          // ====================================================
          _loadPeriodo();

          return;
        }

        // ======================================================
        // ERROR
        // ======================================================
        if (response is ErrorData) {
          _isDeleting = false;

          _showError(_getErrorMessage(response));

          context.read<PeriodoContableBloc>().add(
            const ClearPeriodoContableActionResponseEvent(),
          );
        }
      },

      // ========================================================
      // FULLSCREEN DIALOG
      // ========================================================
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Cerrar',
            onPressed: () {
              _close();
            },
            icon: const Icon(Icons.close),
          ),
          title: const Text('Detalle del período'),
        ),

        body: idEmpresa == null
            ? const _EmpresaNoSeleccionada()
            : BlocBuilder<PeriodoContableBloc, PeriodoContableState>(
                buildWhen: (previous, current) {
                  return previous.detailResponse != current.detailResponse ||
                      previous.periodoSelected != current.periodoSelected ||
                      previous.actionResponse != current.actionResponse;
                },
                builder: (context, state) {
                  // =============================================
                  // LOADING
                  // =============================================
                  if (state.detailResponse is Loading) {
                    return const _PeriodoDetalleLoading();
                  }

                  // =============================================
                  // ERROR
                  // =============================================
                  if (state.detailResponse is ErrorData) {
                    final ErrorData error = state.detailResponse as ErrorData;

                    return _PeriodoDetalleError(
                      message: _getErrorMessage(error),
                      onRetry: _loadPeriodo,
                    );
                  }

                  // =============================================
                  // DATA
                  // =============================================
                  final PeriodoContableData? periodo = state.periodoSelected;

                  if (periodo == null) {
                    return _PeriodoDetalleError(
                      message: 'No se encontró el período contable.',
                      onRetry: _loadPeriodo,
                    );
                  }

                  // =============================================
                  // CONTENT
                  // =============================================
                  return PeriodoContableDetalleContent(periodo: periodo);
                },
              ),
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
            Icon(Icons.business_outlined, size: 70, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay una empresa activa.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Seleccione una empresa para consultar '
              'el período contable.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// LOADING DETALLE
// ==========================================================
class _PeriodoDetalleLoading extends StatelessWidget {
  const _PeriodoDetalleLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

// ==========================================================
// ERROR DETALLE
// ==========================================================
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
