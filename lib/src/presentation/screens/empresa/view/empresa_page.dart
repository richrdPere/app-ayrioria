import 'package:flutter/material.dart';

class EmpresaPage extends StatelessWidget {
  const EmpresaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text("Nueva"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // const Text(
            //   "Empresas",
            //   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            // ),

            // const SizedBox(height: 5),

            // Text(
            //   "Administra las empresas registradas",
            //   style: TextStyle(color: Colors.grey.shade700),
            // ),

            // const SizedBox(height: 25),

            TextField(
              decoration: InputDecoration(
                hintText: "Buscar empresa...",
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
              child: ListView.builder(
                itemCount: 5,

                itemBuilder: (_, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),

                    elevation: 3,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.blue.shade100,

                        child: Icon(
                          Icons.business,
                          color: Colors.blue.shade700,
                        ),
                      ),

                      title: Text(
                        "Empresa ${index + 1}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      subtitle: const Text("RUC: 20123456789"),

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
