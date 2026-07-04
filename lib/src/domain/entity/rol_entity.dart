class RolEntity {
  final int idRol;
  final String nombre;
  final String? descripcion;
  final bool estado;

  const RolEntity({
    required this.idRol,
    required this.nombre,
    this.descripcion,
    required this.estado,
  });
}