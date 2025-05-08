import 'package:fasionrecommender/controllers/signup_page_controller.dart';
import 'package:fasionrecommender/data/notifiers.dart';
import 'package:fasionrecommender/views/pages/login_page.dart';
import 'package:fasionrecommender/views/widgets/global%20widgets/appbar.dart';
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
  bool isEmailValid = true;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

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
    double paddingH = ResponsiveUtils.paddingH(context);
    double paddingV = ResponsiveUtils.paddingV(context);
    double titleSize = ResponsiveUtils.titleSize(context);
    double subtitleSize = ResponsiveUtils.subtitleSize(context);
    double inputFontSize = ResponsiveUtils.inputFontSize(context);
    double buttonWidth = ResponsiveUtils.buttonWidth(context);

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color primaryColor = isDarkMode ? Colors.white : Colors.black;
    Color errorColor = Colors.red;
    Color textFieldBorderColor = Colors.grey;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //const Icon(Icons.waving_hand_outlined, size: 32),
                      //SizedBox(height: paddingV * 0.5),

                      // Title
                      Text(
                        'Hello There!',
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),

                      SizedBox(height: paddingV * 0.25),

                      // Subtitle
                      Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
                        style: TextStyle(
                          fontSize: subtitleSize,
                          color: primaryColor,
                        ),
                      ),

                      SizedBox(height: paddingV * 2.5),

                      // Email
                      TextField(
                        controller: signup_emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail, color: primaryColor),
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            emailEmpty = value.isEmpty;
                            isEmailValid = _isValidEmail(value);
                          });
                        },
                      ),
                      SizedBox(height: paddingV * 0.25),
                      if (emailEmpty || !isEmailValid)
                        Text(
                          emailEmpty ? 'Email cannot be empty' : 'Invalid email format',
                          style: TextStyle(color: errorColor, fontSize: subtitleSize),
                        ),
                      SizedBox(height: paddingV * 1.5),

                      // Password
                      TextField(
                        controller: signup_passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: primaryColor),
                          hintText: 'Enter password',
                          hintStyle: TextStyle(color: primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            passwordMismatch = value != confirmpasswordController.text;
                          });
                        },
                      ),
                      SizedBox(height: paddingV),

                      // Confirm Password
                      TextField(
                        controller: confirmpasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline, color: primaryColor),
                          hintText: 'Confirm password',
                          hintStyle: TextStyle(color: primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            passwordMismatch = value != signup_passwordController.text;
                          });
                        },
                      ),
                      SizedBox(height: paddingV),
                      if (passwordMismatch)
                        Text(
                          'Passwords do not match',
                          style: TextStyle(color: errorColor, fontSize: subtitleSize),
                        ),

                      // Sign Up Button
                      SizedBox(height: paddingV),
                      Center(
                        child: SizedBox(
                          width: buttonWidth,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                emailEmpty = signup_emailController.text.isEmpty;
                                passwordMismatch =
                                    signup_passwordController.text != confirmpasswordController.text;
                              });

                              if (emailEmpty) {
                                _showResultDialog('Error', 'Please input your email');
                              } else if (!isEmailValid) {
                                _showResultDialog('Error', 'Please enter a valid email');
                              } else if (signup_passwordController.text.isEmpty) {
                                _showResultDialog('Error', 'Please enter a password');
                              } else if (passwordMismatch) {
                                _showResultDialog('Error', 'Passwords do not match');
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: isDarkMode ? Colors.black : Colors.white,
                                fontSize: inputFontSize,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Sign In Option
                      SizedBox(height: paddingV * 2),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: TextStyle(color: primaryColor),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Sign-in',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  //decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
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
