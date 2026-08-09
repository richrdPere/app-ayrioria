import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_mensual.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetFlujoContableMensualUC {
  FlujoContableRepository flujoContableRepository;
  GetFlujoContableMensualUC(this.flujoContableRepository);

  Future<Resource<ApiResponse<FlujoContableMensualData>>> run({
    required int idPeriodo,
    required int idEmpresa,
  }) => flujoContableRepository.getFlujoContableMensual(
    idEmpresa: idEmpresa,
    idPeriodo: idPeriodo,
  );
}
