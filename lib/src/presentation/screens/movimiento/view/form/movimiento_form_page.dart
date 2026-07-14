import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_request.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_response.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_event.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_state.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/view/form/movimiento_form_content.dart';

import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MovimientoFormPage extends StatefulWidget {
  final int? idMovimiento;

  const MovimientoFormPage({super.key, this.idMovimiento});

  bool get isEditing => idMovimiento != null;

  @override
  State<MovimientoFormPage> createState() => _MovimientoFormPageState();
}

class _MovimientoFormPageState extends State<MovimientoFormPage> {
  bool _hasLoadedDetail = false;

  int? get _idEmpresa {
    return context.read<SessionBloc>().state.empresaActiva?.idEmpresa;
  }

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
    if (_idEmpresa == null) {
      _showError('No existe una empresa activa.');
      return;
    }

    if (_idPeriodo == null) {
      _showError('No existe un período contable abierto.');
      return;
    }

    if (widget.isEditing && !_hasLoadedDetail) {
      _hasLoadedDetail = true;

      context.read<MovimientoBloc>().add(
        GetMovimientoByIdEvent(idMovimiento: widget.idMovimiento!),
      );
    }
  }

  void _onSubmit(MovimientoRequest request) {
    if (widget.isEditing) {
      context.read<MovimientoBloc>().add(
        UpdateMovimientoEvent(
          idMovimiento: widget.idMovimiento!,
          request: request,
        ),
      );

      return;
    }

    context.read<MovimientoBloc>().add(CreateMovimientoEvent(request: request));
  }

  void _showError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
  }

  void _showSuccess(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
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
        // CREAR O ACTUALIZAR
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
                  : widget.isEditing
                  ? 'Movimiento actualizado correctamente.'
                  : 'Movimiento creado correctamente.';

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
              _showError(response.error);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isEditing ? 'Actualizar movimiento' : 'Nuevo movimiento',
          ),
        ),
        body: Builder(
          builder: (context) {
            if (idEmpresa == null) {
              return const _FormErrorState(
                message: 'No existe una empresa activa.',
              );
            }

            if (idPeriodo == null) {
              return const _FormErrorState(
                message:
                    'Debes abrir un período contable antes de registrar movimientos.',
              );
            }

            return BlocBuilder<MovimientoBloc, MovimientoState>(
              buildWhen: (previous, current) {
                return previous.detailResponse != current.detailResponse ||
                    previous.actionResponse != current.actionResponse;
              },
              builder: (context, state) {
                if (widget.isEditing && state.detailResponse is Loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                MovimientoData? movimiento;

                if (widget.isEditing) {
                  final Resource? response = state.detailResponse;

                  if (response is Success<MovimientoResponse>) {
                    movimiento = response.data.data;
                  }

                  if (movimiento == null && response is! Loading) {
                    return const _FormErrorState(
                      message:
                          'No se pudo obtener la información del movimiento.',
                    );
                  }
                }

                final bool isSubmitting = state.actionResponse is Loading;

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

  const _FormErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}
