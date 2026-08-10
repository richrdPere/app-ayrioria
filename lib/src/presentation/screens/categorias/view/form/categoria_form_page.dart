import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Session
import 'package:app_aryoria/src/config/core/session/session_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_request.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Bloc
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_event.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_state.dart';

// Content
import 'categoria_form_content.dart';

class CategoriaFormPage extends StatefulWidget {
  final int? idCategoria;

  const CategoriaFormPage({super.key, this.idCategoria});

  bool get isEditing => idCategoria != null;

  @override
  State<CategoriaFormPage> createState() => _CategoriaFormPageState();
}

class _CategoriaFormPageState extends State<CategoriaFormPage> {
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

      // Limpiar una categoría seleccionada anteriormente.
      context.read<CategoriaBloc>().add(const ClearCategoriaSelectedEvent());

      _loadCategoria();
    });
  }

  // ==========================================================
  // CARGAR CATEGORÍA PARA EDICIÓN
  // ==========================================================
  void _loadCategoria() {
    if (!widget.isEditing) {
      return;
    }

    final int? idEmpresa = _idEmpresa;
    final int? idCategoria = widget.idCategoria;

    if (idEmpresa == null || idCategoria == null) {
      return;
    }

    context.read<CategoriaBloc>().add(
      GetCategoriaByIdEvent(idCategoria: idCategoria, idEmpresa: idEmpresa),
    );
  }

  // ==========================================================
  // CREAR / ACTUALIZAR
  // ==========================================================
  void _onSubmit(CategoriaFormValue value) {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      _showError('No se encontró una empresa activa.');

      return;
    }

    // ========================================================
    // REQUEST
    // ========================================================
    final CategoriaRequest request = CategoriaRequest(
      idEmpresa: idEmpresa,
      nombre: value.nombre.trim(),
      tipo: value.tipo.trim().toUpperCase(),
      naturaleza: value.naturaleza.trim().toUpperCase(),
      descripcion: _nullableString(value.descripcion),
      color: _nullableString(value.color),
      icono: _nullableString(value.icono),
    );

    // ========================================================
    // EDITAR
    // ========================================================
    if (widget.isEditing) {
      final int? idCategoria = widget.idCategoria;

      if (idCategoria == null) {
        return;
      }

      context.read<CategoriaBloc>().add(
        UpdateCategoriaEvent(
          idCategoria: idCategoria,
          idEmpresa: idEmpresa,
          request: request,
        ),
      );

      return;
    }

    // ========================================================
    // CREAR
    // ========================================================
    context.read<CategoriaBloc>().add(CreateCategoriaEvent(request: request));
  }

  // ==========================================================
  // NORMALIZAR STRING OPCIONAL
  // ==========================================================
  String? _nullableString(String? value) {
    final String? normalized = value?.trim();

    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized;
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

    return widget.isEditing
        ? 'Categoría actualizada correctamente.'
        : 'Categoría creada correctamente.';
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

          // Devuelve true al listado o detalle.
          _close(result: true);

          return;
        }

        // ====================================================
        // ERROR
        // ====================================================
        if (response is ErrorData) {
          _showError(_getErrorMessage(response));

          context.read<CategoriaBloc>().add(
            const ClearCategoriaActionResponseEvent(),
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
          title: Text(
            widget.isEditing ? 'Editar categoría' : 'Nueva categoría',
          ),
        ),

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

                    return _CategoriaDetailError(
                      message: _getErrorMessage(error),
                      onRetry: _loadCategoria,
                    );
                  }

                  // =============================================
                  // CATEGORÍA
                  // =============================================
                  final CategoriaData? categoria = widget.isEditing
                      ? state.categoriaSelected
                      : null;

                  // =============================================
                  // SIN DATA EN EDICIÓN
                  // =============================================
                  if (widget.isEditing && categoria == null) {
                    return _CategoriaDetailError(
                      message: 'No se encontró la categoría.',
                      onRetry: _loadCategoria,
                    );
                  }

                  // =============================================
                  // FORM
                  // =============================================
                  return CategoriaFormContent(
                    categoria: categoria,
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
              'o editar una categoría.',
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
class _CategoriaDetailError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CategoriaDetailError({required this.message, required this.onRetry});

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
