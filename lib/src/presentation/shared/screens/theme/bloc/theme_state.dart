import 'package:equatable/equatable.dart';

class ThemeState extends Equatable {
  final int selectedColor;
  final bool isDarkMode;

  const ThemeState({this.selectedColor = 0, this.isDarkMode = false});

  ThemeState copyWith({int? selectedColor, bool? isDarkMode}) {
    return ThemeState(
      selectedColor: selectedColor ?? this.selectedColor,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  List<Object?> get props => [selectedColor, isDarkMode];
}
