import 'dart:math';

import 'package:find_the_fish/snow/caculators.dart';
import 'package:find_the_fish/snow/falldown_painter.dart';
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

  Paint barrierPainter = Paint()
    ..strokeWidth = 1
    ..strokeCap = StrokeCap.round
    ..color = Colors.red;

  Paint snowBarrierPainter = Paint()
    ..strokeWidth = 10
    ..strokeCap = StrokeCap.round
    ..color = Colors.yellow;

  Offset circlePosition;
  double circleRadius = 30;
  SnowPainter({this.snows, this.snowImage});

  @override
  void paint(Canvas canvas, Size size) {

    circlePosition = Offset(size.width / 2, size.height);
    canvas.drawCircle(circlePosition, circleRadius , barrierPainter);
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
            snow.meltedStart = Offset(snow.x - referredR / 2, size.height - referredR / 2);
            snow.meltedEnd = Offset(snow.x + referredR/ 2, size.height - referredR / 2);
          }
          canvas.drawLine(snow.meltedStart,
              snow.meltedEnd, storedPainter..strokeWidth = snow.r);
          continue;
        }
      }
      
      if(snow.r != 0 && (_checkDangerous(snow, size) || snow.touchBarrier)) {
        snow.touchBarrier = true;
        // 碰壁后，我们假设雪花会与障碍物相交，假定雪花是圆的，那相交线 = 2 * snow.r,
        // 然后通过 snow.r 和 障碍物半斤 radius 反向求出相交后对应的圆夹角
        if(snow.touchRect == null) {
          var angleSnow = 2 * asin(snow.r * 10 / circleRadius);
          snow.touchRect = Rect.fromCircle(center: circlePosition, radius: circleRadius);
          snow.touchRadius = circleRadius;
          snow.startAngle = -pi - angleSnow;
          snow.swipeAngle = angleSnow;
        }
        canvas.drawArc(snow.touchRect, snow.startAngle, snow.swipeAngle, true, snowBarrierPainter);
        continue;
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
      canvas.drawCircle(Offset(melted.x, melted.y), snowImage.width.toDouble() * melted.r / 2, barrierPainter);
      canvas.drawImageRect(snowImage,
          Rect.fromLTWH(0, 0, snowImage.width.toDouble(), snowImage.height.toDouble()),
          Rect.fromLTWH(melted.x - snowImage.width.toDouble() * melted.r / 2, melted.y - snowImage.height.toDouble() * melted.r / 2, snowImage.width.toDouble() * melted.r, snowImage.height.toDouble() * melted.r) ,
          pointPainter);


    }
  }

  bool _checkDangerous(SnowBasicInfo snow, Size canvasSize) {
    // 我们通过snow的x，y距离底下障碍物的中心距离来判断snow会不会撞到障碍物
    double canvasWidth = canvasSize.width;
    double canvasHeight = canvasSize.height;
    var r = snowImage.width.toDouble() * snow.r;
    double xToBarrier = (circlePosition.dx - (snow.x)).abs();
    double yToBarrier = (circlePosition.dy - (snow.y)).abs();
    
    // 勾股定理求雪球中心到障碍物中心距离
    double distance = pow((xToBarrier * xToBarrier + yToBarrier* yToBarrier), 0.5);
    return distance <= circleRadius + r / 2;
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}