import 'package:flutter/material.dart';

class EmpresaEmptyState extends StatelessWidget {
  final VoidCallback? onCreate;

  const EmpresaEmptyState({super.key, this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(.08),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.business_outlined,
                size: 60,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              "No tienes empresas registradas",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Text(
              "Crea tu primera empresa para comenzar a registrar movimientos, categorías y reportes.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.add_business),
                label: const Text(
                  "Crear empresa",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
