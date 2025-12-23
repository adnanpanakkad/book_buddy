import 'package:book_buddy/core/presentation/riverpod/auth_provider.dart';
import 'package:book_buddy/core/presentation/screens/login_screen.dart';
import 'package:book_buddy/core/presentation/widgets/common/custom_snackbar.dart';
import 'package:book_buddy/core/presentation/widgets/common/text_styles.dart';
import 'package:book_buddy/core/presentation/widgets/login/custom_button.dart';
import 'package:book_buddy/core/presentation/widgets/login/custom_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerWidget {
  RegisterScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    // ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
    //   next.when(
    //     data: (_) {
    //       // Registration successful - show message and navigate back to login
    //       CustomSnackbar.show(
    //         context: context,
    //         title: 'Success',
    //         subtitle: 'Account created! Please login.',
    //         color: Colors.green,
    //         icon: Icons.check_circle,
    //       );

    //       // Clear text fields
    //       nameController.clear();
    //       emailController.clear();
    //       passwordController.clear();

    //       // Navigate back to login screen
    //       if (context.mounted) {
    //         Navigator.pop(context);
    //       }
    //     },
    //     error: (error, _) {
    //       CustomSnackbar.show(
    //         context: context,
    //         title: 'Error',
    //         subtitle: error.toString().replaceFirst('Exception: ', ''),
    //         color: Colors.red,
    //         icon: Icons.error,
    //       );
    //     },
    //     loading: () {},
    //   );
    // });

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back, color: Colors.black),
        //     onPressed: () => Navigator.pop(context),
        //   ),
        // ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
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
                "Create your\nBook Buddy Account",
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
                    hintText: "Enter Your Name",
                    controller: nameController,
                    validation: (value) =>
                        ref.read(authRepositoryProvider).validateName(value),
                  ),
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
                          text: 'Sign Up',
                          // onTap: () async {
                          //   if (_formKey.currentState!.validate()) {
                          //     await ref
                          //         .read(authControllerProvider.notifier)
                          //         .userSignin(
                          //           nameController.text.trim(),
                          //           emailController.text.trim(),
                          //           passwordController.text.trim(),
                          //         );
                          //   }
                          // },
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                await ref
                                    .read(authControllerProvider.notifier)
                                    .userSignin(
                                      nameController.text.trim(),
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    );

                                // Show success snackbar
                                if (context.mounted) {
                                  CustomSnackbar.show(
                                    context: context,
                                    title: 'Success',
                                    subtitle:
                                        'Registration successful! Please login.',
                                    color: Colors.green,
                                    icon: Icons.check_circle,
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
                            }
                          },
                        ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Navigate back to login screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Already have an account? Login",
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
