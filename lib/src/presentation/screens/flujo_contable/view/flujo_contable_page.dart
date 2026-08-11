import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_query_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Session
import 'package:app_aryoria/src/config/core/session/session_bloc.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Flujo Contable
import 'package:app_aryoria/src/presentation/screens/flujo_contable/bloc/flujo_contable_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/flujo_contable/bloc/flujo_contable_event.dart';
import 'package:app_aryoria/src/presentation/screens/flujo_contable/bloc/flujo_contable_state.dart';
import 'package:app_aryoria/src/presentation/screens/flujo_contable/view/flujo_contable_content.dart';

// Periodo Contable
import 'package:app_aryoria/src/data/models/periodo_contable/periodo_contable_data.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_event.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_state.dart';
import 'package:go_router/go_router.dart';

class FlujoContablePage extends StatefulWidget {
  const FlujoContablePage({super.key});

  @override
  State<FlujoContablePage> createState() => _FlujoContablePageState();
}

class _FlujoContablePageState extends State<FlujoContablePage> {
  int? _idPeriodoSeleccionado;
  int? _anioSeleccionado;

  // ============================================================
  // EMPRESA ACTIVA
  // ============================================================

  int? get _idEmpresa {
    return context.read<SessionBloc>().state.empresaActiva?.idEmpresa;
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  // ============================================================
  // CARGAR PERIODOS
  // ============================================================

  void _loadInitialData() {
    if (!mounted) return;

    final idEmpresa = _idEmpresa;

    debugPrint('ID EMPRESA FLUJO CONTABLE: $idEmpresa');

    if (idEmpresa == null) {
      return;
    }

    final queryParams = PeriodosContablesParams(page: 1, limit: 10);

    context.read<PeriodoContableBloc>().add(
      GetPeriodosContablesEvent(idEmpresa: idEmpresa, queryParams: queryParams),
    );
  }

  // ============================================================
  // PROCESAR PERIODOS
  // ============================================================

  void _procesarPeriodos(PeriodoContableState state) {
    if (state.periodos.isEmpty) {
      return;
    }

    // ----------------------------------------------------------
    // 1. Prioridad: período ABIERTO
    // 2. Si no existe, primer período disponible
    // ----------------------------------------------------------

    final PeriodoContableData periodoSeleccionado =
        state.periodoActivo ?? state.periodos.first;

    if (_idPeriodoSeleccionado == periodoSeleccionado.idPeriodo &&
        _anioSeleccionado == periodoSeleccionado.anio) {
      return;
    }

    debugPrint(
      'PERIODO SELECCIONADO: '
      '${periodoSeleccionado.idPeriodo}',
    );

    debugPrint(
      'NOMBRE PERIODO: '
      '${periodoSeleccionado.nombre}',
    );

    debugPrint(
      'AÑO SELECCIONADO: '
      '${periodoSeleccionado.anio}',
    );

    if (!mounted) return;

    setState(() {
      _idPeriodoSeleccionado = periodoSeleccionado.idPeriodo;

      _anioSeleccionado = periodoSeleccionado.anio;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final idEmpresa = _idEmpresa;

    if (idEmpresa == null) {
      return const Center(child: Text('No existe una empresa activa.'));
    }

    return MultiBlocListener(
      listeners: [
        // ======================================================
        // FLUJO CONTABLE
        // ======================================================
        BlocListener<FlujoContableBloc, FlujoContableState>(
          listenWhen: (previous, current) =>
              previous.errorMessage != current.errorMessage &&
              current.errorMessage != null,
          listener: (context, state) {
            final message = state.errorMessage;

            if (message == null || message.trim().isEmpty) {
              return;
            }

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(message),
                  behavior: SnackBarBehavior.floating,
                ),
              );

            context.read<FlujoContableBloc>().add(
              const ClearFlujoContableErrorEvent(),
            );
          },
        ),

        // ======================================================
        // PERIODOS CONTABLES
        // ======================================================
        BlocListener<PeriodoContableBloc, PeriodoContableState>(
          listenWhen: (previous, current) =>
              previous.periodos != current.periodos ||
              previous.response != current.response,
          listener: (context, state) {
            _procesarPeriodos(state);
          },
        ),
      ],

      child: BlocBuilder<PeriodoContableBloc, PeriodoContableState>(
        builder: (context, state) {
          // ----------------------------------------------------
          // Si el bloc ya tenía períodos cargados antes de entrar
          // a esta pantalla, resolvemos el seleccionado aquí.
          // ----------------------------------------------------

          if (_idPeriodoSeleccionado == null && state.periodos.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _procesarPeriodos(state);
              }
            });
          }

          // ----------------------------------------------------
          // Aún no existe período seleccionado
          // ----------------------------------------------------

          if (_idPeriodoSeleccionado == null || _anioSeleccionado == null) {
            return _buildEstadoPeriodo(state);
          }

          // ----------------------------------------------------
          // Empresa + período + año resueltos
          // ----------------------------------------------------

          return FlujoContableContent(
            idEmpresa: idEmpresa,
            idPeriodo: _idPeriodoSeleccionado!,
            anioInicial: _anioSeleccionado!,
          );
        },
      ),
    );
  }

  // ============================================================
  // ESTADO DE PERIODOS
  // ============================================================

  Widget _buildEstadoPeriodo(PeriodoContableState state) {
    final response = state.response;

    // ----------------------------------------------------------
    // Todavía no hay respuesta o está cargando
    // ----------------------------------------------------------

    if (response == null || response is Initial || response is Loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // ----------------------------------------------------------
    // Error al cargar períodos
    // ----------------------------------------------------------

    if (response is ErrorData) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),

              const SizedBox(height: 16),

              Text(response.displayMessage, textAlign: TextAlign.center),

              const SizedBox(height: 16),

              FilledButton.icon(
                onPressed: _loadInitialData,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    // ----------------------------------------------------------
    // Hay respuesta correcta y existen períodos,
    // pero todavía falta ejecutar setState().
    // ----------------------------------------------------------

    if (state.periodos.isNotEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // ----------------------------------------------------------
    // No existen períodos
    // ----------------------------------------------------------

    return _buildSinPeriodos();
  }

  // ============================================================
  // SIN PERIODOS
  // ============================================================
  Widget _buildSinPeriodos() {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ==================================================
              // ICONO
              // ==================================================
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_month_outlined,
                  size: 48,
                  color: colors.onPrimaryContainer,
                ),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // TÍTULO
              // ==================================================
              Text(
                'No hay períodos contables',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              // ==================================================
              // DESCRIPCIÓN
              // ==================================================
              Text(
                'Debes registrar al menos un período contable '
                'para consultar el flujo de ingresos y egresos '
                'de tu empresa.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // IR A PERÍODOS CONTABLES
              // ==================================================
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    context.pushNamed('periodos_contables');
                  },
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: const Text('Ir a períodos contables'),
                ),
              ),

              const SizedBox(height: 10),

              // ==================================================
              // ACTUALIZAR
              // ==================================================
              // TextButton.icon(
              //   onPressed: _loadInitialData,
              //   icon: const Icon(Icons.refresh_rounded, size: 20),
              //   label: const Text('Actualizar'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
