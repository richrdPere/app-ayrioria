import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItem({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon,
  });
}

const appMenuItems = <MenuItem>[
  MenuItem(
    title: 'Movimientos',
    subTitle: 'Registra y consulta ingresos y egresos',
    link: '/movimientos',
    icon: Icons.swap_horiz_rounded,
  ),

  MenuItem(
    title: 'Períodos Contables',
    subTitle: 'Administra los períodos de trabajo contable',
    link: '/periodos_contables',
    icon: Icons.calendar_month_outlined,
  ),

  MenuItem(
    title: 'Categorías',
    subTitle: 'Organiza tus movimientos por tipo',
    link: '/categorias',
    icon: Icons.category_outlined,
  ),

  MenuItem(
    title: 'Subcategorías',
    subTitle: 'Define conceptos para cada categoría',
    link: '/subcategorias',
    icon: Icons.account_tree_outlined,
  ),

  MenuItem(
    title: 'Flujo Contable',
    subTitle: 'Analiza saldos, ingresos, egresos y proyecciones',
    link: '/flujo-contable',
    icon: Icons.account_balance_wallet_outlined,
  ),

  MenuItem(
    title: 'Reportes',
    subTitle: 'Consulta indicadores y resultados financieros',
    link: '/reportes',
    icon: Icons.bar_chart_rounded,
  ),

  MenuItem(
    title: 'Empresas',
    subTitle: 'Gestiona tus empresas registradas',
    link: '/empresas',
    icon: Icons.business_outlined,
  ),

  MenuItem(
    title: 'Configuración',
    subTitle: 'Administra las opciones generales de Aryoria',
    link: '/configuracion',
    icon: Icons.settings_outlined,
  ),

  MenuItem(
    title: 'Introducción a la aplicación',
    subTitle: 'Pequeño tutorial introductorio',
    link: '/tutorial',
    icon: Icons.accessible_rounded,
  ),

  MenuItem(
    title: 'Cambiar tema',
    subTitle: 'Cambiar tema de la aplicación',
    link: '/theme-changer',
    icon: Icons.color_lens_outlined,
  ),
];
