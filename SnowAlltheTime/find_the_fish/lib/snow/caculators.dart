import 'dart:math' as math;

import 'package:flutter/cupertino.dart';

class SnowInfoUtils {

  // 单个雪花体积
  // static double get snowOriginSize => math.Random().nextInt(30).toDouble() ;
  static double get snowRadius => math.Random().nextDouble() + 1; 

  // 秒级重力加速度 ay
  static double get ga => math.Random().nextInt(100) * math.Random().nextInt(1000).toDouble() / 1000 ;

  // 雪花融化加速度 ar
  static double get meltA => - math.Random().nextInt(100) / 1000000;

  // 秒级风力 vx
  static double get wa => math.Random().nextBool() ? math.Random().nextInt(150) / 1000 :  -math.Random().nextInt(150) / 1000;

  // 秒与单位时间转换，因为默认时间单位是微秒，但是计算时候用微秒是在太慢了
  static double get secondMultiply => 1000 ;

  // 反弹后的加速度
  static double bouncedGa(int times) {
    return SnowInfoUtils.ga * math.pow(1.2, times);
  }
}

class SnowBasicInfo {
  late double x, y, r;
  late double vx, vy, vr; // 速度

  late double ax, ay; // 加速度
  late double ar;

  late Offset meltedStart;
  late Offset meltedEnd;

  late Rect touchRect;
  late double touchRadius;
  late double startAngle;
  late double swipeAngle;
  late double stroke;
  late bool touchBarrier = false;

  late bool invalid = false;

  late bool melted = false;
  late bool isUp = false;
  late int upTimes = 0;

  firstUp() {
    vy = - vy;
    invalid = true;
    if(r <= 1) {
      melted = true;
    }
  }

  SnowBasicInfo({this.x = 0, this.y = 0, this.r = 10,
    this.vx = 0,
    this.vr = 0,
    this.vy = 0, this.ax = 0, this.ay = 0, this.ar = 0}) {
    vx = SnowInfoUtils.wa;
  }
}

class SnowMoving {

  // 纵向
  SnowBasicInfo freeFall(SnowBasicInfo info) {
    // 如果是往上反弹，需要一个比重力加速度更大的加速度把球往上拉，从而更快的消耗掉掉落的势能，才能出现弹力减速效果
    info.ay = info.isUp ? SnowInfoUtils.bouncedGa(info.upTimes) / (SnowInfoUtils.secondMultiply) : SnowInfoUtils.ga / SnowInfoUtils.secondMultiply;
    info.vy = info.vy + info.ay;
    if(info.vy > 0) {
      info.isUp = false;
    }
    info.y = info.y + info.vy;
    return info;
  }

  // 横向
  SnowBasicInfo windPush(SnowBasicInfo info) {
    info.ax = SnowInfoUtils.wa;
    info.vx = info.vx + info.ax;
    info.x  = info.vx + info.x;
    return info;
  }

  // 随着时间变化，雪花融化速率固定 meltA
  SnowBasicInfo melt(SnowBasicInfo info) {
    info.ar = SnowInfoUtils.meltA;
    info.vr = info.vr + info.ar;
    info.r = math.max(0, info.r + info.vr);
    return info;
  }
}