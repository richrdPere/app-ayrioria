import 'package:flutter/material.dart';

class EmpresaLoading extends StatelessWidget {
  final int items;

  const EmpresaLoading({super.key, this.items = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),

      itemCount: items,

      separatorBuilder: (_, __) => const SizedBox(height: 14),

      itemBuilder: (_, __) {
        return _buildSkeletonCard();
      },
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [
          // Avatar skeleton
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(14),
            ),
          ),

          const SizedBox(width: 16),

          // Texto skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                _buildSkeletonLine(height: 16, width: double.infinity),

                const SizedBox(height: 10),

                _buildSkeletonLine(height: 12, width: 160),

                const SizedBox(height: 8),

                _buildSkeletonLine(height: 12, width: 220),
              ],
            ),
          ),

          const SizedBox(width: 10),

          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLine({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
