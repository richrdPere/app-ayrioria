import 'package:app_aryoria/blocProviders.dart';
import 'package:app_aryoria/injection.dart';

import 'package:app_aryoria/src/config/core/auth_listener.dart';
import 'package:app_aryoria/src/config/router/app_router.dart';
import 'package:app_aryoria/src/config/theme/app_theme.dart';

// Theme Bloc
import 'package:app_aryoria/src/presentation/shared/screens/theme/bloc/theme_bloc.dart';
import 'package:app_aryoria/src/presentation/shared/screens/theme/bloc/theme_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_PE', null);
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders,

      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          final appTheme = AppTheme(selectedColor: themeState.selectedColor);

          return AuthListener(
            child: MaterialApp.router(
              builder: FToastBuilder(),
              routerConfig: appRouter,
              debugShowCheckedModeBanner: false,
              title: 'Sistema Aryoria',

              // LIGHT THEME
              theme: appTheme.getLightTheme(),

              // DARK THEME
              darkTheme: appTheme.getDarkTheme(),

              // MODO ACTUAL
              themeMode: themeState.isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,
            ),
          );
        },
      ),
    );
  }
}
