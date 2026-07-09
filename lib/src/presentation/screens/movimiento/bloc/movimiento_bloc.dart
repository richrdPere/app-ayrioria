import 'package:app_aryoria/src/domain/use_cases/movimiento/MovimientoUsesCases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_aryoria/src/domain/utils/Resource.dart';

import 'movimiento_event.dart';
import 'movimiento_state.dart';

class MovimientoBloc extends Bloc<MovimientoEvent, MovimientoState> {
  final MovimientoUsesCases movimientoUsesCases;

  MovimientoBloc(this.movimientoUsesCases) : super(const MovimientoState()) {
    on<GetMovimientosEvent>(_onGetMovimientos);
    on<RefreshMovimientosEvent>(_onRefreshMovimientos);
    on<SearchMovimientosEvent>(_onSearchMovimientos);
    on<CreateMovimientoEvent>(_onCreateMovimiento);
    on<UpdateMovimientoEvent>(_onUpdateMovimiento);
    on<DeleteMovimientoEvent>(_onDeleteMovimiento);
    on<GetMovimientoByIdEvent>(_onGetMovimientoById);
  }

  Future<void> _onGetMovimientos(
    GetMovimientosEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    final isFirstPage = event.page == 1;

    emit(
      state.copyWith(
        isLoading: isFirstPage,
        isLoadingMore: !isFirstPage,
        search: event.search,
        page: event.page,
      ),
    );

    final response = await movimientoUsesCases.getMovimientos.run(
      page: event.page,
      limit: event.limit,
      idEmpresa: event.idEmpresa,
      search: event.search,
    );

    if (response is Success) {
      final paginated = response.data;

      final newList = isFirstPage
          ? paginated.data
          : [...state.movimientos, ...paginated.data];

      emit(
        state.copyWith(
          movimientoResponse: response.data,
          movimientos: newList,
          page: paginated.page,
          limit: paginated.limit,
          total: paginated.total,
          totalPages: paginated.totalPages,
          hasMore: paginated.page < paginated.totalPages,
          isLoading: false,
          isLoadingMore: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          movimientoResponse: response,
          isLoading: false,
          isLoadingMore: false,
        ),
      );
    }
  }

  Future<void> _onRefreshMovimientos(
    RefreshMovimientosEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    add(
      GetMovimientosEvent(
        idEmpresa: event.idEmpresa,
        page: 1,
        limit: state.limit,
        search: event.search,
      ),
    );
  }

  Future<void> _onSearchMovimientos(
    SearchMovimientosEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    add(
      GetMovimientosEvent(
        idEmpresa: event.idEmpresa,
        page: 1,
        limit: state.limit,
        search: event.search,
      ),
    );
  }

  Future<void> _onCreateMovimiento(
    CreateMovimientoEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await movimientoUsesCases.createMovimiento.run(
      event.request,
    );

    emit(state.copyWith(actionResponse: response, isLoading: false));
  }

  Future<void> _onUpdateMovimiento(
    UpdateMovimientoEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await movimientoUsesCases.updateMovimiento.run(
      idMovimiento: event.idMovimiento,
      request: event.request,
    );

    emit(state.copyWith(actionResponse: response, isLoading: false));
  }

  Future<void> _onDeleteMovimiento(
    DeleteMovimientoEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await movimientoUsesCases.deleteMovimiento.run(
      event.idMovimiento,
    );

    emit(state.copyWith(actionResponse: response, isLoading: false));

    if (response is Success) {
      add(
        GetMovimientosEvent(
          idEmpresa: event.idEmpresa,
          page: 1,
          limit: state.limit,
          search: state.search,
        ),
      );
    }
  }

  Future<void> _onGetMovimientoById(
    GetMovimientoByIdEvent event,
    Emitter<MovimientoState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await movimientoUsesCases.getMovimientoById.run(
      event.idMovimiento,
    );

    emit(state.copyWith(detailResponse: response, isLoading: false));
  }
}
