import 'package:flutter/material.dart';

class CategoriaPage extends StatelessWidget {
  const CategoriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navegar al formulario de categoría
        },
        icon: const Icon(Icons.add),
        label: const Text("Nueva"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Categorías",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(
              "Administra las categorías de movimientos",
              style: TextStyle(color: Colors.grey.shade700),
            ),

            const SizedBox(height: 25),

            TextField(
              decoration: InputDecoration(
                hintText: "Buscar categoría...",
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
                itemCount: 6,

                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 15),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),

                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.orange.shade100,

                        child: Icon(
                          Icons.category,
                          color: Colors.orange.shade700,
                        ),
                      ),

                      title: Text(
                        "Categoría ${index + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      subtitle: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),

                          Text("Descripción de la categoría."),

                          SizedBox(height: 4),

                          Text(
                            "Estado: Activo",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
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
