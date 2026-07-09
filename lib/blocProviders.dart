import 'package:app_aryoria/injection.dart';
import 'package:app_aryoria/src/config/core/session/session_bloc.dart';
import 'package:app_aryoria/src/domain/use_cases/empresa/EmpresaUseCases.dart';
import 'package:app_aryoria/src/domain/use_cases/movimiento/MovimientoUsesCases.dart';
import 'package:app_aryoria/src/presentation/screens/auth/register/bloc/register_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_bloc.dart';
import 'package:app_aryoria/src/presentation/screens/movimiento/bloc/movimiento_bloc.dart';
// import 'package:app_aryoria/src/presentation/screens/empresa/bloc/empresa_event.dart';
// import 'package:app_aryoria/src/presentation/screens/auth/register/bloc/register_event.dart';
import 'package:app_aryoria/src/presentation/shared/screens/loading/bloc/loading_bloc.dart';
import 'package:app_aryoria/src/presentation/shared/screens/splah/bloc/splash_bloc.dart';
import 'package:app_aryoria/src/presentation/shared/screens/splah/bloc/splash_event.dart';
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
  // LOADING
  // ======================================================
  BlocProvider<LoadingBloc>(
    create: (BuildContext context) =>
        LoadingBloc(locator<AuthUsesCases>()), //..add(const LoadingStarted()),
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
  // MOVIMIENTOS
  // ======================================================
  BlocProvider<MovimientoBloc>(
    create: (BuildContext context) =>
        MovimientoBloc(locator<MovimientoUsesCases>()),
  ),
];
