import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_aryoria/src/data/models/reporte/reporte_categoria_response.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_evolucion_response.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_general_data.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_resumen_periodo_response.dart';

import 'package:app_aryoria/src/domain/use_cases/reporte/ReporteUsesCases.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

import 'reporte_event.dart';
import 'reporte_state.dart';

class ReporteBloc extends Bloc<ReporteEvent, ReporteState> {
  final ReporteUsesCases reporteUsesCases;

  ReporteBloc(this.reporteUsesCases) : super(ReporteState.initial()) {
    on<GetReporteGeneralEvent>(_onGetReporteGeneral);
    on<GetResumenPeriodoEvent>(_onGetResumenPeriodo);
    on<GetEvolucionPeriodoEvent>(_onGetEvolucionPeriodo);
    on<GetReporteCategoriasEvent>(_onGetReporteCategorias);
    on<RefreshReporteEvent>(_onRefreshReporte);
    on<ClearReporteEvent>(_onClearReporte);
  }

  // =========================================================
  // 1. OBTENER REPORTE GENERAL
  // =========================================================

  Future<void> _onGetReporteGeneral(
    GetReporteGeneralEvent event,
    Emitter<ReporteState> emit,
  ) async {
    emit(
      state.copyWith(
        generalResponse: Loading(),
        idEmpresaSeleccionada: event.idEmpresa,
        idPeriodoSeleccionado: event.idPeriodo,
      ),
    );

    final Resource<ReporteGeneralData> response = await reporteUsesCases
        .getReporteGeneral
        .run(idEmpresa: event.idEmpresa, idPeriodo: event.idPeriodo);

    if (response is Success<ReporteGeneralData>) {
      debugPrint('REPORTE GENERAL EVOLUCION: ${response.data.evolucion}');
      debugPrint(
        'REPORTE GENERAL CATEGORIAS EGRESO: ${response.data.categoriasEgreso}',
      );
      debugPrint(
        'REPORTE GENERAL CATEGORIAS INGRESO: ${response.data.categoriasIngreso}',
      );
       debugPrint(
        'REPORTE GENERAL CATEGORIAS RESUMEN: ${response.data.resumen.cantidadCategorias}',
      );

      emit(
        state.copyWith(
          generalResponse: response,
          reporteGeneral: response.data,
          idEmpresaSeleccionada: event.idEmpresa,
          idPeriodoSeleccionado: event.idPeriodo,
        ),
      );

      return;
    }

    emit(state.copyWith(generalResponse: response));
  }

  // =========================================================
  // 2. OBTENER RESUMEN DEL PERÍODO
  // =========================================================

  Future<void> _onGetResumenPeriodo(
    GetResumenPeriodoEvent event,
    Emitter<ReporteState> emit,
  ) async {
    emit(
      state.copyWith(
        resumenResponse: Loading(),
        idEmpresaSeleccionada: event.idEmpresa,
        idPeriodoSeleccionado: event.idPeriodo,
      ),
    );

    final Resource<ReporteResumenPeriodoResponse> response =
        await reporteUsesCases.getResumenPeriodo.run(
          idEmpresa: event.idEmpresa,
          idPeriodo: event.idPeriodo,
        );

    if (response is Success<ReporteResumenPeriodoResponse>) {
      emit(
        state.copyWith(
          resumenResponse: response,
          resumenPeriodo: response.data,
          idEmpresaSeleccionada: event.idEmpresa,
          idPeriodoSeleccionado: event.idPeriodo,
        ),
      );

      return;
    }

    emit(state.copyWith(resumenResponse: response));
  }

  // =========================================================
  // 3. OBTENER EVOLUCIÓN DEL PERÍODO
  // =========================================================

  Future<void> _onGetEvolucionPeriodo(
    GetEvolucionPeriodoEvent event,
    Emitter<ReporteState> emit,
  ) async {
    emit(
      state.copyWith(
        evolucionResponse: Loading(),
        idEmpresaSeleccionada: event.idEmpresa,
        idPeriodoSeleccionado: event.idPeriodo,
      ),
    );

    final Resource<ReporteEvolucionResponse> response = await reporteUsesCases
        .getEvolucionPeriodo
        .run(idEmpresa: event.idEmpresa, idPeriodo: event.idPeriodo);

    if (response is Success<ReporteEvolucionResponse>) {
      emit(
        state.copyWith(
          evolucionResponse: response,
          evolucionPeriodo: response.data,
          idEmpresaSeleccionada: event.idEmpresa,
          idPeriodoSeleccionado: event.idPeriodo,
        ),
      );

      return;
    }

    emit(state.copyWith(evolucionResponse: response));
  }

  // =========================================================
  // 4. OBTENER REPORTE POR CATEGORÍAS
  // =========================================================

  Future<void> _onGetReporteCategorias(
    GetReporteCategoriasEvent event,
    Emitter<ReporteState> emit,
  ) async {
    final String? tipoNormalizado =
        event.tipo == null || event.tipo!.trim().isEmpty
        ? null
        : event.tipo!.trim().toUpperCase();

    if (tipoNormalizado != null &&
        tipoNormalizado != 'INGRESO' &&
        tipoNormalizado != 'EGRESO') {
      emit(
        state.copyWith(
          categoriasResponse: ErrorData<ReporteCategoriaResponse>(
            'El tipo debe ser INGRESO o EGRESO.',
          ),
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        categoriasResponse: Loading(),
        idEmpresaSeleccionada: event.idEmpresa,
        idPeriodoSeleccionado: event.idPeriodo,
        tipoCategoriaSeleccionado: tipoNormalizado,
        clearTipoCategoria: tipoNormalizado == null,
      ),
    );

    final Resource<ReporteCategoriaResponse> response = await reporteUsesCases
        .getReporteCategorias
        .run(
          idEmpresa: event.idEmpresa,
          idPeriodo: event.idPeriodo,
          tipo: tipoNormalizado,
        );

    if (response is Success<ReporteCategoriaResponse>) {
      emit(
        state.copyWith(
          categoriasResponse: response,
          reporteCategorias: response.data,
          idEmpresaSeleccionada: event.idEmpresa,
          idPeriodoSeleccionado: event.idPeriodo,
          tipoCategoriaSeleccionado: tipoNormalizado,
          clearTipoCategoria: tipoNormalizado == null,
        ),
      );

      return;
    }

    emit(state.copyWith(categoriasResponse: response));
  }

  // =========================================================
  // 5. RECARGAR REPORTE
  // =========================================================

  Future<void> _onRefreshReporte(
    RefreshReporteEvent event,
    Emitter<ReporteState> emit,
  ) async {
    emit(
      state.copyWith(
        generalResponse: Loading(),
        resumenResponse: Loading(),
        evolucionResponse: Loading(),
        categoriasResponse: Loading(),
        idEmpresaSeleccionada: event.idEmpresa,
        idPeriodoSeleccionado: event.idPeriodo,
      ),
    );

    final responses = await Future.wait([
      reporteUsesCases.getReporteGeneral.run(
        idEmpresa: event.idEmpresa,
        idPeriodo: event.idPeriodo,
      ),
      reporteUsesCases.getResumenPeriodo.run(
        idEmpresa: event.idEmpresa,
        idPeriodo: event.idPeriodo,
      ),
      reporteUsesCases.getEvolucionPeriodo.run(
        idEmpresa: event.idEmpresa,
        idPeriodo: event.idPeriodo,
      ),
      reporteUsesCases.getReporteCategorias.run(
        idEmpresa: event.idEmpresa,
        idPeriodo: event.idPeriodo,
        tipo: state.tipoCategoriaSeleccionado,
      ),
    ]);

    final Resource<ReporteGeneralData> generalResponse =
        responses[0] as Resource<ReporteGeneralData>;

    final Resource<ReporteResumenPeriodoResponse> resumenResponse =
        responses[1] as Resource<ReporteResumenPeriodoResponse>;

    final Resource<ReporteEvolucionResponse> evolucionResponse =
        responses[2] as Resource<ReporteEvolucionResponse>;

    final Resource<ReporteCategoriaResponse> categoriasResponse =
        responses[3] as Resource<ReporteCategoriaResponse>;

    emit(
      state.copyWith(
        generalResponse: generalResponse,
        resumenResponse: resumenResponse,
        evolucionResponse: evolucionResponse,
        categoriasResponse: categoriasResponse,

        reporteGeneral: generalResponse is Success<ReporteGeneralData>
            ? generalResponse.data
            : null,

        resumenPeriodo:
            resumenResponse is Success<ReporteResumenPeriodoResponse>
            ? resumenResponse.data
            : null,

        evolucionPeriodo: evolucionResponse is Success<ReporteEvolucionResponse>
            ? evolucionResponse.data
            : null,

        reporteCategorias:
            categoriasResponse is Success<ReporteCategoriaResponse>
            ? categoriasResponse.data
            : null,

        idEmpresaSeleccionada: event.idEmpresa,
        idPeriodoSeleccionado: event.idPeriodo,
      ),
    );
  }

  // =========================================================
  // 6. LIMPIAR REPORTE
  // =========================================================

  void _onClearReporte(ClearReporteEvent event, Emitter<ReporteState> emit) {
    emit(ReporteState.initial());
  }
}
