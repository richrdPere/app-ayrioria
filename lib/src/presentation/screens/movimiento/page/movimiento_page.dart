import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_response.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_event.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_state.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/view/movimiento_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovimientoPage extends StatefulWidget {
  const MovimientoPage({super.key});

  @override
  State<MovimientoPage> createState() => _MovimientoPageState();
}

class _MovimientoPageState extends State<MovimientoPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final session = context.read<SessionBloc>().state;
      final idEmpresa = session.empresaActiva?.idEmpresa;

      if (idEmpresa != null) {
        context.read<MovimientoBloc>().add(
          GetMovimientosEvent(idEmpresa: idEmpresa),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MovimientoBloc, MovimientoState>(
      listenWhen: (previous, current) =>
          previous.actionResponse != current.actionResponse,

      listener: (context, state) {
        final response = state.actionResponse;

        if (response is Success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Operación realizada correctamente.'),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (response is ErrorData<MovimientoResponse>) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.error),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: const MovimientoContent(),
    );
  }
}
