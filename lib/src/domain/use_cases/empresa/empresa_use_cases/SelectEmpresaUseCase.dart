import 'package:app_aryoria/src/domain/repositories/empresa_repository.dart';

class SelectEmpresaUseCase {
  EmpresaRepository empresaRepository;

  SelectEmpresaUseCase(this.empresaRepository);

  run(int idEmpresa) =>
      empresaRepository.selectEmpresa(idEmpresa);
}
