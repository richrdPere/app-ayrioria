import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_event.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/view/categoria_list/categoria_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriaPage extends StatefulWidget {
  const CategoriaPage({super.key});

  @override
  State<CategoriaPage> createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final session = context.read<SessionBloc>().state;
      final idEmpresa = session.empresaActiva?.idEmpresa;

      debugPrint('ID EMPRESA: $idEmpresa');

      if (idEmpresa == null) {
        debugPrint('No existe una empresa activa.');
        return;
      }

      context.read<CategoriaBloc>().add(
        GetCategoriasEvent(page: 1, limit: 10, idEmpresa: idEmpresa),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CategoriaContent();
  }
}
