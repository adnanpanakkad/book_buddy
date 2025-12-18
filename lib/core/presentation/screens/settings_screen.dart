import 'package:book_buddy/core/presentation/riverpod/auth_provider.dart';
import 'package:book_buddy/core/presentation/screens/login_screen.dart';
import 'package:book_buddy/core/presentation/widgets/common/custom_snackbar.dart';
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
              CustomSnackbar.show(
                context: context,
                title: 'Logout',
                subtitle: ' logged out successfully.',
                color: Colors.red,
                icon: Icons.logout,
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: Text('Settings')),
    );
  }
}
