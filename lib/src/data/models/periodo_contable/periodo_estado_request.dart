class PeriodoEstadoRequest {
  final String estado;

  const PeriodoEstadoRequest({required this.estado});

  Map<String, dynamic> toJson() {
    return {'estado': estado.toUpperCase()};
  }
}
