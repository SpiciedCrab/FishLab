import 'dart:ui';
import 'dart:ui' as ui;

///定义 雪花模型 用来保存雪花的基本属性信息
class DecorationBean {
  //位置
  Offset? position;

  //初始位置
  Offset? origin;
  //颜色
  Color? color;
  //运动的速度
  double? speed;
  //半径
  double? radius;

  ui.Image? image;

  double? width;
}
