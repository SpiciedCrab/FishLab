
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ThunderPoint {
  double x = 0;
  double y = 0;
  double ay = 0.00009;
  double vy = 0;
  double alpha = 1;
  double splitValue;
  double va = 0.0001;
  int maxSpeed = 1000;
  List<Offset> offsets = [];
  bool lock = false;
  List<ThunderPoint> subThunders = [];

  ThunderPoint() {
    _setup();
  }

  _setup() {
    x = 200 + Random().nextInt(100).toDouble();
    ay = 0.0001 * (0.5 + Random().nextInt(50) / 100);
    alpha = Random().nextInt(10) / 10;
    va = 0.0001;
  }

  void split() {
    bool random = Random().nextInt(100) * (y.toInt() ~/ 100) % 2 == 1;
    if(random) {
      lock = true;
      double randomInt = Random().nextBool() ? 1 : -1;
      splitValue = randomInt;
      subThunders.add(ThunderPoint()..x = x..y = y..alpha = alpha..splitValue = -randomInt);
      // subThunders.add(ThunderPoint()..x = x..y = y..alpha = alpha..splitValue = -0.8);
    }
  }
  reset() {
    y = 0;
    vy = 0;
    maxSpeed = 100 + Random().nextInt(100);
    offsets.clear();
    subThunders.clear();
    _setup();
    lock = false;
  }
}

class ThunderPainter extends CustomPainter {

  List<ThunderPoint> thunders;

  ThunderPainter(this.thunders);

  var painter = Paint()..strokeWidth = 1
    ..color = Colors.white
    ..strokeCap = ui.StrokeCap.square
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    void thunderDrawing(ThunderPoint t) {
      if(t.y <= size.height && t.alpha > 0) {
        for(int i = 0; i <= t.maxSpeed ;i ++) {
          double randomInt = (Random().nextBool() ? 1 : -1);
          var value = randomInt *  (t.splitValue == null ? (Random().nextInt(30)  / 1000) : Random().nextInt(100)  / 100) ;
          double finalValue = randomInt * (t.splitValue ?? 0)  >= 0 ? value * 1 : value * 0.85;
          if(t.splitValue != 0) {
            finalValue = finalValue * 1.5;
          }
          t.x = t.x + finalValue ;
          t.vy = t.ay + t.vy;
          t.y = t.y + t.vy;
          // if(t.splitValue != 0) {
          //   t.splitValue = t.splitValue + Random().nextInt(10) / 10000;
          // }
          t.alpha = max(t.alpha - t.va, 0);
          var offset = Offset(t.x, t.y);
          t.offsets.add(offset);
        }
        t.split();
      } else {
        t.reset();
      }
    }

    for(var thunder in thunders) {
      thunderDrawing(thunder);
      canvas.drawPoints(ui.PointMode.polygon, thunder.offsets, painter
        ..color = Colors.white.withOpacity(thunder.alpha)
      // ..shader = ui.Gradient.sweep(
      //     Offset(size.width / 2, size.height / 2), [ Colors.transparent, Colors.white,])
        ..strokeWidth = Random().nextInt(5) * (size.height - thunder.y) / size.height);


      thunder.subThunders.forEach((element) => thunderDrawing(element));

      thunder.subThunders.forEach((element) => canvas.drawPoints(ui.PointMode.polygon, element.offsets, painter
        ..shader = ui.Gradient.sweep(
            Offset(size.width / 2, size.height / 2), [Colors.transparent, Colors.white.withOpacity(element.alpha),])
      // ..color = Colors.white.withOpacity(element.alpha)
        ..strokeWidth = 2 * (size.height - element.y) / size.height));
    }


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}