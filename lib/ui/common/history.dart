import 'package:attendance_app/model/logs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:timelines/timelines.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class HistoryPage extends StatelessWidget {
  final String userId;
  final int totalPresent;
  final int totalAbsent;
  HistoryPage(
      {Key? key,
      required this.userId,
      required this.totalAbsent,
      required this.totalPresent})
      : super(key: key);
  var nextTime;
  var editedTime;
  String? rawTime;

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      'Present': totalPresent.toDouble(),
      'Absent': totalAbsent.toDouble()
    };
    var colorList = <Color>[Colors.blue, Colors.red];
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: 0.5.sw,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:20),
                  child: PieChart(
                    dataMap: dataMap,
                    animationDuration: Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: 100.r,
                    colorList: colorList,
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    centerText:
                        "${((totalPresent / (totalPresent + totalAbsent)) * 100).toStringAsFixed(1)}%",
                    legendOptions: LegendOptions(
                      showLegendsInRow: true,
                      legendPosition: LegendPosition.bottom,
                      showLegends: true,
                      legendShape: BoxShape.circle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: false,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Total Classes: ",
                            style: TextStyle(
                                fontSize: 25.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${totalPresent + totalAbsent}',
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Present: ",
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$totalPresent',
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Absent: ",
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$totalAbsent',
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(height: 20.h,)
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 0.5.sw,
              child: PaginateFirestore(
                shrinkWrap: true,
                isLive: true,
                physics: NeverScrollableScrollPhysics(),
                query: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('logs')
                    .orderBy('timestamp', descending: true),
                itemBuilderType: PaginateBuilderType.listView,
                itemBuilder: (index, context, snap) {
                  Logs log = Logs.fromFirestore(doc: snap);
                  var time;
                  rawTime = DateTimeFormat.format(
                      DateTime.fromMillisecondsSinceEpoch(log.timestamp!),
                      format: DateTimeFormats.americanAbbr);
                  time = rawTime!.split(',')[0];
                  editedTime =
                      "${rawTime!.split(',')[1].split(' ')[2].toString()} ${rawTime!.split(',')[1].split(' ')[3].toString()}";
                  return Column(
                    children: [
                      if (nextTime != time)
                        Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0.08.sw, vertical: 8),
                              child: Text('$time',
                                  style: TextStyle(fontSize: 24.sp)),
                            )),
                      Builder(builder: (context) {
                        nextTime = time;
                        return TimelineTile(
                          oppositeContents: Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text('$editedTime'),
                          ),
                          contents: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${log.subjectName}',
                                  style: TextStyle(fontSize: 24.sp),
                                ),
                                Text('• ${log.attendance}',
                                    style: TextStyle(fontSize: 16.sp))
                              ],
                            ),
                          ),
                          node: TimelineNode(
                            indicator: DotIndicator(
                              color: Colors.black,
                              size: 8,
                            ),
                            startConnector: SolidLineConnector(),
                            endConnector: SolidLineConnector(),
                          ),
                        );
                      })
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
