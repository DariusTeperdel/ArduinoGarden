import 'dart:async';

import 'package:arduino_garden/color_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'grid_card.dart';
import 'network.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arduino Garden',
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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  String selectedGarden;

  static List<Widget> pages = [
    const MainPage(),
    const GraphsPage(),
    const SchedulePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedGarden ?? "Arduino Garden"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "garden 1",
                child: Text("garden 1"),
              ),
              const PopupMenuItem(
                value: "garden 2",
                child: Text("garden 2"),
              ),
            ],
            icon: Icon(Icons.arrow_drop_down),
            onSelected: (newGarden) {
              setState(() {
                selectedGarden = newGarden;
              });
            },
          ),
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

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  bool disposed = false;
  Timer refreshTimer;
  Timer pumpImageTimer;
  Timer deviceImageTimer;
  Timer restartTimer;
  StreamController<int> tempStreamController;
  StreamController<int> humidityStreamController;
  StreamController<int> lightIntensityStreamController;
  StreamController<bool> pumpStreamController;
  Stream<int> tempStream;
  Stream<int> humidityStream;
  Stream<int> lightIntensityStream;
  Stream<bool> pumpStream;
  bool pumpState = false;
  bool lightsState = false;
  bool rgbStatus = false;
  int rgbMode = 0;
  int pumpImage = 0;
  int deviceImage = 0;
  final int deviceImageCount = 6;
  final int pumpImageCount = 6;
  int arduinoLastActive = 60;
  Color rgbColor = Colors.green.withAlpha(255);
  AnimationController rainbowAnimationController;
  AnimationController bounceAnimationController;

  Widget get rgbModeIcon {
    switch (rgbMode) {
      case 0:
        return Icon(Icons.wb_iridescent);
      case 1:
        return Image.asset(
          "assets/rainbow.png",
          alignment: Alignment.center,
        );
      case 2:
        return Icon(Icons.blur_linear);
      default:
        return null;
    }
  }

  bool get arduinoOnline {
    return arduinoLastActive < 30;
  }

  void delayedStartRefreshTimer() {
    restartTimer?.cancel();
    restartTimer = Timer(const Duration(seconds: 2), () {
      if (!disposed) startRefreshTimer();
    });
  }

  void pauseRefreshTimer() {
    refreshTimer?.cancel();
    delayedStartRefreshTimer();
  }

  void startRefreshTimer() {
    refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getDataField("temperature")
          .then((value) => tempStreamController.sink.add(value));
      getDataField("pump")
          .then((value) => pumpStreamController.sink.add(value != 0));
      getDataField("humidity")
          .then((value) => humidityStreamController.sink.add(value));
      getDataField("lightIntensity")
          .then((value) => lightIntensityStreamController.sink.add(value));
      getTimeField("lastOnline").then((value) {
        setState(() {
          arduinoLastActive = value;
        });
      });

      getDataStringField("rgbColor").then((value) {
        final rgb = value.split(",").map((e) => int.parse(e)).toList();
        setState(() {
          rgbColor = Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1);
        });
      });

      getDataField("rgbStatus").then((value) {
        setState(() {
          rgbStatus = value != 0;
        });
      });

      getDataField("rgbMode").then((value) {
        setState(() {
          rgbMode = value;
        });
      });

      getDataField("lights").then((value) {
        setState(() {
          lightsState = value != 0;
        });
      });
    });
  }

  void initialAssetLoad(BuildContext context) {
    precacheImage(AssetImage("assets/base.png"), context);
    precacheImage(AssetImage("assets/device off.png"), context);
    precacheImage(AssetImage("assets/device on 0.png"), context);
    precacheImage(AssetImage("assets/device on 1.png"), context);
    precacheImage(AssetImage("assets/device on 2.png"), context);
    precacheImage(AssetImage("assets/device on 3.png"), context);
    precacheImage(AssetImage("assets/device on 4.png"), context);
    precacheImage(AssetImage("assets/device on 5.png"), context);
    precacheImage(AssetImage("assets/pump on 0.png"), context);
    precacheImage(AssetImage("assets/pump on 1.png"), context);
    precacheImage(AssetImage("assets/pump on 2.png"), context);
    precacheImage(AssetImage("assets/pump on 3.png"), context);
    precacheImage(AssetImage("assets/pump on 4.png"), context);
    precacheImage(AssetImage("assets/pump on 5.png"), context);
    precacheImage(AssetImage("assets/pump off.png"), context);
    precacheImage(AssetImage("assets/light on.png"), context);
    precacheImage(AssetImage("assets/light off.png"), context);
    precacheImage(AssetImage("assets/rgb off.png"), context);
    precacheImage(AssetImage("assets/rgb on.png"), context);
    precacheImage(AssetImage("assets/logo transparent.png"), context);
    precacheImage(AssetImage("assets/rainbow.png"), context);
  }

  @override
  void initState() {
    rainbowAnimationController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    );
    rainbowAnimationController.repeat();

    bounceAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    bounceAnimationController.repeat(reverse: true);

    tempStreamController = StreamController();
    humidityStreamController = StreamController();
    lightIntensityStreamController = StreamController();
    pumpStreamController = StreamController();
    tempStream = tempStreamController.stream.asBroadcastStream();
    humidityStream = humidityStreamController.stream.asBroadcastStream();
    lightIntensityStream =
        lightIntensityStreamController.stream.asBroadcastStream();
    pumpStream = pumpStreamController.stream.asBroadcastStream();

    pumpStream.listen((event) {
      setState(() {
        pumpState = event;
      });
    });

    startRefreshTimer();

    pumpImageTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      pumpImage = (pumpImage + 1) % pumpImageCount;
      if (pumpState) {
        setState(() {});
      } else {
        pumpImage = 0;
      }
    });

    deviceImageTimer =
        Timer.periodic(const Duration(milliseconds: 200), (timer) {
      deviceImage = (deviceImage + 1) % deviceImageCount;
      if (arduinoOnline) {
        setState(() {});
      } else {
        deviceImage = 0;
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    initialAssetLoad(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    disposed = true;
    refreshTimer.cancel();
    restartTimer?.cancel();
    pumpImageTimer.cancel();
    deviceImageTimer.cancel();
    tempStreamController.close();
    pumpStreamController.close();
    humidityStreamController.close();
    lightIntensityStreamController.close();
    rainbowAnimationController.dispose();
    bounceAnimationController.dispose();
    super.dispose();
  }

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
      child: Center(
        child: ListView(
          children: <Widget>[
            GridCard(
              aspectRatio: 3.0 / 2.0,
              child: FittedBox(
                child: Container(
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/base.png",
                        alignment: Alignment.center,
                      ),
                      if (lightsState)
                        Image.asset(
                          "assets/light on.png",
                          alignment: Alignment.center,
                        ),
                      if (!lightsState)
                        Image.asset(
                          "assets/light off.png",
                          alignment: Alignment.center,
                        ),
                      if (!pumpState)
                        Image.asset(
                          "assets/pump off.png",
                          alignment: Alignment.center,
                        ),
                      if (pumpState)
                        Image.asset(
                          "assets/pump on $pumpImage.png",
                          alignment: Alignment.center,
                        ),
                      if (arduinoOnline)
                        Image.asset(
                          "assets/device on $deviceImage.png",
                          alignment: Alignment.center,
                        ),
                      if (!arduinoOnline)
                        Image.asset(
                          "assets/device off.png",
                          alignment: Alignment.center,
                        ),
                      Image.asset(
                        "assets/rgb off.png",
                        alignment: Alignment.center,
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 400),
                        opacity: rgbStatus ? 1 : 0,
                        child: rgbMode == 1
                            ? AnimatedBuilder(
                                animation: rainbowAnimationController,
                                builder: (context, child) {
                                  return ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                        HSVColor.fromAHSV(
                                                1,
                                                rainbowAnimationController
                                                        .value *
                                                    360,
                                                1,
                                                1)
                                            .toColor(),
                                        BlendMode.srcATop),
                                    child: child,
                                  );
                                },
                                child: Image.asset(
                                  "assets/rgb on.png",
                                  alignment: Alignment.center,
                                ),
                              )
                            : rgbMode == 2
                                ? AnimatedBuilder(
                                    animation: bounceAnimationController,
                                    builder: (context, child) {
                                      return ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                            HSVColor.fromAHSV(
                                                    1,
                                                    bounceAnimationController
                                                                .value *
                                                            30 +
                                                        HSVColor.fromColor(
                                                                rgbColor)
                                                            .hue,
                                                    1,
                                                    1)
                                                .toColor(),
                                            BlendMode.srcATop),
                                        child: child,
                                      );
                                    },
                                    child: Image.asset(
                                      "assets/rgb on.png",
                                      alignment: Alignment.center,
                                    ),
                                  )
                                : ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                        rgbColor, BlendMode.srcATop),
                                    child: Image.asset(
                                      "assets/rgb on.png",
                                      alignment: Alignment.center,
                                    ),
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Table(
              defaultColumnWidth: FlexColumnWidth(),
              children: [
                TableRow(
                  children: [
                    GridCardButton(
                      rounded: false,
                      alpha: arduinoOnline ? 220 : 180,
                      icon: Icon(arduinoOnline ? Icons.wifi : Icons.wifi_off),
                      enabled: arduinoOnline,
                      iconColor: Colors.green,
                    ),
                    GridCardButton(
                      icon: Icon(Icons.invert_colors),
                      onTap: () {
                        pauseRefreshTimer();
                        changePump(!pumpState);
                      },
                      alpha: pumpState ? 255 : 180,
                      enabled: pumpState,
                      iconColor: Colors.blue,
                    ),
                    GridCardButton(
                      icon: Icon(lightsState
                          ? Icons.lightbulb
                          : Icons.lightbulb_outline),
                      onTap: () {
                        pauseRefreshTimer();
                        changeLights(!lightsState);
                      },
                      alpha: lightsState ? 255 : 180,
                      enabled: lightsState,
                      iconColor: Colors.yellow.shade600,
                    ),
                    Hero(
                      tag: "rgbButton",
                      child: GridCardButton(
                        icon: rgbModeIcon,
                        enabled: rgbStatus,
                        iconColor: rgbColor,
                        alpha: rgbStatus ? 255 : 180,
                        onTap: () {
                          pauseRefreshTimer();
                          changeRgbStatus(!rgbStatus);
                        },
                        onLongPress: () async {
                          final newColor = await Navigator.of(context).push(
                              PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 300),
                                  fullscreenDialog: true,
                                  opaque: false,
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return ColorPickerPage(
                                      initialIcon: rgbModeIcon,
                                      rgbColor: rgbColor,
                                      rgbStatus: rgbStatus,
                                    );
                                  }));
                          setState(() {
                            rgbColor = newColor;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: StreamBuilder<int>(
                      stream: tempStream,
                      initialData: 0,
                      builder: (context, snapshot) {
                        return GridCard(
                          backgroundColor: Colors.amber.shade50,
                          child: Stack(children: [
                            SfRadialGauge(
                                key: Key("temperatureGauge"),
                                title: GaugeTitle(text: "Temperature"),
                                axes: [
                                  RadialAxis(
                                      startAngle: 150,
                                      endAngle: 30,
                                      minimum: -20,
                                      maximum: 60,
                                      ranges: [
                                        GaugeRange(
                                            startValue: -20,
                                            endValue: 0,
                                            color: Colors.cyan.shade200),
                                        GaugeRange(
                                            startValue: 0,
                                            endValue: 20,
                                            color: Colors.lightBlue.shade600),
                                        GaugeRange(
                                            startValue: 20,
                                            endValue: 35,
                                            color: Colors.green.shade400),
                                        GaugeRange(
                                            startValue: 35,
                                            endValue: 45,
                                            color: Colors.orange.shade400),
                                        GaugeRange(
                                            startValue: 45,
                                            endValue: 60,
                                            color: Colors.red.shade500),
                                      ],
                                      pointers: [
                                        NeedlePointer(
                                            animationDuration: 1000,
                                            enableAnimation: true,
                                            value:
                                                snapshot.data?.toDouble() ?? 0,
                                            needleLength: 0.45,
                                            gradient: LinearGradient(colors: [
                                              Colors.deepPurple.shade900,
                                              Colors.pink.shade200,
                                            ]))
                                      ])
                                ]),
                            Positioned(
                              child: Text(
                                "${snapshot.data}°C",
                                textAlign: TextAlign.center,
                              ),
                              bottom: 20,
                              left: 0,
                              right: 0,
                            ),
                          ]),
                        );
                      }),
                ),
                Expanded(
                  child: StreamBuilder<int>(
                      initialData: 0,
                      stream: humidityStream,
                      builder: (context, snapshot) {
                        return GridCard(
                          backgroundColor: Colors.amber.shade50,
                          child: Stack(
                            children: [
                              SfRadialGauge(
                                  key: Key("humidityGauge"),
                                  title: GaugeTitle(text: "Humidity"),
                                  axes: [
                                    RadialAxis(
                                        startAngle: 150,
                                        endAngle: 30,
                                        minimum: 0,
                                        maximum: 100,
                                        ranges: [
                                          GaugeRange(
                                            startValue: 0,
                                            endValue: 60,
                                            gradient: SweepGradient(
                                              colors: [
                                                Colors.orange.shade900,
                                                Colors.orange.shade200,
                                              ],
                                            ),
                                          ),
                                          GaugeRange(
                                            startValue: 60,
                                            endValue: 80,
                                            gradient: SweepGradient(
                                              colors: [
                                                Colors.orange.shade200,
                                                Colors.lightBlue.shade400,
                                              ],
                                            ),
                                          ),
                                          GaugeRange(
                                            startValue: 80,
                                            endValue: 100,
                                            gradient: SweepGradient(
                                              colors: [
                                                Colors.lightBlue.shade400,
                                                Colors.blue.shade800,
                                              ],
                                            ),
                                          ),
                                        ],
                                        pointers: [
                                          NeedlePointer(
                                              animationDuration: 1000,
                                              enableAnimation: true,
                                              value:
                                                  snapshot.data?.toDouble() ??
                                                      0,
                                              needleLength: 0.45,
                                              gradient: LinearGradient(colors: [
                                                Colors.deepPurple.shade900,
                                                Colors.pink.shade200,
                                              ]))
                                        ])
                                  ]),
                              Positioned(
                                child: Text(
                                  "${snapshot.data}%",
                                  textAlign: TextAlign.center,
                                ),
                                bottom: 20,
                                left: 0,
                                right: 0,
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: StreamBuilder<int>(
                    initialData: 0,
                    stream: lightIntensityStream,
                    builder: (context, snapshot) {
                      return GridCard(
                        backgroundColor: Colors.amber.shade50,
                        child: Stack(
                          children: [
                            SfRadialGauge(
                                key: Key("intensityGauge"),
                                title: GaugeTitle(text: "Light Intensity"),
                                axes: [
                                  RadialAxis(
                                      startAngle: 150,
                                      endAngle: 30,
                                      minimum: 0,
                                      maximum: 100,
                                      ranges: [
                                        GaugeRange(
                                          startValue: 0,
                                          endValue: 100,
                                          gradient: SweepGradient(
                                            colors: [
                                              Colors.blueGrey.shade900,
                                              Colors.yellow.shade400,
                                            ],
                                          ),
                                        ),
                                      ],
                                      pointers: [
                                        NeedlePointer(
                                            animationDuration: 1000,
                                            enableAnimation: true,
                                            value:
                                                snapshot.data?.toDouble() ?? 0,
                                            needleLength: 0.45,
                                            gradient: LinearGradient(colors: [
                                              Colors.deepPurple.shade900,
                                              Colors.pink.shade200,
                                            ]))
                                      ])
                                ]),
                            Positioned(
                              child: Text(
                                "${snapshot.data}%",
                                textAlign: TextAlign.center,
                              ),
                              bottom: 20,
                              left: 0,
                              right: 0,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder<int>(
                    initialData: 0,
                    stream: lightIntensityStream,
                    builder: (context, snapshot) {
                      return GridCard(
                        backgroundColor: Colors.amber.shade50,
                        child: Stack(
                          children: [
                            SfRadialGauge(
                                key: Key("SolarProduction"),
                                title: GaugeTitle(text: "Solar Power"),
                                axes: [
                                  RadialAxis(
                                      startAngle: 150,
                                      endAngle: 30,
                                      minimum: 0,
                                      maximum: 100,
                                      ranges: [
                                        GaugeRange(
                                          startValue: 0,
                                          endValue: 100,
                                          gradient: SweepGradient(
                                            colors: [
                                              Color.fromARGB(255, 15, 72, 84),
                                              Color.fromARGB(255, 44, 189, 99),
                                            ],
                                          ),
                                        ),
                                      ],
                                      pointers: [
                                        NeedlePointer(
                                            animationDuration: 1000,
                                            enableAnimation: true,
                                            value:
                                                snapshot.data?.toDouble() ?? 0,
                                            needleLength: 0.45,
                                            gradient: LinearGradient(colors: [
                                              Colors.deepPurple.shade900,
                                              Colors.pink.shade200,
                                            ]))
                                      ])
                                ]),
                            Positioned(
                              child: Text(
                                "${snapshot.data}V",
                                textAlign: TextAlign.center,
                              ),
                              bottom: 20,
                              left: 0,
                              right: 0,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void changePump(bool newVal) {
    pumpStreamController.sink.add(newVal);
    setDataField("pump", newVal ? 1 : 0);
  }

  void changeLights(bool newVal) {
    setState(() {
      lightsState = newVal;
    });
    setDataField("lights", newVal ? 1 : 0);
  }

  void changeRgbStatus(bool newVal) {
    setState(() {
      rgbStatus = newVal;
    });
    setDataField("rgbStatus", newVal ? 1 : 0);
  }

  void changeRgbMode(int newVal) {
    setState(() {
      rgbMode = newVal;
    });
    setDataField("rgbMode", newVal);
  }
}

class GraphsPage extends StatefulWidget {
  const GraphsPage({Key key}) : super(key: key);

  @override
  State<GraphsPage> createState() => _GraphsPageState();
}

///JSUT DEMO FOR GRAPHS DELETUS AFTER
class GraphDataDemo {
  GraphDataDemo(this.time, this.value);
  final double time;
  final double value;
}

List<GraphDataDemo> getGraphDataDemo() {
  final List<GraphDataDemo> chartData = [
    GraphDataDemo(10, 18.5),
    GraphDataDemo(11, 20.2),
    GraphDataDemo(12, 21.5),
    GraphDataDemo(13, 23.1),
    GraphDataDemo(14, 24.2),
    GraphDataDemo(15, 23.6),
    GraphDataDemo(16, 24.7)
  ];

  //TODO: make charts show only last 7 recorded values, swipe right on card
  // shows previous 7 and swipe left shows next 7 if available

  return chartData;
}

class _GraphsPageState extends State<GraphsPage> {
  List<GraphDataDemo> _chartData;
  TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = getGraphDataDemo();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Center(
          child: ListView(children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: GridCard(
                    child: Expanded(
                      child: Container(
                        child: SfCartesianChart(
                          title: ChartTitle(text: 'Temperature History'),
                          legend: Legend(isVisible: false),
                          tooltipBehavior: _tooltipBehavior,
                          primaryXAxis: NumericAxis(
                              edgeLabelPlacement: EdgeLabelPlacement.shift),
                          primaryYAxis: NumericAxis(labelFormat: '{value}°C'),
                          series: <ChartSeries>[
                            LineSeries<GraphDataDemo, double>(
                              name: 'Temperature History',
                              enableTooltip: true,
                              dataSource: _chartData,
                              xValueMapper: (GraphDataDemo graph, _) =>
                                  graph.time,
                              yValueMapper: (GraphDataDemo graph, _) =>
                                  graph.value,
                              dataLabelSettings:
                                  DataLabelSettings(isVisible: true),
                            )
                          ],
                        ),
                        margin:
                            const EdgeInsets.fromLTRB(10.0, 18.0, 22.0, 6.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key key}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Center(
          child: Text("Schedule Page"),
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Center(
          child: Text("Settings Page"),
        ),
      ),
    );
  }
}
