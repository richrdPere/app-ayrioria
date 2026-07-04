class EmpresaData {
  final int idEmpresa;
  final int idUsuario;

  final bool estado;
  final bool activoSunat;

  final String razonSocial;
  final String nombreComercial;
  final String ruc;
  final String tipoEmpresa;

  final String direccionFiscal;
  final String telefono;
  final String email;
  final String paginaWeb;
  final String logoUrl;

  final DateTime createdAt;
  final DateTime updatedAt;

  EmpresaData({
    required this.idEmpresa,
    required this.idUsuario,
    required this.estado,
    required this.activoSunat,
    required this.razonSocial,
    required this.nombreComercial,
    required this.ruc,
    required this.tipoEmpresa,
    required this.direccionFiscal,
    required this.telefono,
    required this.email,
    required this.paginaWeb,
    required this.logoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmpresaData.fromJson(Map<String, dynamic> json) {
    return EmpresaData(
      idEmpresa: json["id_empresa"],
      idUsuario: json["id_usuario"],
      estado: json["estado"],
      activoSunat: json["activo_sunat"],
      razonSocial: json["razon_social"],
      nombreComercial: json["nombre_comercial"],
      ruc: json["ruc"],
      tipoEmpresa: json["tipo_empresa"],
      direccionFiscal: json["direccion_fiscal"] ?? "",
      telefono: json["telefono"] ?? "",
      email: json["email"] ?? "",
      paginaWeb: json["pagina_web"] ?? "",
      logoUrl: json["logo_url"] ?? "",
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }
}
