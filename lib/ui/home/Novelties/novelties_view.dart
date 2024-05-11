import 'package:fluchat/ui/home/Novelties/create_novelty.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';


class NoveltiesView extends StatelessWidget {
  const NoveltiesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Todas' ), // Primer tab
              Tab(text: 'Próximas'), // Segundo tab
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contenido del primer tab
            ListView(
              children: [
                EmployeeCard(
                  name: 'Jenny Chavez',
                  role: 'Gerente de Proyectos',
                  imagePath: 'assets/jenny.png',
                  progress: 0.7,
                  noveltyDate: DateTime(2024, 6, 15),
                  startNoveltyDate: DateTime(2024, 6, 6),
                  endNoveltyDate: DateTime(2024, 6, 10),
                ),
                EmployeeCard(
                  name: 'William Bohorquez',
                  role: 'Desarrollador Senior',
                  imagePath: 'assets/William.jpg',
                  progress: 0.5,
                  noveltyDate: DateTime(2024, 7, 10),
                  startNoveltyDate: DateTime(2024, 6, 6),
                  endNoveltyDate: DateTime(2024, 6, 10),
                ),
                EmployeeCard(
                  name: 'Sergio Andres Duran',
                  role: 'Diseñador UI/UX',
                  imagePath: 'assets/sergio.png',
                  progress: 0.9,
                  noveltyDate: DateTime(2024, 5, 20),
                  startNoveltyDate: DateTime(2024, 6, 6),
                  endNoveltyDate: DateTime(2024, 6, 10),
                ),
                // Agrega más EmployeeCard según sea necesario
              ],
            ),
            // Contenido del segundo tab (Próximas)
            ListView(
              children: [
                EmployeeCard1(
                  name: 'María Rodriguez',
                  role: 'Desarrolladora de Software',
                  imagePath: 'assets/jenny.png',
                  progress: 0.7,
                  startNoveltyDate: DateTime(2024, 6, 6),
                  endNoveltyDate: DateTime(2024, 6, 10),
                  noveltyDate: DateTime(2024, 6, 6),
                ),
                EmployeeCard1(
                  name: 'Juan Perez',
                  role: 'Diseñador UI/UX',
                  imagePath: 'assets/William.jpg',
                  progress: 0.5,
                  startNoveltyDate: DateTime(2024, 7, 7),
                  endNoveltyDate: DateTime(2024, 7, 12),
                  noveltyDate: DateTime(2024, 6, 6),
                ),
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
          child: Icon(Icons.access_alarm),
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
  final DateTime startNoveltyDate;
  final DateTime endNoveltyDate;

  const EmployeeCard({
    required this.name,
    required this.role,
    required this.imagePath,
    required this.progress,
    required this.noveltyDate,
    required this.startNoveltyDate,
    required this.endNoveltyDate,
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
                  Row(
                    children: [
                      Icon(
                        Icons.trip_origin,
                        color: Colors.blue,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Duración: ${endNoveltyDate.difference(startNoveltyDate).inDays} días',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
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

class EmployeeCard1 extends StatelessWidget {
  final String name;
  final String role;
  final String imagePath;
  final double progress;
  final DateTime noveltyDate;
  final DateTime startNoveltyDate;
  final DateTime endNoveltyDate;

  const EmployeeCard1({
    required this.name,
    required this.role,
    required this.imagePath,
    required this.progress,
    required this.noveltyDate,
    required this.startNoveltyDate,
    required this.endNoveltyDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Inicio: ${DateFormat('dd/MM/yyyy').format(startNoveltyDate)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              'Fin: ${DateFormat('dd/MM/yyyy').format(endNoveltyDate)}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.trip_origin,
                              color: Colors.blue,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Duración: ${endNoveltyDate.difference(startNoveltyDate).inDays} días',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
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
          ),
          Positioned(
            top: 0,
            right: 0,
            child: CustomPaint(
              size: Size(24, 24),
              painter: TrianglePainter(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}