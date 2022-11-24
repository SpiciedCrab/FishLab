import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:find_the_fish/decoration/decoration_custom_painter.dart';
import 'package:find_the_fish/utils/load_image.dart';
import 'package:find_the_fish/decoration/decoration_model.dart';

int containerWidth = 375;

class DecorationBgWidget extends StatefulWidget {
  final String? imageUrl;
  final DecorationOptions? options;

  DecorationBgWidget({this.imageUrl, this.options});

  @override
  _DecorationBgState createState() => _DecorationBgState();
}

class _DecorationBgState extends State<DecorationBgWidget> with TickerProviderStateMixin {
  ui.Image? _netImageFrame;//网络图片
  //创建一个集合用来保存图片
  List<DecorationBean> _list = [];

  //随机数
  Random _random = new Random(DateTime.now().microsecondsSinceEpoch);

  //来个动画控制器
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    if(widget.imageUrl != null) {
      _getNetImage(widget.imageUrl ?? '');
    }

    //创建动画控制器 1秒
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 10000));

    //执行刷新监听
    _animationController.addListener(() {
      setState(() {});
    });
    //开启图片的运动
    _animationController.repeat();

  }

  _getNetImage(String url) async {
    ui.Image imageFrame = await loadImageByUrl(url, width: 40, height: 40);
    setState(() {
      _netImageFrame = imageFrame;
      initData();
    });
  }

  void initData() async {
    DecorationOptions options = widget.options ?? DecorationOptions.defaultValue();
    for (int i = 0; i < 10; i++) {
      DecorationBean bean = new DecorationBean();
      bean.image = await _rotatedImage(image: _netImageFrame, angle: _random.nextDouble() * 2 * pi / 10.0);
      //获取随机透明度白色
      bean.color = getRandomWhiteColor(_random);
      double startX = randomNumberInRange(-(options.wind!).abs(), containerWidth + (options.wind!).abs());
      double endY = _random.nextDouble() * MediaQuery.of(context).size.height;
      double endX = startX + randomNumberInRange(options.wind! - options.windVariance!, options.wind! + options.windVariance!);
      double size = randomNumberInRange(options.small, options.large);
      double speed = options.speed! / ((randomNumberInRange(size * 1.2, size * 0.8) - options.small!) / (options.large! - options.small!) + 0.5);
      bean.width = size;
      bean.speed = speed;
      bean.position = Offset(endX.toDouble(), endY);
      bean.origin = Offset(startX.toDouble(), 0);
      //设置半径
      bean.width = size;

      _list.add(bean);
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      //层叠布局
      child: Stack(
        children: [
          CustomPaint(
            size: MediaQuery.of(context).size,
            //画布
            painter: SnowCustomMyPainter(list: _list, random: _random),
          ),
        ],
      ),
    );
  }

  Future<ui.Image>? _rotatedImage({ui.Image? image, required double angle}) {
    if(image == null) {
      return null;
    }

    var pictureRecorder = ui.PictureRecorder();
    Canvas canvas = Canvas(pictureRecorder);
    final double r = sqrt(image.width * image.width + image.height * image.height) / 2;
    final alpha = atan(image.height / image.width);
    final beta = alpha + angle;
    final shiftY = r * sin(beta);
    final shiftX = r * cos(beta);
    final translateX = image.width / 2 - shiftX;
    final translateY = image.height / 2 - shiftY;
    canvas.translate(translateX, translateY);
    canvas.rotate(angle);
    canvas.drawImage(image, Offset.zero, Paint());
    return pictureRecorder.endRecording().toImage(image.width, image.height);
  }

  double randomNumberInRange(min, max) {
    return (Random().nextDouble() * (max - min + 1) + min).ceil().toDouble();
  }

  @override
  void dispose() {
    _animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

}

//全局定义获取颜色的方法
Color getRandomWhiteColor(Random random) {
  //透明度 0 ~ 200  255是不透明
  int a = random.nextInt(200);
  return Color.fromARGB(a, 255, 255, 255);
}
