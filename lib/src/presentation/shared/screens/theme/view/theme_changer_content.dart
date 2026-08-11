import 'package:flutter/material.dart';

// Theme
import 'package:app_aryoria/src/config/theme/app_theme.dart';

// State
import 'package:app_aryoria/src/presentation/shared/screens/theme/bloc/theme_state.dart';

class ThemeChangerContent extends StatelessWidget {
  final ThemeState state;

  final VoidCallback onToggleDarkMode;
  final ValueChanged<int> onColorSelected;

  const ThemeChangerContent({
    super.key,
    required this.state,
    required this.onToggleDarkMode,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return ColoredBox(
      color: colors.surfaceContainerLowest,

      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================================
              // TEMA PRINCIPAL
              // ============================================================
              _SectionTitle(
                title: 'Tema principal',
                icon: state.isDarkMode
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),

              const SizedBox(height: 12),

              _ThemeModeCard(
                isDarkMode: state.isDarkMode,
                onChanged: onToggleDarkMode,
              ),

              const SizedBox(height: 28),

              // ============================================================
              // COLOR PRINCIPAL
              // ============================================================
              const _SectionTitle(
                title: 'Color principal',
                icon: Icons.color_lens_outlined,
              ),

              const SizedBox(height: 6),

              Text(
                'Selecciona el color que utilizará Aryoria en botones, '
                'encabezados y elementos destacados.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 18),

              // ============================================================
              // SELECTOR DE COLORES
              // ============================================================
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;

                  final int crossAxisCount;

                  if (width >= 900) {
                    crossAxisCount = 4;
                  } else if (width >= 600) {
                    crossAxisCount = 3;
                  } else {
                    crossAxisCount = 2;
                  }

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
                          onColorSelected(index);
                        },
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 30),

              // ============================================================
              // VISTA PREVIA
              // ============================================================
              const _SectionTitle(
                title: 'Vista previa',
                icon: Icons.visibility_outlined,
              ),

              const SizedBox(height: 12),

              const _ThemePreviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// THEME MODE CARD
// ============================================================================

class _ThemeModeCard extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onChanged;

  const _ThemeModeCard({required this.isDarkMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),

      child: SwitchListTile(
        value: isDarkMode,

        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),

        secondary: Container(
          width: 44,
          height: 44,

          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(13),
          ),

          child: Icon(
            isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            color: colors.onPrimaryContainer,
          ),
        ),

        title: Text(
          isDarkMode ? 'Modo oscuro' : 'Modo claro',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),

          child: Text(
            isDarkMode
                ? 'Reduce el brillo y utiliza tonos oscuros.'
                : 'Utiliza una apariencia clara y luminosa.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ),

        onChanged: (_) {
          onChanged();
        },
      ),
    );
  }
}

// ============================================================================
// SECTION TITLE
// ============================================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 21, color: colors.primary),

        const SizedBox(width: 8),

        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// COLOR OPTION
// ============================================================================

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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

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

                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,

                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.25),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: theme.textTheme.bodyMedium?.copyWith(
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

// ============================================================================
// THEME PREVIEW
// ============================================================================

class _ThemePreviewCard extends StatelessWidget {
  const _ThemePreviewCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
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
                    Text(
                      'Flujo Contable',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      'Analiza tus ingresos y egresos.',
                      style: theme.textTheme.bodySmall?.copyWith(
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

            child: FilledButton.icon(
              onPressed: () {},

              icon: const Icon(Icons.add_chart_outlined),

              label: const Text('Botón de ejemplo'),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// COLOR NAME
// ============================================================================

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
