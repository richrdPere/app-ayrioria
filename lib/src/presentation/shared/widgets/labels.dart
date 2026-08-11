import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String titulo;
  final String subTitulo;

  const Labels({
    super.key,
    required this.ruta,
    required this.titulo,
    required this.subTitulo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
        ),

        const SizedBox(height: 10),

        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            context.goNamed(ruta);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              subTitulo,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colors.primary,
                // color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
