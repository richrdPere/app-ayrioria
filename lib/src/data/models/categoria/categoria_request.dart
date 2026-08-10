class CategoriaRequest {
  final int idEmpresa;
  final String nombre;
  final String tipo;
  final String naturaleza;
  final String? descripcion;
  final String? color;
  final String? icono;

  const CategoriaRequest({
    required this.idEmpresa,
    required this.nombre,
    required this.tipo,
    this.naturaleza = 'OTRO',
    this.descripcion,
    this.color,
    this.icono,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_empresa': idEmpresa,
      'nombre': nombre,
      'tipo': tipo,
      'naturaleza': naturaleza,
      'descripcion': descripcion,
      'color': color,
      'icono': icono,
    };
  }
}
