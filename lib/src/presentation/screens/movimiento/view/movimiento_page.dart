import 'package:flutter/material.dart';

class MovimientoPage extends StatelessWidget {
  const MovimientoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navegar al formulario de movimiento
        },
        icon: const Icon(Icons.add),
        label: const Text("Nuevo"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Movimientos",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(
              "Administra los ingresos y egresos registrados",
              style: TextStyle(color: Colors.grey.shade700),
            ),

            const SizedBox(height: 25),

            TextField(
              decoration: InputDecoration(
                hintText: "Buscar movimiento...",
                prefixIcon: const Icon(Icons.search),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: 8,

                itemBuilder: (context, index) {
                  final bool ingreso = index.isEven;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),

                    elevation: 3,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),

                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor: ingreso
                            ? Colors.green.shade100
                            : Colors.red.shade100,

                        child: Icon(
                          ingreso ? Icons.arrow_downward : Icons.arrow_upward,
                          color: ingreso
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),

                      title: Text(
                        ingreso
                            ? "Ingreso ${index + 1}"
                            : "Egreso ${index + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),

                          Text(
                            ingreso
                                ? "Categoría: Ventas"
                                : "Categoría: Compras",
                          ),

                          const SizedBox(height: 3),

                          const Text("Fecha: 30/06/2026"),

                          const SizedBox(height: 3),

                          Text(
                            ingreso
                                ? "Monto: S/. 1,250.00"
                                : "Monto: S/. 450.00",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ingreso
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),

                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case "editar":
                              break;

                            case "eliminar":
                              break;
                          }
                        },

                        itemBuilder: (_) => const [
                          PopupMenuItem(value: "editar", child: Text("Editar")),

                          PopupMenuItem(
                            value: "eliminar",
                            child: Text("Eliminar"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
