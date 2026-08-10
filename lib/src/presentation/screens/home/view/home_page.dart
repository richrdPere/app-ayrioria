import 'package:flutter/material.dart';
import 'package:app_aryoria/src/presentation/shared/widgets/dashboard_card.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;

    // ==========================================================
    // BREAKPOINTS
    // ==========================================================

    final bool isSmallMobile = width < 360;
    final bool isTablet = width >= 600;
    final bool isDesktop = width >= 1000;

    // ==========================================================
    // MEDIDAS RESPONSIVAS
    // ==========================================================

    final horizontalPadding = isDesktop
        ? 40.0
        : isTablet
        ? 28.0
        : isSmallMobile
        ? 14.0
        : 20.0;

    final sectionTitleSize = isTablet ? 24.0 : 22.0;

    final crossAxisCount = isDesktop
        ? 3
        : isTablet
        ? 2
        : 1;

    final spacing = isTablet ? 16.0 : 12.0;

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 20,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // 1.- ACCESOS RÁPIDOS
                    // ==================================================
                    Text(
                      'Accesos rápidos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: sectionTitleSize,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _DashboardGrid(
                      crossAxisCount: crossAxisCount,
                      spacing: spacing,
                      children: [
                        DashboardCard(
                          titulo: 'Movimientos',
                          descripcion:
                              'Registra y consulta ingresos y egresos.',
                          icon: Icons.receipt_long_outlined,
                          onTap: () => context.pushNamed('movimientos'),
                        ),

                        DashboardCard(
                          titulo: 'Periodos Contables',
                          descripcion:
                              'Administra los períodos de trabajo contable.',
                          icon: Icons.calendar_month_outlined,
                          onTap: () => context.pushNamed('periodos_contables'),
                        ),

                        DashboardCard(
                          titulo: 'Categorías',
                          descripcion: 'Organiza tus movimientos por tipo.',
                          icon: Icons.category,
                          onTap: () => context.pushNamed('categorias'),
                        ),

                        DashboardCard(
                          titulo: 'Subcategorías',
                          descripcion:
                              'Define conceptos específicos para cada categoría.',
                          icon: Icons.account_tree_outlined,
                          onTap: () => context.pushNamed('subcategorias'),
                        ),
                      ],
                    ),

                    SizedBox(height: isTablet ? 32 : 24),

                    // ==================================================
                    // 2.- FINANZAS
                    // ==================================================
                    Text(
                      'Finanzas',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: sectionTitleSize,
                      ),
                    ),

                    const SizedBox(height: 18),

                    _DashboardGrid(
                      crossAxisCount: crossAxisCount,
                      spacing: spacing,
                      children: [
                        DashboardCard(
                          titulo: 'Flujo Contable',
                          descripcion:
                              'Analiza saldos, ingresos, egresos y proyecciones.',
                          icon: Icons.account_balance_wallet_outlined,
                          onTap: () => context.pushNamed('flujo_contable'),
                        ),

                        DashboardCard(
                          titulo: 'Reportes',
                          descripcion:
                              'Consulta indicadores y resultados financieros.',
                          icon: Icons.bar_chart,
                          onTap: () => context.pushNamed('reportes'),
                        ),

                        // DashboardCard(
                        //   titulo: 'Tus Empresas',
                        //   descripcion:
                        //       'Gestiona las empresas vinculadas a tu cuenta.',
                        //   icon: Icons.business,
                        //   onTap: () => context.pushNamed('empresas'),
                        // ),

                        // DashboardCard(
                        //   titulo: 'Configuración',
                        //   descripcion:
                        //       'Personaliza las opciones generales de la aplicación.',
                        //   icon: Icons.settings,
                        //   onTap: () => context.pushNamed('configuracion'),
                        // ),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// GRID RESPONSIVO
// ============================================================

class _DashboardGrid extends StatelessWidget {
  final int crossAxisCount;
  final double spacing;
  final List<Widget> children;

  const _DashboardGrid({
    required this.crossAxisCount,
    required this.spacing,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    // ==========================================================
    // MÓVIL
    // ==========================================================

    if (crossAxisCount == 1) {
      return Column(children: children);
    }

    // ==========================================================
    // TABLET / DESKTOP
    // ==========================================================

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,

      // Más altura porque ahora tenemos título + descripción.
      childAspectRatio: 2.7,

      children: children,
    );
  }
}
