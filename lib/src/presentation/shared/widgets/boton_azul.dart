import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const BotonAzul({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: FilledButton(
        onPressed: onPressed,

        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,

          disabledBackgroundColor: colors.onSurface.withValues(alpha: 0.12),

          disabledForegroundColor: colors.onSurface.withValues(alpha: 0.38),

          elevation: 2,

          shape: const StadiumBorder(),

          textStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20),

                  const SizedBox(width: 8),

                  Text(text),
                ],
              )
            : Text(text),
      ),
    );
  }
}
// import 'package:flutter/material.dart';

// class BotonAzul extends StatelessWidget {
//   final String text;
//   final VoidCallback? onPressed;

//   const BotonAzul({super.key, required this.text, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         elevation: 2,
//         backgroundColor: Colors.blue,
   
//         shape: const StadiumBorder(),
//         minimumSize: const Size(double.infinity, 55), // reemplaza el Container
//       ),
//       onPressed: onPressed,
//       child: Text(text, style: TextStyle(color: Colors.white, fontSize: 17)),
//     );
//   }
// }
