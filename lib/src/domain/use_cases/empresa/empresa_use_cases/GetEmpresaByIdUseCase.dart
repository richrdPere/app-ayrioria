import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_data.dart';
import 'package:app_aryoria/src/domain/repositories/empresa_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetEmpresaByIdUseCase {
  EmpresaRepository empresaRepository;
  GetEmpresaByIdUseCase(this.empresaRepository);

  Future<Resource<ApiResponse<EmpresaData>>> run(int idEmpresa) =>
      empresaRepository.getEmpresaById(idEmpresa);
}
