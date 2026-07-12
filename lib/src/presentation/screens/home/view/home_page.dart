import 'package:flutter/material.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/dashboard_card.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Accesos rápidos",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),

            const SizedBox(height: 20),

            DashboardCard(
              titulo: "Movimientos",
              icon: Icons.swap_horiz,
              onTap: () => context.pushNamed("movimientos"),
            ),

            DashboardCard(
              titulo: "Periodos Contables",
              icon: Icons.history,
              onTap: () => context.pushNamed("periodos_contables"),
            ),

            DashboardCard(
              titulo: "Categorías",
              icon: Icons.category,
              onTap: () => context.pushNamed("categorias"),
            ),

            const SizedBox(height: 15),

            const Text(
              "Finanzas",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),

            const SizedBox(height: 20),

            DashboardCard(
              titulo: "Tus Empresas",
              icon: Icons.business,
              onTap: () => context.pushNamed("empresas"),
            ),

            DashboardCard(
              titulo: "Reportes",
              icon: Icons.bar_chart,
              onTap: () => context.pushNamed("reportes"),
            ),

            DashboardCard(
              titulo: "Configuración",
              icon: Icons.settings,
              onTap: () => context.pushNamed("configuracion"),
            ),
          ],
        ),
      ),
    );
  }
}
