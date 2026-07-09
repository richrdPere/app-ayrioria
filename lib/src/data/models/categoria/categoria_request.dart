class CategoriaRequest {
  final int idEmpresa;
  final String nombre;
  final String tipo;
  final String? descripcion;
  final String? color;
  final String? icono;

  const CategoriaRequest({
    required this.idEmpresa,
    required this.nombre,
    required this.tipo,
    this.descripcion,
    this.color,
    this.icono,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_empresa': idEmpresa,
      'nombre': nombre,
      'tipo': tipo,
      'descripcion': descripcion,
      'color': color,
      'icono': icono,
    };
  }
}
