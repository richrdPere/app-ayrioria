import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_anual.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_mensual.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_proyectado.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';
import 'package:equatable/equatable.dart';

class FlujoContableState extends Equatable {
  // 1.- Flujo mensual
  final Resource<ApiResponse<FlujoContableMensualData>>? flujoMensualResponse;

  // 2.- Flujo anual
  final Resource<ApiResponse<FlujoAnualData>>? flujoAnualResponse;

  // 3.- Flujo proyectado
  final Resource<ApiResponse<FlujoProyectadoData>>? flujoProyectadoResponse;

  // Error general opcional
  final String? errorMessage;

  const FlujoContableState({
    this.flujoMensualResponse,
    this.flujoAnualResponse,
    this.flujoProyectadoResponse,
    this.errorMessage,
  });

  FlujoContableState copyWith({
    Resource<ApiResponse<FlujoContableMensualData>>? flujoMensualResponse,
    Resource<ApiResponse<FlujoAnualData>>? flujoAnualResponse,
    Resource<ApiResponse<FlujoProyectadoData>>? flujoProyectadoResponse,

    String? errorMessage,
    bool clearError = false,
  }) {
    return FlujoContableState(
      flujoMensualResponse: flujoMensualResponse ?? this.flujoMensualResponse,
      flujoAnualResponse: flujoAnualResponse ?? this.flujoAnualResponse,
      flujoProyectadoResponse:
          flujoProyectadoResponse ?? this.flujoProyectadoResponse,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    flujoMensualResponse,
    flujoAnualResponse,
    flujoProyectadoResponse,
    errorMessage,
  ];
}
