import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ChangeThemeColorEvent>(_onChangeThemeColor);

    on<ToggleDarkModeEvent>(_onToggleDarkMode);
  }

  void _onChangeThemeColor(
    ChangeThemeColorEvent event,
    Emitter<ThemeState> emit,
  ) {
    emit(state.copyWith(selectedColor: event.colorIndex));
  }

  void _onToggleDarkMode(ToggleDarkModeEvent event, Emitter<ThemeState> emit) {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }
}
