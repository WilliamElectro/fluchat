import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

class NewNoveltyForm extends StatefulWidget {
  @override
  _NewNoveltyFormState createState() => _NewNoveltyFormState();
}

class _NewNoveltyFormState extends State<NewNoveltyForm> {
  late DateTime _startDate;
  late DateTime _endDate;
  late String _noveltyType = '';
  List<Map<String, dynamic>> _attachedDocuments = [];
  List<String> noveltyTypes = [];

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now();
    _fetchNoveltyTypes();
  }

  Future<void> _fetchNoveltyTypes() async {
    final response =
    await http.get(Uri.parse('https://backendpgcell.azurewebsites.net/api/TypeNovelties'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        noveltyTypes = data.map((item) => item['name'].toString()).toList();
        _noveltyType = noveltyTypes.isNotEmpty ? noveltyTypes[0] : '';
      });
    } else {
      throw Exception('Failed to load novelty types');
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
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
