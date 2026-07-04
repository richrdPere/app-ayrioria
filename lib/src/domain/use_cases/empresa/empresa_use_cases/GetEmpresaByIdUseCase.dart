import 'package:app_aryoria/src/domain/repositories/empresa_repository.dart';

class GetEmpresaByIdUseCase {
  EmpresaRepository empresaRepository;
  GetEmpresaByIdUseCase(this.empresaRepository);

  run(int idEmpresa) => empresaRepository.getEmpresaById(idEmpresa);
}
