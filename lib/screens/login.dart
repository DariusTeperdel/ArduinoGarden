import 'package:arduino_garden/config/config.dart';
import 'package:arduino_garden/config/state_handler.dart';
import 'package:arduino_garden/screens/homescreen.dart';
import 'package:arduino_garden/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  static const String path = '/login';
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.pink.shade600,
            Colors.amber.shade900,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(30),
                child: const Text(
                  'ArduinoGarden',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 42,
                  ),
                ),
              ),
              const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFFFF8E1),
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                  ),
                ),
              ),
              Container(
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFFFF8E1),
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                ),
              ),
              Container(
                child: MaterialButton(
                  color: Colors.pink,
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    try {
                      final token = await api.authenticate(
                        emailController.text,
                        passwordController.text,
                      );
                      await Provider.of<StateHandler>(context, listen: false)
                          .updateToken(token);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          HomeScreen.path, (route) => false);
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ),
              Container(
                child: MaterialButton(
                  color: Colors.pink,
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      Register.path,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
