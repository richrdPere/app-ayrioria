class EmpresaEntity {
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

  const EmpresaEntity({
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

  EmpresaEntity copyWith({
    int? idEmpresa,
    int? idUsuario,
    bool? estado,
    bool? activoSunat,
    String? razonSocial,
    String? nombreComercial,
    String? ruc,
    String? tipoEmpresa,
    String? direccionFiscal,
    String? telefono,
    String? email,
    String? paginaWeb,
    String? logoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EmpresaEntity(
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idUsuario: idUsuario ?? this.idUsuario,
      estado: estado ?? this.estado,
      activoSunat: activoSunat ?? this.activoSunat,
      razonSocial: razonSocial ?? this.razonSocial,
      nombreComercial: nombreComercial ?? this.nombreComercial,
      ruc: ruc ?? this.ruc,
      tipoEmpresa: tipoEmpresa ?? this.tipoEmpresa,
      direccionFiscal: direccionFiscal ?? this.direccionFiscal,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      paginaWeb: paginaWeb ?? this.paginaWeb,
      logoUrl: logoUrl ?? this.logoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
