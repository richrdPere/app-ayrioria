import 'package:app_aryoria/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';


final locator = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => locator.init();