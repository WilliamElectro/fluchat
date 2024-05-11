import 'package:fluchat/data/auth_repository.dart';
import 'package:fluchat/domain/models/auth_user.dart';

class AuthLocalImpl extends AuthRepository {
  @override
  Future<AuthUser> getAuthUser() async {
    await Future.delayed(const Duration(seconds: 2));
    return AuthUser('john');
  }

  @override
  Future<AuthUser> signIn() async {
    await Future.delayed(const Duration(seconds: 2));
    return AuthUser('john');
  }

  @override
  Future<void> logout() async {
    return;
  }
}
