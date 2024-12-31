import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/intro_page.dart';
import 'package:flutter_application_1/screens/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  String registeredUsername = '';
  String registeredPassword = '';

  void login() {
    if (usernameController.text == registeredUsername &&
        passwordController.text == registeredPassword) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => IntroPage(username: registeredUsername)),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('Invalid credentials'),
          actions: [
            TextButton(
              child: Text('Okay'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      );
    }
  }

  void navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Register(onRegister: (username, password) {
          setState(() {
            registeredUsername = username;
            registeredPassword = password;
          });
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Center(
          child: Text(
            "Login Page",
            style: TextStyle(
                fontSize: 24,
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontFamily: 'poppins'),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              const Text('Welcome Back'),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              color: Colors.grey, width: 1.0))),
                  child: const Text(
                    'login',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontFamily: 'poppins'),
                  ),
                  onPressed: login,
                ),
              ),
              const Text(
                'Don\'t have an account?',
                style: TextStyle(
                  color: Color.fromARGB(255, 26, 153, 188),
                ),
              ),
              GestureDetector(
                onTap: navigateToRegister,
                child: const Text(
                  'Register here',
                  style: TextStyle(
                    color: Colors.deepOrange,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
