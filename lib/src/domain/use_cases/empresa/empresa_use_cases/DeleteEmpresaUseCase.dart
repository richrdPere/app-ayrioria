import 'package:app_aryoria/src/domain/repositories/empresa_repository.dart';

class DeleteEmpresaUseCase {
  EmpresaRepository empresaRepository;
  DeleteEmpresaUseCase(this.empresaRepository);

  run(int idEmpresa) => empresaRepository.deleteEmpresa(idEmpresa);
}
