import 'package:arduino_garden/widgets/grid_card.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({Key? key}) : super(key: key);

  @override
  State<GraphPage> createState() => _GraphPageState();
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

class _GraphPageState extends State<GraphPage> {
  late List<GraphDataDemo> _chartData;
  late TooltipBehavior _tooltipBehavior;

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
          child: ListView(children: [
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
