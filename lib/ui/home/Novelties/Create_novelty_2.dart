import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluchat/ApiService_web.dart'; // Importa el archivo donde se define ApiService
import 'package:fluchat/constants.dart'; // Importa las variables globales
import 'package:fluchat/navigator_utils.dart';
import 'package:fluchat/ui/app_theme_cubit.dart';
import 'package:fluchat/ui/common/avatar_image_view.dart';
import 'package:fluchat/ui/home/settings/settings_cubit.dart';
import 'package:fluchat/ui/sign_in/sign_in_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class NewNoveltyForm2 extends StatefulWidget {
  @override
  _NewNoveltyFormState createState() => _NewNoveltyFormState();
}

class _NewNoveltyFormState extends State<NewNoveltyForm2> {
  late DateTime _startDate;
  late DateTime _endDate;
  late String _noveltyType;
  String _attachedDocument = '';

  @override
  void initState() {
    super.initState();
    // Inicializa las fechas con la fecha actual
    _startDate = DateTime.now();
    _endDate = DateTime.now();
    // Inicializa el tipo de novedad con el primer tipo en la lista
    _noveltyType = noveltyTypes[0];
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
              Navigator.of(context).pop();
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
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _noveltyType,
              items: noveltyTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _noveltyType = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Tipo de Novedad',
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
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
            SizedBox(height: 8),
            ListTile(
              title: TextFormField(
                readOnly: true,
                controller: TextEditingController(
                    text: _attachedDocument.isNotEmpty ? 'Documento adjunto: $_attachedDocument' : 'Adjuntar Documento'),
                onTap: () {
                  // Aquí puedes abrir un diálogo o navegar a una pantalla para seleccionar un archivo
                  // y luego actualizar _attachedDocument con el nombre del archivo seleccionado
                  // Por ahora, lo dejaremos vacío
                },
                decoration: InputDecoration(
                  labelText: 'Adjuntar Documento',
                  suffixIcon: Icon(Icons.attach_file),
                ),
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
      await ApiService(baseUrl, token).createNovelty(combinedNameAndType);
      // Si la solicitud es exitosa, cierra la pantalla
      Navigator.of(context).pop();
    } catch (e) {
      // Si la solicitud falla, muestra un mensaje de error al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create novelty: $e')),
      );
    }
  }
}

// Lista de tipos de novedad (puedes modificarla según sea necesario)
List<String> noveltyTypes = ['Vacaciones', 'Licencia', 'Permiso'];
