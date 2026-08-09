import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Theme
import 'package:app_aryoria/src/config/theme/app_theme.dart';

// Bloc
import 'package:app_aryoria/src/presentation/shared/screens/theme/bloc/theme_bloc.dart';
import 'package:app_aryoria/src/presentation/shared/screens/theme/bloc/theme_event.dart';
import 'package:app_aryoria/src/presentation/shared/screens/theme/bloc/theme_state.dart';

class ThemeChangerPage extends StatelessWidget {
  const ThemeChangerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final colors = Theme.of(context).colorScheme;

        return ColoredBox(
          color: colors.surfaceContainerLowest,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // HEADER
                  // ==================================================
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.palette_outlined,
                          color: colors.onPrimaryContainer,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Apariencia',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              'Personaliza el color y la apariencia de Aryoria.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: colors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // MODO OSCURO
                  // ==================================================
                  Text(
                    'Tema',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    elevation: 0,
                    color: colors.surfaceContainerLow,
                    child: SwitchListTile(
                      value: state.isDarkMode,

                      secondary: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          state.isDarkMode
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                          color: colors.onPrimaryContainer,
                        ),
                      ),

                      title: Text(
                        state.isDarkMode ? 'Modo oscuro' : 'Modo claro',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),

                      subtitle: Text(
                        state.isDarkMode
                            ? 'Reduce el brillo de la interfaz.'
                            : 'Utiliza una apariencia clara.',
                      ),

                      onChanged: (_) {
                        context.read<ThemeBloc>().add(
                          const ToggleDarkModeEvent(),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // COLOR PRINCIPAL
                  // ==================================================
                  Text(
                    'Color principal',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Selecciona el color que utilizará Aryoria en botones, encabezados y elementos destacados.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ==================================================
                  // SELECTOR DE COLORES
                  // ==================================================
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;

                      final crossAxisCount = width >= 900
                          ? 4
                          : width >= 600
                          ? 3
                          : 2;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),

                        itemCount: colorList.length,

                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.1,
                        ),

                        itemBuilder: (context, index) {
                          final color = colorList[index];

                          final selected = state.selectedColor == index;

                          return _ColorOption(
                            color: color,
                            label: _getColorName(index),
                            selected: selected,
                            onTap: () {
                              context.read<ThemeBloc>().add(
                                ChangeThemeColorEvent(index),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // PREVISUALIZACIÓN
                  // ==================================================
                  Text(
                    'Vista previa',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Card(
                    elevation: 0,
                    color: colors.surfaceContainerLow,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: colors.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.account_balance_wallet_outlined,
                                  color: colors.onPrimaryContainer,
                                ),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Flujo Contable',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 3),

                                    Text(
                                      'Analiza tus ingresos y egresos.',
                                      style: TextStyle(
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {},
                              child: const Text('Botón de ejemplo'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getColorName(int index) {
    switch (index) {
      case 0:
        return 'Azul';

      case 1:
        return 'Turquesa';

      case 2:
        return 'Verde';

      case 3:
        return 'Morado';

      case 4:
        return 'Morado intenso';

      case 5:
        return 'Naranja';

      case 6:
        return 'Rosa';

      case 7:
        return 'Rosa intenso';

      default:
        return 'Color';
    }
  }
}

class _ColorOption extends StatelessWidget {
  final Color color;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: selected
          ? color.withValues(alpha: 0.12)
          : colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),

      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,

        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),

            border: Border.all(
              color: selected ? color : colors.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),

          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),

              if (selected) Icon(Icons.check_circle, color: color, size: 21),
            ],
          ),
        ),
      ),
    );
  }
}
