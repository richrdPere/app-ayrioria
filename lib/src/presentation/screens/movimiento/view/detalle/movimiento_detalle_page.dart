import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_event.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_state.dart';

import 'package:app_aryoria/src/presentation/screens/movimiento/view/detalle/movimiento_detalle_content.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MovimientoDetailPage extends StatefulWidget {
  final int idMovimiento;

  const MovimientoDetailPage({super.key, required this.idMovimiento});

  @override
  State<MovimientoDetailPage> createState() => _MovimientoDetailPageState();
}

class _MovimientoDetailPageState extends State<MovimientoDetailPage> {
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

      _loadMovimiento();
    });
  }

  // ==========================================================
  // CARGAR MOVIMIENTO
  // ==========================================================

  void _loadMovimiento() {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      _showError('No existe una empresa activa.');
      return;
    }

    context.read<MovimientoBloc>().add(
      GetMovimientoByIdEvent(
        idMovimiento: widget.idMovimiento,
        idEmpresa: idEmpresa,
      ),
    );
  }

  // ==========================================================
  // EDITAR
  // ==========================================================

  Future<void> _onEditMovimiento() async {
    final result = await context.pushNamed(
      'editar_movimiento',
      pathParameters: {'idMovimiento': widget.idMovimiento.toString()},
    );

    if (!mounted) {
      return;
    }

    // Si fue actualizado, volvemos a consultar
    // el detalle desde backend.
    if (result == true) {
      _loadMovimiento();
    }
  }

  // ==========================================================
  // ELIMINAR
  // ==========================================================

  Future<void> _onDeleteMovimiento() async {
    final int? idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      _showError('No existe una empresa activa.');
      return;
    }

    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          title: const Text('Eliminar movimiento'),
          content: const Text(
            '¿Estás seguro de eliminar este movimiento? '
            'Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    context.read<MovimientoBloc>().add(
      DeleteMovimientoEvent(
        idMovimiento: widget.idMovimiento,
        idEmpresa: idEmpresa,
      ),
    );
  }

  // ==========================================================
  // MENSAJE DE ACTION
  // ==========================================================

  String _getActionMessage(Resource response, {required String fallback}) {
    if (response is Success) {
      final dynamic result = response.data;

      if (result is ApiResponse) {
        final String message = result.message.trim();

        if (message.isNotEmpty) {
          return message;
        }
      }
    }

    return fallback;
  }

  // ==========================================================
  // MENSAJES
  // ==========================================================

  void _showSuccess(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
  }

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
    return MultiBlocListener(
      listeners: [
        // ======================================================
        // ERROR AL OBTENER DETALLE
        // ======================================================
        BlocListener<MovimientoBloc, MovimientoState>(
          listenWhen: (previous, current) {
            return previous.detailResponse != current.detailResponse;
          },
          listener: (context, state) {
            final Resource? response = state.detailResponse;

            if (response is ErrorData) {
              _showError(response.displayMessage);
            }
          },
        ),

        // ======================================================
        // ELIMINAR
        // ======================================================
        BlocListener<MovimientoBloc, MovimientoState>(
          listenWhen: (previous, current) {
            return previous.actionResponse != current.actionResponse;
          },
          listener: (context, state) {
            final Resource? response = state.actionResponse;

            if (response == null) {
              return;
            }

            // ================================================
            // SUCCESS
            // ================================================
            if (response is Success) {
              final String message = _getActionMessage(
                response,
                fallback: 'Movimiento eliminado correctamente.',
              );

              _showSuccess(message);

              context.read<MovimientoBloc>().add(
                const ClearMovimientoActionResponseEvent(),
              );

              // true indica al listado que debe recargar.
              context.pop(true);

              return;
            }

            // ================================================
            // ERROR
            // ================================================
            if (response is ErrorData) {
              _showError(response.displayMessage);

              context.read<MovimientoBloc>().add(
                const ClearMovimientoActionResponseEvent(),
              );
            }
          },
        ),
      ],

      // ========================================================
      // FULL SCREEN DETAIL
      // ========================================================
      child: Scaffold(
        appBar: AppBar(
          // X porque es un fullscreen dialog.
          leading: IconButton(
            tooltip: 'Cerrar',
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.close_rounded),
          ),

          title: const Text('Detalle del movimiento'),

          actions: [
            // ==================================================
            // EDITAR
            // ==================================================
            IconButton(
              tooltip: 'Editar movimiento',
              onPressed: _onEditMovimiento,
              icon: const Icon(Icons.edit_outlined),
            ),

            // ==================================================
            // MENÚ EXTRA
            // ==================================================
            PopupMenuButton<String>(
              tooltip: 'Más opciones',
              onSelected: (value) {
                if (value == 'eliminar') {
                  _onDeleteMovimiento();
                }
              },
              itemBuilder: (_) {
                return const [
                  PopupMenuItem<String>(
                    value: 'eliminar',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red),
                        SizedBox(width: 10),
                        Text('Eliminar', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ],
        ),

        body: BlocBuilder<MovimientoBloc, MovimientoState>(
          buildWhen: (previous, current) {
            return previous.detailResponse != current.detailResponse ||
                previous.movimientoSelected != current.movimientoSelected ||
                previous.actionResponse != current.actionResponse;
          },
          builder: (context, state) {
            final Resource? response = state.detailResponse;

            // ================================================
            // ESTADO INICIAL / LOADING
            // ================================================
            if (response == null || response is Loading) {
              return const Center(child: CircularProgressIndicator());
            }

            // ================================================
            // ERROR
            // ================================================
            if (response is ErrorData) {
              return _MovimientoDetailError(
                message: response.displayMessage,
                onRetry: _loadMovimiento,
              );
            }

            // ================================================
            // SUCCESS
            // ================================================
            if (response is Success) {
              final MovimientoData? movimiento = state.movimientoSelected;

              if (movimiento == null) {
                return _MovimientoDetailError(
                  message: 'No se encontró la información del movimiento.',
                  onRetry: _loadMovimiento,
                );
              }

              return MovimientoDetailContent(movimiento: movimiento);
            }

            return _MovimientoDetailError(
              message: 'No se pudo cargar el movimiento.',
              onRetry: _loadMovimiento,
            );
          },
        ),
      ),
    );
  }
}

// ==========================================================
// ERROR DETAIL
// ==========================================================
class _MovimientoDetailError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MovimientoDetailError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: colors.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.error_outline, size: 42, color: colors.error),
              ),

              const SizedBox(height: 20),

              Text(
                'No fue posible cargar el movimiento',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
// import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
// import 'package:app_aryoria/src/data/models/movimientos/movimiento_response.dart';
// import 'package:app_aryoria/src/domain/utils/Resource.dart';

// import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_bloc.dart';
// import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_event.dart';
// import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_state.dart';
// import 'package:app_aryoria/src/presentation/screens/movimiento/view/detalle/movimiento_detalle_content.dart';

// import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_bloc.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class MovimientoDetailPage extends StatefulWidget {
//   final int idMovimiento;

//   const MovimientoDetailPage({super.key, required this.idMovimiento});

//   @override
//   State<MovimientoDetailPage> createState() => _MovimientoDetailPageState();
// }

// class _MovimientoDetailPageState extends State<MovimientoDetailPage> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;

//       _loadMovimiento();
//     });
//   }

//   @override
//   void dispose() {
//     /*
//      * No usamos context.read() aquí para evitar:
//      *
//      * Looking up a deactivated widget's ancestor is unsafe.
//      *
//      * La respuesta del detalle se limpiará antes de cargar otro
//      * movimiento o al regresar correctamente.
//      */
//     super.dispose();
//   }

//   // ==========================================================
//   // EMPRESA ACTIVA
//   // ==========================================================
//   int? get _idEmpresa {
//     return context.read<SessionBloc>().state.empresaActiva?.idEmpresa;
//   }

//   // ==========================================================
//   // PERÍODO ACTIVO
//   // ==========================================================
//   int? get _idPeriodo {
//     return context.read<PeriodoContableBloc>().state.idPeriodoActivo;
//   }

//   // ==========================================================
//   // CARGAR DETALLE
//   // ==========================================================
//   void _loadMovimiento() {
//     final int? idEmpresa = _idEmpresa;

//     if (idEmpresa == null) {
//       _showError('No existe una empresa  activo.');
//       return;
//     }
//     context.read<MovimientoBloc>().add(
//       GetMovimientoByIdEvent(
//         idMovimiento: widget.idMovimiento,
//         idEmpresa: idEmpresa,
//       ),
//     );
//   }

//   // ==========================================================
//   // EDITAR MOVIMIENTO
//   // ==========================================================
//   Future<void> _onEditMovimiento() async {
//     final bool? result = await context.push<bool>(
//       '/movimientos/${widget.idMovimiento}/editar',
//     );

//     if (!mounted) {
//       return;
//     }

//     if (result == true) {
//       _loadMovimiento();
//     }
//   }

//   // ==========================================================
//   // ELIMINAR MOVIMIENTO
//   // ==========================================================
//   Future<void> _onDeleteMovimiento() async {
//     final int? idEmpresa = _idEmpresa;
//     final int? idPeriodo = _idPeriodo;

//     if (idEmpresa == null || idPeriodo == null) {
//       _showError('No existe una empresa o período contable activo.');
//       return;
//     }

//     final bool? confirmed = await showDialog<bool>(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           title: const Text('Eliminar movimiento'),
//           content: const Text(
//             '¿Estás seguro de eliminar este movimiento? '
//             'Esta acción no se puede deshacer.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop(false);
//               },
//               child: const Text('Cancelar'),
//             ),
//             FilledButton(
//               onPressed: () {
//                 Navigator.of(dialogContext).pop(true);
//               },
//               style: FilledButton.styleFrom(backgroundColor: Colors.red),
//               child: const Text('Eliminar'),
//             ),
//           ],
//         );
//       },
//     );

//     if (!mounted || confirmed != true) {
//       return;
//     }

//     context.read<MovimientoBloc>().add(
//       DeleteMovimientoEvent(
//         idMovimiento: widget.idMovimiento,
//         idEmpresa: idEmpresa,
//       ),
//     );
//   }

//   // ==========================================================
//   // MENSAJES
//   // ==========================================================
//   void _showSuccess(String message) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(content: Text(message), backgroundColor: Colors.green),
//       );
//   }

//   void _showError(String message) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(content: Text(message), backgroundColor: Colors.red),
//       );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         // ======================================================
//         // ESCUCHAR ERRORES DEL DETALLE
//         // ======================================================
//         BlocListener<MovimientoBloc, MovimientoState>(
//           listenWhen: (previous, current) {
//             return previous.detailResponse != current.detailResponse;
//           },
//           listener: (context, state) {
//             final Resource? response = state.detailResponse;

//             if (response is ErrorData) {
//               _showError(response.displayMessage);
//             }
//           },
//         ),

//         // ======================================================
//         // ESCUCHAR ELIMINACIÓN
//         // ======================================================
//         BlocListener<MovimientoBloc, MovimientoState>(
//           listenWhen: (previous, current) {
//             return previous.actionResponse != current.actionResponse;
//           },
//           listener: (context, state) {
//             final Resource? response = state.actionResponse;

//             if (response == null) {
//               return;
//             }

//             if (response is Success) {
//               final String message = response.data.message.isNotEmpty
//                   ? response.data.message
//                   : 'Movimiento eliminado correctamente.';

//               _showSuccess(message);

//               context.read<MovimientoBloc>().add(
//                 const ClearMovimientoActionResponseEvent(),
//               );

//               context.pop(true);
//             }

//             if (response is ErrorData<MovimientoResponse>) {
//               _showError(response.displayMessage);

//               context.read<MovimientoBloc>().add(
//                 const ClearMovimientoActionResponseEvent(),
//               );
//             }
//           },
//         ),
//       ],
//       child: BlocBuilder<MovimientoBloc, MovimientoState>(
//   buildWhen: (previous, current) {
//     return previous.detailResponse != current.detailResponse ||
//         previous.movimientoSelected != current.movimientoSelected ||
//         previous.actionResponse != current.actionResponse;
//   },
//   builder: (context, state) {
//     final Resource? response = state.detailResponse;

//     // ========================================================
//     // LOADING
//     // ========================================================
//     if (response is Loading) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     // ========================================================
//     // ERROR
//     // ========================================================
//     if (response is ErrorData) {
//       return _MovimientoDetailError(
//         message: response.displayMessage,
//         onRetry: _loadMovimiento,
//       );
//     }

//     // ========================================================
//     // SUCCESS
//     // ========================================================
//     if (response is Success) {
//       final MovimientoData? movimiento =
//           state.movimientoSelected;

//       if (movimiento == null) {
//         return _MovimientoDetailError(
//           message:
//               'No se encontró la información del movimiento.',
//           onRetry: _loadMovimiento,
//         );
//       }

//       return MovimientoDetailContent(
//         movimiento: movimiento,
//         isDeleting: state.actionResponse is Loading,
//         onEdit: _onEditMovimiento,
//         onDelete: _onDeleteMovimiento,
//       );
//     }

//     // ========================================================
//     // ESTADO INICIAL
//     // ========================================================
//     return const Center(
//       child: CircularProgressIndicator(),
//     );
//   },
// ),
//     );
//   }
// }

// class _MovimientoDetailError extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;

//   const _MovimientoDetailError({required this.message, required this.onRetry});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.error_outline,
//               size: 70,
//               color: Theme.of(context).colorScheme.error,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 22),
//             FilledButton.icon(
//               onPressed: onRetry,
//               icon: const Icon(Icons.refresh),
//               label: const Text('Reintentar'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
