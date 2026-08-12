// ==========================================================
// MOVIMIENTO CARD
// ==========================================================

import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MovimientoCard extends StatelessWidget {
  final MovimientoData movimiento;

  /// Abre el detalle del movimiento.
  final VoidCallback onTap;

  /// Abre el formulario de edición.
  final VoidCallback onEdit;

  /// Elimina el movimiento.
  final VoidCallback onDelete;

  const MovimientoCard({
    super.key,
    required this.movimiento,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  // ==========================================================
  // TIPO
  // ==========================================================
  bool get isIngreso {
    return movimiento.tipo.toUpperCase() == 'INGRESO';
  }

  // ==========================================================
  // MONTO
  // ==========================================================
  String get montoFormateado {
    final formatter = NumberFormat.currency(
      locale: 'es_PE',
      symbol: 'S/ ',
      decimalDigits: 2,
    );

    return formatter.format(movimiento.monto);
  }

  // ==========================================================
  // FECHA
  // ==========================================================
  String get fechaFormateada {
    final date = DateTime.tryParse(movimiento.fecha);

    if (date == null) {
      return movimiento.fecha;
    }

    return DateFormat('dd MMM yyyy', 'es_PE').format(date);
  }

  // ==========================================================
  // COLOR TIPO
  // ==========================================================
  Color _tipoColor(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (isIngreso) {
      return Colors.green.shade600;
    }

    return colors.error;
  }

  // ==========================================================
  // COLOR ESTADO
  // ==========================================================
  Color _estadoColor(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    switch (movimiento.estado.toUpperCase()) {
      case 'PAGADO':
        return Colors.green.shade600;

      case 'PENDIENTE':
        return Colors.orange.shade700;

      case 'ANULADO':
        return colors.error;

      default:
        return colors.onSurfaceVariant;
    }
  }

  // ==========================================================
  // ICONO ESTADO
  // ==========================================================
  IconData get _estadoIcon {
    switch (movimiento.estado.toUpperCase()) {
      case 'PAGADO':
        return Icons.check_circle_outline_rounded;

      case 'PENDIENTE':
        return Icons.schedule_rounded;

      case 'ANULADO':
        return Icons.cancel_outlined;

      default:
        return Icons.info_outline_rounded;
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    // final String categoria = movimiento.categoria?.nombre ?? 'Sin categoría';

    final String subcategoria =
        movimiento.subcategoria?.nombre ?? 'Sin subcategoría';

    final Color tipoColor = _tipoColor(context);
    final Color estadoColor = _estadoColor(context);

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,

      // ======================================================
      // SUPERFICIE ADAPTABLE
      // ======================================================
      color: colors.surfaceContainerLow,

      shadowColor: colors.shadow.withValues(alpha: 0.12),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.65)),
      ),

      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // CABECERA
              // ==================================================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==============================================
                  // ICONO INGRESO / EGRESO
                  // ==============================================
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: tipoColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: tipoColor.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Icon(
                      isIngreso
                          ? Icons.south_west_rounded
                          : Icons.north_east_rounded,
                      color: tipoColor,
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // ==============================================
                  // DESCRIPCIÓN
                  // ==============================================
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movimiento.descripcion,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                          ),
                        ),

                        const SizedBox(height: 7),

                        // ==========================================
                        // TIPO
                        // ==========================================
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: tipoColor.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isIngreso ? 'INGRESO' : 'EGRESO',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: tipoColor,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 4),

                  // ==============================================
                  // MENÚ
                  // ==============================================
                  _MovimientoMenu(
                    onTap: onTap,
                    onEdit: onEdit,
                    onDelete: onDelete,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ==================================================
              // CATEGORÍA
              // ==================================================
              // _MovimientoDetailRow(
              //   icon: Icons.category_outlined,
              //   title: 'Categoría',
              //   value: categoria,
              // ),

              // const SizedBox(height: 10),

              // ==================================================
              // SUBCATEGORÍA
              // ==================================================
              _MovimientoDetailRow(
                icon: Icons.account_tree_outlined,
                title: 'Subcategoría',
                value: subcategoria,
              ),

              const SizedBox(height: 10),

              // ==================================================
              // FECHA
              // ==================================================
              // _MovimientoDetailRow(
              //   icon: Icons.calendar_today_outlined,
              //   title: 'Fecha',
              //   value: fechaFormateada,
              // ),

              // const SizedBox(height: 16),

              Divider(
                height: 1,
                color: colors.outlineVariant.withValues(alpha: 0.65),
              ),

              const SizedBox(height: 14),

              // ==================================================
              // FOOTER
              // ==================================================
              Row(
                children: [
                  // ==============================================
                  // ESTADO
                  // ==============================================
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: estadoColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: estadoColor.withValues(alpha: 0.16),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_estadoIcon, size: 16, color: estadoColor),

                        const SizedBox(width: 5),

                        Text(
                          movimiento.estado.toUpperCase(),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: estadoColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // ==============================================
                  // MONTO
                  // ==============================================
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Monto',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        '${isIngreso ? '+' : '-'} $montoFormateado',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: tipoColor,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// FILA DE INFORMACIÓN
// ==========================================================

class _MovimientoDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _MovimientoDetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 17, color: colors.onSurfaceVariant),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 1),

              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================================
// MENÚ DEL MOVIMIENTO
// ==========================================================

class _MovimientoMenu extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MovimientoMenu({
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return PopupMenuButton<String>(
      tooltip: 'Opciones',
      padding: EdgeInsets.zero,

      color: colors.surfaceContainerHigh,

      icon: Icon(Icons.more_vert_rounded, color: colors.onSurfaceVariant),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      onSelected: (value) {
        switch (value) {
          case 'detalle':
            onTap();
            break;

          case 'editar':
            onEdit();
            break;

          case 'eliminar':
            onDelete();
            break;
        }
      },

      itemBuilder: (context) {
        return [
          PopupMenuItem<String>(
            value: 'detalle',
            child: Row(
              children: [
                Icon(Icons.visibility_outlined, color: colors.onSurfaceVariant),
                const SizedBox(width: 12),
                const Text('Ver detalle'),
              ],
            ),
          ),

          PopupMenuItem<String>(
            value: 'editar',
            child: Row(
              children: [
                Icon(Icons.edit_outlined, color: colors.primary),
                const SizedBox(width: 12),
                Text('Editar', style: TextStyle(color: colors.primary)),
              ],
            ),
          ),

          const PopupMenuDivider(),

          PopupMenuItem<String>(
            value: 'eliminar',
            child: Row(
              children: [
                Icon(Icons.delete_outline_rounded, color: colors.error),
                const SizedBox(width: 12),
                Text('Eliminar', style: TextStyle(color: colors.error)),
              ],
            ),
          ),
        ];
      },
    );
  }
}
// // ==========================================================
// // MOVIMIENTO CARD
// // ==========================================================

// import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class MovimientoCard extends StatelessWidget {
//   final MovimientoData movimiento;

//   /// Abre el detalle del movimiento.
//   final VoidCallback onTap;

//   /// Abre el formulario de edición.
//   final VoidCallback onEdit;

//   /// Elimina el movimiento.
//   final VoidCallback onDelete;

//   const MovimientoCard({
//     super.key,
//     required this.movimiento,
//     required this.onTap,
//     required this.onEdit,
//     required this.onDelete,
//   });

//   // ==========================================================
//   // TIPO
//   // ==========================================================
//   bool get isIngreso {
//     return movimiento.tipo.toUpperCase() == 'INGRESO';
//   }

//   // ==========================================================
//   // MONTO
//   // ==========================================================
//   String get montoFormateado {
//     final formatter = NumberFormat.currency(
//       locale: 'es_PE',
//       symbol: 'S/ ',
//       decimalDigits: 2,
//     );

//     return formatter.format(movimiento.monto);
//   }

//   // ==========================================================
//   // FECHA
//   // ==========================================================
//   String get fechaFormateada {
//     final date = DateTime.tryParse(movimiento.fecha);

//     if (date == null) {
//       return movimiento.fecha;
//     }

//     return DateFormat('dd MMM yyyy', 'es_PE').format(date);
//   }

//   // ==========================================================
//   // ESTADO
//   // ==========================================================
//   Color _estadoColor(BuildContext context) {
//     switch (movimiento.estado.toUpperCase()) {
//       case 'PAGADO':
//         return Colors.green;

//       case 'PENDIENTE':
//         return Colors.orange;

//       case 'ANULADO':
//         return Colors.red;

//       default:
//         return Theme.of(context).colorScheme.outline;
//     }
//   }

//   IconData get _estadoIcon {
//     switch (movimiento.estado.toUpperCase()) {
//       case 'PAGADO':
//         return Icons.check_circle_outline;

//       case 'PENDIENTE':
//         return Icons.schedule_outlined;

//       case 'ANULADO':
//         return Icons.cancel_outlined;

//       default:
//         return Icons.info_outline;
//     }
//   }

//   // ==========================================================
//   // BUILD
//   // ==========================================================
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;

//     final String categoria = movimiento.categoria?.nombre ?? 'Sin categoría';

//     final String subcategoria =
//         movimiento.subcategoria?.nombre ?? 'Sin subcategoría';

//     final Color tipoColor = isIngreso ? Colors.green : Colors.red;

//     final Color estadoColor = _estadoColor(context);

//     return Card(
//       // ======================================================
//       // ELEVACIÓN
//       // ======================================================
//       elevation: 2,
//       margin: EdgeInsets.zero,
//       color: colors.surface,
//       // shadowColor: colors.shadow.withValues(alpha: 0.20),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(18),
//         side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.55)),
//       ),

//       clipBehavior: Clip.antiAlias,

//       child: InkWell(
//         // Tocar cualquier parte de la card abre detalle.
//         onTap: onTap,

//         borderRadius: BorderRadius.circular(18),

//         child: Padding(
//           padding: const EdgeInsets.all(16),

//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ==================================================
//               // CABECERA
//               // ==================================================
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ==============================================
//                   // ICONO TIPO
//                   // ==============================================
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: tipoColor.withValues(alpha: 0.12),
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: Icon(
//                       isIngreso
//                           ? Icons.south_west_rounded
//                           : Icons.north_east_rounded,
//                       color: tipoColor,
//                       size: 26,
//                     ),
//                   ),

//                   const SizedBox(width: 14),

//                   // ==============================================
//                   // DESCRIPCIÓN + CATEGORÍA
//                   // ==============================================
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           movimiento.descripcion,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: theme.textTheme.titleMedium?.copyWith(
//                             fontWeight: FontWeight.w700,
//                             height: 1.25,
//                           ),
//                         ),

//                         const SizedBox(height: 5),

//                         Text(
//                           categoria,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: theme.textTheme.bodyMedium?.copyWith(
//                             color: colors.onSurfaceVariant,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(width: 8),

//                   // ==============================================
//                   // MENÚ
//                   // ==============================================
//                   PopupMenuButton<String>(
//                     padding: EdgeInsets.zero,
//                     tooltip: 'Opciones',

//                     icon: const Icon(Icons.more_vert),

//                     onSelected: (value) {
//                       switch (value) {
//                         case 'detalle':
//                           onTap();
//                           break;

//                         case 'editar':
//                           onEdit();
//                           break;

//                         case 'eliminar':
//                           onDelete();
//                           break;
//                       }
//                     },

//                     itemBuilder: (context) {
//                       return [
//                         // ==========================================
//                         // DETALLE
//                         // ==========================================
//                         const PopupMenuItem<String>(
//                           value: 'detalle',
//                           child: Row(
//                             children: [
//                               Icon(Icons.visibility_outlined),
//                               SizedBox(width: 12),
//                               Text('Ver detalle'),
//                             ],
//                           ),
//                         ),

//                         // ==========================================
//                         // EDITAR
//                         // ==========================================
//                         PopupMenuItem<String>(
//                           value: 'editar',
//                           child: Row(
//                             children: [
//                               // Icon(Icons.edit_outlined, color: colors.primary),
//                               Icon(Icons.edit_outlined),
//                               const SizedBox(width: 12),
//                               Text(
//                                 'Editar',
//                                 // style: TextStyle(color: colors.primary),
//                               ),
//                             ],
//                           ),
//                         ),

//                         const PopupMenuDivider(),

//                         // ==========================================
//                         // ELIMINAR
//                         // ==========================================
//                         const PopupMenuItem<String>(
//                           value: 'eliminar',
//                           child: Row(
//                             children: [
//                               Icon(Icons.delete_outline, color: Colors.red),
//                               SizedBox(width: 12),
//                               Text(
//                                 'Eliminar',
//                                 style: TextStyle(color: Colors.red),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ];
//                     },
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 16),

//               // ==================================================
//               // SUBCATEGORÍA + FECHA
//               // ==================================================
//               Row(
//                 children: [
//                   Expanded(
//                     child: _MovimientoInfo(
//                       icon: Icons.account_tree_outlined,
//                       text: subcategoria,
//                     ),
//                   ),

//                   const SizedBox(width: 12),

//                   _MovimientoInfo(
//                     icon: Icons.calendar_today_outlined,
//                     text: fechaFormateada,
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 16),

//               Divider(
//                 height: 1,
//                 color: colors.outlineVariant.withValues(alpha: 0.60),
//               ),

//               const SizedBox(height: 14),

//               // ==================================================
//               // FOOTER
//               // ==================================================
//               Row(
//                 children: [
//                   // ==============================================
//                   // ESTADO
//                   // ==============================================
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 7,
//                     ),
//                     decoration: BoxDecoration(
//                       color: estadoColor.withValues(alpha: 0.10),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(_estadoIcon, size: 16, color: estadoColor),

//                         const SizedBox(width: 5),

//                         Text(
//                           movimiento.estado,
//                           style: theme.textTheme.labelMedium?.copyWith(
//                             color: estadoColor,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const Spacer(),

//                   // ==============================================
//                   // MONTO
//                   // ==============================================
//                   Text(
//                     '${isIngreso ? '+' : '-'} $montoFormateado',
//                     style: theme.textTheme.titleMedium?.copyWith(
//                       color: tipoColor,
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ==========================================================
// // INFO SECUNDARIA DE MOVIMIENTO
// // ==========================================================

// class _MovimientoInfo extends StatelessWidget {
//   final IconData icon;
//   final String text;

//   const _MovimientoInfo({required this.icon, required this.text});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;

//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 16, color: colors.onSurfaceVariant),

//         const SizedBox(width: 6),

//         Flexible(
//           child: Text(
//             text,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: theme.textTheme.bodySmall?.copyWith(
//               color: colors.onSurfaceVariant,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
