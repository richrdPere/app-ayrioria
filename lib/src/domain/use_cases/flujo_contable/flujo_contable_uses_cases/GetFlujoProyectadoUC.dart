import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_proyectado.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetFlujoProyectadoUC {
  FlujoContableRepository flujoContableRepository;
  GetFlujoProyectadoUC(this.flujoContableRepository);

  Future<Resource<ApiResponse<FlujoProyectadoData>>> run({
    required int idPeriodo,
    required int idEmpresa,
  }) => flujoContableRepository.getFlujoProyectado(
    idEmpresa: idEmpresa,
    idPeriodo: idPeriodo,
  );
}
