import 'package:app_aryoria/src/domain/use_cases/empresa/empresa_use_cases/DeleteEmpresaUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/empresa/empresa_use_cases/GetEmpresaByIdUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/empresa/empresa_use_cases/GetEmpresasUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/empresa/empresa_use_cases/UpdateEmpresaUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/empresa/empresa_use_cases/createEmpresaUseCase.dart';

class EmpresaUseCases {
  CreateEmpresaUseCase createEmpresa;
  DeleteEmpresaUseCase deleteEmpresa;
  GetEmpresaByIdUseCase getEmpresaById;
  GetEmpresasUseCase getEmpresas;
  UpdateEmpresaUseCase updateEmpresa;

  EmpresaUseCases({
    required this.createEmpresa,
    required this.deleteEmpresa,
    required this.getEmpresaById,
    required this.getEmpresas,
    required this.updateEmpresa,
  });
}
