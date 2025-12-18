import 'package:book_buddy/core/presentation/riverpod/auth_provider.dart';
import 'package:book_buddy/core/presentation/screens/bottombar_screens.dart';
import 'package:book_buddy/core/presentation/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Buddy',
      home: authState.when(
        data: (isLoggedIn) {
          return isLoggedIn ? const BottombarScreens() : RegisterScreen();
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      ),
    );
  }
}
