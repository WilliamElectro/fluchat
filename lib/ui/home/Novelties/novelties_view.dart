import 'package:fluchat/ui/home/Novelties/create_novelty.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class NoveltiesView extends StatelessWidget {
  const NoveltiesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Novedades'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Todas'), // Primer tab
              Tab(text: 'Próximas'), // Segundo tab
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contenido del primer tab (Todas)
            ListView(
              children: [
                EmployeeCard(
                  name: 'Jenny Chavez',
                  role: 'Gerente de Proyectos',
                  imagePath: 'assets/jenny.png',
                  progress: 0.7,
                  noveltyDate: DateTime(2024, 6, 15),
                ),
                EmployeeCard(
                  name: 'William Bohorquez',
                  role: 'Desarrollador Senior',
                  imagePath: 'assets/William.jpg',
                  progress: 0.5,
                  noveltyDate: DateTime(2024, 7, 10),
                ),
                EmployeeCard(
                  name: 'Sergio Andres Duran',
                  role: 'Diseñador UI/UX',
                  imagePath: 'assets/sergio.png',
                  progress: 0.9,
                  noveltyDate: DateTime(2024, 5, 20),
                ),
                // Agrega más EmployeeCard según sea necesario
              ],
            ),
            // Contenido del segundo tab (Próximas)
            ListView(
              children: [
                // Aquí puedes mostrar las próximas novedades
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Abre la pantalla para crear una nueva novedad
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewNoveltyForm()),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final String name;
  final String role;
  final String imagePath;
  final double progress;
  final DateTime noveltyDate;

  const EmployeeCard({
    required this.name,
    required this.role,
    required this.imagePath,
    required this.progress,
    required this.noveltyDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name),
                  Text(
                    role,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Llega hasta el: ${DateFormat('dd/MM/yyyy').format(noveltyDate)}',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(imagePath),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
