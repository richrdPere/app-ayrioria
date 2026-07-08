import 'package:app_aryoria/src/data/models/empresa/empresa_data.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'empresa_card.dart';

class EmpresaList extends StatelessWidget {
  final List<EmpresaData> empresas;

  final TextEditingController searchCtrl;

  const EmpresaList({
    super.key,
    required this.empresas,
    required this.searchCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<EmpresaBloc>().add(
          GetEmpresasEvent(search: searchCtrl.text.trim()),
        );
      },

      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: empresas.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          return EmpresaCard(empresa: empresas[index]);
        },
      ),
    );
  }
}
