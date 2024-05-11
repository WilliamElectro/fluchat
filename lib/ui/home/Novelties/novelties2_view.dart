import 'dart:convert'; // Importante para convertir la respuesta JSON en un objeto Dart
import 'package:http/http.dart' as http;
import 'package:fluchat/ui/home/Novelties/Create_novelty_2.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';


class NoveltiesView2 extends StatelessWidget {
  const NoveltiesView2 ({Key? key}) : super(key: key);

  Future<List<dynamic>> fetchNovelties() async {
    final response = await http.get(Uri.parse('https://backendpgcell.azurewebsites.net/api/Novelties'));
    if (response.statusCode == 200) {
      // Si la solicitud es exitosa, devuelve los datos como una lista
      return json.decode(response.body);
    } else {
      // Si la solicitud falla, lanza una excepción
      throw Exception('Failed to load novelties');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchNovelties(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Muestra un indicador de carga mientras se realiza la solicitud
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Si la solicitud es exitosa, procesa los datos y construye tu UI
          final novelties = snapshot.data!;
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueAccent,
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Todas'),
                    Tab(text: 'Próximas'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  // Contenido del primer tab
                  ListView.builder(
                    itemCount: novelties.length,
                    itemBuilder: (context, index) {
                      final novelty = novelties[index];
                      return EmployeeCard(
                        id: novelty['id'],
                        name: novelty['name'],
                      );
                    },
                  ),
                  // Contenido del segundo tab
                  // Similar al primer tab, pero con los datos de las próximas novedades
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Abre la pantalla para crear una nueva novedad
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewNoveltyForm2()),
                  );
                },
                child: Icon(Icons.access_alarm),
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
        // Puedes mostrar el id si es necesario
        // subtitle: Text('ID: $id'),
      ),
    );
  }
}
