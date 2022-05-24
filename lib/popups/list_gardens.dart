import 'package:arduino_garden/config/config.dart';
import 'package:arduino_garden/config/state_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListGardens extends StatefulWidget {
  const ListGardens({Key? key}) : super(key: key);

  @override
  State<ListGardens> createState() => _ListGardensState();
}

class _ListGardensState extends State<ListGardens> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(Provider.of<StateHandler>(context).gardens[index].name),
                Row(
                  children: [
                    MaterialButton(
                      onPressed: () async {
                        await api.deleteGarden(
                          Provider.of<StateHandler>(context, listen: false)
                              .token!,
                          Provider.of<StateHandler>(context, listen: false)
                              .gardens[index]
                              .id,
                        );
                        Provider.of<StateHandler>(context, listen: false)
                            .updateUser();
                        Provider.of<StateHandler>(context, listen: false)
                            .setGardenIndex(0);
                        Provider.of<StateHandler>(context, listen: false)
                            .setCurrentGarden(Provider.of<StateHandler>(context,
                                    listen: false)
                                .gardens[0]);
                        Navigator.of(context).pop();
                      },
                      child: Text('delete'),
                      color: Colors.blue,
                    ),
                    MaterialButton(
                      onPressed: () {},
                      child: Text('link'),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            );
          },
          itemCount: Provider.of<StateHandler>(context).gardens.length,
        ),
      ),
    );
  }
}
