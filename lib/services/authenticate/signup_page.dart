import 'package:fasionrecommender/controllers/signup_page_controller.dart';
import 'package:fasionrecommender/data/notifiers.dart';
import 'package:fasionrecommender/services/authenticate/login_page.dart';
import 'package:fasionrecommender/views/widget/appbar.dart';
import 'package:fasionrecommender/data/responsive_utils.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController confirmpasswordController = TextEditingController();
  String passwordError = '';
  String emailError = '';
  bool passwordMismatch = false;
  bool emailEmpty = false;

  void _showResultDialog(String title, String message, {bool isSuccess = false}) {
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
                    MaterialPageRoute(builder: (context) => LoginPage()),
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
    // Responsive padding and size from utility
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
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        'Hello There!',
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: paddingV * 0.5),
                      // Subtitle
                      Text(
                        'Lorem ipsum dolor sit amet',
                        style: TextStyle(fontSize: subtitleSize),
                      ),
                      SizedBox(height: paddingV * 3),

                      // Email Field
                      TextField(
                        controller: signup_emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail),
                          labelText: 'Enter Your Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: emailEmpty ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            emailEmpty = value.isEmpty;
                          });
                        },
                      ),
                      SizedBox(
                        height: paddingV,
                        child: Center(
                          child: Text(
                            emailError,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: subtitleSize,
                            ),
                          ),
                        ),
                      ),

                      // Password Field
                      TextField(
                        controller: signup_passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          labelText: 'Enter Your Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: passwordMismatch ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            passwordMismatch = value != confirmpasswordController.text;
                          });
                        },
                      ),
                      SizedBox(height: paddingV),
                      // Confirm Password Field
                      TextField(
                        controller: confirmpasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: passwordMismatch ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            passwordMismatch = value != signup_passwordController.text;
                          });
                        },
                      ),
                      SizedBox(height: paddingV),
                      SizedBox(
                        height: 24,
                        child: Center(
                          child: Text(
                            passwordError,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: subtitleSize,
                            ),
                          ),
                        ),
                      ),

                      // Signup Button and Navigation
                      Center(
                        child: ValueListenableBuilder(
                          valueListenable: isDarkModeNotifier,
                          builder: (BuildContext context, dynamic value, Widget? child) {
                            return Column(
                              children: [
                                SizedBox(height: paddingV),
                                SizedBox(
                                  width: buttonWidth,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        emailEmpty = signup_emailController.text.isEmpty;
                                        passwordMismatch = signup_passwordController.text !=
                                            confirmpasswordController.text;
                                      });

                                      if (emailEmpty) {
                                        _showResultDialog('Error', 'Please input your email');
                                      } else if (passwordMismatch) {
                                        _showResultDialog('Error', 'Passwords do not match');
                                      } else if (signup_passwordController.text.isEmpty) {
                                        _showResultDialog('Error', 'Please enter a password');
                                      } else {
                                        createUserWithEmailAndPassword().then((_) {
                                          _showResultDialog('Success', 'Successfully Signed Up!',
                                              isSuccess: true);
                                        }).catchError((error) {
                                          _showResultDialog('Error', 'Signup failed: ${error.toString()}');
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: paddingH * 2,
                                        vertical: paddingV,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      backgroundColor: value ? Colors.white : Colors.black,
                                    ),
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: value ? Colors.black : Colors.white,
                                        fontSize: inputFontSize,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: paddingV * 2),
                                Text(
                                  "Already Have An Account?",
                                  style: TextStyle(
                                    color: value ? Colors.white : Colors.black,
                                    fontSize: subtitleSize,
                                  ),
                                ),
                                SizedBox(height: paddingV),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: paddingV),
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: value ? Colors.white : Colors.black,
                                          fontSize: subtitleSize,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
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
