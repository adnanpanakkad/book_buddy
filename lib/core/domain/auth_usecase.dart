import 'package:book_buddy/core/data/data_source/firebase_auth.dart';

class AuthUseCases {
  final AuthenticationRepository repository;

  AuthUseCases(this.repository);

  Future<void> login(String email, String password) async {
    await repository.loginUser(email: email, password: password);
  }

  Future<void> register(String email, String password) async {
    await repository.registerUser(email: email, password: password);
  }

  Future<void> logout() async => await repository.signOut();

  Stream authStateChanges() => repository.authStateChanges();
}
