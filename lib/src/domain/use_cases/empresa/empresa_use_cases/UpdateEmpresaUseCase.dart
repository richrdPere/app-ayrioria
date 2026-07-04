import 'package:app_aryoria/src/data/models/empresa/empresa_request.dart';
import 'package:app_aryoria/src/domain/repositories/empresa_repository.dart';

class UpdateEmpresaUseCase {
  EmpresaRepository empresaRepository;
  UpdateEmpresaUseCase(this.empresaRepository);

  run({required int idEmpresa, required EmpresaRequest request}) =>
      empresaRepository.updateEmpresa(idEmpresa: idEmpresa, request: request);
}
