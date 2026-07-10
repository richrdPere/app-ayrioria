import 'package:flutter/material.dart';

class CategoriaSummary extends StatelessWidget {
  final int total;
  final bool isSearching;
  final String search;

  const CategoriaSummary({
    super.key,
    required this.total,
    required this.isSearching,
    required this.search,
  });

  @override
  Widget build(BuildContext context) {
    final text = total == 1 ? '1 categoría' : '$total categorías';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.withOpacity(0.12)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.category_outlined,
                  size: 17,
                  color: Colors.blue,
                ),
                const SizedBox(width: 6),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          if (isSearching) ...[
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Resultados para “${search.trim()}”',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
