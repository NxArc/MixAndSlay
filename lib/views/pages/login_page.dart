import 'package:fasionrecommender/controllers/login_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:fasionrecommender/data/notifiers.dart';
import 'package:fasionrecommender/views/pages/signup_page.dart';
import 'package:fasionrecommender/views/pages/homepage.dart';

class LoginPage extends StatefulWidget {
  
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;

  void _showResultDialog(
    String title,
    String message, {
    bool isSuccess = false,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => Home()),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<ThemeMode>(
      
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: ThemeData.light().copyWith(
            primaryColor: themeColorNotifier.value,
            scaffoldBackgroundColor: Colors.white,
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: themeColorNotifier.value,
            scaffoldBackgroundColor: Colors.black,
          ),
          home: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Image.asset(
                        themeMode == ThemeMode.dark?
                        'assets/images/logoDark.png' : 'assets/images/logoLight.png', 
                        height: 100,
                      ),
                      
                      const SizedBox(height: 25),
                      Text(
                        'Mix it. Match it. Slay it.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Email Field
                      TextField(
                        controller: emailController,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail),
                          hintText: 'Enter your email',
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Password Field
                      TextField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                          hintText: 'Enter your password',
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Add your logic here
                          },
                          child: const Text(
                            'Forgot password',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Sign In button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (emailController.text.isEmpty) {
                              _showResultDialog('Error', 'Please enter your email');
                              return;
                            }
                            if (passwordController.text.isEmpty) {
                              _showResultDialog('Error', 'Please enter your password');
                              return;
                            }

                            try {
                              await signInwithEmailAndPassword();
                              if (context.mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => Home()),
                                );
                              }
                            } catch (e) {
                              String errorMessage;
                              if (e.toString().contains('user-not-found')) {
                                errorMessage = 'No account found with this email.';
                              } else if (e.toString().contains('wrong-password')) {
                                errorMessage = 'Incorrect password. Please try again.';
                              } else {
                                errorMessage = 'Login failed: ${e.toString()}';
                              }
                              _showResultDialog('Error', errorMessage);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            backgroundColor: themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: themeMode == ThemeMode.dark
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Sign up text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account?",
                            style: TextStyle(
                              color: themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              selectPageNotifier.value = 2;
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const SignupPage()),
                              );
                            },
                            child: Text(
                              'Sign-up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: themeMode == ThemeMode.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
