import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Modelos
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_anual.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_mensual.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_proyectado.dart';

// BloC's
import 'package:app_aryoria/src/presentation/screens/flujo_contable/bloc/flujo_contable_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/flujo_contable/bloc/flujo_contable_event.dart';
import 'package:app_aryoria/src/presentation/screens/flujo_contable/bloc/flujo_contable_state.dart';

// Widgets
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/widgets/flujo_anual_view.dart';
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/widgets/flujo_mensual_view.dart';
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/widgets/flujo_proyectado_view.dart';

enum TipoFlujoContable { mensual, proyectado, anual }

class FlujoContableContent extends StatefulWidget {
  final int idEmpresa;
  final int idPeriodo;
  final int anioInicial;

  const FlujoContableContent({
    super.key,
    required this.idEmpresa,
    required this.idPeriodo,
    required this.anioInicial,
  });

  @override
  State<FlujoContableContent> createState() => _FlujoContableContentState();
}

class _FlujoContableContentState extends State<FlujoContableContent> {
  TipoFlujoContable tipoSeleccionado = TipoFlujoContable.mensual;

  late int anioSeleccionado;

  @override
  void initState() {
    super.initState();

    anioSeleccionado = widget.anioInicial;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarFlujoMensual();
    });
  }

  // ============================================================
  // CARGAS
  // ============================================================

  void _cargarFlujoMensual() {
    context.read<FlujoContableBloc>().add(
      GetFlujoContableMensualEvent(
        idPeriodo: widget.idPeriodo,
        idEmpresa: widget.idEmpresa,
      ),
    );
  }

  void _cargarFlujoProyectado() {
    context.read<FlujoContableBloc>().add(
      GetFlujoProyectadoEvent(
        idPeriodo: widget.idPeriodo,
        idEmpresa: widget.idEmpresa,
      ),
    );
  }

  void _cargarFlujoAnual() {
    context.read<FlujoContableBloc>().add(
      GetFlujoContableAnualEvent(
        idEmpresa: widget.idEmpresa,
        anio: anioSeleccionado,
      ),
    );
  }

  void _seleccionarTipo(TipoFlujoContable tipo) {
    if (tipoSeleccionado == tipo) return;

    setState(() {
      tipoSeleccionado = tipo;
    });

    switch (tipo) {
      case TipoFlujoContable.mensual:
        _cargarFlujoMensual();
        break;

      case TipoFlujoContable.proyectado:
        _cargarFlujoProyectado();
        break;

      case TipoFlujoContable.anual:
        _cargarFlujoAnual();
        break;
    }
  }

  Future<void> _refresh() async {
    switch (tipoSeleccionado) {
      case TipoFlujoContable.mensual:
        _cargarFlujoMensual();
        break;

      case TipoFlujoContable.proyectado:
        _cargarFlujoProyectado();
        break;

      case TipoFlujoContable.anual:
        _cargarFlujoAnual();
        break;
    }
  }

  void _cambiarAnio(int diferencia) {
    setState(() {
      anioSeleccionado += diferencia;
    });

    _cargarFlujoAnual();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,

          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: _buildHeader(),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: _buildSelector(),
                ),
              ),

              if (tipoSeleccionado == TipoFlujoContable.anual)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _buildSelectorAnio(),
                  ),
                ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildContenido(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.account_balance_wallet_outlined,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),

        const SizedBox(width: 14),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Flujo contable',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 3),
              Text(
                'Analiza ingresos, egresos, saldos y proyecciones.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SELECTOR
  // ============================================================
  Widget _buildSelector() {
    return SegmentedButton<TipoFlujoContable>(
      segments: const [
        ButtonSegment(
          value: TipoFlujoContable.mensual,
          label: Text('Mensual'),
          icon: Icon(Icons.calendar_month_outlined),
        ),
        ButtonSegment(
          value: TipoFlujoContable.proyectado,
          label: Text('Proyección'),
          icon: Icon(Icons.trending_up),
        ),
        ButtonSegment(
          value: TipoFlujoContable.anual,
          label: Text('Anual'),
          icon: Icon(Icons.bar_chart),
        ),
      ],
      selected: {tipoSeleccionado},
      showSelectedIcon: false,
      onSelectionChanged: (value) {
        _seleccionarTipo(value.first);
      },
    );
  }

  Widget _buildSelectorAnio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => _cambiarAnio(-1),
          icon: const Icon(Icons.chevron_left),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.surfaceContainer,
          ),
          child: Text(
            '$anioSeleccionado',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ),

        IconButton(
          onPressed: () => _cambiarAnio(1),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  // ============================================================
  // CONTENIDO
  // ============================================================
  Widget _buildContenido() {
    return BlocBuilder<FlujoContableBloc, FlujoContableState>(
      builder: (context, state) {
        switch (tipoSeleccionado) {
          case TipoFlujoContable.mensual:
            return _buildMensual(state);

          case TipoFlujoContable.proyectado:
            return _buildProyectado(state);

          case TipoFlujoContable.anual:
            return _buildAnual(state);
        }
      },
    );
  }

  Widget _buildMensual(FlujoContableState state) {
    final response = state.flujoMensualResponse;

    if (response == null || response is Initial) {
      return const _LoadingView();
    }

    if (response is Loading) {
      return const _LoadingView();
    }

    if (response is Success<ApiResponse<FlujoContableMensualData>>) {
      final data = response.data.data;

      if (data == null) {
        return const _EmptyView(
          message: 'No existe información mensual disponible.',
        );
      }

      return FlujoMensualView(data: data);
    }

    if (response is ErrorData<ApiResponse<FlujoContableMensualData>>) {
      return _ErrorView(
        message: response.displayMessage,
        onRetry: _cargarFlujoMensual,
      );
    }

    return const SizedBox();
  }

  Widget _buildProyectado(FlujoContableState state) {
    final response = state.flujoProyectadoResponse;

    if (response == null || response is Initial || response is Loading) {
      return const _LoadingView();
    }

    if (response is Success<ApiResponse<FlujoProyectadoData>>) {
      final data = response.data.data;

      if (data == null) {
        return const _EmptyView(message: 'No existe información proyectada.');
      }

      return FlujoProyectadoView(data: data);
    }

    if (response is ErrorData<ApiResponse<FlujoProyectadoData>>) {
      return _ErrorView(
        message: response.displayMessage,
        onRetry: _cargarFlujoProyectado,
      );
    }

    return const SizedBox();
  }

  Widget _buildAnual(FlujoContableState state) {
    final response = state.flujoAnualResponse;

    if (response == null || response is Initial || response is Loading) {
      return const _LoadingView();
    }

    if (response is Success<ApiResponse<FlujoAnualData>>) {
      final data = response.data.data;

      if (data == null) {
        return const _EmptyView(
          message: 'No existe información anual disponible.',
        );
      }

      return FlujoAnualView(data: data);
    }

    if (response is ErrorData<ApiResponse<FlujoAnualData>>) {
      return _ErrorView(
        message: response.displayMessage,
        onRetry: _cargarFlujoAnual,
      );
    }

    return const SizedBox();
  }
}

// ============================================================
// ESTADOS VISUALES
// ============================================================
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final String message;

  const _EmptyView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.inbox_outlined, size: 46, color: Colors.grey),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
