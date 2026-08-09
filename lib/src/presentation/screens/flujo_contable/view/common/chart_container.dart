import 'package:flutter/material.dart';

class ChartContainer extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final Widget child;

  const ChartContainer({
    super.key,
    required this.titulo,
    this.subtitulo,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            if (subtitulo != null) ...[
              const SizedBox(height: 4),
              Text(subtitulo!, style: Theme.of(context).textTheme.bodySmall),
            ],

            const SizedBox(height: 24),

            child,
          ],
        ),
      ),
    );
  }
}
