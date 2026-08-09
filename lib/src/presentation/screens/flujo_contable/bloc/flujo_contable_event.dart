abstract class FlujoContableEvent {
  const FlujoContableEvent();
}

// ============================================================
// 1.- Obtener Flujo Contable Mensual
// ============================================================

class GetFlujoContableMensualEvent extends FlujoContableEvent {
  final int idPeriodo;
  final int idEmpresa;

  const GetFlujoContableMensualEvent({
    required this.idPeriodo,
    required this.idEmpresa,
  });
}

// ============================================================
// 2.- Obtener Flujo Contable Anual
// ============================================================

class GetFlujoContableAnualEvent extends FlujoContableEvent {
  final int idEmpresa;
  final int anio;

  const GetFlujoContableAnualEvent({
    required this.idEmpresa,
    required this.anio,
  });
}

// ============================================================
// 3.- Obtener Flujo Proyectado
// ============================================================

class GetFlujoProyectadoEvent extends FlujoContableEvent {
  final int idPeriodo;
  final int idEmpresa;

  const GetFlujoProyectadoEvent({
    required this.idPeriodo,
    required this.idEmpresa,
  });
}

// ============================================================
// 4.- Refrescar todo el flujo contable
// ============================================================

class RefreshFlujoContableEvent extends FlujoContableEvent {
  final int idPeriodo;
  final int idEmpresa;
  final int anio;

  const RefreshFlujoContableEvent({
    required this.idPeriodo,
    required this.idEmpresa,
    required this.anio,
  });
}

// ============================================================
// 5.- Limpiar errores
// ============================================================

class ClearFlujoContableErrorEvent extends FlujoContableEvent {
  const ClearFlujoContableErrorEvent();
}
