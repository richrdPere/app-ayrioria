import 'package:app_aryoria/src/presentation/screens/subcategorias/view/form/subcategoria_form_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Session
import 'package:app_aryoria/src/config/core/session/session_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_create_req.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_data.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_update_req.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Bloc
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_event.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_state.dart';


class SubcategoriaFormPage extends StatefulWidget {
  final int? idSubcategoria;

  const SubcategoriaFormPage({super.key, this.idSubcategoria});

  bool get isEditing => idSubcategoria != null;

  @override
  State<SubcategoriaFormPage> createState() => _SubcategoriaFormPageState();
}

class _SubcategoriaFormPageState extends State<SubcategoriaFormPage> {
  // ==========================================================
  // EMPRESA ACTIVA
  // ==========================================================
  int? get _idEmpresa {
    return context.read<SessionBloc>().state.empresaActiva?.idEmpresa;
  }

  void _onSubmit(SubcategoriaFormValue value) {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      _showError('No se encontró una empresa activa.');

      return;
    }

    // ========================================================
    // EDITAR
    // ========================================================
    if (widget.isEditing) {
      final int? idSubcategoria = widget.idSubcategoria;

      if (idSubcategoria == null) {
        _showError('No se encontró la subcategoría a editar.');

        return;
      }

      final SubcategoriaUpdateRequest request = SubcategoriaUpdateRequest(
        idCategoria: value.idCategoria,
        nombre: value.nombre.trim(),
        descripcion: _nullableString(value.descripcion),
        esPredeterminada: value.esPredeterminada,
        orden: value.orden,
        estado: value.estado,
      );

      context.read<SubcategoriaBloc>().add(
        UpdateSubcategoriaEvent(
          idEmpresa: idEmpresa,
          idSubcategoria: idSubcategoria,
          request: request,
        ),
      );

      return;
    }

    // ========================================================
    // CREAR
    // ========================================================
    final SubcategoriaCreateRequest request = SubcategoriaCreateRequest(
      idCategoria: value.idCategoria,
      nombre: value.nombre.trim(),
      descripcion: _nullableString(value.descripcion),
      orden: value.orden,
      estado: value.estado,
    );

    context.read<SubcategoriaBloc>().add(
      CreateSubcategoriaEvent(idEmpresa: idEmpresa, request: request),
    );
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

      // Limpiar detalle anterior.
      context.read<SubcategoriaBloc>().add(
        const ClearSubcategoriaDetailEvent(),
      );

      _loadSubcategoria();
    });
  }

  // ==========================================================
  // CARGAR SUBCATEGORÍA PARA EDICIÓN
  // ==========================================================
  void _loadSubcategoria() {
    if (!widget.isEditing) {
      return;
    }

    final int? idEmpresa = _idEmpresa;
    final int? idSubcategoria = widget.idSubcategoria;

    if (idEmpresa == null || idSubcategoria == null) {
      return;
    }

    context.read<SubcategoriaBloc>().add(
      GetSubcategoriaByIdEvent(
        idEmpresa: idEmpresa,
        idSubcategoria: idSubcategoria,
      ),
    );
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
        // Respuesta sin propiedad message.
      }
    }

    return widget.isEditing
        ? 'Subcategoría actualizada correctamente.'
        : 'Subcategoría creada correctamente.';
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

    return BlocListener<SubcategoriaBloc, SubcategoriaState>(
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

          context.read<SubcategoriaBloc>().add(
            const ClearSubcategoriaActionResponseEvent(),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.green),
            );

          _close(result: true);

          return;
        }

        // ====================================================
        // ERROR
        // ====================================================
        if (response is ErrorData) {
          _showError(_getErrorMessage(response));

          context.read<SubcategoriaBloc>().add(
            const ClearSubcategoriaActionResponseEvent(),
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
            widget.isEditing ? 'Editar subcategoría' : 'Nueva subcategoría',
          ),
        ),

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

                    return _SubcategoriaDetailError(
                      message: _getErrorMessage(error),
                      onRetry: _loadSubcategoria,
                    );
                  }

                  // =============================================
                  // SUBCATEGORÍA
                  // =============================================
                  final SubcategoriaData? subcategoria = widget.isEditing
                      ? state.subcategoriaSelected
                      : null;

                  // =============================================
                  // SIN DATA
                  // =============================================
                  if (widget.isEditing && subcategoria == null) {
                    return _SubcategoriaDetailError(
                      message: 'No se encontró la subcategoría.',
                      onRetry: _loadSubcategoria,
                    );
                  }

                  // =============================================
                  // FORM CONTENT
                  // =============================================
                  return SubcategoriaFormContent(
                    subcategoria: subcategoria,
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
              'o editar una subcategoría.',
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
