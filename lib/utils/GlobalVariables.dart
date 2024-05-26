import 'package:google_sign_in/google_sign_in.dart';

import '../domain/models/workers.dart';

class GlobalVariables {
  // Variable estática que almacena la cuenta de Google del usuario actualmente autenticado.
  static GoogleSignInAccount? googleUser;

  // URL base para realizar solicitudes a la API del backend.
  static String baseUrl = 'https://backendpgcell.azurewebsites.net';

  // Token de autenticación para el backend, usado para autorizar solicitudes.
  static String? tokenBackend;

  // Lista estática que almacena los trabajadores disponibles.
  static List<Workers> availableWorkers = [];

// Indicador booleano que señala si hay trabajadores disponibles.
  static bool isWorkerAvailable = false;
}
