import 'package:app_aryoria/src/config/core/session/session_bloc.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_event.dart';
import 'package:app_aryoria/src/presentation/screens/reportes/bloc/reporte_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/reportes/bloc/reporte_state.dart';
import 'package:app_aryoria/src/presentation/screens/reportes/view/reportes_content.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportePage extends StatefulWidget {
  const ReportePage({super.key});

  @override
  State<ReportePage> createState() => _ReportePageState();
}

class _ReportePageState extends State<ReportePage> {
  // int? _idEmpresa;
  int? get _idEmpresa {
    return context.read<SessionBloc>().state.empresaActiva?.idEmpresa;
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(_loadInitialData);
  }

  void _loadInitialData() {
    if (!mounted) return;

    final int? idEmpresa = _idEmpresa;

    debugPrint("ID EMPRESA: $idEmpresa");

    if (idEmpresa == null) {
      return;
    }

    // final session = context.read<SessionBloc>().state;
    // final idEmpresa = session.empresaActiva?.idEmpresa;

    // if (idEmpresa == null) {
    //   return;
    // }

    // _idEmpresa = idEmpresa;

    context.read<PeriodoContableBloc>().add(
      GetPeriodosContablesEvent(idEmpresa: idEmpresa, page: 1),
    );
  }

  @override
  void dispose() {
    /*
     * No uses context.read() directamente en dispose si el BLoC
     * se encuentra por encima en el árbol y puede estar desactivado.
     *
     * Si deseas limpiar el reporte, puedes hacerlo antes de navegar
     * o mantener el estado en memoria.
     */
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      return const _EmpresaNoDisponible();
    }

    return BlocListener<ReporteBloc, ReporteState>(
      listenWhen: (previous, current) {
        return previous.generalResponse != current.generalResponse;
      },
      listener: (context, state) {
        final Resource response = state.generalResponse;

        if (response is ErrorData) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(response.error),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
        }
      },
      child: ReporteContent(idEmpresa: idEmpresa),
    );
  }
}

class _EmpresaNoDisponible extends StatelessWidget {
  const _EmpresaNoDisponible();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.business_outlined,
              size: 58,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No existe una empresa activa',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Selecciona una empresa antes de consultar los reportes.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
