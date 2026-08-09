import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_data.dart';
import 'package:app_aryoria/src/data/models/empresa/empresa_request.dart';
import 'package:app_aryoria/src/domain/repositories/empresa_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class CreateEmpresaUseCase {
  EmpresaRepository empresaRepository;
  CreateEmpresaUseCase(this.empresaRepository);

  Future<Resource<ApiResponse<EmpresaData>>> run(EmpresaRequest req) =>
      empresaRepository.createEmpresa(req);
}
