import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import "package:charts_flutter/flutter.dart" as charts;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class Task {
  String task;
  int taskvalue;
  Color colors;
  Task({this.task, this.taskvalue, this.colors});
}

class _AdminPanelState extends State<AdminPanel> {
  Map<String, dynamic> data = {};
  List<charts.Series<Task, String>> _seriesPieData =
      List<charts.Series<Task, String>>();
  List<charts.Series<Task, String>> _seriesPieData2 =
      List<charts.Series<Task, String>>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    QuerySnapshot temp =
        await FirebaseFirestore.instance.collection("users").get();
    int p = 0, f = 0, s = 0, o = 0, clg = 0, courses = 0, pl = 0;

    List<Task> roledata = [], povData = [];
    temp.docs.forEach((element) {
      if (element.data()["role"] == "Parent") {
        p++;
      } else if (element.data()["role"] == "Student") {
        s++;
      } else if (element.data()["role"] == "Faculty") {
        f++;
      } else {
        o++;
      }
      if (element.data()["purposeOfVisit"] == "Know about FRCRCE") {
        clg++;
      } else if (element.data()["purposeOfVisit"] == "Know about our Courses") {
        courses++;
      } else {
        pl++;
      }
    });
    roledata
        .add(new Task(task: "Parent", taskvalue: p, colors: Color(0xFF003cbf)));
    roledata.add(
        new Task(task: "Student", taskvalue: s, colors: Color(0xFF06cafd)));
    roledata.add(
        new Task(task: "Faculty", taskvalue: f, colors: Color(0xFFff5c4d)));
    roledata
        .add(new Task(task: "Others", taskvalue: o, colors: Colors.deepOrange));
    povData.add(new Task(
        task: "Know about FRCRCE", taskvalue: clg, colors: Color(0xFF003cbf)));
    povData.add(new Task(
        task: "Know about Courses",
        taskvalue: courses,
        colors: Color(0xFF06cafd)));
    povData.add(new Task(
        task: "Know about Placements",
        taskvalue: pl,
        colors: Color(0xFFff5c4d)));
    setState(() {
      _seriesPieData.add(charts.Series(
        data: roledata,
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.colors),
        id: "India",
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ));
      _seriesPieData2.add(charts.Series(
        data: povData,
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) => charts.ColorUtil.fromDartColor(task.colors),
        id: "India",
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ));
    });
  }

  Widget chart() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          // padding: EdgeInsets.all(25.0),
          width: 460,
          height: 250,
          child: Padding(
              padding: EdgeInsets.all(1.0),
              child: Container(
                  child: Center(
                      child: Column(
                children: <Widget>[
                  _seriesPieData.length > 0
                      ? Expanded(
                          child: charts.PieChart(
                            _seriesPieData,
                            animate: true,
                            animationDuration: Duration(milliseconds: 1600),
                            behaviors: [
                              new charts.DatumLegend(
                                outsideJustification:
                                    charts.OutsideJustification.endDrawArea,
                                horizontalFirst: false,
                                desiredMaxRows: 3,
                                cellPadding: new EdgeInsets.only(
                                    left: 15.0, bottom: 4.0),
                                entryTextStyle: charts.TextStyleSpec(
                                    color: charts.MaterialPalette.black,
                                    fontFamily: "Jost",
                                    fontSize: 13),
                              ),
                            ],
                            defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: 50,
                                arcRendererDecorators: [
                                  new charts.ArcLabelDecorator(
                                    labelPosition:
                                        charts.ArcLabelPosition.outside,
                                  )
                                ]),
                          ),
                        )
                      : Container(),
                ],
              ))))),
    );
  }

  Widget chart2() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          // padding: EdgeInsets.all(25.0),
          width: 460,
          height: 250,
          child: Padding(
              padding: EdgeInsets.all(1.0),
              child: Container(
                  child: Center(
                      child: Column(
                children: <Widget>[
                  _seriesPieData2.length > 0
                      ? Expanded(
                          child: charts.PieChart(
                            _seriesPieData2,
                            animate: true,
                            animationDuration: Duration(milliseconds: 1600),
                            behaviors: [
                              new charts.DatumLegend(
                                outsideJustification:
                                    charts.OutsideJustification.endDrawArea,
                                horizontalFirst: false,
                                desiredMaxRows: 3,
                                cellPadding: new EdgeInsets.only(
                                    left: 15.0, bottom: 4.0),
                                entryTextStyle: charts.TextStyleSpec(
                                    color: charts.MaterialPalette.black,
                                    fontFamily: "Jost",
                                    fontSize: 13),
                              ),
                            ],
                            defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: 50,
                                arcRendererDecorators: [
                                  new charts.ArcLabelDecorator(
                                    labelPosition:
                                        charts.ArcLabelPosition.outside,
                                  )
                                ]),
                          ),
                        )
                      : Container()
                ],
              ))))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("User traffic Statistics")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("TYPE OF USERS", style: TextStyle(fontSize: 22)),
            ),
            chart(),
            Text("PURPOSES OF VISITS", style: TextStyle(fontSize: 22)),
            chart2(),
            FlatButton(
                onPressed: () async {
                  print('pressed');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WebViewer()));
                  print('going to open');
                },
                child: Text('Open Indepth Analytics'))
          ],
        ));
  }
}

class WebViewer extends StatefulWidget {
  @override
  _WebViewerState createState() => _WebViewerState();
}

class _WebViewerState extends State<WebViewer> {
  bool _isLoadingPage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text("NEWS "),
                    _isLoadingPage
                        ? Center(
                            child: Container(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.black,
                                strokeWidth: 1.0,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                Expanded(
                  child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl:
                        "https://dialogflow.cloud.google.com/#/agent/chatbot-cdml/analytics",
                    onPageFinished: (finish) {
                      setState(() {
                        _isLoadingPage = false;
                      });
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
}
