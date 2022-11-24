  import 'dart:math';
import 'dart:ui';

double randomNumberInRange(min, max) {
  return (Random().nextDouble() * (max - min + 1) + min).ceil().toDouble();
}

//全局定义获取颜色的方法
Color getRandomWhiteColor(Random random) {
  //透明度 0 ~ 200  255是不透明
  int a = random.nextInt(200);
  return Color.fromARGB(a, 255, 255, 255);
}