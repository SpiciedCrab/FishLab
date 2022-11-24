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
class DecorationOptions {
  num? frequency;
  num? speed;
  num? small;
  num? large;
  num? wind;
  num? windVariance;
  num? rotation;
  num? rotationVariance;
  double? startOpacity;
  double? endOpacity;
  double? height;

  DecorationOptions({
    this.frequency: 100,
    this.speed: 3000,
    this.small: 8,
    this.large: 28,
    this.wind: 40,
    this.windVariance: 20,
    this.rotation: 90,
    this.rotationVariance: 180,
    this.startOpacity: 1,
    this.endOpacity: 0,
    this.height: 200
  });

  DecorationOptions copyWith({
    num? frequency,
    num? speed,
    num? small,
    num? large,
    num? wind,
    num? windVariance,
    num? rotation,
    num? rotationVariance,
    double? startOpacity,
    double? endOpacity,
    double? height
  }) => DecorationOptions(
    frequency: frequency ?? this.frequency,
    speed: speed ?? this.speed,
    small: small ?? this.small,
    large: large ?? this.large,
    wind: wind ?? this.wind,
    windVariance: windVariance ?? this.windVariance,
    rotation: rotation ?? this.rotation,
    rotationVariance: rotationVariance ?? this.rotationVariance,
    startOpacity: startOpacity ?? this.startOpacity,
    endOpacity: endOpacity ?? this.endOpacity,
    height: height ?? this.height,
  );

  DecorationOptions.defaultValue() {
    frequency = 100;
    speed = 3000;
    small = 28;
    large = 68;
    wind = 40;
    windVariance = 20;
    rotation = 90;
    rotationVariance = 180;
    startOpacity = 1;
    endOpacity = 0;
    height = 200;
  }
}

