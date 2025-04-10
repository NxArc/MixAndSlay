import 'package:fasionrecommender/controllers/signup_page_controller.dart';
import 'package:fasionrecommender/data/notifiers.dart';
import 'package:fasionrecommender/views/widget/appbar.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello There!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: Text(
                'Lorem ipsum dolor sit amet',
                style: TextStyle(fontSize: 12),
              ),
            ),

            // Email Field
            TextField(
              controller: signup_emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail),
                labelText: 'Enter Your Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: emailEmpty ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ),
            // Email Error Message (reserved space)
            SizedBox(
              height: 24,
              child: Center(
                child: Text(
                  emailError,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            ),
            // Password Field
            TextField(
              controller: signup_passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Enter Your Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: passwordMismatch ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ),

            SizedBox(height: 24),

            // Confirm Password Field
            TextField(
              controller: confirmpasswordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: passwordMismatch ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ),

            // Password Error Message (reserved space)
            SizedBox(
              height: 24,
              child: Center(
                child: Text(
                  passwordError,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            ),

            ValueListenableBuilder(
              valueListenable: isDarkModeNotifier,
              builder: (BuildContext context, dynamic value, Widget? child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 18),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          if (emailEmpty) {
                            setState(() {
                              emailError = "Please input your email";
                            });
                          } else {
                            emailError = '';
                          }

                          if (passwordMismatch) {
                            setState(() {
                              passwordError = "Passwords didn't match";
                            });
                          } else {
                            passwordError = '';
                          }

                          if (!emailEmpty && !passwordMismatch) {
                            createUserWithEmailAndPassword();
                            passwordError = 'Successfully Signed Up!';
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 120,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: value ? Colors.black : Colors.white,
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: value ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Center(
                      child: Text(
                        "Already Have An Account?",
                        style: TextStyle(
                          color: value ? Colors.black : Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            selectPageNotifier.value = 2;
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: value ? Colors.black : Colors.white,
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
    );
  }
}
