abstract class ThemeEvent {
  const ThemeEvent();
}

// =========================================================
// CARGAR TEMA GUARDADO
// =========================================================

class LoadThemeEvent extends ThemeEvent {
  const LoadThemeEvent();
}

// =========================================================
// CAMBIAR COLOR
// =========================================================

class ChangeThemeColorEvent extends ThemeEvent {
  final int colorIndex;

  const ChangeThemeColorEvent(this.colorIndex);
}

// =========================================================
// MODO OSCURO / CLARO
// =========================================================

class ToggleDarkModeEvent extends ThemeEvent {
  const ToggleDarkModeEvent();
}
