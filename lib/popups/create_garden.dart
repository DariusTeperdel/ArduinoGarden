import 'package:arduino_garden/config/config.dart';
import 'package:arduino_garden/config/state_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateGarden extends StatelessWidget {
  const CreateGarden({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gardenName = TextEditingController();

    return AlertDialog(
      content: Column(
        children: [
          Text('Garden name'),
          TextField(
            controller: gardenName,
            decoration: const InputDecoration(hintText: 'Garden Name'),
          ),
          MaterialButton(
            color: Colors.blue,
            child: const Text('Create'),
            onPressed: () async {
              try {
                await api.createGarden(
                    Provider.of<StateHandler>(context, listen: false).token!,
                    gardenName.text);
                await Provider.of<StateHandler>(context, listen: false)
                    .updateAll();
                Navigator.of(context).pop();
              } catch (e) {}
            },
          ),
        ],
      ),
    );
  }
}
