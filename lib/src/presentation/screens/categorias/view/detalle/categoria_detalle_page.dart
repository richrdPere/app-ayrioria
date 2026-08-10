import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Session
import 'package:app_aryoria/src/config/core/session/session_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Bloc
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_event.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_state.dart';

// Content
import 'categoria_detalle_content.dart';

class CategoriaDetallePage extends StatefulWidget {
  final int idCategoria;

  const CategoriaDetallePage({super.key, required this.idCategoria});

  @override
  State<CategoriaDetallePage> createState() => _CategoriaDetallePageState();
}

class _CategoriaDetallePageState extends State<CategoriaDetallePage> {
  bool _isDeleting = false;

  late CategoriaBloc _categoriaBloc;

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

    _categoriaBloc = context.read<CategoriaBloc>();
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

      context.read<CategoriaBloc>().add(const ClearCategoriaSelectedEvent());

      _loadCategoria();
    });
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================
  @override
  void dispose() {
    _categoriaBloc.add(const ClearCategoriaSelectedEvent());

    super.dispose();
  }

  // ==========================================================
  // CARGAR CATEGORÍA
  // ==========================================================
  void _loadCategoria() {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      return;
    }

    context.read<CategoriaBloc>().add(
      GetCategoriaByIdEvent(
        idCategoria: widget.idCategoria,
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
  // EDITAR
  // ==========================================================
  Future<void> _onEdit() async {
    final result = await context.push(
      '/categorias/${widget.idCategoria}/editar',
    );

    if (!mounted) {
      return;
    }

    if (result == true) {
      _loadCategoria();
    }
  }

  // ==========================================================
  // ELIMINAR
  // ==========================================================
  Future<void> _onDelete(CategoriaData categoria) async {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      _showError('No se encontró la empresa activa.');

      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar categoría'),
          content: Text(
            '¿Está seguro de eliminar la categoría '
            '"${categoria.nombre}"?\n\n'
            'Esta acción podría no estar permitida '
            'si existen movimientos o subcategorías asociadas.',
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

    context.read<CategoriaBloc>().add(
      DeleteCategoriaEvent(
        idCategoria: categoria.idCategoria,
        idEmpresa: idEmpresa,
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
        // ApiResponse sin message accesible.
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
  // ERROR
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

    return BlocListener<CategoriaBloc, CategoriaState>(
      listenWhen: (previous, current) {
        return previous.actionResponse != current.actionResponse;
      },
      listener: (context, state) {
        final Resource? response = state.actionResponse;

        // ====================================================
        // SUCCESS
        // ====================================================
        if (response is Success) {
          final String message = _getSuccessMessage(response);

          context.read<CategoriaBloc>().add(
            const ClearCategoriaActionResponseEvent(),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.green),
            );

          if (_isDeleting) {
            _isDeleting = false;

            _close(result: true);

            return;
          }

          _loadCategoria();

          return;
        }

        // ====================================================
        // ERROR
        // ====================================================
        if (response is ErrorData) {
          _isDeleting = false;

          _showError(_getErrorMessage(response));

          context.read<CategoriaBloc>().add(
            const ClearCategoriaActionResponseEvent(),
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

          title: const Text('Detalle de categoría'),

          actions: [
            BlocBuilder<CategoriaBloc, CategoriaState>(
              buildWhen: (previous, current) {
                return previous.categoriaSelected !=
                        current.categoriaSelected ||
                    previous.actionResponse != current.actionResponse;
              },
              builder: (context, state) {
                final CategoriaData? categoria = state.categoriaSelected;

                if (categoria == null) {
                  return const SizedBox.shrink();
                }

                final bool isProcessing = state.actionResponse is Loading;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ==========================================
                    // EDITAR
                    // ==========================================
                    IconButton(
                      tooltip: 'Editar categoría',
                      onPressed: isProcessing ? null : _onEdit,
                      icon: const Icon(Icons.edit_outlined),
                    ),

                    // ==========================================
                    // ELIMINAR
                    // ==========================================
                    IconButton(
                      tooltip: 'Eliminar categoría',
                      onPressed: isProcessing
                          ? null
                          : () {
                              _onDelete(categoria);
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
            : BlocBuilder<CategoriaBloc, CategoriaState>(
                buildWhen: (previous, current) {
                  return previous.detailResponse != current.detailResponse ||
                      previous.categoriaSelected != current.categoriaSelected ||
                      previous.actionResponse != current.actionResponse;
                },
                builder: (context, state) {
                  // =============================================
                  // LOADING
                  // =============================================
                  if (state.detailResponse is Loading) {
                    return const _CategoriaDetalleLoading();
                  }

                  // =============================================
                  // ERROR
                  // =============================================
                  if (state.detailResponse is ErrorData) {
                    final ErrorData error = state.detailResponse as ErrorData;

                    return _CategoriaDetalleError(
                      message: _getErrorMessage(error),
                      onRetry: _loadCategoria,
                    );
                  }

                  // =============================================
                  // DATA
                  // =============================================
                  final CategoriaData? categoria = state.categoriaSelected;

                  if (categoria == null) {
                    return _CategoriaDetalleError(
                      message: 'No se encontró la categoría.',
                      onRetry: _loadCategoria,
                    );
                  }

                  return CategoriaDetalleContent(categoria: categoria);
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
              'Seleccione una empresa para consultar '
              'la categoría.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// LOADING
// ==========================================================
class _CategoriaDetalleLoading extends StatelessWidget {
  const _CategoriaDetalleLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

// ==========================================================
// ERROR
// ==========================================================
class _CategoriaDetalleError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CategoriaDetalleError({required this.message, required this.onRetry});

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
              'No se pudo cargar la categoría',
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
