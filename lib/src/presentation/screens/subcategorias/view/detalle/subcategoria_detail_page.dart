import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Session
import 'package:app_aryoria/src/config/core/session/session_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_data.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Bloc
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_event.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_state.dart';

// Content
import 'package:app_aryoria/src/presentation/screens/subcategorias/view/detalle/subcategoria_detail_content.dart';

class SubcategoriaDetallePage extends StatefulWidget {
  final int idSubcategoria;

  const SubcategoriaDetallePage({super.key, required this.idSubcategoria});

  @override
  State<SubcategoriaDetallePage> createState() =>
      _SubcategoriaDetallePageState();
}

class _SubcategoriaDetallePageState extends State<SubcategoriaDetallePage> {
  bool _isDeleting = false;

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

      context.read<SubcategoriaBloc>().add(
        const ClearSubcategoriaDetailEvent(),
      );

      _loadSubcategoria();
    });
  }

  // ==========================================================
  // CARGAR DETALLE
  // ==========================================================
  void _loadSubcategoria() {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      return;
    }

    context.read<SubcategoriaBloc>().add(
      GetSubcategoriaByIdEvent(
        idEmpresa: idEmpresa,
        idSubcategoria: widget.idSubcategoria,
      ),
    );
  }

  // ==========================================================
  // CERRAR
  // ==========================================================
  void _close({bool result = false}) {
    if (!mounted) {
      return;
    }

    context.pop(result);
  }

  // ==========================================================
  // EDITAR
  // ==========================================================
  Future<void> _onEdit() async {
    final result = await context.push(
      '/subcategorias/${widget.idSubcategoria}/editar',
    );

    if (!mounted) {
      return;
    }

    if (result == true) {
      _loadSubcategoria();
    }
  }

  // ==========================================================
  // CAMBIAR ESTADO
  // ==========================================================
  Future<void> _onChangeEstado(SubcategoriaData subcategoria) async {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      _showError('No se encontró una empresa activa.');

      return;
    }

    final bool nuevoEstado = !subcategoria.estado;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            nuevoEstado ? 'Activar subcategoría' : 'Desactivar subcategoría',
          ),
          content: Text(
            nuevoEstado
                ? '¿Deseas activar "${subcategoria.nombre}"?'
                : '¿Deseas desactivar "${subcategoria.nombre}"?',
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
              child: Text(nuevoEstado ? 'Activar' : 'Desactivar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    context.read<SubcategoriaBloc>().add(
      ChangeSubcategoriaEstadoEvent(
        idEmpresa: idEmpresa,
        idSubcategoria: subcategoria.idSubcategoria,
        estado: nuevoEstado,
      ),
    );
  }

  // ==========================================================
  // ELIMINAR
  // ==========================================================
  Future<void> _onDelete(SubcategoriaData subcategoria) async {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      _showError('No se encontró una empresa activa.');

      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 10),
              Expanded(child: Text('Eliminar subcategoría')),
            ],
          ),
          content: Text(
            '¿Estás seguro de eliminar '
            '"${subcategoria.nombre}"?\n\n'
            'Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    _isDeleting = true;

    context.read<SubcategoriaBloc>().add(
      DeleteSubcategoriaEvent(
        idEmpresa: idEmpresa,
        idSubcategoria: subcategoria.idSubcategoria,
      ),
    );
  }

  // ==========================================================
  // SUCCESS MESSAGE
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
        // Sin message accesible.
      }
    }

    return 'Operación realizada correctamente.';
  }

  // ==========================================================
  // ERROR MESSAGE
  // ==========================================================
  String _getErrorMessage(ErrorData response) {
    final dynamic error = response.error;

    if (error != null && error.toString().trim().isNotEmpty) {
      return error.toString();
    }

    return 'Ocurrió un error inesperado.';
  }

  // ==========================================================
  // ERROR SNACKBAR
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

    return BlocListener<SubcategoriaBloc, SubcategoriaState>(
      listenWhen: (previous, current) {
        return previous.actionResponse != current.actionResponse;
      },
      listener: (context, state) {
        final Resource? response = state.actionResponse;

        if (response is Success) {
          final String message = _getSuccessMessage(response);

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.green),
            );

          context.read<SubcategoriaBloc>().add(
            const ClearSubcategoriaActionResponseEvent(),
          );

          if (_isDeleting) {
            _isDeleting = false;

            _close(result: true);

            return;
          }

          _loadSubcategoria();

          return;
        }

        if (response is ErrorData) {
          _isDeleting = false;

          _showError(_getErrorMessage(response));

          context.read<SubcategoriaBloc>().add(
            const ClearSubcategoriaActionResponseEvent(),
          );
        }
      },
      child: Scaffold(
        // ======================================================
        // APP BAR
        // ======================================================
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Cerrar',
            onPressed: () {
              _close();
            },
            icon: const Icon(Icons.close),
          ),
          title: const Text('Detalle de subcategoría'),
          actions: [
            BlocBuilder<SubcategoriaBloc, SubcategoriaState>(
              buildWhen: (previous, current) {
                return previous.subcategoriaSelected !=
                        current.subcategoriaSelected ||
                    previous.actionResponse != current.actionResponse;
              },
              builder: (context, state) {
                final SubcategoriaData? subcategoria =
                    state.subcategoriaSelected;

                if (subcategoria == null) {
                  return const SizedBox.shrink();
                }

                final bool isProcessing = state.actionResponse is Loading;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ==========================================
                    // ACTIVAR / DESACTIVAR
                    // ==========================================
                    IconButton(
                      tooltip: subcategoria.estado ? 'Desactivar' : 'Activar',
                      onPressed: isProcessing
                          ? null
                          : () {
                              _onChangeEstado(subcategoria);
                            },
                      icon: Icon(
                        subcategoria.estado
                            ? Icons.toggle_off_outlined
                            : Icons.toggle_on_outlined,
                      ),
                    ),

                    // ==========================================
                    // EDITAR
                    // ==========================================
                    IconButton(
                      tooltip: 'Editar subcategoría',
                      onPressed: isProcessing ? null : _onEdit,
                      icon: const Icon(Icons.edit_outlined),
                    ),

                    // ==========================================
                    // ELIMINAR
                    // ==========================================
                    IconButton(
                      tooltip: 'Eliminar subcategoría',
                      onPressed: isProcessing
                          ? null
                          : () {
                              _onDelete(subcategoria);
                            },
                      icon: const Icon(Icons.delete_outline),
                    ),

                    const SizedBox(width: 6),
                  ],
                );
              },
            ),
          ],
        ),

        // ======================================================
        // BODY
        // ======================================================
        body: idEmpresa == null
            ? const _EmpresaNoSeleccionada()
            : BlocBuilder<SubcategoriaBloc, SubcategoriaState>(
                buildWhen: (previous, current) {
                  return previous.detailResponse != current.detailResponse ||
                      previous.subcategoriaSelected !=
                          current.subcategoriaSelected ||
                      previous.actionResponse != current.actionResponse;
                },
                builder: (context, state) {
                  if (state.detailResponse is Loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.detailResponse is ErrorData) {
                    final ErrorData error = state.detailResponse as ErrorData;

                    return _SubcategoriaDetailError(
                      message: _getErrorMessage(error),
                      onRetry: _loadSubcategoria,
                    );
                  }

                  final SubcategoriaData? subcategoria =
                      state.subcategoriaSelected;

                  if (subcategoria == null) {
                    return _SubcategoriaDetailError(
                      message: 'No se encontró la subcategoría.',
                      onRetry: _loadSubcategoria,
                    );
                  }

                  return SubcategoriaDetalleContent(subcategoria: subcategoria);
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
              'Selecciona una empresa para consultar '
              'la subcategoría.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// ERROR DETALLE
// ==========================================================
class _SubcategoriaDetailError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _SubcategoriaDetailError({
    required this.message,
    required this.onRetry,
  });

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
              'No se pudo cargar la subcategoría',
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
