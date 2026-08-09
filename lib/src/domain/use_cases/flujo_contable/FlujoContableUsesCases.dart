import 'package:app_aryoria/src/domain/use_cases/index_uses_cases.dart';


class FlujoContableUsesCases {
  GetFlujoContableAnualUC getFlujoContableAnual;
  GetFlujoContableMensualUC getFlujoContableMensual;
  GetFlujoProyectadoUC getFlujoProyectado;

  FlujoContableUsesCases({
    required this.getFlujoContableAnual,
    required this.getFlujoContableMensual,
    required this.getFlujoProyectado,
  });
}
