import 'package:flutter/material.dart';

class CategoriaEmptyState extends StatelessWidget {
  final String search;
  final Future<void> Function() onRefresh;

  const CategoriaEmptyState({
    super.key,
    required this.search,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final hasSearch = search.trim().isNotEmpty;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 130),

          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.category_outlined,
              size: 48,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            hasSearch
                ? 'No se encontraron categorías'
                : 'No hay categorías registradas',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),

          if (hasSearch) ...[
            const SizedBox(height: 8),
            Text(
              'No existen resultados para “${search.trim()}”.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }
}
