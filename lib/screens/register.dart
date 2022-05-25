import 'package:arduino_garden/config/config.dart';
import 'package:arduino_garden/config/state_handler.dart';
import 'package:arduino_garden/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  static const String path = '/register';
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
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
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFFFF8E1),
                    border: OutlineInputBorder(),
                    hintText: 'name',
                  ),
                ),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFFFF8E1),
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
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
              MaterialButton(
                color: Colors.pink,
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  try {
                    final token = await api.register(
                      nameController.text,
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
            ],
          ),
        ),
      ),
    );
  }
}
