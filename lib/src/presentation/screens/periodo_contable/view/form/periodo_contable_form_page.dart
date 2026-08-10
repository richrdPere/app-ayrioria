import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Session
import 'package:app_aryoria/src/config/core/session/session_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_data.dart';
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_request.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Bloc
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_event.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_state.dart';

// Content
import 'periodo_contable_form_content.dart';

class PeriodoContableFormPage extends StatefulWidget {
  final int? idPeriodo;

  const PeriodoContableFormPage({super.key, this.idPeriodo});

  bool get isEditing => idPeriodo != null;

  @override
  State<PeriodoContableFormPage> createState() =>
      _PeriodoContableFormPageState();
}

class _PeriodoContableFormPageState extends State<PeriodoContableFormPage> {
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

      // Limpiamos estados anteriores del detalle.
      context.read<PeriodoContableBloc>().add(
        const ClearPeriodoContableSelectedEvent(),
      );

      _loadPeriodo();
    });
  }

  // ==========================================================
  // CARGAR PERÍODO PARA EDICIÓN
  // ==========================================================
  void _loadPeriodo() {
    if (!widget.isEditing) {
      return;
    }

    final int? idEmpresa = _idEmpresa;
    final int? idPeriodo = widget.idPeriodo;

    if (idEmpresa == null || idPeriodo == null) {
      return;
    }

    context.read<PeriodoContableBloc>().add(
      GetPeriodoContableByIdEvent(idPeriodo: idPeriodo, idEmpresa: idEmpresa),
    );
  }

  // ==========================================================
  // CREAR O ACTUALIZAR
  // ==========================================================
  void _onSubmit(PeriodoContableFormValue value) {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('No se encontró una empresa activa.'),
            backgroundColor: Colors.red,
          ),
        );

      return;
    }

    // ========================================================
    // REQUEST
    // ========================================================
    final PeriodoContableRequest request = PeriodoContableRequest(
      idEmpresa: idEmpresa,
      nombre: value.nombre,
      anio: value.anio,
      mes: value.mes,
      fechaInicio: value.fechaInicio,
      fechaFin: value.fechaFin,
      saldoInicial: value.saldoInicial,
      observacion: value.observacion,
    );

    // ========================================================
    // ACTUALIZAR
    // ========================================================
    if (widget.isEditing) {
      final int? idPeriodo = widget.idPeriodo;

      if (idPeriodo == null) {
        return;
      }

      context.read<PeriodoContableBloc>().add(
        UpdatePeriodoContableEvent(
          idPeriodo: idPeriodo,
          idEmpresa: idEmpresa,
          request: request,
        ),
      );

      return;
    }

    // ========================================================
    // CREAR
    // ========================================================
    context.read<PeriodoContableBloc>().add(
      CreatePeriodoContableEvent(request: request),
    );
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
        // Respuesta sin propiedad message.
      }
    }

    return widget.isEditing
        ? 'Período actualizado correctamente.'
        : 'Período creado correctamente.';
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
  // CERRAR FULLSCREEN DIALOG
  // ==========================================================
  void _close({bool result = false}) {
    if (!mounted) {
      return;
    }

    context.pop(result);
  }

  // ==========================================================
  // BUILD
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    final int? idEmpresa = _idEmpresa;

    return MultiBlocListener(
      listeners: [
        // =====================================================
        // CREATE / UPDATE
        // =====================================================
        BlocListener<PeriodoContableBloc, PeriodoContableState>(
          listenWhen: (previous, current) {
            return previous.actionResponse != current.actionResponse;
          },
          listener: (context, state) {
            final Resource? response = state.actionResponse;

            // =================================================
            // SUCCESS
            // =================================================
            if (response is Success) {
              final String message = _getSuccessMessage(response);

              context.read<PeriodoContableBloc>().add(
                const ClearPeriodoContableActionResponseEvent(),
              );

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: Colors.green,
                  ),
                );

              // Retornamos true al listado para que refresque.
              _close(result: true);

              return;
            }

            // =================================================
            // ERROR
            // =================================================
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
        ),
      ],

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
          title: Text(widget.isEditing ? 'Editar período' : 'Nuevo período'),
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
                  // LOADING DETALLE
                  // =============================================
                  if (widget.isEditing && state.detailResponse is Loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // =============================================
                  // ERROR DETALLE
                  // =============================================
                  if (widget.isEditing && state.detailResponse is ErrorData) {
                    final ErrorData error = state.detailResponse as ErrorData;

                    return _PeriodoDetailError(
                      message: _getErrorMessage(error),
                      onRetry: _loadPeriodo,
                    );
                  }

                  // =============================================
                  // PERÍODO SELECCIONADO
                  // =============================================
                  final PeriodoContableData? periodo = widget.isEditing
                      ? state.periodoSelected
                      : null;

                  // =============================================
                  // SIN PERÍODO
                  // =============================================
                  if (widget.isEditing && periodo == null) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No se encontró el período contable.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  // =============================================
                  // FORMULARIO
                  // =============================================
                  return PeriodoContableFormContent(
                    periodo: periodo,
                    isEditing: widget.isEditing,
                    isSaving: state.actionResponse is Loading,
                    onSubmit: _onSubmit,
                  );
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
            Icon(Icons.business_outlined, size: 68, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay una empresa activa.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Selecciona una empresa antes de crear '
              'o editar un período.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// ERROR AL CARGAR DETALLE
// ==========================================================
class _PeriodoDetailError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _PeriodoDetailError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 68, color: Colors.red),
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
