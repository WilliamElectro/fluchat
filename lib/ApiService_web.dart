import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final String token;

  ApiService(this.baseUrl, this.token);

  Future<List<dynamic>> fetchNovelties() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Novelties'),
      headers: _createHeaders(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('No se puedo cargar las novedades');
    }
  }

  Future<void> createNovelty(String name) async {
    final Map<String, dynamic> data = {
      'id': 0,
      'name': name,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/Novelties'),
      headers: _createHeaders(),
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('No se pudo crear la novedad');
    }
  }

  Future<List<dynamic>> fetchTypeNovelties() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/TypeNovelties'),
      headers: _createHeaders(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('No se puedo cargar los tipos de novedades');
    }
  }


  Map<String, String> _createHeaders() {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      // Otros encabezados personalizados, si es necesario
    };
  }
}
