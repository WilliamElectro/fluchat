import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluchat/data/ApiService_web.dart'; // Importa el archivo donde se define ApiService
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../utils/navigator_utils.dart';
import 'novelties2_view.dart'; // Importa las variables globales

class NewNoveltyForm2 extends StatefulWidget {
  @override
  _NewNoveltyFormState createState() => _NewNoveltyFormState();
}

class _NewNoveltyFormState extends State<NewNoveltyForm2> {
  late DateTime _startDate;
  late DateTime _endDate;
  String _noveltyType = '';
  String _attachedDocument = '';
  List<Map<String, dynamic>> _attachedDocuments = [];
  List<String> noveltyTypes = []; // Lista de tipos de novedad

  @override
  void initState() {
    super.initState();
    // Inicializa las fechas con la fecha actual
    _startDate = DateTime.now();
    _endDate = DateTime.now();
    // Cargar los tipos de novedad
    _fetchNoveltyTypes();
  }

  Future<void> _fetchNoveltyTypes() async {
    try {
      final List<dynamic> data = await ApiServiceBack().fetchTypeNovelties();
      setState(() {
        noveltyTypes = data.map((item) => item['name'].toString()).toList();
        _noveltyType = noveltyTypes.isNotEmpty ? noveltyTypes[0] : '';
      });
    } catch (e) {
      print('Error fetching novelty types: $e');
    }
  }

  Future<void> _selectDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _attachedDocuments.add({
          'name': result.files.single.name!,
          'icon': _getIconForFileExtension(result.files.single.extension),
        });
      });
    }
  }

  IconData? _getIconForFileExtension(String? extension) {
    if (extension == null) return null;

    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      default:
        return Icons.attach_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = StreamChat.of(context).client.state.currentUser;
    final loggedUserName = user?.name ?? 'Usuario Desconocido'; // Obtener el nombre del usuario logueado

    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Nueva Novedad'),
        actions: [
          TextButton(
            onPressed: () {
              // Retorna un valor de actualización al cerrar la pantalla
              Navigator.of(context).pop(true);
            },
            child: Text('Cancelar'),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo para mostrar el icono y el nombre del usuario logueado
            ListTile(
              leading: Icon(Icons.person, size: 40), // Icono de usuario
              title: Text(
                loggedUserName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Nombre del Trabajador',
                style: TextStyle(
                  color: Colors.grey[400], // Aquí estableces el color gris
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(height: 16),

            ListTile(
              title: TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: _noveltyType.isNotEmpty ? _noveltyType : 'Seleccione Tipo de Novedad',
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: Text('Seleccione Tipo de Novedad'),
                        children: noveltyTypes.map((type) {
                          return SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context, type);
                            },
                            child: ListTile(
                              title: Text(type),
                              selected: _noveltyType == type,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        _noveltyType = value;
                      });
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Tipo de Novedad',
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              title: TextFormField(
                readOnly: true,
                controller: TextEditingController(
                    text: DateFormat('dd/MM/yyyy').format(_startDate)),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _startDate = selectedDate;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Fecha de Inicio',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              title: TextFormField(
                readOnly: true,
                controller: TextEditingController(
                    text: DateFormat('dd/MM/yyyy').format(_endDate)),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _endDate,
                    firstDate: _startDate,
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _endDate = selectedDate;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Fecha de Finalización',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _selectDocument,
              icon: Icon(Icons.attach_file),
              label: Text('Adjuntar Documento'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _attachedDocuments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_attachedDocuments[index]['name']),
                    leading: Icon(_attachedDocuments[index]['icon']),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _saveNovelty('$loggedUserName - $_noveltyType'); // Concatenar el nombre del usuario con el tipo de novedad
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNovelty(String combinedNameAndType) async {
    try {
      // Llama a la función createNovelty de ApiService para crear una nueva novedad
      await ApiServiceBack().createNovelty(combinedNameAndType);
      // Si la solicitud es exitosa, cierra la pantalla y navega a la página de novedades
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => NoveltiesView2()),
            (route) => false,
      );
    } catch (e) {
      // Si la solicitud falla, muestra un mensaje de error al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create novelty: $e')),
      );
    }
  }
}

