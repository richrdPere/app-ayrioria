import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_event.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovimientoContent extends StatefulWidget {
  const MovimientoContent({super.key});

  @override
  State<MovimientoContent> createState() => _MovimientoContentState();
}

class _MovimientoContentState extends State<MovimientoContent> {
  final TextEditingController searchCtrl = TextEditingController();
  final ScrollController scrollController = ScrollController();

  int? get idEmpresa =>
      context.read<SessionBloc>().state.empresaActiva?.idEmpresa;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      final bloc = context.read<MovimientoBloc>();
      final state = bloc.state;

      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !state.isLoadingMore &&
          state.hasMore &&
          idEmpresa != null) {
        bloc.add(
          GetMovimientosEvent(
            idEmpresa: idEmpresa!,
            page: state.page + 1,
            limit: state.limit,
            search: state.search,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _search(String value) {
    if (idEmpresa == null) return;

    context.read<MovimientoBloc>().add(
      SearchMovimientosEvent(idEmpresa: idEmpresa!, search: value.trim()),
    );
  }

  Future<void> _refresh() async {
    if (idEmpresa == null) return;

    context.read<MovimientoBloc>().add(
      RefreshMovimientosEvent(
        idEmpresa: idEmpresa!,
        search: searchCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovimientoBloc, MovimientoState>(
      builder: (context, state) {
        if (state.isLoading && state.movimientos.isEmpty) {
          return _buildLoading();
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 25),
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildSearch(),
              const SizedBox(height: 16),

              if (state.movimientoResponse is ErrorData)
                _buildError(state.movimientoResponse as ErrorData),

              if (state.movimientos.isEmpty)
                _buildEmptyState()
              else
                ...state.movimientos.map((movimiento) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _MovimientoTile(
                      titulo: movimiento.descripcion,
                      categoria:
                          movimiento.categoria?.nombre ?? 'Sin categoría',
                      fecha: movimiento.fecha,
                      tipo: movimiento.tipo,
                      monto: movimiento.monto,
                    ),
                  );
                }),

              if (state.isLoadingMore)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Movimientos',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          'Consulta tus ingresos y egresos de la empresa activa.',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return TextField(
      controller: searchCtrl,
      onSubmitted: _search,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Buscar movimiento...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchCtrl.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  searchCtrl.clear();
                  _search('');
                  setState(() {});
                },
              ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 350,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.receipt_long_outlined, size: 70, color: Colors.black38),
            SizedBox(height: 12),
            Text(
              'No hay movimientos registrados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text(
              'Cuando registres ingresos o egresos aparecerán aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(ErrorData error) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        error.error,
        style: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}

class _MovimientoTile extends StatelessWidget {
  final String titulo;
  final String categoria;
  final String fecha;
  final String tipo;
  final double monto;

  const _MovimientoTile({
    required this.titulo,
    required this.categoria,
    required this.fecha,
    required this.tipo,
    required this.monto,
  });

  @override
  Widget build(BuildContext context) {
    final isIngreso = tipo.toUpperCase() == 'INGRESO';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: CircleAvatar(
          backgroundColor: isIngreso
              ? Colors.green.withOpacity(.12)
              : Colors.red.withOpacity(.12),
          child: Icon(
            isIngreso ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIngreso ? Colors.green : Colors.redAccent,
          ),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('$categoria • $fecha'),
        trailing: Text(
          '${isIngreso ? '+' : '-'} S/ ${monto.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isIngreso ? Colors.green : Colors.redAccent,
          ),
        ),
      ),
    );
  }
}
