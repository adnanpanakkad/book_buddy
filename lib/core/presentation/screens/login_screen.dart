import 'package:book_buddy/core/presentation/riverpod/auth_provider.dart';
import 'package:book_buddy/core/presentation/screens/bottombar_screens.dart';
import 'package:book_buddy/core/presentation/screens/register_screen.dart';
import 'package:book_buddy/core/presentation/widgets/common/custom_snackbar.dart';
import 'package:book_buddy/core/presentation/widgets/common/text_styles.dart';
import 'package:book_buddy/core/presentation/widgets/login/custom_button.dart';
import 'package:book_buddy/core/presentation/widgets/login/custom_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_buddy/core/presentation/screens/home_screen.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final mode = ref.watch(authModeProvider);

    // ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
    //   next.whenOrNull(
    //     data: (_) {
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (_) => const HomeScreen()),
    //       );
    //     },
    //     error: (err, _) {
    //       ScaffoldMessenger.of(
    //         context,
    //       ).showSnackBar(SnackBar(content: Text(err.toString())));
    //     },
    //   );
    // });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 60),
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Mobile login-bro.png'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                mode == AuthMode.login
                    ? "Login to your\nBook Buddy"
                    : "Create your\nBook Buddy Account",
                textAlign: TextAlign.center,
                style: CustomTextStyle.ultraBoldTextstyle,
              ),
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextfield(
                    hintText: "Enter Your Email",
                    controller: emailController,
                    validation: (value) =>
                        ref.read(authRepositoryProvider).validateEmail(value),
                  ),
                  CustomTextfield(
                    hintText: "Enter Your Password",
                    controller: passwordController,
                    validation: (value) => ref
                        .read(authRepositoryProvider)
                        .validatePassword(value),
                  ),
                  const SizedBox(height: 20),
                  authState.isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          text: 'Login',
                          onTap: () async {
                            if (!_formKey.currentState!.validate()) return;

                            // In your UI (LoginScreen or Controller)
                            try {
                              await ref
                                  .read(authUseCaseProvider)
                                  .login(
                                    emailController.text,
                                    passwordController.text,
                                  );

                              if (context.mounted) {
                                CustomSnackbar.show(
                                  context: context,
                                  title: 'Success',
                                  subtitle: 'Login successful',
                                  color: Colors.green,
                                  icon: Icons.check_circle,
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const BottombarScreens(),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                CustomSnackbar.show(
                                  context: context,
                                  title: 'Error',
                                  subtitle: e.toString().replaceFirst(
                                    'Exception: ',
                                    '',
                                  ),
                                  color: Colors.red,
                                  icon: Icons.error,
                                );
                              }
                            }
                          },
                        ),

                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Navigate back to login screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
