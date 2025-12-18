import 'package:book_buddy/core/data/data_source/user_auth.dart';

class AuthUseCases {
  final AuthenticationRepository repository;

  AuthUseCases(this.repository);

  Future<void> login(String email, String password) async {
    await repository.loginUser(email: email, password: password);
  }

  Future<void> register(String name, String email, String password) async {
    await repository.registerUser(name: name, email: email, password: password);
  }

  Future<void> logout() async => repository.signOut();

  Stream<bool> authStateChanges() => repository.authStateChanges();
}
