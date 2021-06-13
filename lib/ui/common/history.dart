import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final String userId;
  HistoryPage({ Key? key ,required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History'),),
      
    );
  }
}