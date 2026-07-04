import 'package:flutter/material.dart';

class ReportesPage extends StatelessWidget {
  const ReportesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Reportes",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(
              "Consulta y genera reportes financieros",
              style: TextStyle(color: Colors.grey.shade700),
            ),

            const SizedBox(height: 25),

            TextField(
              decoration: InputDecoration(
                hintText: "Buscar reporte...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,

                children: const [
                  ReportCard(
                    title: "Libro Diario",
                    subtitle: "Movimientos diarios",
                    icon: Icons.menu_book,
                    color: Colors.blue,
                  ),

                  ReportCard(
                    title: "Libro Mayor",
                    subtitle: "Resumen por cuentas",
                    icon: Icons.account_balance,
                    color: Colors.indigo,
                  ),

                  ReportCard(
                    title: "Balance General",
                    subtitle: "Estado financiero",
                    icon: Icons.balance,
                    color: Colors.green,
                  ),

                  ReportCard(
                    title: "Estado de Resultados",
                    subtitle: "Ingresos y gastos",
                    icon: Icons.bar_chart,
                    color: Colors.orange,
                  ),

                  ReportCard(
                    title: "Movimientos",
                    subtitle: "Listado completo",
                    icon: Icons.swap_horiz,
                    color: Colors.red,
                  ),

                  ReportCard(
                    title: "Categorías",
                    subtitle: "Resumen de categorías",
                    icon: Icons.category,
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const ReportCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      child: InkWell(
        borderRadius: BorderRadius.circular(18),

        onTap: () {
          // TODO: Navegar al reporte
        },

        child: Padding(
          padding: const EdgeInsets.all(18),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withOpacity(.15),

                child: Icon(icon, color: color, size: 32),
              ),

              const SizedBox(height: 18),

              Text(
                title,
                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                subtitle,
                textAlign: TextAlign.center,

                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
