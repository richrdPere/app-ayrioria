import 'package:app_aryoria/src/domain/use_cases/index_uses_cases.dart';

class EmpresaUseCases {
  CreateEmpresaUseCase createEmpresa;
  DeleteEmpresaUseCase deleteEmpresa;
  GetEmpresaByIdUseCase getEmpresaById;
  GetEmpresasUseCase getEmpresas;
  UpdateEmpresaUseCase updateEmpresa;
  SelectEmpresaUseCase selectEmpresa;

  EmpresaUseCases({
    required this.createEmpresa,
    required this.deleteEmpresa,
    required this.getEmpresaById,
    required this.getEmpresas,
    required this.updateEmpresa,
    required this.selectEmpresa,
  });
}
