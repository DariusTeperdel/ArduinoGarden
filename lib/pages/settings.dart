import 'package:arduino_garden/config/state_handler.dart';
import 'package:arduino_garden/popups/create_garden.dart';
import 'package:arduino_garden/popups/list_gardens.dart';
import 'package:arduino_garden/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MaterialButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const ListGardens();
                    });
              },
              color: Colors.pink,
              child: Text(
                'List gardens',
                style: TextStyle(color: Colors.white),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const CreateGarden();
                    });
              },
              color: Colors.pink,
              child: Text(
                'Create garden',
                style: TextStyle(color: Colors.white),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                final route =
                    MaterialPageRoute(builder: (context) => const Login());
                final deleteToken =
                    Provider.of<StateHandler>(context, listen: false)
                        .deleteToken;
                Navigator.of(context)
                    .pushAndRemoveUntil(route, (route) => false);
                await route.didPush();
                await deleteToken();
              },
              color: Colors.pink,
              child: Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
