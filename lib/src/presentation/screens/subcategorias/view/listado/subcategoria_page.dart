import 'package:app_aryoria/src/data/models/categoria/categoria_query_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/sub_categoria/sub_categoria_data.dart';

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
  @override
  void initState() {
    super.initState();

    // ---------------------------------------------------------
    // Cargar subcategorías
    // ---------------------------------------------------------
    context.read<SubcategoriaBloc>().add(
      GetSubcategoriasPaginatedEvent(
        idEmpresa: widget.idEmpresa,
        queryParams: const {'page': 1, 'limit': 10},
      ),
    );

    // ---------------------------------------------------------
    // Cargar categorías para filtros/formularios
    // ---------------------------------------------------------

    final queryParams = CategoriasParams(page: 1, limit: 10);

    context.read<CategoriaBloc>().add(
      GetCategoriasEvent(idEmpresa: widget.idEmpresa, queryParams: queryParams),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubcategoriaBloc, SubcategoriaState>(
      listenWhen: (previous, current) {
        return previous.actionResponse != current.actionResponse ||
            previous.deleteResponse != current.deleteResponse;
      },
      listener: _handleListener,
      child: SubcategoriaContent(idEmpresa: widget.idEmpresa),
    );
  }

  // ==========================================================
  // LISTENER
  // ==========================================================

  void _handleListener(BuildContext context, SubcategoriaState state) {
    final actionResponse = state.actionResponse;

    final deleteResponse = state.deleteResponse;

    // ========================================================
    // CREATE / UPDATE / CHANGE ESTADO
    // ========================================================

    if (actionResponse is Success<ApiResponse<SubcategoriaData>>) {
      final apiResponse = actionResponse.data;

      _showSuccess(context, apiResponse.message);

      _refreshSubcategorias();

      context.read<SubcategoriaBloc>().add(
        const ClearSubcategoriaActionResponseEvent(),
      );

      return;
    }

    if (actionResponse is ErrorData<ApiResponse<SubcategoriaData>>) {
      _showError(context, actionResponse.displayMessage);

      context.read<SubcategoriaBloc>().add(
        const ClearSubcategoriaActionResponseEvent(),
      );

      return;
    }

    // ========================================================
    // DELETE
    // ========================================================

    if (deleteResponse is Success<ApiResponse<void>>) {
      final apiResponse = deleteResponse.data;

      _showSuccess(context, apiResponse.message);

      _refreshSubcategorias();

      context.read<SubcategoriaBloc>().add(
        const ClearSubcategoriaActionResponseEvent(),
      );

      return;
    }

    if (deleteResponse is ErrorData<ApiResponse<void>>) {
      _showError(context, deleteResponse.displayMessage);

      context.read<SubcategoriaBloc>().add(
        const ClearSubcategoriaActionResponseEvent(),
      );
    }
  }

  // ==========================================================
  // REFRESH
  // ==========================================================

  void _refreshSubcategorias() {
    context.read<SubcategoriaBloc>().add(
      GetSubcategoriasPaginatedEvent(
        idEmpresa: widget.idEmpresa,
        queryParams: const {'page': 1, 'limit': 10},
      ),
    );
  }

  // ==========================================================
  // SUCCESS MESSAGE
  // ==========================================================

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  // ==========================================================
  // ERROR MESSAGE
  // ==========================================================

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
