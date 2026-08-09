import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/login/login_data_model.dart';
import 'package:app_aryoria/src/domain/repositories/empresa_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class SelectEmpresaUseCase {
  EmpresaRepository empresaRepository;

  SelectEmpresaUseCase(this.empresaRepository);

  Future<Resource<ApiResponse<LoginDataModel>>> run(int idEmpresa) =>
      empresaRepository.selectEmpresa(idEmpresa);
}
