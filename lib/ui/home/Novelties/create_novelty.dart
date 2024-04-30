import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewNoveltyForm extends StatefulWidget {
  @override
  _NewNoveltyFormState createState() => _NewNoveltyFormState();
}

class _NewNoveltyFormState extends State<NewNoveltyForm> {
  late DateTime _startDate;
  late DateTime _endDate;
  late String _noveltyType;

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
          ElevatedButton(
            onPressed: () {
              // Aquí puedes agregar la lógica para guardar la nueva novedad
              // Usando _noveltyType, _startDate y _endDate
              Navigator.of(context).pop();
            },
            child: Text('Guardar'),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              decoration: InputDecoration(labelText: 'Tipo de Novedad'),
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
          ],
        ),
      ),
    );
  }
}

// Lista de tipos de novedad (puedes modificarla según sea necesario)
List<String> noveltyTypes = ['Vacaciones', 'Licencia', 'Permiso'];
