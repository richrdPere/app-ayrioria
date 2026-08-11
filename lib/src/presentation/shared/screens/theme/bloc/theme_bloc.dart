import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:app_aryoria/src/data/datasources/local/preferences/app_pref.dart';

import 'theme_event.dart';
import 'theme_state.dart';

@injectable
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final AppPreferences appPreferences;

  ThemeBloc(this.appPreferences) : super(const ThemeState()) {
    on<LoadThemeEvent>(_onLoadTheme);

    on<ChangeThemeColorEvent>(_onChangeThemeColor);

    on<ToggleDarkModeEvent>(_onToggleDarkMode);
  }

  // =========================================================
  // CARGAR TEMA
  // =========================================================
  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final savedThemeMode = await appPreferences.getThemeMode();
    final savedColorIndex = await appPreferences.getColorIndex();

    emit(
      state.copyWith(
        isDarkMode: savedThemeMode == 'dark',
        selectedColor: savedColorIndex,
      ),
    );
  }

  // =========================================================
  // CAMBIAR COLOR
  // =========================================================
  Future<void> _onChangeThemeColor(
    ChangeThemeColorEvent event,
    Emitter<ThemeState> emit,
  ) async {
    emit(state.copyWith(selectedColor: event.colorIndex));

    await appPreferences.saveColorIndex(event.colorIndex);
  }

  // =========================================================
  // CAMBIAR DARK MODE
  // =========================================================
  Future<void> _onToggleDarkMode(
    ToggleDarkModeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final newDarkMode = !state.isDarkMode;

    emit(state.copyWith(isDarkMode: newDarkMode));

    await appPreferences.saveThemeMode(newDarkMode ? 'dark' : 'light');
  }
}
