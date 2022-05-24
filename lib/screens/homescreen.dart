import 'package:arduino_garden/config/state_handler.dart';
import 'package:arduino_garden/models/garden.dart';
import 'package:arduino_garden/pages/graph.dart';
import 'package:arduino_garden/pages/schedule.dart';
import 'package:arduino_garden/pages/stats.dart';
import 'package:arduino_garden/pages/settings.dart';
import 'package:arduino_garden/popups/create_garden.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String path = '/homescreen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;

  static List pages = [
    StatsPage(),
    GraphPage(),
    SchedulePage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    Provider.of<StateHandler>(context, listen: false).updateUser();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Provider.of<StateHandler>(context).currentGarden == null
              ? "Arduino Garden"
              : Provider.of<StateHandler>(context).currentGarden!.name,
        ),
        actions: [
          if (Provider.of<StateHandler>(context).gardens.isNotEmpty) ...[
            PopupMenuButton(
              itemBuilder: ((context) {
                List<Garden> gardens =
                    Provider.of<StateHandler>(context, listen: false).gardens;
                List<PopupMenuItem> items = [];
                for (var i = 0; i < gardens.length; i++) {
                  items.add(
                    PopupMenuItem(
                      value: i,
                      child: Text(gardens[i].name),
                    ),
                  );
                }
                return items;
              }),
              icon: Icon(Icons.arrow_drop_down),
              onSelected: (newGarden) {
                setState(() {
                  Provider.of<StateHandler>(context, listen: false)
                      .setCurrentGarden(
                          Provider.of<StateHandler>(context, listen: false)
                              .gardens[newGarden as int]);
                  Provider.of<StateHandler>(context, listen: false)
                      .setGardenIndex(newGarden);
                });
              },
            ),
          ] else ...[
            MaterialButton(
              onPressed: () async {
                setState(() {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const CreateGarden();
                    },
                  );
                });
              },
              child: Text('+'),
            ),
          ]
        ],
      ),
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Graphs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Schedule",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        currentIndex: currentPage,
        onTap: (newIndex) => setState(() => currentPage = newIndex),
      ),
    );
  }
}
