import 'package:book_buddy/core/data/data_source/firebase_auth.dart';
import 'package:book_buddy/core/domain/auth_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

enum AuthMode { login, signup }

final authModeProvider = StateProvider<AuthMode>((ref) => AuthMode.login);
// Repository Provider
final authRepositoryProvider = Provider<AuthenticationRepository>((ref) {
  return AuthenticationRepository(FirebaseAuth.instance);
});

// Usecase Provider
final authUseCaseProvider = Provider<AuthUseCases>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthUseCases(repo);
});

// Auth State Provider
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

// Controller for login / register actions
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
      final useCases = ref.watch(authUseCaseProvider);
      return AuthController(useCases);
    });

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthUseCases useCases;
  AuthController(this.useCases) : super(const AsyncData(null));

  Future<void> userLogin(String email, String password) async {
    state = const AsyncLoading();
    try {
      await useCases.login(email, password);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> userSignin(String email, String password) async {
    state = const AsyncLoading();
    try {
      await useCases.register(email, password);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> userLogout() async {
    await useCases.logout();
  }
}
