import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_create_request.dart';

import 'package:app_aryoria/src/data/models/movimientos/movimiento_update_request.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_event.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_state.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/view/form/movimiento_form_content.dart';

import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MovimientoFormValue {
  final int idCategoria;
  final int idSubcategoria;
  final int? idCuenta;
  final int? idUsuario;

  final String tipo;
  final String fecha;
  final String descripcion;
  final double monto;

  final String? observacion;
  final String? comprobante;
  final String estado;

  const MovimientoFormValue({
    required this.idCategoria,
    required this.idSubcategoria,
    this.idCuenta,
    this.idUsuario,
    required this.tipo,
    required this.fecha,
    required this.descripcion,
    required this.monto,
    this.observacion,
    this.comprobante,
    required this.estado,
  });
}

class MovimientoFormPage extends StatefulWidget {
  final int? idMovimiento;

  const MovimientoFormPage({super.key, this.idMovimiento});

  bool get isEditing => idMovimiento != null;

  @override
  State<MovimientoFormPage> createState() => _MovimientoFormPageState();
}

class _MovimientoFormPageState extends State<MovimientoFormPage> {
  bool _hasLoadedDetail = false;

  // EMPRESA ACTIVA
  int? get _idEmpresa {
    return context.read<SessionBloc>().state.empresaActiva?.idEmpresa;
  }

  // PERÍODO ACTIVO
  int? get _idPeriodo {
    return context.read<PeriodoContableBloc>().state.idPeriodoActivo;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _initializePage();
    });
  }

  void _initializePage() {
    final int? idEmpresa = _idEmpresa;
    final int? idPeriodo = _idPeriodo;

    if (idEmpresa == null) {
      _showError('No existe una empresa activa.');
      return;
    }

    if (idPeriodo == null) {
      _showError('No existe un período contable abierto.');
      return;
    }

    if (widget.isEditing && !_hasLoadedDetail) {
      _hasLoadedDetail = true;

      context.read<MovimientoBloc>().add(
        GetMovimientoByIdEvent(
          idMovimiento: widget.idMovimiento!,
          idEmpresa: idEmpresa,
        ),
      );
    }
  }

  // ==========================================================
  // CREAR
  // ==========================================================
  void _onCreate(MovimientoCreateRequest request) {
    context.read<MovimientoBloc>().add(CreateMovimientoEvent(request: request));
  }

  // ==========================================================
  // ACTUALIZAR
  // ==========================================================
  void _onUpdate(MovimientoUpdateRequest request) {
    final int? idEmpresa = _idEmpresa;
    final int? idMovimiento = widget.idMovimiento;

    if (idEmpresa == null) {
      _showError('No existe una empresa activa.');
      return;
    }

    if (idMovimiento == null) {
      _showError('No se encontró el movimiento.');
      return;
    }

    context.read<MovimientoBloc>().add(
      UpdateMovimientoEvent(
        idMovimiento: idMovimiento,
        idEmpresa: idEmpresa,
        request: request,
      ),
    );
  }

  // ==========================================================
  // MENSAJES
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

  void _showSuccess(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
  }

  // ==========================================================
  // MENSAJE SUCCESS
  // ==========================================================
  String _getSuccessMessage(Resource response) {
    if (response is Success) {
      final dynamic result = response.data;

      if (result is ApiResponse) {
        final String message = result.message.trim();

        if (message.isNotEmpty) {
          return message;
        }
      }
    }

    return widget.isEditing
        ? 'Movimiento actualizado correctamente.'
        : 'Movimiento creado correctamente.';
  }

  void _onSubmit(MovimientoFormValue value) {
    final int? idEmpresa = _idEmpresa;
    final int? idPeriodo = _idPeriodo;

    if (idEmpresa == null) {
      _showError('No existe una empresa activa.');
      return;
    }

    if (idPeriodo == null) {
      _showError('No existe un período contable abierto.');
      return;
    }

    // ==========================================================
    // EDITAR
    // ==========================================================
    if (widget.isEditing) {
      final int? idMovimiento = widget.idMovimiento;

      if (idMovimiento == null) {
        _showError('No se encontró el movimiento.');
        return;
      }

      final request = MovimientoUpdateRequest(
        idCategoria: value.idCategoria,
        idSubcategoria: value.idSubcategoria,
        idCuenta: value.idCuenta,
        idPeriodo: idPeriodo,
        tipo: value.tipo,
        fecha: value.fecha,
        descripcion: value.descripcion,
        monto: value.monto,
        observacion: value.observacion,
        comprobante: value.comprobante,
        estado: value.estado,
      );

      _onUpdate(request);

      return;
    }

    // ==========================================================
    // CREAR
    // ==========================================================
    final int? idUsuario = value.idUsuario;

    if (idUsuario == null) {
      _showError('No se encontró el usuario que registra el movimiento.');
      return;
    }

    final request = MovimientoCreateRequest(
      idEmpresa: idEmpresa,
      idPeriodo: idPeriodo,
      idCategoria: value.idCategoria,
      idSubcategoria: value.idSubcategoria,
      idCuenta: value.idCuenta,
      idUsuario: idUsuario,
      tipo: value.tipo,
      fecha: value.fecha,
      descripcion: value.descripcion,
      monto: value.monto,
      observacion: value.observacion,
      comprobante: value.comprobante,
      estado: value.estado,
    );

    _onCreate(request);
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
        // CREAR O ACTUALIZAR
        // ======================================================
        BlocListener<MovimientoBloc, MovimientoState>(
          listenWhen: (previous, current) {
            return previous.actionResponse != current.actionResponse;
          },
          listener: (context, state) {
            final Resource? response = state.actionResponse;

            if (response == null) {
              return;
            }

            // ==================================================
            // SUCCESS
            // ==================================================
            if (response is Success) {
              final String message = _getSuccessMessage(response);

              _showSuccess(message);

              context.read<MovimientoBloc>().add(
                const ClearMovimientoActionResponseEvent(),
              );

              context.pop(true);

              return;
            }

            // ==================================================
            // ERROR
            // ==================================================
            if (response is ErrorData) {
              _showError(response.displayMessage);

              context.read<MovimientoBloc>().add(
                const ClearMovimientoActionResponseEvent(),
              );
            }
          },
        ),

        // ======================================================
        // ERROR AL OBTENER DETALLE
        // ======================================================
        BlocListener<MovimientoBloc, MovimientoState>(
          listenWhen: (previous, current) {
            return previous.detailResponse != current.detailResponse;
          },
          listener: (context, state) {
            final Resource? response = state.detailResponse;

            if (response is ErrorData) {
              _showError(response.displayMessage);
            }
          },
        ),
      ],

      // ========================================================
      // FULL SCREEN FORM
      // ========================================================
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Cerrar',
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.close_rounded),
          ),
          title: Text(
            widget.isEditing ? 'Editar movimiento' : 'Nuevo movimiento',
          ),
        ),

        body: Builder(
          builder: (context) {
            // ==================================================
            // EMPRESA
            // ==================================================
            if (idEmpresa == null) {
              return const _FormErrorState(
                message: 'No existe una empresa activa.',
              );
            }

            // ==================================================
            // PERÍODO
            // ==================================================
            if (idPeriodo == null) {
              return const _FormErrorState(
                message:
                    'Debes abrir un período contable antes de '
                    'registrar movimientos.',
              );
            }

            return BlocBuilder<MovimientoBloc, MovimientoState>(
              buildWhen: (previous, current) {
                return previous.detailResponse != current.detailResponse ||
                    previous.movimientoSelected != current.movimientoSelected ||
                    previous.actionResponse != current.actionResponse;
              },
              builder: (context, state) {
                // ==============================================
                // CARGANDO DETALLE PARA EDICIÓN
                // ==============================================
                if (widget.isEditing && state.detailResponse is Loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ==============================================
                // ERROR DETALLE
                // ==============================================
                if (widget.isEditing && state.detailResponse is ErrorData) {
                  final error = state.detailResponse as ErrorData;

                  return _FormErrorState(
                    message: error.displayMessage,
                    onRetry: _initializePage,
                  );
                }

                // ==============================================
                // MOVIMIENTO SELECCIONADO
                // ==============================================
                final MovimientoData? movimiento = widget.isEditing
                    ? state.movimientoSelected
                    : null;

                if (widget.isEditing && movimiento == null) {
                  return _FormErrorState(
                    message:
                        'No se pudo obtener la información '
                        'del movimiento.',
                    onRetry: _initializePage,
                  );
                }

                // ==============================================
                // GUARDANDO
                // ==============================================
                final bool isSubmitting = state.actionResponse is Loading;

                // ==============================================
                // FORM CONTENT
                // ==============================================
                return MovimientoFormContent(
                  idEmpresa: idEmpresa,
                  idPeriodo: idPeriodo,
                  movimiento: movimiento,
                  isEditing: widget.isEditing,
                  isSubmitting: isSubmitting,
                  onSubmit: _onSubmit,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _FormErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _FormErrorState({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: colors.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 42,
                  color: colors.error,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'No se puede continuar',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.45,
                  color: colors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 24),

              if (onRetry != null)
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                )
              else
                OutlinedButton.icon(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('Cerrar'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
