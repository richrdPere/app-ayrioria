import 'package:app_aryoria/src/data/models/reporte/reporte_categoria_response.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_evolucion_response.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_general_data.dart';
import 'package:app_aryoria/src/data/models/reporte/reporte_resumen_periodo_response.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

class ReporteState {
  // =========================================================
  // RESPUESTAS RESOURCE
  // =========================================================
  final Resource<ReporteGeneralData> generalResponse;

  final Resource<ReporteResumenPeriodoResponse> resumenResponse;

  final Resource<ReporteEvolucionResponse> evolucionResponse;

  final Resource<ReporteCategoriaResponse> categoriasResponse;

  // =========================================================
  // DATOS PROCESADOS
  // =========================================================
  final ReporteGeneralData? reporteGeneral;

  final ReporteResumenPeriodoResponse? resumenPeriodo;

  final ReporteEvolucionResponse? evolucionPeriodo;

  final ReporteCategoriaResponse? reporteCategorias;

  // =========================================================
  // INFORMACIÓN DE FILTRO
  // =========================================================
  final int? idEmpresaSeleccionada;
  final int? idPeriodoSeleccionado;
  final String? tipoCategoriaSeleccionado;

  const ReporteState({
    required this.generalResponse,
    required this.resumenResponse,
    required this.evolucionResponse,
    required this.categoriasResponse,
    this.reporteGeneral,
    this.resumenPeriodo,
    this.evolucionPeriodo,
    this.reporteCategorias,
    this.idEmpresaSeleccionada,
    this.idPeriodoSeleccionado,
    this.tipoCategoriaSeleccionado,
  });

  factory ReporteState.initial() {
    return ReporteState(
      generalResponse: Initial(),
      resumenResponse: Initial(),
      evolucionResponse: Initial(),
      categoriasResponse: Initial(),
    );
  }

  // =========================================================
  // HELPERS DE ESTADO
  // =========================================================

  bool get isLoadingGeneral => generalResponse is Loading;

  bool get isLoadingResumen => resumenResponse is Loading;

  bool get isLoadingEvolucion => evolucionResponse is Loading;

  bool get isLoadingCategorias => categoriasResponse is Loading;

  bool get isLoading =>
      isLoadingGeneral ||
      isLoadingResumen ||
      isLoadingEvolucion ||
      isLoadingCategorias;

  bool get hasReporteGeneral => reporteGeneral != null;

  bool get hasResumenPeriodo => resumenPeriodo != null;

  bool get hasEvolucionPeriodo => evolucionPeriodo != null;

  bool get hasReporteCategorias => reporteCategorias != null;

  bool get tieneMovimientos {
    return reporteGeneral?.resumen.tieneMovimientos ??
        resumenPeriodo?.resumen.tieneMovimientos ??
        false;
  }

  ReporteState copyWith({
    Resource<ReporteGeneralData>? generalResponse,
    Resource<ReporteResumenPeriodoResponse>? resumenResponse,
    Resource<ReporteEvolucionResponse>? evolucionResponse,
    Resource<ReporteCategoriaResponse>? categoriasResponse,
    ReporteGeneralData? reporteGeneral,
    ReporteResumenPeriodoResponse? resumenPeriodo,
    ReporteEvolucionResponse? evolucionPeriodo,
    ReporteCategoriaResponse? reporteCategorias,
    int? idEmpresaSeleccionada,
    int? idPeriodoSeleccionado,
    String? tipoCategoriaSeleccionado,
    bool clearReporteGeneral = false,
    bool clearResumenPeriodo = false,
    bool clearEvolucionPeriodo = false,
    bool clearReporteCategorias = false,
    bool clearTipoCategoria = false,
  }) {
    return ReporteState(
      generalResponse: generalResponse ?? this.generalResponse,
      resumenResponse: resumenResponse ?? this.resumenResponse,
      evolucionResponse: evolucionResponse ?? this.evolucionResponse,
      categoriasResponse: categoriasResponse ?? this.categoriasResponse,

      reporteGeneral: clearReporteGeneral
          ? null
          : reporteGeneral ?? this.reporteGeneral,

      resumenPeriodo: clearResumenPeriodo
          ? null
          : resumenPeriodo ?? this.resumenPeriodo,

      evolucionPeriodo: clearEvolucionPeriodo
          ? null
          : evolucionPeriodo ?? this.evolucionPeriodo,

      reporteCategorias: clearReporteCategorias
          ? null
          : reporteCategorias ?? this.reporteCategorias,

      idEmpresaSeleccionada:
          idEmpresaSeleccionada ?? this.idEmpresaSeleccionada,

      idPeriodoSeleccionado:
          idPeriodoSeleccionado ?? this.idPeriodoSeleccionado,

      tipoCategoriaSeleccionado: clearTipoCategoria
          ? null
          : tipoCategoriaSeleccionado ?? this.tipoCategoriaSeleccionado,
    );
  }
}
