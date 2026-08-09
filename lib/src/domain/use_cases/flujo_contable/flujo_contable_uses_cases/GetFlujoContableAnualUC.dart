import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_anual.dart';
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';
import 'package:app_aryoria/src/domain/utils/Resource.dart';

class GetFlujoContableAnualUC {
  FlujoContableRepository flujoContableRepository;
  GetFlujoContableAnualUC(this.flujoContableRepository);

  Future<Resource<ApiResponse<FlujoAnualData>>> run({
    required int idEmpresa,
    required int anio,
  }) => flujoContableRepository.getFlujoContableAnual(
    idEmpresa: idEmpresa,
    anio: anio,
  );
}
