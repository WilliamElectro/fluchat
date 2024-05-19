import 'package:fluchat/ui/home/Novelties/create_novelty.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoveltiesView extends StatefulWidget {
  const NoveltiesView({Key? key}) : super(key: key);

  @override
  _NoveltiesViewState createState() => _NoveltiesViewState();
}

class _NoveltiesViewState extends State<NoveltiesView> {
  int _selectedIndex = 0; // Índice del botón seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildElevatedButton(0, 'Todas'),
            SizedBox(width: 16),
            _buildElevatedButton(1, 'Próximas'),
          ],
        ),
      ),
      body: _selectedIndex == 0 ? _buildTodasView() : _buildProximasView(),
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
    );
  }

  Widget _buildElevatedButton(int index, String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index; // Actualizar el índice del botón seleccionado
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          final theme = Theme.of(context);
          if (states.contains(MaterialState.pressed)) {
            return theme.primaryColor; // Color primario cuando presionado
          }
          return _selectedIndex == index ? Colors.blueAccent : Colors.white70; // Color azul claro cuando seleccionado, gris cuando no
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          final theme = Theme.of(context);
          if (states.contains(MaterialState.pressed)) {
            return Colors.white; // Color blanco para el texto cuando presionado
          }
          return _selectedIndex == index ? Colors.white : Colors.black; // Color blanco para el texto cuando seleccionado, negro cuando no
        }),
      ),
      child: Text(text),
    );
  }


  Widget _buildTodasView() {
    return ListView(
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
    );
  }

  Widget _buildProximasView() {
    return ListView(
      children: [
        EmployeeCard1(
          name: 'María Rodriguez',
          role: 'Desarrolladora de Software Junior',
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
    Text (
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

