import 'package:flutter/material.dart';
import 'package:fluchat/ui/home/Novelties/Create_novelty_2.dart';
import 'package:fluchat/ApiService_web.dart'; // Importa el archivo donde se define ApiService

class NoveltiesView2 extends StatelessWidget {
  const NoveltiesView2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: ApiServiceBack().fetchNovelties(), // Usando las constantes globales
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final novelties = snapshot.data!;
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              body: ListView.builder(
                itemCount: novelties.length,
                itemBuilder: (context, index) {
                  final novelty = novelties[index];
                  return EmployeeCard(
                    id: novelty['id'],
                    name: novelty['name'],
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  final shouldReload = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewNoveltyForm2()),
                  );

                  if (shouldReload == true) {
                    // Llama a la función para recargar la pantalla aquí
                    // Puedes implementar la lógica de recarga aquí
                  }
                },
                child: Icon(Icons.five_k_plus_sharp),
              ),
            ),
          );
        }
      },
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final int id;
  final String name;

  const EmployeeCard({
    required this.id,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(name),
      ),
    );
  }
}
