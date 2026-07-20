import 'package:app_aryoria/injection.dart';
import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/domain/use_cases/categoria/CategoriaUsesCases.dart';
import 'package:app_aryoria/src/domain/use_cases/empresa/EmpresaUseCases.dart';
import 'package:app_aryoria/src/domain/use_cases/index_uses_cases.dart';
import 'package:app_aryoria/src/domain/use_cases/movimiento/MovimientoUsesCases.dart';
import 'package:app_aryoria/src/presentation/screens/auth/register/bloc/register_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/categorias/bloc/categoria_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/periodo_contable/bloc/periodo_contable_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/reportes/bloc/reporte_bloc.dart';
// import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_event.dart';
// import 'package:app_aryoria/src/presentation/screens/auth/register/bloc/register_event.dart';
import 'package:app_aryoria/src/presentation/shared/screens/loading/bloc/loading_bloc.dart';
import 'package:app_aryoria/src/presentation/shared/screens/logout/bloc/logout_bloc.dart';
import 'package:app_aryoria/src/presentation/shared/screens/splash/bloc/splash_bloc.dart';
import 'package:app_aryoria/src/presentation/shared/screens/splash/bloc/splash_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_aryoria/src/domain/use_cases/auth/AuthUseCases.dart';
import 'package:app_aryoria/src/presentation/screens/auth/login/bloc/login_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/auth/login/bloc/login_event.dart';

List<BlocProvider> blocProviders = [
  // ======================================================
  // AUTH
  // ======================================================
  BlocProvider<LoginBloc>(
    create: (BuildContext context) =>
        LoginBloc(locator<AuthUsesCases>())..add(InitEvent()),
  ),

  BlocProvider<RegisterBloc>(
    create: (BuildContext context) =>
        RegisterBloc(locator<AuthUsesCases>()), //..add(RegisterEvent()),
  ),

  // ======================================================
  // SPLASH
  // ======================================================
  BlocProvider<SplashBloc>(
    create: (BuildContext context) =>
        SplashBloc(locator<AuthUsesCases>())..add(const SplashStarted()),
  ),

  // ======================================================
  // LOADING Y LOGOUT
  // ======================================================
  BlocProvider<LoadingBloc>(
    create: (BuildContext context) =>
        LoadingBloc(locator<AuthUsesCases>()), //..add(const LoadingStarted()),
  ),

  BlocProvider<LogoutBloc>(
    create: (BuildContext context) => LogoutBloc(locator<AuthUsesCases>()),
  ),

  // ======================================================
  // SESSION
  // ======================================================
  BlocProvider<SessionBloc>(
    create: (BuildContext context) =>
        SessionBloc(), //..add(const LoadingStarted()),
  ),

  // ======================================================
  // EMPRESA
  // ======================================================
  BlocProvider<EmpresaBloc>(
    create: (BuildContext context) => EmpresaBloc(
      locator<EmpresaUseCases>(),
    ), //..add(const GetEmpresasEvent(page: 1, limit: 5, search: '')),
  ),

  // ======================================================
  // CATEGORIAS
  // ======================================================
  BlocProvider<CategoriaBloc>(
    create: (BuildContext context) =>
        CategoriaBloc(locator<CategoriaUsesCases>()),
  ),

  // ======================================================
  // PERIODO CONTABLE
  // ======================================================
  BlocProvider<PeriodoContableBloc>(
    create: (BuildContext context) =>
        PeriodoContableBloc(locator<PeriodoContableUsesCases>()),
  ),

  // ======================================================
  // MOVIMIENTOS
  // ======================================================
  BlocProvider<MovimientoBloc>(
    create: (BuildContext context) =>
        MovimientoBloc(locator<MovimientoUsesCases>()),
  ),

  // ======================================================
  // REPORTES
  // ======================================================
  BlocProvider<ReporteBloc>(
    create: (BuildContext context) => ReporteBloc(locator<ReporteUsesCases>()),
  ),
];
