class EmpresaSelectedRequest {
  final int idEmpresa;

  EmpresaSelectedRequest({
    required this.idEmpresa,
  });

  Map<String, dynamic> toJson() {
    return {
      "id_empresa": idEmpresa,
    };
  }
}