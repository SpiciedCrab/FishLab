import 'dart:math';
import 'dart:ui' as ui;
import 'package:find_the_fish/snow/caculators.dart';
import 'package:find_the_fish/utils/calculateRandom.dart';
import 'package:flutter/cupertino.dart';
import 'package:find_the_fish/decoration/decoration_model.dart';

// 重力加速度
double g = SnowInfoUtils.ga / SnowInfoUtils.secondMultiply * 100;
///创建画布
class SnowCustomMyPainter extends CustomPainter {
  List<DecorationBean>? list;
  Random? random;
  final Paint? pointPainter = Paint();

  SnowCustomMyPainter({this.list, this.random}); 

  //先来个画笔
  Paint _paint = new Paint()..isAntiAlias = true;
  //具体的绘制功能
  @override
  void paint(Canvas canvas, Size size) {
    if(list == null) return;

    // 在绘制前重新计算每个点的位置
    list!.forEach((element) {
      //左右微抖动
      // double dx = random!.nextDouble() * 2.0 - 1.0;
      double dx = 0;
      //竖直方向位置偏移
      double dy = element.speed!  + g;
      element.speed = element.speed! + g;
      //位置偏移量计算
      element.position = element.position! + Offset(dx, dy);

      //重置位置
      if (element.position!.dy > size.height) {
        element.position = element.origin;
        element.speed = randomNumberInRange(0, 4);
      }
      
    });
    //
    // //绘制
    list!.forEach((element) {
      //修改画笔的颜色
      _paint.color = element.color!;
      //绘制圆,留着画雪花
      // canvas.drawCircle(element.position!, element.radius!, _paint);

      ui.Image? snowImage = element.image;
      double ratio = snowImage!.width / snowImage.height;
      canvas.drawImageRect(snowImage,
          Rect.fromLTWH(0, 0, snowImage.width.toDouble(), snowImage.height.toDouble()),
          Rect.fromLTWH(element.position!.dx, element.position!.dy, element.width!, element.width! / ratio),
          pointPainter!);
    });
  }

  //刷新 控制
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    //返回false 不刷新
    return true;
  }
}
