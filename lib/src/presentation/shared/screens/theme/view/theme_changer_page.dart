import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_aryoria/src/presentation/shared/screens/theme/bloc/theme_bloc.dart';
import 'package:app_aryoria/src/presentation/shared/screens/theme/bloc/theme_event.dart';
import 'package:app_aryoria/src/presentation/shared/screens/theme/bloc/theme_state.dart';

import 'theme_changer_content.dart';

class ThemeChangerPage extends StatelessWidget {
  const ThemeChangerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return ThemeChangerContent(
          state: state,

          onToggleDarkMode: () {
            context.read<ThemeBloc>().add(const ToggleDarkModeEvent());
          },

          onColorSelected: (index) {
            context.read<ThemeBloc>().add(ChangeThemeColorEvent(index));
          },
        );
      },
    );
  }
}
