import 'package:app_aryoria/src/data/models/empresa/empresa_data.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpresaCard extends StatelessWidget {
  final EmpresaData empresa;

  const EmpresaCard({super.key, required this.empresa});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<EmpresaBloc>().add(SelectEmpresaEvent(empresa.idEmpresa));
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
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
            // ICONO
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

            // INFORMACION
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

            // MENU
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.grey),

              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    // TODO editar empresa
                    break;

                  case 'delete':
                    // TODO eliminar empresa
                    break;
                }
              },

              itemBuilder: (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Editar')),

                const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
