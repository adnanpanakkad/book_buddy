import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  AuthenticationRepository(this._dio, this._storage) {
    _configureDio();
  }

  static const _tokenKey = 'auth_token';
  static const _baseUrl = 'https://ecommerce-app-fultter-api.vercel.app/api';

  // Configure Dio with proper settings
  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        // Accept status codes less than 500
        return status != null && status < 500;
      },
    );

    // Add interceptor for logging and token injection
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add token to requests if available
          final token = await _storage.read(key: _tokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          log('🌐 REQUEST[${options.method}] => ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('✅ RESPONSE[${response.statusCode}] => ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          log('❌ ERROR[${error.response?.statusCode}] => ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  // 🔐 REGISTER (Does NOT store token)
  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      log('📝 Registering user: $email');

      final response = await _dio.post(
        '/auth/register',
        data: {"name": name, "email": email, "password": password},
      );

      // Check if registration was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ Registration successful');
        log('📋 Response: ${response.data}');

        // ⚠️ DO NOT store token after registration
        // User must login separately to get the token stored
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      log('❌ Registration error: ${e.message}');

      if (e.response != null) {
        final message =
            e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Registration failed';
        throw Exception(message);
      } else {
        // Network error or timeout
        throw Exception('Network error. Please check your connection.');
      }
    } catch (e) {
      log('❌ Unexpected error: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  // 🔐 LOGIN (ONLY this stores the token)
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      log('Logging in user: $email');

      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final token = response.data?['data']?['token'];

      if (token == null || token.toString().isEmpty) {
        throw Exception('Token not received from server');
      }

      await _storage.write(key: _tokenKey, value: token);

      log('Login successful, token stored');
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
          e.response?.data?['error'] ??
          'Login failed';

      log('Login error: $message');
      throw Exception(message);
    } catch (e) {
      log('Unexpected login error: $e');
      throw Exception(e.toString());
    }
  }

  // 🚪 LOGOUT
  Future<void> signOut() async {
    try {
      await _storage.delete(key: _tokenKey);
      log('👋 User signed out');
    } catch (e) {
      log('❌ Sign out error: $e');
      throw Exception('Failed to sign out');
    }
  }

  // 🔄 AUTH STATE (token-based)
  Stream<bool> authStateChanges() async* {
    final token = await _storage.read(key: _tokenKey);
    yield token != null;
  }

  // 📱 Get current token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // 🔍 Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null;
  }

  // ---------------- Validators ----------------

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    } else if (!RegExp(
      r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$",
    ).hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
}
