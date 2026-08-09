import 'package:flutter/material.dart';

class AppSearchFilterOption<T> {
  final T? value;
  final String label;

  const AppSearchFilterOption({required this.value, required this.label});
}

class AppSearchFilterBar<T> extends StatefulWidget {
  final TextEditingController controller;

  final String hintText;

  final ValueChanged<String> onSearch;
  final ValueChanged<T?> onFilterChanged;

  final T? selectedFilter;

  final List<AppSearchFilterOption<T>> filterOptions;

  final String filterTooltip;

  final EdgeInsetsGeometry padding;

  const AppSearchFilterBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSearch,
    required this.onFilterChanged,
    required this.filterOptions,
    this.selectedFilter,
    this.filterTooltip = 'Filtrar',
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 12),
  });

  @override
  State<AppSearchFilterBar<T>> createState() => _AppSearchFilterBarState<T>();
}

class _AppSearchFilterBarState<T> extends State<AppSearchFilterBar<T>> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final bool hasFilter = widget.selectedFilter != null;

    return Padding(
      padding: widget.padding,
      child: Row(
        children: [
          // ==================================================
          // SEARCH
          // ==================================================
          Expanded(
            child: TextField(
              controller: widget.controller,
              textInputAction: TextInputAction.search,
              onSubmitted: widget.onSearch,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: widget.hintText,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: widget.controller.text.trim().isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpiar',
                        onPressed: () {
                          widget.controller.clear();

                          setState(() {});

                          widget.onSearch('');
                        },
                        icon: const Icon(Icons.close),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: colors.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: colors.primary, width: 1.5),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // ==================================================
          // FILTRO
          // ==================================================
          PopupMenuButton<T?>(
            tooltip: widget.filterTooltip,
            initialValue: widget.selectedFilter,
            onSelected: widget.onFilterChanged,
            itemBuilder: (context) {
              return widget.filterOptions.map((option) {
                return PopupMenuItem<T?>(
                  value: option.value,
                  child: Text(option.label),
                );
              }).toList();
            },
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                border: Border.all(
                  color: hasFilter ? colors.primary : colors.outlineVariant,
                ),
                borderRadius: BorderRadius.circular(15),
                color: hasFilter
                    ? colors.primaryContainer.withValues(alpha: 0.45)
                    : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.filter_list_rounded,
                    color: hasFilter ? colors.primary : colors.onSurfaceVariant,
                  ),

                  if (hasFilter)
                    Positioned(
                      right: 9,
                      top: 9,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
