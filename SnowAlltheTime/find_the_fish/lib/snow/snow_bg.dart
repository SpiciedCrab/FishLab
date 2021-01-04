import 'dart:async';
import 'dart:math';

import 'package:find_the_fish/snow/caculators.dart';
import 'package:find_the_fish/snow/falldown_painter.dart';
import 'package:find_the_fish/snow/snow_painter.dart';
import 'package:find_the_fish/thunder/thunder_painter.dart';
import 'package:flutter/material.dart';

import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

final radiansPerSecond = 2 * pi / 1000.0;

class SnowBg extends StatefulWidget {
  @override
  _SnowBgState createState() => _SnowBgState();
}

class _SnowBgState extends State<SnowBg>  {

  Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateTimer();
  }


  var _now = DateTime.now();
  _updateTimer() {
    setState(() {
      _now = DateTime.now();
      _timer = Timer((Duration(milliseconds: 1)), (){
        _updateTimer();
      });
    });

  }

  Future<ui.Image> load(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  double windowWidth;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  var snow = List.generate(10, (index) => SnowBasicInfo(x: Random().nextInt(400).toDouble() , y: - Random().nextInt(50).toDouble(), r: SnowInfoUtils.snowRadius));

  List<SnowBasicInfo> moreSnow() {
    return List.generate(Random().nextInt(5), (index) => SnowBasicInfo(x: Random().nextInt(400).toDouble() , y: - Random().nextInt(100).toDouble(), r: SnowInfoUtils.snowRadius));
  }

  @override
  Widget build(BuildContext context) {
    if(_now.millisecond % 10 == 0) {
      snow.addAll(moreSnow());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_now.millisecondsSinceEpoch.toString()),
      ),
      body: Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: falldown(),
      )
    );
  }

  var thunder = ThunderPoint();
  Widget falldown() {
    return CustomPaint(
      // painter: FalldownPainter
      painter: ThunderPainter(thunder),
    );
  }

  Widget snowWidget() {
    return FutureBuilder(
      future: load('assets/xuehua.png').then((value) => _rotatedImage(image: value, angle:_now.millisecond * radiansPerSecond)),
      builder: (ctx, snp) {
        var data = snp.data;
        if(data == null) {
          return Container();
        } else {
          return CustomPaint(
            painter: SnowPainter(snows: snow, snowImage: data),
          );
        }
      },
    );
  }

  Future<ui.Image> _rotatedImage({ui.Image image, double angle}) {
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
}
