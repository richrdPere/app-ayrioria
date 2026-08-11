import 'package:flutter/material.dart';

// =========================================================
// COLORES DISPONIBLES
// =========================================================
//
// IMPORTANTE:
// No cambies el orden de esta lista si ya estás guardando
// selectedColor en SharedPreferences por índice.
//
const List<Color> colorList = [
  Colors.blue, // 0 - Azul
  Colors.teal, // 1 - Turquesa
  Colors.green, // 2 - Verde
  Colors.purple, // 3 - Morado
  Colors.deepPurple, // 4 - Morado intenso
  Colors.orange, // 5 - Naranja
  Colors.pink, // 6 - Rosa
  Colors.pinkAccent, // 7 - Rosa intenso
];

class AppTheme {
  final int selectedColor;

  const AppTheme({this.selectedColor = 0})
    : assert(
        selectedColor >= 0 && selectedColor < colorList.length,
        'selectedColor fuera del rango permitido',
      );

  // =========================================================
  // SEED COLOR
  // =========================================================

  Color get seedColor => colorList[selectedColor];

  // =========================================================
  // LIGHT THEME
  // =========================================================

  ThemeData getLightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,

      brightness: Brightness.light,

      colorScheme: colorScheme,

      scaffoldBackgroundColor: colorScheme.surface,

      // =====================================================
      // APP BAR
      // =====================================================
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),

      // =====================================================
      // CARDS
      // =====================================================
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      // =====================================================
      // INPUTS
      // =====================================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,

        fillColor: colorScheme.surfaceContainerLow,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),

        prefixIconColor: colorScheme.primary,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
      ),

      // =====================================================
      // FILLED BUTTON
      // =====================================================
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,

          minimumSize: const Size(double.infinity, 52),

          shape: const StadiumBorder(),

          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // =====================================================
      // ELEVATED BUTTON
      // =====================================================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,

          minimumSize: const Size(double.infinity, 52),

          elevation: 2,

          shape: const StadiumBorder(),
        ),
      ),

      // =====================================================
      // SWITCH
      // =====================================================
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }

          return colorScheme.outline;
        }),

        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }

          return colorScheme.surfaceContainerHighest;
        }),
      ),

      // =====================================================
      // DIVIDER
      // =====================================================
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),
    );
  }

  // =========================================================
  // DARK THEME
  // =========================================================

  ThemeData getDarkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,

      brightness: Brightness.dark,

      colorScheme: colorScheme,

      scaffoldBackgroundColor: colorScheme.surface,

      // =====================================================
      // APP BAR
      // =====================================================
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),

      // =====================================================
      // CARDS
      // =====================================================
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),

      // =====================================================
      // INPUTS
      // =====================================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,

        fillColor: colorScheme.surfaceContainerLow,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),

        prefixIconColor: colorScheme.primary,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
      ),

      // =====================================================
      // FILLED BUTTON
      // =====================================================
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,

          minimumSize: const Size(double.infinity, 52),

          shape: const StadiumBorder(),

          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // =====================================================
      // ELEVATED BUTTON
      // =====================================================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,

          minimumSize: const Size(double.infinity, 52),

          elevation: 2,

          shape: const StadiumBorder(),
        ),
      ),

      // =====================================================
      // SWITCH
      // =====================================================
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }

          return colorScheme.outline;
        }),

        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }

          return colorScheme.surfaceContainerHighest;
        }),
      ),

      // =====================================================
      // DIVIDER
      // =====================================================
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),
    );
  }
}
// import 'package:flutter/material.dart';

// const colorList = <Color>[
//   Colors.blue, // 0 - Azul
//   Colors.teal, // 1 - Turquesa
//   Colors.green, // 2 - Verde
//   Colors.purple, // 3 - Morado
//   Colors.deepPurple, // 4 - Morado intenso
//   Colors.orange, // 5 - Naranja
//   Colors.pink, // 6 - Rosa
//   Colors.pinkAccent, // 7 - Rosa intenso
// ];

// class AppTheme {
//   final int selectedColor;

//   const AppTheme({this.selectedColor = 0})
//     : assert(
//         selectedColor >= 0 && selectedColor < colorList.length,
//         'selectedColor fuera del rango permitido',
//       );

//   Color get seedColor => colorList[selectedColor];

//   ThemeData getLightTheme() {
//     return ThemeData(
//       useMaterial3: true,

//       colorScheme: ColorScheme.fromSeed(
//         seedColor: seedColor,
//         brightness: Brightness.light,
//       ),
//     );
//   }

//   ThemeData getDarkTheme() {
//     return ThemeData(
//       useMaterial3: true,

//       colorScheme: ColorScheme.fromSeed(
//         seedColor: seedColor,
//         brightness: Brightness.dark,
//       ),
//     );
//   }
// }
