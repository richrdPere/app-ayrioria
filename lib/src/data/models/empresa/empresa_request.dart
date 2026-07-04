class EmpresaRequest {
  final int idUsuario;
  final String razonSocial;
  final String nombreComercial;
  final String ruc;
  final String tipoEmpresa;
  final String direccionFiscal;
  final String telefono;
  final String email;
  final String paginaWeb;
  final String logoUrl;

  EmpresaRequest({
    required this.idUsuario,
    required this.razonSocial,
    required this.nombreComercial,
    required this.ruc,
    required this.tipoEmpresa,
    required this.direccionFiscal,
    required this.telefono,
    required this.email,
    required this.paginaWeb,
    required this.logoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "id_usuario": idUsuario,
      "razon_social": razonSocial,
      "nombre_comercial": nombreComercial,
      "ruc": ruc,
      "tipo_empresa": tipoEmpresa,
      "direccion_fiscal": direccionFiscal,
      "telefono": telefono,
      "email": email,
      "pagina_web": paginaWeb,
      "logo_url": logoUrl,
    };
  }
}
