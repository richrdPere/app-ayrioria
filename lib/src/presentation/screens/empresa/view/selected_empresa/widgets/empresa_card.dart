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
    final sessionState = context.watch<SessionBloc>().state;
    final empresaActivaId = sessionState.empresaActiva?.idEmpresa;
    final isSelected = empresaActivaId == empresa.idEmpresa;

    return GestureDetector(
      onTap: () => _selectEmpresa(context),

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xff2563EB) : Colors.transparent,
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.business, color: Colors.blue, size: 28),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    empresa.nombreComercial,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "RUC: ${empresa.ruc}",
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    empresa.direccionFiscal,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),

            Radio<int>(
              value: empresa.idEmpresa,
              groupValue: empresaActivaId,
              activeColor: const Color(0xff2563EB),
              onChanged: (_) => _selectEmpresa(context),
            ),
          ],
        ),
      ),
    );
  }
}
