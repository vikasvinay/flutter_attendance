import 'dart:developer';

import 'package:attendance_app/model/logs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:timelines/timelines.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryPage extends StatelessWidget {
  final String userId;
  HistoryPage({Key? key, required this.userId}) : super(key: key);
  var nextTime;
  var editedTime;
  String? rawTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 0.4.sw,
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
