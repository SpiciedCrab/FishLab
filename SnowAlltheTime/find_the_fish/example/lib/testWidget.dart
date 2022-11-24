import 'package:example/decorationWidget.dart';
import 'package:flutter/material.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({ Key? key }) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('下个圣诞树'),),
      body: Builder(
          builder: (ctx) => Container(
            child: Stack(children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.cyan,
              ),
              DecorationWidget(url: url,)
            ],),
          )
      )
    );
  }
}