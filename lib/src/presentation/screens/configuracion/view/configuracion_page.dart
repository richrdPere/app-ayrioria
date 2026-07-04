import 'package:flutter/material.dart';

class ConfiguracionPage extends StatelessWidget {
  const ConfiguracionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Configuración",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(
              "Administra tu cuenta y las preferencias del sistema.",
              style: TextStyle(color: Colors.grey.shade700),
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      child: Icon(Icons.person, size: 35),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: const [
                          Text(
                            "Richard Pereira",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            "Administrador",
                            style: TextStyle(color: Colors.grey),
                          ),

                          SizedBox(height: 3),

                          Text(
                            "richard@email.com",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "General",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 10),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: Column(
                children: [
                  _SettingTile(
                    icon: Icons.business,
                    title: "Empresa Activa",
                    subtitle: "Seleccionar empresa",
                    onTap: () {},
                  ),

                  Divider(height: 1),

                  _SettingTile(
                    icon: Icons.calendar_month,
                    title: "Periodo Contable",
                    subtitle: "Seleccionar periodo",
                    onTap: () {},
                  ),

                  Divider(height: 1),

                  _SettingTile(
                    icon: Icons.palette,
                    title: "Tema",
                    subtitle: "Claro",
                    onTap: () {},
                  ),

                  Divider(height: 1),

                  _SettingTile(
                    icon: Icons.language,
                    title: "Idioma",
                    subtitle: "Español",
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Seguridad",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 10),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: Column(
                children: [
                  _SettingTile(
                    icon: Icons.lock,
                    title: "Cambiar contraseña",
                    subtitle: "Actualizar credenciales",
                    onTap: () {},
                  ),

                  Divider(height: 1),

                  _SettingTile(
                    icon: Icons.verified_user,
                    title: "Roles y permisos",
                    subtitle: "Administrar accesos",
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Aplicación",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 10),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: Column(
                children: [
                  _SettingTile(
                    icon: Icons.info_outline,
                    title: "Acerca de",
                    subtitle: "Versión 1.0.0",
                    onTap: () {},
                  ),

                  Divider(height: 1),

                  _SettingTile(
                    icon: Icons.logout,
                    title: "Cerrar sesión",
                    subtitle: "Salir del sistema",
                    iconColor: Colors.red,
                    onTap: () {
                      // Logout
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade50,

        child: Icon(icon, color: iconColor ?? Colors.blue),
      ),

      title: Text(title),

      subtitle: Text(subtitle),

      trailing: const Icon(Icons.chevron_right),

      onTap: onTap,
    );
  }
}
