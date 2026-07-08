import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmpresaSearch extends StatefulWidget {
  final TextEditingController controller;

  const EmpresaSearch({super.key, required this.controller});

  @override
  State<EmpresaSearch> createState() => _EmpresaSearchState();
}

class _EmpresaSearchState extends State<EmpresaSearch> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),

              blurRadius: 12,

              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: TextField(
          controller: widget.controller,

          textInputAction: TextInputAction.search,

          onChanged: (value) {
            context.read<EmpresaBloc>().add(
              GetEmpresasEvent(search: value.trim()),
            );
          },

          decoration: InputDecoration(
            hintText: "Buscar por nombre comercial o RUC...",

            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),

            border: InputBorder.none,

            prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade600),

            suffixIcon: widget.controller.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.close),

                    onPressed: () {
                      widget.controller.clear();

                      context.read<EmpresaBloc>().add(const GetEmpresasEvent());

                      setState(() {});
                    },
                  ),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,

              vertical: 18,
            ),
          ),
        ),
      ),
    );
  }
}
