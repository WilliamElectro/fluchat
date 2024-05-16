import 'package:google_sign_in/google_sign_in.dart';

import '../domain/models/workers.dart';

class GlobalVariables {
  static GoogleSignInAccount? googleUser;
  static String emailUser = '';
  static String baseUrl = 'https://backendpgcell.azurewebsites.net';
  static String? tokenBackend;
  static List<Workers> availableWorkers = [];
  static String? recipientEmail;
}
