import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String titulo;

  /// Ancho máximo disponible para el contenido.
  final double maxWidth;

  /// Tamaño máximo de líneas del título.
  final int titleMaxLines;

  /// Tamaño del logo circular.
  final double logoSize;

  const Logo({
    super.key,
    required this.titulo,
    this.maxWidth = 320,
    this.titleMaxLines = 2,
    this.logoSize = 180,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ==================================================
            // LOGO CIRCULAR
            // ==================================================
            Container(
              width: logoSize,
              height: logoSize,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surfaceContainerLow,
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.20),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/img/aryoria_logo.png',
                  width: logoSize,
                  height: logoSize,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ==================================================
            // TÍTULO
            // ==================================================
            Text(
              titulo,
              textAlign: TextAlign.center,
              maxLines: titleMaxLines,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w800,
                height: 1.10,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class Logo extends StatelessWidget {
//   final String titulo;

//   const Logo({super.key, required this.titulo});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         width: 170,
//         child: Column(
//           children: [
//             Image(image: AssetImage('assets/img/aryoria_logo.png')),

//             SizedBox(height: 20),

//             Text(
//               titulo,
//               style: TextStyle(
//                 fontSize: 30,
//                 // color: Colors.blue,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
