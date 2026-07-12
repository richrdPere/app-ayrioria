import 'package:injectable/injectable.dart';
import 'package:app_aryoria/src/data/datasources/local/sharefPref.dart';

// SERVICES
import 'package:app_aryoria/src/data/datasources/index_datasource.dart';

// REPOSITORY  Y REPOSITORY IMPL
import 'package:app_aryoria/src/domain/repositories/index_repository.dart';
import 'package:app_aryoria/src/data/repositories/index_repository_impl.dart';

// USES CASES
import 'package:app_aryoria/src/domain/use_cases/index_uses_cases.dart';

@module
abstract class AppModule {
  @injectable
  SharefPref get sharedPref => SharefPref();

  // ==========================================================
  // 1. SERVICES
  // ==========================================================
  @injectable
  AuthService get authService => AuthService();

  @injectable
  EmpresaService get empresaService => EmpresaService();

  @injectable
  MovimientoService get movimientoService => MovimientoService();

  @injectable
  CategoriaService get catgoriaService => CategoriaService();

  @injectable
  PeriodoContableService get periodoCService => PeriodoContableService();

  // ==========================================================
  // 2. REPOSITORY
  // ==========================================================
  @injectable
  AuthRepository get authRepository =>
      AuthRepositoryImpl(authService, sharedPref);

  @injectable
  EmpresaRepository get empresaRepository => EmpresaRepositoryImpl(
    empresaService: empresaService,
    authRepository: authRepository,
  );

  @injectable
  MovimientoRepository get movimientoRepository => MovimientoRepositoryImpl(
    movimientoService: movimientoService,
    authRepository: authRepository,
  );

  @injectable
  CategoriaRepository get categoriaRepository => CategoriaRepositoryImpl(
    categoriaService: catgoriaService,
    authRepository: authRepository,
  );

  @injectable
  PeriodoContableRepository get periodoCRepository =>
      PeriodoContableRepositoryImpl(
        periodoService: periodoCService,
        authRepository: authRepository,
      );

  // ==========================================================
  // 3. USES CASES
  // ==========================================================
  @injectable
  AuthUsesCases get authUsesCases => AuthUsesCases(
    login: LoginUseCase(authRepository),
    register: RegisterUseCase(authRepository),
    saveUserSession: SaveUserSessionUseCase(authRepository),
    getUserSession: GetUserSessionUseCase(authRepository),
    logoutSession: LogoutUseCase(authRepository),
  );

  @injectable
  EmpresaUseCases get empresaUseCases => EmpresaUseCases(
    createEmpresa: CreateEmpresaUseCase(empresaRepository),
    deleteEmpresa: DeleteEmpresaUseCase(empresaRepository),
    getEmpresaById: GetEmpresaByIdUseCase(empresaRepository),
    getEmpresas: GetEmpresasUseCase(empresaRepository),
    updateEmpresa: UpdateEmpresaUseCase(empresaRepository),
    selectEmpresa: SelectEmpresaUseCase(empresaRepository),
  );

  @injectable
  MovimientoUsesCases get movimientoUseCases => MovimientoUsesCases(
    createMovimiento: CreateMovimientoUseCase(movimientoRepository),
    deleteMovimiento: DeleteMovimientoUseCase(movimientoRepository),
    getMovimientoById: GetMovimientoByIdUseCase(movimientoRepository),
    getMovimientos: GetMovimientosUseCase(movimientoRepository),
    updateMovimiento: UpdateMovimientoUseCase(movimientoRepository),
  );

  @injectable
  CategoriaUsesCases get categoriaUseCases => CategoriaUsesCases(
    createCategoria: CreateCategoriaUseCase(categoriaRepository),
    deleteCategoria: DeleteCategoriaUseCase(categoriaRepository),
    getCategoriaById: GetCategoriaByIdUseCase(categoriaRepository),
    getCategoriaByTipo: GetCategoriaByTipoUseCase(categoriaRepository),
    getCategorias: GetCategoriasUseCase(categoriaRepository),
    updateCategoria: UpdateCategoriaUseCase(categoriaRepository),
  );

  @injectable
  PeriodoContableUsesCases get periodoCUseCases => PeriodoContableUsesCases(
    changeEstadoPeriodoC: ChangeEstadoPeriodoCUseCase(periodoCRepository),
    createPeriodoC: CreatePeriodoCUseCase(periodoCRepository),
    deletePeriodoC: DeletePeriodoCUseCase(periodoCRepository),
    getPeriodoCById: GetPeriodoCByIdUseCase(periodoCRepository),
    getPeriodoC: GetPeriodoCUseCase(periodoCRepository),
    updatePeriodoC: UpdatePeriodoCUseCase(periodoCRepository),
  );
}
