abstract class ThemeEvent {
  const ThemeEvent();
}

class ChangeThemeColorEvent extends ThemeEvent {
  final int colorIndex;

  const ChangeThemeColorEvent(this.colorIndex);
}

class ToggleDarkModeEvent extends ThemeEvent {
  const ToggleDarkModeEvent();
}
