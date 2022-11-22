import 'dart:async';
import 'dart:math';

import 'package:find_the_fish/snow/caculators.dart';
import 'package:find_the_fish/snow/falldown_painter.dart';
import 'package:find_the_fish/snow/snow_painter.dart';
import 'package:find_the_fish/thunder/thunder_painter.dart';
import 'package:flutter/material.dart';

import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

final radiansPerSecond = 2 * pi / 1000.0;

class ThunderBg extends StatefulWidget {
  @override
  _ThunderBgState createState() => _ThunderBgState();
}

class _ThunderBgState extends State<ThunderBg>  {

  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateTimer();
  }


  var _now = DateTime.now();
  _updateTimer() {
    setState(() {
      _now = DateTime.now();
      _timer = Timer((Duration(milliseconds: 1)), (){
        _updateTimer();
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_now.millisecondsSinceEpoch.toString()),
        ),
        body: Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: CustomPaint(
            // painter: FalldownPainter
            painter: ThunderPainter(thunder),
          ),
        )
    );
  }

  var thunder = [ThunderPoint()];

  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer?.cancel();
  }
}
