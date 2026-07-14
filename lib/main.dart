import 'package:app_aryoria/blocProviders.dart';
import 'package:app_aryoria/injection.dart';
import 'package:app_aryoria/src/config/core/auth_listener.dart';
import 'package:app_aryoria/src/config/router/app_router.dart';
import 'package:app_aryoria/src/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders,
      child: AuthListener(
        child: MaterialApp.router(
          builder: FToastBuilder(),
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
          title: 'Sistema Aryoria Demo',
          theme: AppTheme(selectedColor: 4).getTheme(),
        ),
      ),
    );
  }
}
