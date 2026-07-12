class PeriodoContableRequest {
  final int idEmpresa;
  final String nombre;
  final int anio;
  final int mes;
  final String fechaInicio;
  final String fechaFin;
  final double saldoInicial;
  final String? observacion;

  const PeriodoContableRequest({
    required this.idEmpresa,
    required this.nombre,
    required this.anio,
    required this.mes,
    required this.fechaInicio,
    required this.fechaFin,
    required this.saldoInicial,
    this.observacion,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_empresa': idEmpresa,
      'nombre': nombre.trim(),
      'anio': anio,
      'mes': mes,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
      'saldo_inicial': saldoInicial,
      'observacion': observacion?.trim().isEmpty == true
          ? null
          : observacion?.trim(),
    };
  }
}
