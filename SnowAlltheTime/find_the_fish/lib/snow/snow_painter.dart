import 'dart:math';

import 'package:find_the_fish/snow/caculators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
class SnowPainter extends CustomPainter {

  List<SnowBasicInfo> snows;
  ui.Image snowImage;
  Paint pointPainter = Paint()
    ..colorFilter = ColorFilter.linearToSrgbGamma()
    ..color = Colors.white;

  Paint storedPainter = Paint()
    ..strokeWidth = 3
    ..strokeCap = StrokeCap.round
    ..color = Colors.white;


  SnowPainter({this.snows, this.snowImage});

  @override
  void paint(Canvas canvas, Size size) {

    for(var snow in snows) {
      if(snow.invalid) {
        if(snow.melted) {
          continue;
        } else {
          // 当invalid = true 并且雪还没融化，就说明他会积雪
          if(snow.meltedStart == null) {
            var multip = pow((snows.where((element) => element.meltedStart != null).length / 20), 0.5);
            var referredR = snow.r * 10 * multip;
            snow.r = referredR;
            snow.meltedStart = Offset(snow.x + referredR / 2, size.height - referredR / 2);
            snow.meltedEnd = Offset(snow.x + referredR, size.height - referredR / 2);
          }
          canvas.drawLine(snow.meltedStart,
              snow.meltedEnd, storedPainter..strokeWidth = snow.r);
          continue;
        }
      }

      final falled = SnowMoving().freeFall(snow);
      if(falled.y >= size.height - 20) {
        falled.firstUp();
      }


      final pushed = SnowMoving().windPush(falled);
      if(pushed.x >= size.width || pushed.x < 0) {
        pushed.vx = - pushed.vx;
      }

      final melted = SnowMoving().melt(pushed);

      canvas.drawImageRect(snowImage,
          Rect.fromLTWH(0, 0, snowImage.width.toDouble(), snowImage.height.toDouble()),
          Rect.fromLTWH(melted.x, melted.y, snowImage.width.toDouble() * melted.r, snowImage.height.toDouble() * melted.r) ,
          pointPainter);
    }


    // canvas.drawImage(snowImage, Offset(pushed.x, pushed.y), pointPainter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}