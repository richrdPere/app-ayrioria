import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/domain/repositories/empresa_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class DeleteEmpresaUseCase {
  EmpresaRepository empresaRepository;
  DeleteEmpresaUseCase(this.empresaRepository);

  Future<Resource<ApiResponse<void>>> run(int idEmpresa) =>
      empresaRepository.deleteEmpresa(idEmpresa);
}
