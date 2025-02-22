import 'dart:math';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_examples/model/model.dart';
import 'package:flutter_examples/widgets/flutter_backdrop.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AddDataPoints extends StatefulWidget {
  final SubItemList sample;
  const AddDataPoints(this.sample, {Key key}) : super(key: key);

  @override
  _LiveVerticalState createState() => _LiveVerticalState(sample);
}

List<_ChartData> chartData = chartData = <_ChartData>[
  _ChartData(0, 10),
  _ChartData(1, 13),
  _ChartData(2, 80),
  _ChartData(3, 30),
  _ChartData(4, 72),
  _ChartData(5, 19),
  _ChartData(6, 30),
  _ChartData(7, 92),
  _ChartData(8, 48),
  _ChartData(9, 20),
  _ChartData(10, 51),
];
int count = 11;

class _LiveVerticalState extends State<AddDataPoints> {
  final SubItemList sample;
  _LiveVerticalState(this.sample);
  bool panelOpen;
  final frontPanelVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    panelOpen = frontPanelVisible.value;
    frontPanelVisible.addListener(_subscribeToValueNotifier);
    super.initState();
  }

  void _subscribeToValueNotifier() => panelOpen = frontPanelVisible.value;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(AddDataPoints oldWidget) {
    super.didUpdateWidget(oldWidget);
    frontPanelVisible.removeListener(_subscribeToValueNotifier);
    frontPanelVisible.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        builder: (context, _, model) => SafeArea(
              child: Backdrop(
                needCloseButton: false,
                panelVisible: frontPanelVisible,
                sampleListModel: model,
                frontPanelOpenPercentage: 0.28,
                appBarAnimatedLeadingMenuIcon: AnimatedIcons.close_menu,
                appBarActions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        icon:
                            Image.asset('images/code.png', color: Colors.white),
                        onPressed: () {
                          launch(
                              'https://github.com/syncfusion/flutter-examples/blob/master/lib/samples/chart/dynamic_updates/add_remove_data/add_remove_points.dart');
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Container(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (frontPanelVisible.value)
                            frontPanelVisible.value = false;
                          else
                            frontPanelVisible.value = true;
                        },
                      ),
                    ),
                  ),
                ],
                appBarTitle: AnimatedSwitcher(
                    duration: Duration(milliseconds: 1000),
                    child: Text(sample.title.toString())),
                backLayer: BackPanel(sample),
                frontLayer: FrontPanel(sample),
                sideDrawer: null,
                headerClosingHeight: 350,
                titleVisibleOnPanelClosed: true,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12), bottom: Radius.circular(0)),
              ),
            ));
  }
}

class FrontPanel extends StatefulWidget {
  final SubItemList subItemList;
  FrontPanel(this.subItemList);

  @override
  _FrontPanelState createState() => _FrontPanelState(this.subItemList);
}

class _FrontPanelState extends State<FrontPanel> {
  final SubItemList sample;
  _FrontPanelState(this.sample);
  num getRandomInt(num min, num max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  List<_ChartData> getChartData(SampleListModel model) {
    chartData.add(_ChartData(count, getRandomInt(10, 100)));
    count = count + 1;
    return chartData;
  }

  List<_ChartData> getChartData1(SampleListModel model) {
    // ignore: invalid_use_of_protected_member
    if (chartData != null && chartData.isNotEmpty)
      chartData.removeAt(chartData.length - 1);
    count = count - 1;
    return chartData;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
        rebuildOnChange: true,
        builder: (context, _, model) {
          return Scaffold(
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 50),
                child: Container(child: getAddRemovePointsChart(chartData)),
              ),
              floatingActionButton: Stack(children: <Widget>[
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                    child: Container(
                      height: 50,
                      width: 120,
                      child: InkWell(
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.add_circle,
                                  size: 50, color: model.backgroundColor),
                              onPressed: () => setState(() {
                                    chartData = getChartData(model);
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: IconButton(
                                icon: Icon(Icons.remove_circle,
                                    size: 50, color: model.backgroundColor),
                                onPressed: () => setState(() {
                                      chartData = getChartData1(model);
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ]));
        });
  }
}

class BackPanel extends StatefulWidget {
  final SubItemList sample;

  BackPanel(this.sample);

  @override
  _BackPanelState createState() => _BackPanelState(sample);
}

class _BackPanelState extends State<BackPanel> {
  final SubItemList sample;
  GlobalKey _globalKey = GlobalKey();
  _BackPanelState(this.sample);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    _getSizesAndPosition();
  }

  _getSizesAndPosition() {
    final RenderBox renderBoxRed = _globalKey.currentContext.findRenderObject();
    final size = renderBoxRed.size;
    final position = renderBoxRed.localToGlobal(Offset.zero);
    double appbarHeight = 60;
    BackdropState.frontPanelHeight =
        position.dy + (size.height - appbarHeight) + 20;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SampleListModel>(
      rebuildOnChange: true,
      builder: (context, _, model) {
        return Container(
          color: model.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  sample.title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      color: Colors.white,
                      letterSpacing: 0.53),
                ),
                Padding(
                  key: _globalKey,
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    sample.description,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0,
                        color: Colors.white,
                        letterSpacing: 0.3,
                        height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

SfCartesianChart getAddRemovePointsChart([List<_ChartData> chartData]) {
  return SfCartesianChart(
    plotAreaBorderColor: Colors.transparent,
    primaryXAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift),
    primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0), majorTickLines: MajorTickLines(size: 0)),
    series: getLineSeries(chartData),
  );
}

List<_ChartData> chartData1 = <_ChartData>[
  _ChartData(0, 10),
  _ChartData(1, 13),
  _ChartData(2, 80),
  _ChartData(3, 30),
  _ChartData(4, 72),
  _ChartData(5, 19),
  _ChartData(6, 30),
  _ChartData(7, 92),
  _ChartData(8, 48),
  _ChartData(9, 20),
  _ChartData(10, 51),
];
List<LineSeries<_ChartData, num>> getLineSeries(List<_ChartData> chartData) {
  return <LineSeries<_ChartData, num>>[
    LineSeries<_ChartData, num>(
        dataSource: chartData ?? chartData1,
        xValueMapper: (_ChartData sales, _) => sales.country,
        yValueMapper: (_ChartData sales, _) => sales.sales,
        width: 2),
  ];
}

class _ChartData {
  _ChartData(this.country, this.sales);
  final num country;
  final int sales;
}
