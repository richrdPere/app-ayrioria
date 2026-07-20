abstract class ReporteEvent {
  const ReporteEvent();
}

// =========================================================
// 1. REPORTE GENERAL
// =========================================================

class GetReporteGeneralEvent extends ReporteEvent {
  final int idEmpresa;
  final int idPeriodo;

  const GetReporteGeneralEvent({
    required this.idEmpresa,
    required this.idPeriodo,
  });
}

// =========================================================
// 2. RESUMEN DEL PERÍODO
// =========================================================

class GetResumenPeriodoEvent extends ReporteEvent {
  final int idEmpresa;
  final int idPeriodo;

  const GetResumenPeriodoEvent({
    required this.idEmpresa,
    required this.idPeriodo,
  });
}

// =========================================================
// 3. EVOLUCIÓN DEL PERÍODO
// =========================================================

class GetEvolucionPeriodoEvent extends ReporteEvent {
  final int idEmpresa;
  final int idPeriodo;

  const GetEvolucionPeriodoEvent({
    required this.idEmpresa,
    required this.idPeriodo,
  });
}

// =========================================================
// 4. REPORTE POR CATEGORÍAS
// =========================================================

class GetReporteCategoriasEvent extends ReporteEvent {
  final int idEmpresa;
  final int idPeriodo;

  /// Puede ser:
  /// - INGRESO
  /// - EGRESO
  /// - null para obtener ambos
  final String? tipo;

  const GetReporteCategoriasEvent({
    required this.idEmpresa,
    required this.idPeriodo,
    this.tipo,
  });
}

// =========================================================
// 5. RECARGAR TODOS LOS DATOS
// =========================================================

class RefreshReporteEvent extends ReporteEvent {
  final int idEmpresa;
  final int idPeriodo;

  const RefreshReporteEvent({required this.idEmpresa, required this.idPeriodo});
}

// =========================================================
// 6. LIMPIAR ESTADO
// =========================================================

class ClearReporteEvent extends ReporteEvent {
  const ClearReporteEvent();
}
