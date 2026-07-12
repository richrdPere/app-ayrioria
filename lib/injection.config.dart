// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app_aryoria/src/data/datasources/index_datasource.dart'
    as _i313;
import 'package:app_aryoria/src/data/datasources/local/sharefPref.dart'
    as _i969;
import 'package:app_aryoria/src/di/AppModule.dart' as _i847;
import 'package:app_aryoria/src/domain/repositories/index_repository.dart'
    as _i897;
import 'package:app_aryoria/src/domain/use_cases/auth/AuthUseCases.dart'
    as _i1037;
import 'package:app_aryoria/src/domain/use_cases/index_uses_cases.dart'
    as _i1052;
import 'package:app_aryoria/src/presentation/shared/screens/loading/bloc/loading_bloc.dart'
    as _i43;
import 'package:app_aryoria/src/presentation/shared/screens/splash/bloc/splash_bloc.dart'
    as _i425;
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
    gh.factory<_i313.AuthService>(() => appModule.authService);
    gh.factory<_i313.EmpresaService>(() => appModule.empresaService);
    gh.factory<_i313.MovimientoService>(() => appModule.movimientoService);
    gh.factory<_i313.CategoriaService>(() => appModule.catgoriaService);
    gh.factory<_i313.PeriodoContableService>(() => appModule.periodoCService);
    gh.factory<_i897.AuthRepository>(() => appModule.authRepository);
    gh.factory<_i897.EmpresaRepository>(() => appModule.empresaRepository);
    gh.factory<_i897.MovimientoRepository>(
      () => appModule.movimientoRepository,
    );
    gh.factory<_i897.CategoriaRepository>(() => appModule.categoriaRepository);
    gh.factory<_i897.PeriodoContableRepository>(
      () => appModule.periodoCRepository,
    );
    gh.factory<_i1052.AuthUsesCases>(() => appModule.authUsesCases);
    gh.factory<_i1052.EmpresaUseCases>(() => appModule.empresaUseCases);
    gh.factory<_i1052.MovimientoUsesCases>(() => appModule.movimientoUseCases);
    gh.factory<_i1052.CategoriaUsesCases>(() => appModule.categoriaUseCases);
    gh.factory<_i1052.PeriodoContableUsesCases>(
      () => appModule.periodoCUseCases,
    );
    gh.factory<_i43.LoadingBloc>(
      () => _i43.LoadingBloc(gh<_i1037.AuthUsesCases>()),
    );
    gh.factory<_i425.SplashBloc>(
      () => _i425.SplashBloc(gh<_i1037.AuthUsesCases>()),
    );
    return this;
  }
}

class _$AppModule extends _i847.AppModule {}
