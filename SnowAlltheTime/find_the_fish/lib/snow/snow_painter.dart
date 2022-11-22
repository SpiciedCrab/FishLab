import 'dart:math';

import 'package:find_the_fish/snow/caculators.dart';
import 'package:find_the_fish/snow/falldown_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
class SnowPainter extends CustomPainter {

  final List<SnowBasicInfo>? snows;
  final ui.Image? snowImage;
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
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..color = Colors.white;

  Offset circlePosition = Offset(0, 0);
  double circleRadius = 50;
  SnowPainter({this.snows, this.snowImage});

  @override
  void paint(Canvas canvas, Size size) {

    if(snowImage == null || snows == null || snows!.isEmpty) return;

    circlePosition = Offset(size.width / 2, size.height);

    canvas.drawCircle(circlePosition, circleRadius , barrierPainter);
    // canvas.drawArc(Rect.fromCircle(center: circlePosition, radius: circleRadius), pi,  pi / 2, true, snowBarrierPainter);
    for(var snow in snows!) {
      if(snow.invalid) {
        if(snow.melted) {
          continue;
        } else {
          // 当invalid = true 并且雪还没融化，就说明他会积雪
          if(snow.meltedStart == null) {
            var multip = pow((snows!.where((element) => element.meltedStart != null).length / 20), 0.5);
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

      if(snow.r != 0 && (_checkDangerous(snow) || snow.touchBarrier)) {
        snow.touchBarrier = true;
        // 碰壁后，我们假设雪花会与障碍物相交，假定雪花是圆的，那相交线 = 2 * snow.r,
        // 然后通过 snow.r 和 障碍物半斤 radius 反向求出相交后对应的圆夹角

        if(snow.touchRect == null) {
          var multip = pow((snows!.where((element) => element.touchRect != null).length / 10 ), 0.5);
          var angleSnow = atan((snow.r * snowImage!.width.toDouble() / 2) / circleRadius);
          snow.touchRect = Rect.fromCircle(center: circlePosition, radius: circleRadius);
          snow.stroke = multip * snow.r * 10 ;
          snow.touchRadius = snow.r * snowImage!.width.toDouble() / 2;
          snow.startAngle = snow.x < circlePosition.dx ? pi + asin((circlePosition.dy - snow.y) / circleRadius) - angleSnow : 2* pi -(asin((circlePosition.dy - snow.y) / circleRadius));
          snow.swipeAngle = snow.x < circlePosition.dx ? angleSnow * 2 * snow.r / 2: -angleSnow * 2 * snow.r / 2;
        } else {
          // snow.startAngle = snow.x <= circlePosition.dx ? snow.startAngle - pi / 1000 : snow.startAngle + pi / 1000;
          if(snow.startAngle < pi || snow.startAngle > 2 * pi) {
            snow.invalid = true;
            snow.melted = true;
            continue;
          }
          snow.stroke = snow.stroke - 0.001;
        }
        canvas.drawArc(snow.touchRect, snow.startAngle, snow.swipeAngle, false, snowBarrierPainter..strokeWidth = snow.stroke);
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
      canvas.drawImageRect(snowImage!,
          Rect.fromLTWH(0, 0, snowImage!.width.toDouble(), snowImage!.height.toDouble()),
          Rect.fromLTWH(melted.x - snowImage!.width.toDouble() * melted.r / 2, 
                        melted.y - snowImage!.height.toDouble() * melted.r / 2, 
                        snowImage!.width.toDouble() * melted.r, 
                        snowImage!.height.toDouble() * melted.r) ,
          pointPainter);


    }
  }

  bool _checkDangerous(SnowBasicInfo snow) {
    // 我们通过snow的x，y距离底下障碍物的中心距离来判断snow会不会撞到障碍物
    num xToBarrier = (circlePosition.dx - (snow.x)).abs();
    num yToBarrier = (circlePosition.dy - (snow.y)).abs();
    
    // 勾股定理求雪球中心到障碍物中心距离
    num distance = pow((xToBarrier * xToBarrier + yToBarrier* yToBarrier), 0.5);
    return distance < circleRadius;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}