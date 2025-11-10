import 'package:book_buddy/core/presentation/riverpod/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).userLogout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: Text('Settings')),
    );
  }
}
