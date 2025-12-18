import 'package:book_buddy/core/data/data_source/user_auth.dart';
import 'package:book_buddy/core/domain/auth_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthMode { login, signup }

final authModeProvider =
    StateProvider<AuthMode>((ref) => AuthMode.login);

// Dio Provider
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: 'https://ecommerce-app-fultter-api.vercel.app/api',
      headers: {'Content-Type': 'application/json'},
    ),
  );
});

// Secure Storage Provider
final secureStorageProvider =
    Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

// Repository Provider
final authRepositoryProvider =
    Provider<AuthenticationRepository>((ref) {
  return AuthenticationRepository(
    ref.watch(dioProvider),
    ref.watch(secureStorageProvider),
  );
});

// Usecase Provider
final authUseCaseProvider = Provider<AuthUseCases>((ref) {
  return AuthUseCases(ref.watch(authRepositoryProvider));
});

// Auth State Provider (token-based)
final authStateProvider = StreamProvider<bool>((ref) {
  return ref.watch(authUseCaseProvider).authStateChanges();
});

// Controller
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authUseCaseProvider));
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

  Future<void> userSignin(
    String name,
    String email,
    String password,
  ) async {
    state = const AsyncLoading();
    try {
      await useCases.register(name, email, password);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> userLogout() async {
    await useCases.logout();
  }
}
