import 'package:find_the_fish/snow/caculators.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
double y = 10;
double vy = 0;

double x = 0;
double vx = 0;
int times = 0;
double g = 10;
bool isUp = false;
double custmizedG = 10 / 100;

class FalldownNormalPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    // vy = vy + custmizedG;
    // y = y + vy;
    //
    // canvas.drawCircle(Offset(100, y), 10, Paint()..color = Colors.white..strokeWidth = 10);

    //
    // // 普通反弹
    // y = y + vy;
    // vy = vy + custmizedG;
    //
    // if(y >= size.height / 2 || y < 0) {
    //   vy = -vy * 0.9;
    // }
    // canvas.drawCircle(Offset(100, y), 10, Paint()..color = Colors.white..strokeWidth = 10);

    // 加速度反弹
    g = isUp ? math.pow(1.2, times) * custmizedG : custmizedG;

    y = y + vy;
    vy = vy + g;

    if(y >= size.height / 2) {
      vy = -vy;
      times ++;
      isUp = true;
    }

    if(vy > 0) {
      isUp = false;
    }


    canvas.drawCircle(Offset(100, y), 10, Paint()..color = Colors.white..strokeWidth = 10);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class FalldownPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    g = isUp ? math.pow(1.2, times) * 60 / 1000 : 60 / 1000;
    if(y > size.height/2) {
      vy = -vy;
    }

    vy = vy + g;
    y = y + vy;

    if(vy > 0) {
      isUp = false;
    }

    if(y >= size.height/2){
      isUp = true;
      times  = times + 1;
    }


    if(x > size.width || x < 0) {
      vx = -vx;
    }

    vx = vx + 0.01;
    x = x + vx;

    canvas.drawCircle(Offset(x, y), 10, Paint()..color = Colors.white..strokeWidth = 10);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class ManyBallsPainter extends CustomPainter {

  List<SnowBasicInfo> snows;

  ManyBallsPainter({this.snows});

  @override
  void paint(Canvas canvas, Size size) {
    snows.forEach((element) {
      element.ay = element.isUp ? math.pow(1.2, element.upTimes) * 60 / 1000 : 60 / 1000;
      if(element.y > size.height) {
        element.vy = -element.vy;
      }

      element.vy = element.vy + element.ay;
      element.y = element.y + element.vy;

      if(element.vy > 0) {
        element.isUp = false;
      }

      if(element.y >= size.height){
        element.isUp = true;
        element.upTimes  = element.upTimes + 1;
      }


      if(element.x > size.width || element.x < 0) {
        element.vx = -element.vx;
      }

      element.vx = element.vx + 0.01;
      element.x = element.x + element.vx;

      canvas.drawCircle(Offset(element.x, element.y), 10, Paint()..color = Colors.white..strokeWidth = 10);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}