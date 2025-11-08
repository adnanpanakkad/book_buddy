import 'package:book_buddy/core/presentation/riverpod/auth_provider.dart';
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

    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      next.when(
        data: (_) {
          if (mode == AuthMode.login) {
            // Login successful - navigate to home screen
            CustomSnackbar.show(
              context: context,
              title: 'Success',
              subtitle: 'Login successful!',
              color: Colors.green,
              icon: Icons.check_circle,
            );
            
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            }
          } else {
            // Signup successful - switch to login mode
            CustomSnackbar.show(
              context: context,
              title: 'Success',
              subtitle: 'Account created! Please login.',
              color: Colors.green,
              icon: Icons.check_circle,
            );
            
            // Clear text fields
            emailController.clear();
            passwordController.clear();
            
            // Switch to login mode
            ref.read(authModeProvider.notifier).state = AuthMode.login;
          }
        },
        error: (error, _) {
          CustomSnackbar.show(
            context: context,
            title: 'Error',
            subtitle: mode == AuthMode.login
                ? 'Please check the email & password'
                : 'Failed to create account. Try again.',
            color: Colors.red,
            icon: Icons.error,
          );
        },
        loading: () {},
      );
    });

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
                    ? "Login to your\nAdmin"
                    : "Create your\nAdmin Account",
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
                    validation:
                        (value) => ref
                            .read(authRepositoryProvider)
                            .validateEmail(value),
                  ),
                  CustomTextfield(
                    hintText: "Enter Your Password",
                    controller: passwordController,
                    validation:
                        (value) => ref
                            .read(authRepositoryProvider)
                            .validatePassword(value),
                  ),
                  const SizedBox(height: 20),
                  authState.isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                        text: mode == AuthMode.login ? 'Login' : 'Sign Up',
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            if (mode == AuthMode.login) {
                              await ref
                                  .read(authControllerProvider.notifier)
                                  .login(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                            } else {
                              await ref
                                  .read(authControllerProvider.notifier)
                                  .signin(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  );
                            }
                          }
                        },
                      ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Clear fields when switching modes
                      emailController.clear();
                      passwordController.clear();
                      
                      ref.read(authModeProvider.notifier).state =
                          mode == AuthMode.login
                              ? AuthMode.signup
                              : AuthMode.login;
                    },
                    child: Text(
                      mode == AuthMode.login
                          ? "Don't have an account? Sign Up"
                          : "Already have an account? Login",
                      style: const TextStyle(
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