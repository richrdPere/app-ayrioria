import 'package:app_aryoria/src/domain/entity/empresa_entity.dart';

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

  Map<String, dynamic> toJson() {
    return {
      "id_empresa": idEmpresa,
      "id_usuario": idUsuario,
      "estado": estado,
      "activo_sunat": activoSunat,
      "razon_social": razonSocial,
      "nombre_comercial": nombreComercial,
      "ruc": ruc,
      "tipo_empresa": tipoEmpresa,
      "direccion_fiscal": direccionFiscal,
      "telefono": telefono,
      "email": email,
      "pagina_web": paginaWeb,
      "logo_url": logoUrl,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }

  EmpresaData copyWith({
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
    return EmpresaData(
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

  EmpresaEntity toEntity() {
    return EmpresaEntity(
      idEmpresa: idEmpresa,
      idUsuario: idUsuario,
      estado: estado,
      activoSunat: activoSunat,
      razonSocial: razonSocial,
      nombreComercial: nombreComercial,
      ruc: ruc,
      tipoEmpresa: tipoEmpresa,
      direccionFiscal: direccionFiscal,
      telefono: telefono,
      email: email,
      paginaWeb: paginaWeb,
      logoUrl: logoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
