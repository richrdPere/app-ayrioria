import 'package:flutter/material.dart';

class AppEmptyState extends StatelessWidget {
  final bool hasFilters;

  final IconData emptyIcon;
  final IconData filteredIcon;

  final String emptyTitle;
  final String filteredTitle;

  final String emptyMessage;
  final String filteredMessage;

  final String createLabel;
  final String clearFiltersLabel;

  final VoidCallback? onCreate;
  final VoidCallback? onClearFilters;

  final EdgeInsetsGeometry padding;

  const AppEmptyState({
    super.key,
    required this.hasFilters,
    required this.emptyIcon,
    this.filteredIcon = Icons.search_off_outlined,
    required this.emptyTitle,
    this.filteredTitle = 'No se encontraron resultados',
    required this.emptyMessage,
    this.filteredMessage =
        'Prueba modificando los criterios de búsqueda o filtros.',
    this.createLabel = 'Crear',
    this.clearFiltersLabel = 'Limpiar filtros',
    this.onCreate,
    this.onClearFilters,
    this.padding = const EdgeInsets.all(30),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final IconData icon = hasFilters ? filteredIcon : emptyIcon;

    final String title = hasFilters ? filteredTitle : emptyTitle;

    final String message = hasFilters ? filteredMessage : emptyMessage;

    return Center(
      child: SingleChildScrollView(
        padding: padding,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ==================================================
              // ICONO
              // ==================================================
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: colors.primaryContainer.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 42, color: colors.primary),
              ),

              const SizedBox(height: 22),

              // ==================================================
              // TÍTULO
              // ==================================================
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              // ==================================================
              // MENSAJE
              // ==================================================
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.45,
                  color: colors.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // ACCIÓN
              // ==================================================
              if (hasFilters && onClearFilters != null)
                OutlinedButton.icon(
                  onPressed: onClearFilters,
                  icon: const Icon(Icons.filter_alt_off_outlined),
                  label: Text(clearFiltersLabel),
                )
              else if (!hasFilters && onCreate != null)
                FilledButton.icon(
                  onPressed: onCreate,
                  icon: const Icon(Icons.add),
                  label: Text(createLabel),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
