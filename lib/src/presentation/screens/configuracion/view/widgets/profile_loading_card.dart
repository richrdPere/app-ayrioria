import 'package:flutter/material.dart';

class ProfileLoadingCard extends StatelessWidget {
  final bool isLoading;

  const ProfileLoadingCard({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: colors.primaryContainer,
            child: Icon(
              Icons.person_outline_rounded,
              color: colors.onPrimaryContainer,
              size: 32,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              isLoading ? 'Cargando perfil...' : 'Perfil no disponible',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),

          if (isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }
}
