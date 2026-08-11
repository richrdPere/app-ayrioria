import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_data.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpresaCard extends StatelessWidget {
  final EmpresaData empresa;

  const EmpresaCard({super.key, required this.empresa});

  void _selectEmpresa(BuildContext context) {
    context.read<EmpresaBloc>().add(SelectEmpresaEvent(empresa.idEmpresa));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final sessionState = context.watch<SessionBloc>().state;

    final empresaActivaId = sessionState.empresaActiva?.idEmpresa;

    final isSelected = empresaActivaId == empresa.idEmpresa;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectEmpresa(context),
        borderRadius: BorderRadius.circular(16),

        child: Container(
          margin: const EdgeInsets.only(bottom: 12),

          padding: const EdgeInsets.all(15),

          decoration: BoxDecoration(
            // ==================================================
            // FONDO
            // ==================================================
            color: isSelected
                ? colors.primaryContainer.withValues(alpha: 0.30)
                : colors.surfaceContainerLow,

            borderRadius: BorderRadius.circular(16),

            // ==================================================
            // BORDE
            // ==================================================
            border: Border.all(
              color: isSelected
                  ? colors.primary
                  : colors.outlineVariant.withValues(alpha: 0.55),
              width: isSelected ? 1.5 : 1,
            ),

            // ==================================================
            // SOMBRA
            // ==================================================
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Row(
            children: [
              // ==================================================
              // ICONO EMPRESA
              // ==================================================
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary : colors.primaryContainer,

                  borderRadius: BorderRadius.circular(14),
                ),

                child: Icon(
                  Icons.business_rounded,
                  color: isSelected
                      ? colors.onPrimary
                      : colors.onPrimaryContainer,
                  size: 27,
                ),
              ),

              const SizedBox(width: 12),

              // ==================================================
              // INFORMACIÓN EMPRESA
              // ==================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      empresa.nombreComercial,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'RUC: ${empresa.ruc}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: colors.onSurfaceVariant,
                        ),

                        const SizedBox(width: 4),

                        Expanded(
                          child: Text(
                            empresa.direccionFiscal,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,

                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ==================================================
              // SELECCIÓN
              // ==================================================
              Radio<int>(
                value: empresa.idEmpresa,
                groupValue: empresaActivaId,

                activeColor: colors.primary,

                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return colors.primary;
                  }

                  return colors.onSurfaceVariant;
                }),

                onChanged: (_) {
                  _selectEmpresa(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
