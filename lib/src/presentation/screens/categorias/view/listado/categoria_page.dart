import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Session
import 'package:app_aryoria/src/config/core/session/session_bloc.dart';

// Models
import 'package:app_aryoria/src/data/models/categoria/categoria_query_params.dart';

// Bloc
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_event.dart';

// Content
import 'package:app_aryoria/src/presentation/screens/categorias/view/listado/categoria_content.dart';

class CategoriaPage extends StatefulWidget {
  const CategoriaPage({super.key});

  @override
  State<CategoriaPage> createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _loadCategorias(page: 1, refresh: true);
    });
  }

  // ==========================================================
  // CARGAR CATEGORÍAS
  // ==========================================================
  void _loadCategorias({int page = 1, int limit = 10, bool refresh = false}) {
    final int? idEmpresa = _idEmpresa;

    debugPrint('ID EMPRESA: $idEmpresa');

    if (idEmpresa == null) {
      debugPrint('No existe una empresa activa.');

      return;
    }

    final CategoriasParams queryParams = CategoriasParams(
      page: page,
      limit: limit,
    );

    context.read<CategoriaBloc>().add(
      GetCategoriasEvent(
        idEmpresa: idEmpresa,
        queryParams: queryParams,
        refresh: refresh,
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      return const _EmpresaNoSeleccionada();
    }

    return const CategoriaContent();
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
            Icon(Icons.business_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay una empresa seleccionada.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Seleccione una empresa para consultar sus categorías.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
