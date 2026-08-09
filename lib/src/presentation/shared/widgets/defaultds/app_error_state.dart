import 'package:flutter/material.dart';

class AppErrorState extends StatelessWidget {
  final String title;
  final String message;

  final VoidCallback? onRetry;

  final String retryLabel;

  final IconData icon;

  final EdgeInsetsGeometry padding;

  const AppErrorState({
    super.key,
    this.title = 'No fue posible cargar la información',
    required this.message,
    this.onRetry,
    this.retryLabel = 'Reintentar',
    this.icon = Icons.error_outline,
    this.padding = const EdgeInsets.all(30),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: padding,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: colors.errorContainer.withValues(alpha: 0.65),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 42, color: colors.error),
              ),

              const SizedBox(height: 20),

              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.45,
                  color: colors.onSurfaceVariant,
                ),
              ),

              if (onRetry != null) ...[
                const SizedBox(height: 24),

                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(retryLabel),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
