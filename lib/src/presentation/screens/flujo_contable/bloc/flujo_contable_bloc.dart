import 'package:flutter_bloc/flutter_bloc.dart';

// Use Cases
import 'package:app_aryoria/src/domain/use_cases/index_uses_cases.dart';

// Resource
import 'package:app_aryoria/src/domain/utils/Resource.dart';

// Models
import 'package:app_aryoria/src/data/models/common/api_response.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_anual.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_contable_mensual.dart';
import 'package:app_aryoria/src/data/models/flujo_contable/flujo_proyectado.dart';

// Bloc
import 'flujo_contable_event.dart';
import 'flujo_contable_state.dart';

class FlujoContableBloc extends Bloc<FlujoContableEvent, FlujoContableState> {
  final FlujoContableUsesCases flujoContableUsesCases;

  FlujoContableBloc(this.flujoContableUsesCases)
    : super(const FlujoContableState()) {
    on<GetFlujoContableMensualEvent>(_onGetFlujoContableMensual);

    on<GetFlujoContableAnualEvent>(_onGetFlujoContableAnual);

    on<GetFlujoProyectadoEvent>(_onGetFlujoProyectado);

    on<RefreshFlujoContableEvent>(_onRefreshFlujoContable);

    on<ClearFlujoContableErrorEvent>(_onClearError);
  }

  // ***************************************************************************
  // 1.- Obtener Flujo Contable Mensual
  // ***************************************************************************F
  Future<void> _onGetFlujoContableMensual(
    GetFlujoContableMensualEvent event,
    Emitter<FlujoContableState> emit,
  ) async {
    emit(
      state.copyWith(
        flujoMensualResponse: Loading<ApiResponse<FlujoContableMensualData>>(),
        clearError: true,
      ),
    );

    final response = await flujoContableUsesCases.getFlujoContableMensual.run(
      idPeriodo: event.idPeriodo,
      idEmpresa: event.idEmpresa,
    );

    emit(
      state.copyWith(
        flujoMensualResponse: response,
        errorMessage:
            response is ErrorData<ApiResponse<FlujoContableMensualData>>
            ? response.error
            : null,
      ),
    );
  }

  // ***************************************************************************
  // 2.- Obtener Flujo Contable Anual
  // ***************************************************************************
  Future<void> _onGetFlujoContableAnual(
    GetFlujoContableAnualEvent event,
    Emitter<FlujoContableState> emit,
  ) async {
    emit(
      state.copyWith(
        flujoAnualResponse: Loading<ApiResponse<FlujoAnualData>>(),
        clearError: true,
      ),
    );

    final response = await flujoContableUsesCases.getFlujoContableAnual.run(
      idEmpresa: event.idEmpresa,
      anio: event.anio,
    );

    emit(
      state.copyWith(
        flujoAnualResponse: response,
        errorMessage: response is ErrorData<ApiResponse<FlujoAnualData>>
            ? response.error
            : null,
      ),
    );
  }

  // ***************************************************************************
  // 3.- Obtener Flujo Proyectado
  // ***************************************************************************
  Future<void> _onGetFlujoProyectado(
    GetFlujoProyectadoEvent event,
    Emitter<FlujoContableState> emit,
  ) async {
    emit(
      state.copyWith(
        flujoProyectadoResponse: Loading<ApiResponse<FlujoProyectadoData>>(),
        clearError: true,
      ),
    );

    final response = await flujoContableUsesCases.getFlujoProyectado.run(
      idPeriodo: event.idPeriodo,
      idEmpresa: event.idEmpresa,
    );

    emit(
      state.copyWith(
        flujoProyectadoResponse: response,
        errorMessage: response is ErrorData<ApiResponse<FlujoProyectadoData>>
            ? response.error
            : null,
      ),
    );
  }

  // ============================================================
  // 4.- Refrescar Flujo Contable
  // ============================================================
  Future<void> _onRefreshFlujoContable(
    RefreshFlujoContableEvent event,
    Emitter<FlujoContableState> emit,
  ) async {
    emit(
      state.copyWith(
        flujoMensualResponse: Loading<ApiResponse<FlujoContableMensualData>>(),
        flujoAnualResponse: Loading<ApiResponse<FlujoAnualData>>(),
        flujoProyectadoResponse: Loading<ApiResponse<FlujoProyectadoData>>(),
        clearError: true,
      ),
    );

    final results = await Future.wait([
      flujoContableUsesCases.getFlujoContableMensual.run(
        idPeriodo: event.idPeriodo,
        idEmpresa: event.idEmpresa,
      ),

      flujoContableUsesCases.getFlujoContableAnual.run(
        idEmpresa: event.idEmpresa,
        anio: event.anio,
      ),

      flujoContableUsesCases.getFlujoProyectado.run(
        idPeriodo: event.idPeriodo,
        idEmpresa: event.idEmpresa,
      ),
    ]);

    final mensual =
        results[0] as Resource<ApiResponse<FlujoContableMensualData>>;

    final anual = results[1] as Resource<ApiResponse<FlujoAnualData>>;

    final proyectado = results[2] as Resource<ApiResponse<FlujoProyectadoData>>;

    emit(
      state.copyWith(
        flujoMensualResponse: mensual,
        flujoAnualResponse: anual,
        flujoProyectadoResponse: proyectado,
      ),
    );
  }

  // ============================================================
  // 5.- Limpiar Error
  // ============================================================

  void _onClearError(
    ClearFlujoContableErrorEvent event,
    Emitter<FlujoContableState> emit,
  ) {
    emit(state.copyWith(clearError: true));
  }
}
