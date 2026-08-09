import 'package:flutter/material.dart';

class AppContextUnavailable extends StatelessWidget {
  final IconData icon;

  final String title;
  final String message;

  final String? buttonText;
  final IconData? buttonIcon;
  final VoidCallback? onPressed;

  final EdgeInsetsGeometry padding;

  const AppContextUnavailable({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.buttonIcon,
    this.onPressed,
    this.padding = const EdgeInsets.all(35),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final bool hasAction =
        buttonText != null &&
        buttonText!.trim().isNotEmpty &&
        onPressed != null;

    return Center(
      child: SingleChildScrollView(
        padding: padding,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ==================================================
              // ICONO
              // ==================================================
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 48, color: colors.primary),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // TÍTULO
              // ==================================================
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              // ==================================================
              // MENSAJE
              // ==================================================
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: colors.onSurfaceVariant,
                ),
              ),

              // ==================================================
              // ACCIÓN
              // ==================================================
              if (hasAction) ...[
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onPressed,
                    icon: Icon(buttonIcon ?? Icons.arrow_forward_rounded),
                    label: Text(buttonText!),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
