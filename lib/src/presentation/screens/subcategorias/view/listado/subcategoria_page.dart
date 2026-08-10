import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_query_params.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_data.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/subcategoria_query_params.dart';

// Categoria
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_event.dart';

// Subcategoria
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_event.dart';
import 'package:app_aryoria/src/presentation/screens/subcategorias/bloc/subcategoria_state.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// View
import 'package:app_aryoria/src/presentation/screens/subcategorias/view/listado/subcategoria_content.dart';

class SubcategoriaPage extends StatefulWidget {
  final int idEmpresa;

  const SubcategoriaPage({super.key, required this.idEmpresa});

  @override
  State<SubcategoriaPage> createState() => _SubcategoriaPageState();
}

class _SubcategoriaPageState extends State<SubcategoriaPage> {
  // ==========================================================
  // CONFIGURACIÓN
  // ==========================================================
  static const int _defaultLimit = 10;

  // ==========================================================
  // INIT
  // ==========================================================
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _loadInitialData();
    });
  }

  // ==========================================================
  // CARGA INICIAL
  // ==========================================================
  void _loadInitialData() {
    _loadSubcategorias(page: 1, refresh: true);

    _loadCategorias();
  }

  // ==========================================================
  // CARGAR SUBCATEGORÍAS
  // ==========================================================
  void _loadSubcategorias({
    int page = 1,
    int limit = _defaultLimit,
    bool refresh = false,
  }) {
    final SubcategoriasParams queryParams = SubcategoriasParams(
      page: page,
      limit: limit,
    );

    context.read<SubcategoriaBloc>().add(
      GetSubcategoriasPaginatedEvent(
        idEmpresa: widget.idEmpresa,
        queryParams: queryParams,
        refresh: refresh,
      ),
    );
  }

  // ==========================================================
  // CARGAR CATEGORÍAS
  // ==========================================================
  void _loadCategorias() {
    const CategoriasParams queryParams = CategoriasParams(page: 1, limit: 100);

    context.read<CategoriaBloc>().add(
      GetCategoriasEvent(
        idEmpresa: widget.idEmpresa,
        queryParams: queryParams,
        refresh: true,
      ),
    );
  }

  // ==========================================================
  // REFRESH
  // ==========================================================
  // void _refreshSubcategorias() {
  //   _loadSubcategorias(page: 1, refresh: true);
  // }

  // ==========================================================
  // BUILD
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    return BlocListener<SubcategoriaBloc, SubcategoriaState>(
      listenWhen: (previous, current) {
        return previous.actionResponse != current.actionResponse;
      },
      listener: _handleListener,
      child: SubcategoriaContent(idEmpresa: widget.idEmpresa),
    );
  }

  // ==========================================================
  // LISTENER
  // ==========================================================
  void _handleListener(BuildContext context, SubcategoriaState state) {
    final Resource? response = state.actionResponse;

    // ========================================================
    // LOADING
    // ========================================================
    if (response == null || response is Loading) {
      return;
    }

    // ========================================================
    // SUCCESS CREATE / UPDATE / ESTADO
    // ========================================================
    if (response is Success<ApiResponse<SubcategoriaData>>) {
      final ApiResponse<SubcategoriaData> apiResponse = response.data;

      _showSuccess(context, apiResponse.message);

      /*
       * El Bloc ya actualiza localmente el registro,
       * pero refrescamos para respetar filtros, orden
       * y paginación provenientes del backend.
       */
      _refreshCurrentPage();

      _clearActionResponse();

      return;
    }

    // ========================================================
    // SUCCESS DELETE
    // ========================================================
    if (response is Success<ApiResponse<void>>) {
      final ApiResponse<void> apiResponse = response.data;

      _showSuccess(context, apiResponse.message);

      _refreshAfterDelete();

      _clearActionResponse();

      return;
    }

    // ========================================================
    // ERROR
    // ========================================================
    if (response is ErrorData) {
      _showError(context, _getErrorMessage(response));

      _clearActionResponse();
    }
  }

  // ==========================================================
  // REFRESCAR PÁGINA ACTUAL
  // ==========================================================
  void _refreshCurrentPage() {
    final SubcategoriaState state = context.read<SubcategoriaBloc>().state;

    int page = state.page;

    if (page < 1) {
      page = 1;
    }

    _loadSubcategorias(page: page, limit: state.limit, refresh: true);
  }

  // ==========================================================
  // REFRESH DESPUÉS DE ELIMINAR
  // ==========================================================
  void _refreshAfterDelete() {
    final SubcategoriaState state = context.read<SubcategoriaBloc>().state;

    int page = state.page;

    /*
     * Ejemplo:
     *
     * Estábamos en página 3.
     * Eliminamos el único registro de página 3.
     * Ahora totalPages = 2.
     *
     * Debemos volver a página 2.
     */
    if (state.totalPages > 0 && page > state.totalPages) {
      page = state.totalPages;
    }

    if (page < 1) {
      page = 1;
    }

    _loadSubcategorias(page: page, limit: state.limit, refresh: true);
  }

  // ==========================================================
  // LIMPIAR ACTION RESPONSE
  // ==========================================================
  void _clearActionResponse() {
    context.read<SubcategoriaBloc>().add(
      const ClearSubcategoriaActionResponseEvent(),
    );
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
  // SUCCESS MESSAGE
  // ==========================================================
  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message.trim().isEmpty
                ? 'Operación realizada correctamente.'
                : message,
          ),
          backgroundColor: Colors.green,
        ),
      );
  }

  // ==========================================================
  // ERROR MESSAGE
  // ==========================================================
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
  }
}
