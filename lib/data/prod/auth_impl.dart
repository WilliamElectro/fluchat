import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluchat/data/auth_repository.dart';
import 'package:fluchat/domain/models/auth_user.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../utils/GlobalVariables.dart';

class AuthImpl extends AuthRepository {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<AuthUser> getAuthUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      return AuthUser(user.uid);
    }
    return AuthUser('');
  }

  @override
  Future<AuthUser> signIn() async {
    try {
      UserCredential userCredential;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GlobalVariables.googleUser = googleUser;
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      if (googleAuth == null) {
        throw Exception('Google authentication failed.');
      }
      final OAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _auth.signInWithCredential(googleAuthCredential);
      final user = userCredential.user;
      return AuthUser(user!.uid);
    } catch (e) {
      print(e);
      throw Exception('login error');
    }
  }

  @override
  Future<void> logout() async {
    return _auth.signOut();
  }
}
