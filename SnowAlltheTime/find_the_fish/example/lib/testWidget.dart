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
              Scrollbar(
                child: Container(
                  color: Colors.cyan,
                  width: double.infinity,
                  child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(10),
                      child: Column(
                          children:
                          '测试可滚动背景的情况下，是否能拖拽this widget'.split("").map((e) => Text(e, textScaleFactor: 2)).toList(),
                      ),
                  ),
                ),
              ),
              IgnorePointer(
                child: DecorationWidget(url: url,),
              ),
              
            ],),
          )
      )
    );
  }
}