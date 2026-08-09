import 'package:flutter/material.dart';

class AppPaginatedList<T> extends StatelessWidget {
  final List<T> items;

  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  final int page;
  final int totalPages;
  final int totalItems;

  final bool isLoading;
  final bool isLoadingMore;

  final Future<void> Function()? onRefresh;

  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;

  final ScrollController? scrollController;

  final EdgeInsetsGeometry padding;

  final double separatorHeight;

  final Widget? emptyWidget;

  const AppPaginatedList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.page,
    required this.totalPages,
    required this.totalItems,
    required this.isLoading,
    required this.isLoadingMore,
    this.onRefresh,
    this.onPreviousPage,
    this.onNextPage,
    this.scrollController,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 120),
    this.separatorHeight = 12,
    this.emptyWidget,
  });

  @override
  Widget build(BuildContext context) {
    // ==========================================================
    // LOADING
    // ==========================================================
    if (isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // ==========================================================
    // EMPTY
    // ==========================================================
    if (items.isEmpty) {
      return emptyWidget ??
          const Center(child: Text('No hay registros disponibles.'));
    }

    // ==========================================================
    // LISTADO + PAGINACIÓN
    // ==========================================================
    final list = ListView.separated(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: padding,
      itemCount: items.length + 1,
      separatorBuilder: (_, __) => SizedBox(height: separatorHeight),
      itemBuilder: (context, index) {
        if (index < items.length) {
          return itemBuilder(context, items[index], index);
        }

        return _PaginationFooter(
          page: page,
          totalPages: totalPages,
          totalItems: totalItems,
          isLoading: isLoadingMore,
          onPreviousPage: onPreviousPage,
          onNextPage: onNextPage,
        );
      },
    );

    if (onRefresh == null) {
      return list;
    }

    return RefreshIndicator(onRefresh: onRefresh!, child: list);
  }
}

class _PaginationFooter extends StatelessWidget {
  final int page;
  final int totalPages;
  final int totalItems;

  final bool isLoading;

  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;

  const _PaginationFooter({
    required this.page,
    required this.totalPages,
    required this.totalItems,
    required this.isLoading,
    this.onPreviousPage,
    this.onNextPage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bool canGoBack = page > 1;
    final bool canGoNext = totalPages > 0 && page < totalPages;

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: !isLoading && canGoBack ? onPreviousPage : null,
                  icon: const Icon(Icons.chevron_left),
                  label: const Text('Anterior'),
                ),
              ),

              const SizedBox(width: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        totalPages == 0 ? '0 / 0' : '$page / $totalPages',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: FilledButton.icon(
                  onPressed: !isLoading && canGoNext ? onNextPage : null,
                  icon: const Icon(Icons.chevron_right),
                  label: const Text('Siguiente'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            '$totalItems registro'
            '${totalItems == 1 ? '' : 's'} en total',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
