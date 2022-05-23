import 'package:arduino_garden/screens/homescreen.dart';
import 'package:arduino_garden/screens/login.dart';
import 'package:arduino_garden/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/state_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(FutureBuilder<StateHandler>(
    future: StateHandler.fetchToken(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container(
          color: Colors.pink,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (snapshot.hasError) {
        return Container(
          color: Colors.pink,
          child: Center(
            child: Text(
              //TODO: Prettify
              'A network error occured, check your connection and restart the app.\n\n' +
                  snapshot.error!.toString(),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      return ChangeNotifierProvider.value(
        value: snapshot.data,
        child: MyApp(),
      );
    },
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arduino Garden',
      routes: {
        Login.path: (context) => const Login(),
        Register.path: (context) => const Register(),
        HomeScreen.path: (context) => const HomeScreen(),
      },
      theme: ThemeData(
        // useMaterial3: true,
        primarySwatch: Colors.pink,
        //appBarTheme: Colors.pink.shade200,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 233, 30, 99),
          selectedItemColor: Color.fromARGB(220, 251, 251, 243),
          unselectedItemColor: Color.fromARGB(204, 61, 61, 61),
          elevation: 20,
          // showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
      initialRoute:
          Provider.of<StateHandler>(context, listen: false).token != null
              ? HomeScreen.path
              : Login.path,
    );
  }
}
