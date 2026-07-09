import 'dart:async';

import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_event.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_aryoria/src/data/models/categoria/categoria_data.dart';
import 'package:app_aryoria/src/data/models/categoria/categoria_response.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class CategoriaContent extends StatefulWidget {
  const CategoriaContent({super.key});

  @override
  State<CategoriaContent> createState() => _CategoriaContentState();
}

class _CategoriaContentState extends State<CategoriaContent> {
  final TextEditingController searchCtrl = TextEditingController();
  final ScrollController scrollCtrl = ScrollController();

  Timer? _debounce;

  int? get idEmpresa =>
      context.read<SessionBloc>().state.empresaActiva?.idEmpresa;

  @override
  void initState() {
    super.initState();
    scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    scrollCtrl.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<CategoriaBloc>().add(
        GetCategoriasEvent(
          page: 1,
          limit: 10,
          idCategoria: idEmpresa!,
          search: value.trim(),
        ),
      );
    });
  }

  void _onScroll() {
    final state = context.read<CategoriaBloc>().state;

    if (scrollCtrl.position.pixels >=
            scrollCtrl.position.maxScrollExtent - 200 &&
        state.hasMore &&
        !state.isLoading &&
        !state.isLoadingMore) {
      context.read<CategoriaBloc>().add(
        GetCategoriasEvent(
          page: state.page + 1,
          limit: state.limit,
          idCategoria: idEmpresa!,
          search: state.search,
        ),
      );
    }
  }

  Future<void> _onRefresh() async {
    context.read<CategoriaBloc>().add(
      GetCategoriasEvent(
        page: 1,
        limit: 10,
        idCategoria: idEmpresa!,
        search: searchCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoriaBloc, CategoriaState>(
      listenWhen: (previous, current) =>
          previous.actionResponse != current.actionResponse,
      listener: (context, state) {
        final response = state.actionResponse;

        if (response is Success<CategoriaResponse>) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.data.message),
              backgroundColor: Colors.green,
            ),
          );

          context.read<CategoriaBloc>().add(
            GetCategoriasEvent(
              page: 1,
              limit: state.limit,
              idCategoria: idEmpresa!,
              search: state.search,
            ),
          );
        }

        if (response is ErrorData<CategoriaResponse>) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF7F8FA),
        // appBar: AppBar(title: const Text('Categorías'), centerTitle: true),
        body: BlocBuilder<CategoriaBloc, CategoriaState>(
          builder: (context, state) {
            return Column(
              children: [
                _buildSearch(),
                Expanded(child: _buildBody(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: TextField(
        controller: searchCtrl,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Buscar categoría...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(CategoriaState state) {
    if (state.isLoading && state.categorias.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.categorias.isEmpty) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 160),
            Icon(Icons.category_outlined, size: 70, color: Colors.grey),
            SizedBox(height: 16),
            Center(
              child: Text(
                'No hay categorías registradas.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
        controller: scrollCtrl,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.categorias.length + (state.isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= state.categorias.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return _CategoriaCard(categoria: state.categorias[index]);
        },
      ),
    );
  }
}

class _CategoriaCard extends StatelessWidget {
  final CategoriaData categoria;

  const _CategoriaCard({required this.categoria});

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(categoria.color);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(_getIcon(categoria.icono), color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoria.nombre,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  categoria.descripcion ?? 'Sin descripción',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: categoria.tipo == 'INGRESO'
                  ? Colors.green.withOpacity(0.12)
                  : Colors.red.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              categoria.tipo,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: categoria.tipo == 'INGRESO' ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.blue;
    }

    final cleanColor = hexColor.replaceAll('#', '');

    return Color(int.parse('FF$cleanColor', radix: 16));
  }

  IconData _getIcon(String? icono) {
    switch (icono) {
      case 'wifi':
        return Icons.wifi;
      case 'home':
        return Icons.home_outlined;
      case 'food':
        return Icons.restaurant_outlined;
      case 'money':
        return Icons.attach_money;
      case 'car':
        return Icons.directions_car_outlined;
      case 'shopping':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}
