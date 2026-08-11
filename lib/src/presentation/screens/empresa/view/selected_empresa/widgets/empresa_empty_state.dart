import 'package:flutter/material.dart';

class EmpresaEmptyState extends StatelessWidget {
  final VoidCallback? onCreate;

  const EmpresaEmptyState({super.key, this.onCreate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ==================================================
            // ICONO
            // ==================================================
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.business_outlined,
                size: 60,
                color: colors.onPrimaryContainer,
              ),
            ),

            const SizedBox(height: 28),

            // ==================================================
            // TÍTULO
            // ==================================================
            Text(
              'No tienes empresas registradas',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            // ==================================================
            // DESCRIPCIÓN
            // ==================================================
            Text(
              'Crea tu primera empresa para comenzar a registrar '
              'movimientos, categorías y reportes.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 35),

            // ==================================================
            // CREAR EMPRESA
            // ==================================================
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add_business_rounded),
                label: const Text('Crear empresa'),
                style: FilledButton.styleFrom(
                  textStyle: theme.textTheme.labelLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';

// class EmpresaEmptyState extends StatelessWidget {
//   final VoidCallback? onCreate;

//   const EmpresaEmptyState({super.key, this.onCreate});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 color: Colors.blue.withOpacity(.08),
//                 shape: BoxShape.circle,
//               ),

//               child: const Icon(
//                 Icons.business_outlined,
//                 size: 60,
//                 color: Colors.blue,
//               ),
//             ),

//             const SizedBox(height: 28),

//             const Text(
//               "No tienes empresas registradas",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 12),

//             Text(
//               "Crea tu primera empresa para comenzar a registrar movimientos, categorías y reportes.",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.grey.shade600,
//                 fontSize: 15,
//                 height: 1.5,
//               ),
//             ),

//             const SizedBox(height: 35),

//             SizedBox(
//               width: double.infinity,
//               height: 52,
//               child: ElevatedButton.icon(
//                 onPressed: onCreate,
//                 icon: const Icon(Icons.add_business),
//                 label: const Text(
//                   "Crear empresa",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xff2563EB),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   elevation: 0,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
