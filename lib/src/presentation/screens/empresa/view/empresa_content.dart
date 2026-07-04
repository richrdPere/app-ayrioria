import 'package:app_aryoria/src/data/models/empresa/empresa_paginated.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_state.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_event.dart';

class EmpresaContent extends StatefulWidget {
  const EmpresaContent({super.key});

  @override
  State<EmpresaContent> createState() => _EmpresaContentState();
}

class _EmpresaContentState extends State<EmpresaContent> {
  final searchCtrl = TextEditingController();

  void _onSearch() {
    context.read<EmpresaBloc>().add(
      GetEmpresasEvent(search: searchCtrl.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EmpresaBloc>();

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // abrir form crear empresa
        },
        icon: const Icon(Icons.add),
        label: const Text("Nueva"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// SEARCH
            TextField(
              controller: searchCtrl,
              onSubmitted: (_) => _onSearch(),
              decoration: InputDecoration(
                hintText: "Buscar empresa...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// LISTA
            Expanded(
              child: BlocBuilder<EmpresaBloc, EmpresaState>(
                builder: (context, state) {
                  final empresas =
                      (state.empresasResponse
                          is Success<EmpresaPaginatedResponse>)
                      ? (state.empresasResponse
                                as Success<EmpresaPaginatedResponse>)
                            .data
                            .data
                      : [];

                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (empresas.isEmpty) {
                    return const Center(
                      child: Text("No hay empresas registradas"),
                    );
                  }

                  return ListView.builder(
                    itemCount: empresas.length,
                    itemBuilder: (_, index) {
                      final empresa = empresas[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 15),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.blue.shade100,
                            child: Icon(
                              Icons.business,
                              color: Colors.blue.shade700,
                            ),
                          ),

                          title: Text(
                            empresa.nombreComercial,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          subtitle: Text("RUC: ${empresa.ruc}"),

                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              switch (value) {
                                case "editar":
                                  bloc.add(
                                    GetEmpresaByIdEvent(empresa.idEmpresa),
                                  );
                                  break;

                                case "eliminar":
                                  bloc.add(
                                    DeleteEmpresaEvent(empresa.idEmpresa),
                                  );
                                  break;
                              }
                            },

                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: "editar",
                                child: Text("Editar"),
                              ),

                              PopupMenuItem(
                                value: "eliminar",
                                child: Text("Eliminar"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
