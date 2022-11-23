import 'dart:math' as math;

import 'package:find_the_fish/snow/caculators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class DecorationPainter extends CustomPainter {

  final List<SnowBasicInfo>? snows;
  final ui.Image? snowImage;
  final Paint? pointPainter = Paint();

  DecorationPainter({this.snows, this.snowImage});

  @override
  Future<void> paint(Canvas canvas, Size size) async {

    if(snowImage == null || snows == null || snows!.isEmpty) return;

    for(var snow in snows!) {
      if(snow.invalid) {
        if(snow.melted) {
          continue;
        } else {
          continue;
        }
      }

      final falled = SnowMoving().freeFall(snow);
      if(falled.y >= size.height - 20) {
        falled.firstUp();
      }
      double ratio = snowImage!.width / snowImage!.height;
      canvas.drawImageRect(snowImage!,
          Rect.fromLTWH(0, 0, snowImage!.width.toDouble(), snowImage!.height.toDouble()),
          Rect.fromLTWH(falled.x - snowImage!.width.toDouble() * falled.r / 2, 
                        falled.y - snowImage!.height.toDouble() * falled.r / 2, 
                        50 * falled.r, 
                        50 * ratio * falled.r) ,
          pointPainter!);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}