import 'package:fasionrecommender/controllers/login_page_controller.dart';
import 'package:fasionrecommender/data/notifiers.dart';
import 'package:fasionrecommender/data/responsive_utils.dart';
import 'package:fasionrecommender/services/authenticate/signup_page.dart';
import 'package:fasionrecommender/views/pages/homepage.dart';
import 'package:fasionrecommender/views/widget/appbar.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Popup dialog method
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
                  // Handle navigation to home page after success
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
    double paddingH = ResponsiveUtils.paddingH(context);
    double paddingV = ResponsiveUtils.paddingV(context);
    double titleSize = ResponsiveUtils.titleSize(context);
    double subtitleSize = ResponsiveUtils.subtitleSize(context);
    double inputFontSize = ResponsiveUtils.inputFontSize(context);
    double buttonWidth = ResponsiveUtils.buttonWidth(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: paddingH),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  maxWidth: 500,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: paddingV * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: paddingV * 0.5),
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
                        style: TextStyle(fontSize: subtitleSize),
                      ),
                      SizedBox(height: paddingV * 3),
                      TextField(
                        controller: emailController,
                        style: TextStyle(fontSize: inputFontSize),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail),
                          labelText: 'Enter Your Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: paddingV * 1.5),
                      TextField(
                        controller: passwordController,
                        style: TextStyle(fontSize: inputFontSize),
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          labelText: 'Enter Your Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: paddingV * 0.75),
                      ValueListenableBuilder(
                        valueListenable: isDarkModeNotifier,
                        builder: (
                          BuildContext context,
                          dynamic value,
                          Widget? child,
                        ) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {}, // Add forgot password logic here
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: paddingV * 0.5,
                                  ),
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color:
                                          value ? Colors.white : Colors.black,
                                      fontSize: subtitleSize,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: paddingV * 1.5),
                              Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: buttonWidth,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (emailController.text.isEmpty) {
                                        _showResultDialog(
                                          'Error',
                                          'Please enter your email',
                                        );
                                        return;
                                      }
                                      if (passwordController.text.isEmpty) {
                                        _showResultDialog(
                                          'Error',
                                          'Please enter your password',
                                        );
                                        return;
                                      }

                                      try {
                                        await signInwithEmailAndPassword();

                                        // Directly navigate after successful sign-in
                                        if (context.mounted) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => Home(),
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        // Show error dialog if login fails
                                        String errorMessage;
                                        if (e.toString().contains(
                                          'user-not-found',
                                        )) {
                                          errorMessage =
                                              'No account found with this email.';
                                        } else if (e.toString().contains(
                                          'wrong-password',
                                        )) {
                                          errorMessage =
                                              'Incorrect password. Please try again.';
                                        } else {
                                          errorMessage =
                                              'Login failed: ${e.toString()}';
                                        }
                                        _showResultDialog(
                                          'Error',
                                          errorMessage,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: paddingH,
                                        vertical: paddingV,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor:
                                          value ? Colors.black : Colors.white,
                                    ),
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(
                                        color:
                                            value ? Colors.white : Colors.black,
                                        fontSize: inputFontSize,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: paddingV * 1.5),
                              Center(
                                child: Text(
                                  "Don't Have An Account?",
                                  style: TextStyle(
                                    color: value ? Colors.white : Colors.black,
                                    fontSize: subtitleSize,
                                  ),
                                ),
                              ),
                              SizedBox(height: paddingV * 0.5),
                              Center(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      selectPageNotifier.value = 2;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const SignupPage(),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: paddingV * 0.5,
                                      ),
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color:
                                              value
                                                  ? Colors.white
                                                  : Colors.black,
                                          fontSize: subtitleSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
