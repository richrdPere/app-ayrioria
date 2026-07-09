import 'package:app_aryoria/src/data/datasources/local/sharefPref.dart';
import 'package:app_aryoria/src/data/datasources/remote/services/auth_service.dart';
import 'package:app_aryoria/src/data/datasources/remote/services/empresa_service.dart';
import 'package:app_aryoria/src/data/datasources/remote/services/movimiento_service.dart';
import 'package:app_aryoria/src/data/repositories/auth_repository_impl.dart';
import 'package:app_aryoria/src/data/repositories/empresa_repository_impl.dart';
import 'package:app_aryoria/src/data/repositories/movimiento_repository_impl.dart';
import 'package:app_aryoria/src/domain/repositories/auth_repository.dart';
import 'package:app_aryoria/src/domain/repositories/empresa_repository.dart';
import 'package:app_aryoria/src/domain/repositories/movimiento_repository.dart';
import 'package:app_aryoria/src/domain/use_cases/auth/AuthUseCases.dart';
import 'package:app_aryoria/src/domain/use_cases/auth/auth_use_cases/GetUserSessionUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/auth/auth_use_cases/LoginUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/auth/auth_use_cases/LogoutUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/auth/auth_use_cases/RegisterUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/auth/auth_use_cases/SaveUserSessionUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/empresa/EmpresaUseCases.dart';
import 'package:app_aryoria/src/domain/use_cases/empresa/empresa_use_cases/DeleteEmpresaUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/empresa/empresa_use_cases/GetEmpresaByIdUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/empresa/empresa_use_cases/GetEmpresasUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/empresa/empresa_use_cases/SelectEmpresaUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/empresa/empresa_use_cases/UpdateEmpresaUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/empresa/empresa_use_cases/createEmpresaUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/movimiento/MovimientoUsesCases.dart';
import 'package:app_aryoria/src/domain/use_cases/movimiento/movimiento_use_cases/CreateMovimientoUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/movimiento/movimiento_use_cases/DeleteMovimientoUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/movimiento/movimiento_use_cases/GetMovimientoByIdUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/movimiento/movimiento_use_cases/GetMovimientosUseCase.dart';
import 'package:app_aryoria/src/domain/use_cases/movimiento/movimiento_use_cases/UpdateMovimientoUseCase.dart';
import 'package:injectable/injectable.dart';

@module
abstract class AppModule {
  @injectable
  SharefPref get sharedPref => SharefPref();

  // SERVICES
  @injectable
  AuthService get authService => AuthService();

  @injectable
  EmpresaService get empresaService => EmpresaService();

  @injectable
  MovimientoService get movimientoService => MovimientoService();

  // REPOSITORY
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

  // USES CASES
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
}
