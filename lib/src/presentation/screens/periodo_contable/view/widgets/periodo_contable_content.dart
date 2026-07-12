// import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_data.dart';
// import 'package:flutter/material.dart';

// class _PeriodoCard extends StatelessWidget {
//   final PeriodoContableData periodo;
//   final VoidCallback onTap;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//   final VoidCallback onChangeEstado;

//   const _PeriodoCard({
//     required this.periodo,
//     required this.onTap,
//     required this.onEdit,
//     required this.onDelete,
//     required this.onChangeEstado,
//   });

//   bool get _isOpen => periodo.estado.toUpperCase() == 'ABIERTO';

//   @override
//   Widget build(BuildContext context) {
//     final ColorScheme colors = Theme.of(context).colorScheme;

//     return Card(
//       elevation: 0,
//       clipBehavior: Clip.antiAlias,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(18),
//         side: BorderSide(color: colors.outlineVariant),
//       ),
//       child: InkWell(
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     width: 46,
//                     height: 46,
//                     decoration: BoxDecoration(
//                       color: _isOpen
//                           ? Colors.green.withValues(alpha: 0.12)
//                           : Colors.grey.withValues(alpha: 0.15),
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: Icon(
//                       _isOpen ? Icons.lock_open_outlined : Icons.lock_outline,
//                       color: _isOpen ? Colors.green : Colors.grey.shade700,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           periodo.nombre,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           '${_getMonthName(periodo.mes)} ${periodo.anio}',
//                           style: TextStyle(
//                             color: colors.onSurfaceVariant,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   PopupMenuButton<String>(
//                     onSelected: (value) {
//                       switch (value) {
//                         case 'detail':
//                           onTap();
//                           break;

//                         case 'edit':
//                           onEdit();
//                           break;

//                         case 'status':
//                           onChangeEstado();
//                           break;

//                         case 'delete':
//                           onDelete();
//                           break;
//                       }
//                     },
//                     itemBuilder: (context) => [
//                       const PopupMenuItem(
//                         value: 'detail',
//                         child: ListTile(
//                           contentPadding: EdgeInsets.zero,
//                           leading: Icon(Icons.visibility_outlined),
//                           title: Text('Ver detalle'),
//                         ),
//                       ),
//                       const PopupMenuItem(
//                         value: 'edit',
//                         child: ListTile(
//                           contentPadding: EdgeInsets.zero,
//                           leading: Icon(Icons.edit_outlined),
//                           title: Text('Editar'),
//                         ),
//                       ),
//                       PopupMenuItem(
//                         value: 'status',
//                         child: ListTile(
//                           contentPadding: EdgeInsets.zero,
//                           leading: Icon(
//                             _isOpen
//                                 ? Icons.lock_outline
//                                 : Icons.lock_open_outlined,
//                           ),
//                           title: Text(
//                             _isOpen ? 'Cerrar período' : 'Abrir período',
//                           ),
//                         ),
//                       ),
//                       const PopupMenuItem(
//                         value: 'delete',
//                         child: ListTile(
//                           contentPadding: EdgeInsets.zero,
//                           leading: Icon(
//                             Icons.delete_outline,
//                             color: Colors.red,
//                           ),
//                           title: Text(
//                             'Eliminar',
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 14),
//               Row(
//                 children: [
//                   Expanded(
//                     child: _PeriodoInfo(
//                       icon: Icons.calendar_today_outlined,
//                       label: 'Inicio',
//                       value: _formatDate(periodo.fechaInicio),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _PeriodoInfo(
//                       icon: Icons.event_available_outlined,
//                       label: 'Fin',
//                       value: _formatDate(periodo.fechaFin),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 14),
//               Row(
//                 children: [
//                   Expanded(
//                     child: _PeriodoInfo(
//                       icon: Icons.account_balance_wallet_outlined,
//                       label: 'Saldo inicial',
//                       value: 'S/ ${periodo.saldoInicial.toStringAsFixed(2)}',
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Align(
//                       alignment: Alignment.centerRight,
//                       child: _EstadoChip(estado: periodo.estado),
//                     ),
//                   ),
//                 ],
//               ),
//               if (periodo.observacion != null &&
//                   periodo.observacion!.trim().isNotEmpty) ...[
//                 const SizedBox(height: 14),
//                 Text(
//                   periodo.observacion!,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     color: colors.onSurfaceVariant,
//                     fontSize: 13,
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   static String _formatDate(dynamic value) {
//     final String date = value.toString();

//     if (date.length >= 10) {
//       final List<String> parts = date.substring(0, 10).split('-');

//       if (parts.length == 3) {
//         return '${parts[2]}/${parts[1]}/${parts[0]}';
//       }
//     }

//     return date;
//   }

//   static String _getMonthName(int month) {
//     const months = [
//       'Enero',
//       'Febrero',
//       'Marzo',
//       'Abril',
//       'Mayo',
//       'Junio',
//       'Julio',
//       'Agosto',
//       'Septiembre',
//       'Octubre',
//       'Noviembre',
//       'Diciembre',
//     ];

//     if (month < 1 || month > 12) {
//       return 'Mes $month';
//     }

//     return months[month - 1];
//   }
// }

// class _PeriodoInfo extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;

//   const _PeriodoInfo({
//     required this.icon,
//     required this.label,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Icon(icon, size: 19, color: Theme.of(context).colorScheme.primary),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: Theme.of(context).colorScheme.onSurfaceVariant,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 value,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _EstadoChip extends StatelessWidget {
//   final String estado;

//   const _EstadoChip({required this.estado});

//   @override
//   Widget build(BuildContext context) {
//     final bool isOpen = estado.toUpperCase() == 'ABIERTO';

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
//       decoration: BoxDecoration(
//         color: isOpen
//             ? Colors.green.withValues(alpha: 0.12)
//             : Colors.grey.withValues(alpha: 0.15),
//         borderRadius: BorderRadius.circular(50),
//       ),
//       child: Text(
//         estado,
//         style: TextStyle(
//           color: isOpen ? Colors.green.shade700 : Colors.grey.shade700,
//           fontSize: 11,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }

// class _PeriodoLoading extends StatelessWidget {
//   const _PeriodoLoading();

//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
//       itemCount: 4,
//       separatorBuilder: (_, __) => const SizedBox(height: 12),
//       itemBuilder: (_, __) {
//         return Container(
//           height: 180,
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.surfaceContainerHighest,
//             borderRadius: BorderRadius.circular(18),
//           ),
//         );
//       },
//     );
//   }
// }

// class _PeriodoEmpty extends StatelessWidget {
//   final bool hasFilters;
//   final VoidCallback onCreate;
//   final VoidCallback onClearFilters;

//   const _PeriodoEmpty({
//     required this.hasFilters,
//     required this.onCreate,
//     required this.onClearFilters,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               hasFilters
//                   ? Icons.search_off_outlined
//                   : Icons.calendar_month_outlined,
//               size: 72,
//               color: Colors.grey,
//             ),
//             const SizedBox(height: 18),
//             Text(
//               hasFilters
//                   ? 'No se encontraron períodos'
//                   : 'Aún no tienes períodos contables',
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               hasFilters
//                   ? 'Prueba modificando los filtros de búsqueda.'
//                   : 'Crea un período para comenzar a registrar ingresos y egresos.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.onSurfaceVariant,
//               ),
//             ),
//             const SizedBox(height: 22),
//             if (hasFilters)
//               OutlinedButton.icon(
//                 onPressed: onClearFilters,
//                 icon: const Icon(Icons.filter_alt_off_outlined),
//                 label: const Text('Limpiar filtros'),
//               )
//             else
//               FilledButton.icon(
//                 onPressed: onCreate,
//                 icon: const Icon(Icons.add),
//                 label: const Text('Crear período'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _PeriodoError extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;

//   const _PeriodoError({required this.message, required this.onRetry});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.error_outline, size: 70, color: Colors.red),
//             const SizedBox(height: 18),
//             const Text(
//               'No pudimos cargar los períodos',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(message, textAlign: TextAlign.center),
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
