import 'package:arduino_garden/config/config.dart';
import 'package:arduino_garden/config/state_handler.dart';
import 'package:arduino_garden/models/garden.dart';
import 'package:arduino_garden/widgets/grid_card.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CreateGarden extends StatefulWidget {
  const CreateGarden({Key? key}) : super(key: key);

  @override
  State<CreateGarden> createState() => _CreateGardenState();
}

class _CreateGardenState extends State<CreateGarden> {
  @override
  Widget build(BuildContext context) {
    final gardenName = TextEditingController();

    return AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      backgroundColor: Colors.transparent,
      content: GridCard(
        aspectRatio: 3.0 / 3.5,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 18.0),
              child: Text(
                'Create New Garden',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: 60.0, bottom: 8.0, left: 8.0, right: 8.0),
              child: TextField(
                controller: gardenName,
                decoration: const InputDecoration(hintText: 'Garden Name'),
              ),
            ),
            MaterialButton(
              color: Colors.pink,
              child: const Text(
                'Create',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              onPressed: () async {
                Garden garden = await api.createGarden(
                    Provider.of<StateHandler>(context, listen: false).token!,
                    gardenName.text);
                await Provider.of<StateHandler>(context, listen: false)
                    .updateUser();
                FlutterClipboard.copy(garden.gardenToken);
                Fluttertoast.showToast(
                  msg: "Garden token copied to clipoard.",
                  toastLength: Toast.LENGTH_SHORT,
                );

                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
