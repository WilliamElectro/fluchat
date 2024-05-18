import 'package:firebase_auth/firebase_auth.dart';

import '../../data/ApiService_web.dart';
import '../../utils/GlobalVariables.dart';
import '../models/workers.dart';

class BackendLogic {
  BackendLogic();

  FirebaseAuth _auth = FirebaseAuth.instance;

  /**
   * Metodo encargado de obtener los datos iniciales de servicios
   */
  Future<bool> fetchData() async {
    try {
      final user = _auth.currentUser;

      String? emailUser = GlobalVariables.googleUser != null
          ? GlobalVariables.googleUser?.email
          : user != null
              ? user.email
              : '';

      String token = await ApiServiceBack().loginBackEnd(emailUser);
      GlobalVariables.tokenBackend = token;

      List<Workers> workersList = await getAvailableWorkers() as List<Workers>;
      GlobalVariables.availableWorkers = workersList;

      return true;
    } catch (error) {
      print('Error al obtener la información: $error');
      return false;
    }
  }

  /**
   * Método privado para obtener los Workers en horario laboral
   */
  Future<List<Workers>> getAvailableWorkers() async {
    List<dynamic> jsonList = await ApiServiceBack().fetchWorkers();
    List<Workers> workersList =
        jsonList.map((json) => Workers.fromJson(json)).toList();
    return workersList;
  }

  bool isWorkerAvailable(String email) {
    return GlobalVariables.availableWorkers.any((worker) => worker.email == email);
  }

}
