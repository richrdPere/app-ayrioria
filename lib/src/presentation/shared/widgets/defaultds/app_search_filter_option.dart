import 'dart:async';

import 'package:flutter/material.dart';

// ==========================================================
// OPCIÓN DE FILTRO
// ==========================================================

class AppSearchFilterOption<T> {
  final T? value;
  final String label;

  const AppSearchFilterOption({required this.value, required this.label});
}

// ==========================================================
// SEARCH + FILTER
// ==========================================================

class AppSearchFilterBar<T> extends StatefulWidget {
  final TextEditingController controller;

  final String hintText;

  final ValueChanged<String> onSearch;
  final ValueChanged<T?> onFilterChanged;

  final T? selectedFilter;

  final List<AppSearchFilterOption<T>> filterOptions;

  final String filterTooltip;

  final EdgeInsetsGeometry padding;

  final Duration debounceDuration;

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
    this.debounceDuration = const Duration(milliseconds: 450),
  });

  @override
  State<AppSearchFilterBar<T>> createState() => _AppSearchFilterBarState<T>();
}

class _AppSearchFilterBarState<T> extends State<AppSearchFilterBar<T>> {
  Timer? _debounce;

  String _lastSearch = '';

  @override
  void initState() {
    super.initState();

    _lastSearch = widget.controller.text.trim();

    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant AppSearchFilterBar<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);

      widget.controller.addListener(_onControllerChanged);

      _lastSearch = widget.controller.text.trim();
    }
  }

  // ==========================================================
  // SEARCH LISTENER
  // ==========================================================

  void _onControllerChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});

    _debounce?.cancel();

    final String value = widget.controller.text.trim();

    _debounce = Timer(widget.debounceDuration, () {
      if (!mounted) {
        return;
      }

      if (value == _lastSearch) {
        return;
      }

      _lastSearch = value;

      widget.onSearch(value);
    });
  }

  // ==========================================================
  // LIMPIAR SEARCH
  // ==========================================================

  void _clearSearch() {
    _debounce?.cancel();

    widget.controller.clear();

    _lastSearch = '';

    widget.onSearch('');
  }

  @override
  void dispose() {
    _debounce?.cancel();

    widget.controller.removeListener(_onControllerChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final bool hasFilter = widget.selectedFilter != null;

    final bool hasSearch = widget.controller.text.trim().isNotEmpty;

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

              onSubmitted: (value) {
                _debounce?.cancel();

                final search = value.trim();

                _lastSearch = search;

                widget.onSearch(search);
              },

              decoration: InputDecoration(
                hintText: widget.hintText,

                prefixIcon: const Icon(Icons.search),

                suffixIcon: !hasSearch
                    ? null
                    : IconButton(
                        tooltip: 'Limpiar búsqueda',
                        onPressed: _clearSearch,
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
          PopupMenuButton<AppSearchFilterOption<T>>(
            tooltip: widget.filterTooltip,

            // IMPORTANTE:
            // El popup ahora devuelve la opción completa.
            onSelected: (option) {
              widget.onFilterChanged(option.value);
            },

            itemBuilder: (context) {
              return widget.filterOptions.map((option) {
                final bool selected = option.value == widget.selectedFilter;

                return PopupMenuItem<AppSearchFilterOption<T>>(
                  // Nunca es null.
                  value: option,

                  child: Row(
                    children: [
                      Expanded(child: Text(option.label)),

                      if (selected)
                        Icon(
                          Icons.check_rounded,
                          size: 20,
                          color: colors.primary,
                        ),
                    ],
                  ),
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
