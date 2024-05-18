import 'dart:convert';
import 'package:fluchat/utils/GlobalVariables.dart';
import 'package:http/http.dart' as http;

class ApiServiceBack {

  final String baseUrl = GlobalVariables.baseUrl;
  final String? token = GlobalVariables.tokenBackend;

  ApiServiceBack();

  Future<String> loginBackEnd(String? email) async {

    String encodedPassword = base64.encode(utf8.encode(email == null ? '' : email));

    final Map<String, dynamic> body = {
      'email': email,
      'password': encodedPassword,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/Accounts/ObtainMobileAppTokenAsync'),
      headers: _createHeaders(),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String token = responseData['token'] as String;
      return token;
    } else {
      throw Exception('Failed to login');
    }
  }

  static Map<String, String> _createHeaders() {
    return {
      'Content-Type': 'application/json',
    };
  }

  Future<List<dynamic>> fetchNovelties() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Novelties'),
      headers: _createHeadersWhitAuthorization(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('No se pudo cargar las novedades');
    }
  }

  Future<void> createNovelty(String name) async {
    final Map<String, dynamic> data = {
      'id': 0,
      'name': name,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/api/Novelties'),
      headers: _createHeadersWhitAuthorization(),
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('No se pudo crear la novedad');
    }
  }

  Future<List<dynamic>> fetchTypeNovelties() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/TypeNovelties'),
      headers: _createHeadersWhitAuthorization(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('No se pudo cargar los tipos de novedades');
    }
  }

  //TODO: crear servicio en .net que retorne si se puede o no enviar un mensaje a la persona
  /**
   * Metodo encargado de recuperar los trabajadores
   */
  Future<List<dynamic>> fetchWorkers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/ActiveWorkers'),
      headers: _createHeadersWhitAuthorization(),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('No se pudo cargar los Trabajadores');
    }
  }

  Map<String, String> _createHeadersWhitAuthorization() {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      // Otros encabezados personalizados, si es necesario
    };
  }

//TODO: crear servicio en .net que retorne si se puede o no enviar un mensaje a la persona
}
