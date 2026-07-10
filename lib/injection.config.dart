// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app_aryoria/src/data/datasources/local/sharefPref.dart'
    as _i969;
import 'package:app_aryoria/src/data/datasources/remote/services/auth_service.dart'
    as _i995;
import 'package:app_aryoria/src/data/datasources/remote/services/categoria_service.dart'
    as _i462;
import 'package:app_aryoria/src/data/datasources/remote/services/empresa_service.dart'
    as _i335;
import 'package:app_aryoria/src/data/datasources/remote/services/movimiento_service.dart'
    as _i1020;
import 'package:app_aryoria/src/di/AppModule.dart' as _i847;
import 'package:app_aryoria/src/domain/repositories/auth_repository.dart'
    as _i797;
import 'package:app_aryoria/src/domain/repositories/categoria_repostory.dart'
    as _i972;
import 'package:app_aryoria/src/domain/repositories/empresa_repository.dart'
    as _i798;
import 'package:app_aryoria/src/domain/repositories/movimiento_repository.dart'
    as _i1054;
import 'package:app_aryoria/src/domain/use_cases/auth/AuthUseCases.dart'
    as _i1037;
import 'package:app_aryoria/src/domain/use_cases/categoria/CategoriaUsesCases.dart'
    as _i777;
import 'package:app_aryoria/src/domain/use_cases/empresa/EmpresaUseCases.dart'
    as _i1048;
import 'package:app_aryoria/src/domain/use_cases/movimiento/MovimientoUsesCases.dart'
    as _i683;
import 'package:app_aryoria/src/presentation/shared/screens/loading/bloc/loading_bloc.dart'
    as _i43;
import 'package:app_aryoria/src/presentation/shared/screens/splash/bloc/splash_bloc.dart'
    as _i653;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i969.SharefPref>(() => appModule.sharedPref);
    gh.factory<_i995.AuthService>(() => appModule.authService);
    gh.factory<_i335.EmpresaService>(() => appModule.empresaService);
    gh.factory<_i1020.MovimientoService>(() => appModule.movimientoService);
    gh.factory<_i462.CategoriaService>(() => appModule.catgoriaService);
    gh.factory<_i797.AuthRepository>(() => appModule.authRepository);
    gh.factory<_i798.EmpresaRepository>(() => appModule.empresaRepository);
    gh.factory<_i1054.MovimientoRepository>(
      () => appModule.movimientoRepository,
    );
    gh.factory<_i972.CategoriaRepository>(() => appModule.categoriaRepository);
    gh.factory<_i1037.AuthUsesCases>(() => appModule.authUsesCases);
    gh.factory<_i1048.EmpresaUseCases>(() => appModule.empresaUseCases);
    gh.factory<_i683.MovimientoUsesCases>(() => appModule.movimientoUseCases);
    gh.factory<_i777.CategoriaUsesCases>(() => appModule.categoriaUseCases);
    gh.factory<_i43.LoadingBloc>(
      () => _i43.LoadingBloc(gh<_i1037.AuthUsesCases>()),
    );
    gh.factory<_i653.SplashBloc>(
      () => _i653.SplashBloc(gh<_i1037.AuthUsesCases>()),
    );
    return this;
  }
}

class _$AppModule extends _i847.AppModule {}
