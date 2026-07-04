import 'package:app_aryoria/src/data/models/empresa/empresa_request.dart';
import 'package:app_aryoria/src/domain/repositories/empresa_repository.dart';

class CreateEmpresaUseCase {
  EmpresaRepository empresaRepository;
  CreateEmpresaUseCase(this.empresaRepository);

  run(EmpresaRequest req) => empresaRepository.createEmpresa(req);
}
