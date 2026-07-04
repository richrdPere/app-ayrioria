import 'package:app_aryoria/src/domain/repositories/empresa_repository.dart';

class GetEmpresasUseCase {
  EmpresaRepository empresaRepository;
  GetEmpresasUseCase(this.empresaRepository);

  run({int page = 1, int limit = 10, String search = ''}) =>
      empresaRepository.getEmpresas(page: page, limit: limit, search: search);
}
