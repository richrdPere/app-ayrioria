class MovimientoUpdateRequest {
  final int? idCategoria;
  final int? idSubcategoria;
  final int? idCuenta;
  final int? idPeriodo;
  final int? idUsuario;

  final String? tipo;
  final String? fecha;
  final String? descripcion;
  final double? monto;

  final String? observacion;
  final String? comprobante;
  final String? estado;

  const MovimientoUpdateRequest({
    this.idCategoria,
    this.idSubcategoria,
    this.idCuenta,
    this.idPeriodo,
    this.idUsuario,
    this.tipo,
    this.fecha,
    this.descripcion,
    this.monto,
    this.observacion,
    this.comprobante,
    this.estado,
  });

  Map<String, dynamic> toJson() {
    return {
      if (idCategoria != null) 'id_categoria': idCategoria,
      if (idSubcategoria != null) 'id_subcategoria': idSubcategoria,

      // Se incluye incluso si es null para permitir quitar la cuenta.
      'id_cuenta': idCuenta,

      if (idPeriodo != null) 'id_periodo': idPeriodo,
      if (idUsuario != null) 'id_usuario': idUsuario,

      if (tipo != null && tipo!.trim().isNotEmpty)
        'tipo': tipo!.trim().toUpperCase(),

      if (fecha != null && fecha!.trim().isNotEmpty) 'fecha': fecha!.trim(),

      if (descripcion != null && descripcion!.trim().isNotEmpty)
        'descripcion': descripcion!.trim(),

      if (monto != null) 'monto': monto,

      if (observacion != null) 'observacion': observacion!.trim(),

      if (comprobante != null) 'comprobante': comprobante!.trim(),

      if (estado != null && estado!.trim().isNotEmpty)
        'estado': estado!.trim().toUpperCase(),
    };
  }
}
