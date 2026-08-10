import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MovimientoDetailContent extends StatelessWidget {
  final MovimientoData movimiento;

  const MovimientoDetailContent({super.key, required this.movimiento});

  // ==========================================================
  // TIPO
  // ==========================================================

  bool get _isIngreso {
    return movimiento.tipo.trim().toUpperCase() == 'INGRESO';
  }

  // ==========================================================
  // COLORES
  // ==========================================================

  Color get _tipoColor {
    return _isIngreso ? Colors.green : Colors.red;
  }

  IconData get _tipoIcon {
    return _isIngreso ? Icons.south_west_rounded : Icons.north_east_rounded;
  }

  Color _estadoColor(BuildContext context) {
    switch (movimiento.estado.trim().toUpperCase()) {
      case 'PAGADO':
        return Colors.green;

      case 'PENDIENTE':
        return Colors.orange;

      case 'ANULADO':
        return Colors.red;

      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  IconData get _estadoIcon {
    switch (movimiento.estado.trim().toUpperCase()) {
      case 'PAGADO':
        return Icons.check_circle_outline;

      case 'PENDIENTE':
        return Icons.schedule_outlined;

      case 'ANULADO':
        return Icons.cancel_outlined;

      default:
        return Icons.info_outline;
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
      children: [
        // ====================================================
        // RESUMEN PRINCIPAL
        // ====================================================
        _buildSummary(context),

        const SizedBox(height: 20),

        // ====================================================
        // CLASIFICACIÓN
        // ====================================================
        _buildClassification(context),

        const SizedBox(height: 16),

        // ====================================================
        // INFORMACIÓN CONTABLE
        // ====================================================
        _buildAccountingInformation(context),

        const SizedBox(height: 16),

        // ====================================================
        // DETALLE
        // ====================================================
        _buildDetail(context),

        // ====================================================
        // OBSERVACIÓN
        // ====================================================
        if (_hasObservation) ...[
          const SizedBox(height: 16),
          _buildObservation(context),
        ],

        const SizedBox(height: 30),
      ],
    );
  }

  // ==========================================================
  // RESUMEN
  // ==========================================================
  Widget _buildSummary(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final Color tipoColor = _tipoColor;
    final Color estadoColor = _estadoColor(context);

    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      color: colors.surface,
      shadowColor: colors.shadow.withValues(alpha: 0.18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // ICONO + TIPO + ESTADO
            // ==================================================
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: tipoColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(_tipoIcon, color: tipoColor, size: 28),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isIngreso ? 'Ingreso' : 'Egreso',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: tipoColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        _formatDate(movimiento.fecha),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                _StatusChip(
                  text: movimiento.estado,
                  icon: _estadoIcon,
                  color: estadoColor,
                ),
              ],
            ),

            const SizedBox(height: 22),

            // ==================================================
            // DESCRIPCIÓN
            // ==================================================
            Text(
              _description,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),

            const SizedBox(height: 18),

            Divider(color: colors.outlineVariant.withValues(alpha: 0.7)),

            const SizedBox(height: 14),

            // ==================================================
            // MONTO
            // ==================================================
            Text(
              'Monto del movimiento',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              '${_isIngreso ? '+' : '-'} ${_formatAmount(movimiento.monto)}',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: tipoColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // CLASIFICACIÓN
  // ==========================================================
  Widget _buildClassification(BuildContext context) {
    return _DetailSection(
      icon: Icons.account_tree_outlined,
      title: 'Clasificación',
      children: [
        _DetailItem(
          icon: Icons.category_outlined,
          label: 'Categoría',
          value: movimiento.categoria?.nombre ?? 'Sin categoría',
        ),

        _DetailItem(
          icon: Icons.account_tree_outlined,
          label: 'Subcategoría',
          value: movimiento.subcategoria?.nombre ?? 'Sin subcategoría',
        ),

        if (movimiento.subcategoria?.naturaleza != null &&
            movimiento.subcategoria!.naturaleza!.trim().isNotEmpty)
          _DetailItem(
            icon: Icons.label_outline_rounded,
            label: 'Naturaleza',
            value: movimiento.subcategoria!.naturaleza!,
          ),
      ],
    );
  }

  // ==========================================================
  // INFORMACIÓN CONTABLE
  // ==========================================================
  Widget _buildAccountingInformation(BuildContext context) {
    return _DetailSection(
      icon: Icons.account_balance_outlined,
      title: 'Información contable',
      children: [
        _DetailItem(
          icon: Icons.calendar_month_outlined,
          label: 'Período contable',
          value: movimiento.periodoContable?.nombre ?? 'Sin período',
        ),

        _DetailItem(
          icon: Icons.calendar_today_outlined,
          label: 'Fecha del movimiento',
          value: _formatDate(movimiento.fecha),
        ),

        _DetailItem(
          icon: Icons.business_outlined,
          label: 'Empresa',
          value: _empresaNombre,
        ),

        _DetailItem(
          icon: Icons.person_outline_rounded,
          label: 'Registrado por',
          value: movimiento.usuario?.username ?? 'Usuario no disponible',
        ),
      ],
    );
  }

  // ==========================================================
  // DETALLE
  // ==========================================================
  Widget _buildDetail(BuildContext context) {
    return _DetailSection(
      icon: Icons.receipt_long_outlined,
      title: 'Detalle de la operación',
      children: [
        _DetailItem(
          icon: Icons.description_outlined,
          label: 'Descripción',
          value: _description,
        ),

        _DetailItem(
          icon: Icons.receipt_outlined,
          label: 'Comprobante',
          value: _comprobante,
        ),

        _DetailItem(
          icon: Icons.numbers_outlined,
          label: 'Código del movimiento',
          value: '#${movimiento.idMovimiento}',
        ),
      ],
    );
  }

  // ==========================================================
  // OBSERVACIÓN
  // ==========================================================
  Widget _buildObservation(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.notes_outlined, color: colors.primary, size: 21),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Observación',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  movimiento.observacion!.trim(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // HELPERS
  // ==========================================================
  String get _description {
    final value = movimiento.descripcion.trim();

    return value.isEmpty ? 'Movimiento sin descripción' : value;
  }

  bool get _hasObservation {
    return movimiento.observacion != null &&
        movimiento.observacion!.trim().isNotEmpty;
  }

  String get _comprobante {
    final value = movimiento.comprobante?.trim();

    if (value == null || value.isEmpty) {
      return 'Sin comprobante';
    }

    return value;
  }

  String get _empresaNombre {
    final empresa = movimiento.empresa;

    if (empresa == null) {
      return 'Empresa no disponible';
    }

    final comercial = empresa.razonSocial.trim();

    if (comercial.isNotEmpty) {
      return comercial;
    }

    if (empresa.razonSocial.trim().isNotEmpty) {
      return empresa.razonSocial;
    }

    return 'Empresa no disponible';
  }

  String _formatAmount(dynamic value) {
    final double amount;

    if (value is num) {
      amount = value.toDouble();
    } else {
      amount = double.tryParse(value.toString()) ?? 0;
    }

    return NumberFormat.currency(
      locale: 'es_PE',
      symbol: 'S/ ',
      decimalDigits: 2,
    ).format(amount);
  }

  String _formatDate(dynamic value) {
    if (value == null) {
      return 'Sin fecha';
    }

    DateTime? date;

    if (value is DateTime) {
      date = value;
    } else {
      date = DateTime.tryParse(value.toString());
    }

    if (date == null) {
      return value.toString();
    }

    return DateFormat("dd 'de' MMMM 'de' yyyy", 'es_PE').format(date);
  }
}

// ==========================================================
// SECCIÓN
// ==========================================================
class _DetailSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _DetailSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.55)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, size: 20, color: colors.primary),
                ),

                const SizedBox(width: 11),

                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            ..._withDividers(children),
          ],
        ),
      ),
    );
  }

  List<Widget> _withDividers(List<Widget> widgets) {
    final result = <Widget>[];

    for (int index = 0; index < widgets.length; index++) {
      result.add(widgets[index]);

      if (index < widgets.length - 1) {
        result.add(const Divider(height: 24));
      }
    }

    return result;
  }
}

// ==========================================================
// ITEM
// ==========================================================
class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colors.onSurfaceVariant),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
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
// ESTADO
// ==========================================================
class _StatusChip extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const _StatusChip({
    required this.text,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),

          const SizedBox(width: 5),

          Text(
            text.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:app_aryoria/src/data/models/movimientos/movimiento_data.dart';

// import 'package:flutter/material.dart';

// class MovimientoDetailContent extends StatelessWidget {
//   final MovimientoData movimiento;
//   final bool isDeleting;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;

//   const MovimientoDetailContent({
//     super.key,
//     required this.movimiento,
//     required this.isDeleting,
//     required this.onEdit,
//     required this.onDelete,
//   });

//   bool get _isIngreso {
//     return movimiento.tipo.trim().toUpperCase() == 'INGRESO';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () async {
//         /*
//          * La recarga principal está controlada por la Page.
//          * Puedes agregar un callback onRefresh si deseas habilitarlo.
//          */
//       },
//       child: ListView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
//         children: [
//           _buildHeader(context),
//           const SizedBox(height: 20),
//           _buildAmountCard(context),
//           const SizedBox(height: 20),
//           _buildGeneralInformation(context),
//           const SizedBox(height: 20),
//           _buildDescription(context),
//           const SizedBox(height: 20),
//           _buildActions(context),
//         ],
//       ),
//     );
//   }

//   // ==========================================================
//   // ENCABEZADO
//   // ==========================================================
//   Widget _buildHeader(BuildContext context) {
//     final Color statusColor = _isIngreso ? Colors.green : Colors.red;

//     final IconData statusIcon = _isIngreso
//         ? Icons.south_west_rounded
//         : Icons.north_east_rounded;

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: 58,
//           height: 58,
//           decoration: BoxDecoration(
//             color: statusColor.withValues(alpha: 0.12),
//             borderRadius: BorderRadius.circular(18),
//           ),
//           child: Icon(statusIcon, color: statusColor, size: 30),
//         ),
//         const SizedBox(width: 14),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 _getDescription(),
//                 style: Theme.of(
//                   context,
//                 ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 6),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 5,
//                 ),
//                 decoration: BoxDecoration(
//                   color: statusColor.withValues(alpha: 0.12),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   movimiento.tipo.toUpperCase(),
//                   style: TextStyle(
//                     color: statusColor,
//                     fontWeight: FontWeight.w700,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // ==========================================================
//   // MONTO
//   // ==========================================================
//   Widget _buildAmountCard(BuildContext context) {
//     final Color amountColor = _isIngreso ? Colors.green : Colors.red;

//     final String prefix = _isIngreso ? '+' : '-';

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(22),
//       decoration: BoxDecoration(
//         color: amountColor.withValues(alpha: 0.08),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: amountColor.withValues(alpha: 0.18)),
//       ),
//       child: Column(
//         children: [
//           Text(
//             'Monto del movimiento',
//             style: Theme.of(
//               context,
//             ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             '$prefix S/ ${_formatAmount(movimiento.monto)}',
//             style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//               color: amountColor,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ==========================================================
//   // INFORMACIÓN GENERAL
//   // ==========================================================
//   Widget _buildGeneralInformation(BuildContext context) {
//     return _DetailSection(
//       title: 'Información general',
//       icon: Icons.info_outline,
//       children: [
//         _DetailItem(
//           icon: Icons.tag,
//           label: 'ID del movimiento',
//           value: movimiento.idMovimiento.toString(),
//         ),
//         _DetailItem(
//           icon: Icons.category_outlined,
//           label: 'Categoría',
//           value: 'Categoría #${movimiento.idCategoria}',
//         ),
//         _DetailItem(
//           icon: Icons.calendar_today_outlined,
//           label: 'Fecha',
//           value: _formatDate(movimiento.fecha),
//         ),
//         _DetailItem(
//           icon: Icons.business_outlined,
//           label: 'Empresa',
//           value: movimiento.idEmpresa.toString(),
//         ),
//         _DetailItem(
//           icon: Icons.date_range_outlined,
//           label: 'Período contable',
//           value: movimiento.idPeriodo.toString(),
//         ),
//       ],
//     );
//   }

//   // ==========================================================
//   // DESCRIPCIÓN Y OBSERVACIÓN
//   // ==========================================================
//   Widget _buildDescription(BuildContext context) {
//     return _DetailSection(
//       title: 'Detalle',
//       icon: Icons.description_outlined,
//       children: [
//         _DetailItem(
//           icon: Icons.subject_outlined,
//           label: 'Descripción',
//           value: _getDescription(),
//         ),
//         _DetailItem(
//           icon: Icons.notes_outlined,
//           label: 'Observación',
//           value: _getObservation(),
//         ),
//       ],
//     );
//   }

//   // ==========================================================
//   // ACCIONES
//   // ==========================================================
//   Widget _buildActions(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           width: double.infinity,
//           height: 50,
//           child: FilledButton.icon(
//             onPressed: isDeleting ? null : onEdit,
//             icon: const Icon(Icons.edit_outlined),
//             label: const Text('Editar movimiento'),
//           ),
//         ),
//         const SizedBox(height: 12),
//         SizedBox(
//           width: double.infinity,
//           height: 50,
//           child: OutlinedButton.icon(
//             onPressed: isDeleting ? null : onDelete,
//             style: OutlinedButton.styleFrom(
//               foregroundColor: Colors.red,
//               side: const BorderSide(color: Colors.red),
//             ),
//             icon: isDeleting
//                 ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                 : const Icon(Icons.delete_outline),
//             label: Text(isDeleting ? 'Eliminando...' : 'Eliminar movimiento'),
//           ),
//         ),
//       ],
//     );
//   }

//   // ==========================================================
//   // HELPERS
//   // ==========================================================
//   String _getDescription() {
//     final String description = movimiento.descripcion.trim();

//     if (description.isEmpty) {
//       return 'Movimiento sin descripción';
//     }

//     return description;
//   }

//   String _getObservation() {
//     final String? observation = movimiento.observacion;

//     if (observation == null || observation.trim().isEmpty) {
//       return 'Sin observaciones';
//     }

//     return observation.trim();
//   }

//   String _formatAmount(dynamic value) {
//     if (value == null) {
//       return '0.00';
//     }

//     final double? amount = double.tryParse(value.toString());

//     if (amount == null) {
//       return value.toString();
//     }

//     return amount.toStringAsFixed(2);
//   }

//   String _formatDate(dynamic value) {
//     if (value == null) {
//       return 'Sin fecha';
//     }

//     DateTime? date;

//     if (value is DateTime) {
//       date = value;
//     } else {
//       date = DateTime.tryParse(value.toString());
//     }

//     if (date == null) {
//       return value.toString();
//     }

//     const List<String> months = [
//       'enero',
//       'febrero',
//       'marzo',
//       'abril',
//       'mayo',
//       'junio',
//       'julio',
//       'agosto',
//       'septiembre',
//       'octubre',
//       'noviembre',
//       'diciembre',
//     ];

//     return '${date.day} de ${months[date.month - 1]} de ${date.year}';
//   }
// }

// // ============================================================
// // SECCIÓN DEL DETALLE
// // ============================================================
// class _DetailSection extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final List<Widget> children;

//   const _DetailSection({
//     required this.title,
//     required this.icon,
//     required this.children,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: Theme.of(
//             context,
//           ).colorScheme.outlineVariant.withValues(alpha: 0.60),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 icon,
//                 size: 22,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//               const SizedBox(width: 10),
//               Text(
//                 title,
//                 style: Theme.of(
//                   context,
//                 ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           const SizedBox(height: 18),
//           ..._withDividers(children),
//         ],
//       ),
//     );
//   }

//   List<Widget> _withDividers(List<Widget> widgets) {
//     final List<Widget> result = [];

//     for (int index = 0; index < widgets.length; index++) {
//       result.add(widgets[index]);

//       if (index < widgets.length - 1) {
//         result.add(const Divider(height: 24));
//       }
//     }

//     return result;
//   }
// }

// // ============================================================
// // ELEMENTO DEL DETALLE
// // ============================================================
// class _DetailItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;

//   const _DetailItem({
//     required this.icon,
//     required this.label,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, size: 21, color: Colors.grey.shade600),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: Theme.of(
//                   context,
//                 ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
//               ),
//               const SizedBox(height: 3),
//               Text(
//                 value,
//                 style: Theme.of(
//                   context,
//                 ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
