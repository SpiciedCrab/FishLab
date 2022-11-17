import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:find_the_fish/snow/caculators.dart';
import 'package:find_the_fish/utils/load_image.dart';
import 'package:flutter/material.dart';
import 'decoration_painter.dart';

final radiansPerSecond = 2 * pi / 1000.0;
String url = "https://res-qa.app.ikea.cn/content/u/20221117/51f76a0e98164f23a0887adecdd4eae5.png";

class DecorationBg extends StatefulWidget {
  String imageUrl;
  DecorationBg({this.imageUrl});

  @override
  _DecorationBgState createState() => _DecorationBgState();
}

class _DecorationBgState extends State<DecorationBg>  {

  Timer _timer;
  ui.Image _netImageFrame;//网络图片

  @override
  void initState() {
    super.initState();
    _updateTimer();
    // _getNetImage(widget.imageUrl);
    _getNetImage(url);
  }

  var _now = DateTime.now();
  _updateTimer() {
    setState(() {
      _now = DateTime.now();
      _timer = Timer((Duration(milliseconds: 16)), (){
        _updateTimer();
      });
    });

  }

  _getNetImage(String url) async {
    ui.Image imageFrame = await loadImageByUrl(url, width: 40, height: 40);
    setState(() {
      _netImageFrame = imageFrame;
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  var snow = List.generate(5, (index) => SnowBasicInfo(x: Random().nextInt(400).toDouble() , y: - Random().nextInt(500).toDouble(), r: SnowInfoUtils.snowRadius));

  List<SnowBasicInfo> moreSnow() {
    return List.generate(Random().nextInt(3), (index) => SnowBasicInfo(x: Random().nextInt(400).toDouble() , y: - Random().nextInt(1000).toDouble(), r: SnowInfoUtils.snowRadius));
  }

  @override
  Widget build(BuildContext context) {
    if(_now.millisecond % 20 == 0) {
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
        child: snowWidget(),
      )
    );
  }
  Widget snowWidget() {
    if(_netImageFrame == null) {
      return Container();
    }
    return FutureBuilder(
      future: _rotatedImage(image: _netImageFrame, angle: 0),
      builder: (ctx, snp) {
        var data = snp.data;
        if(data == null) {
          return Container();
        } else {
          return CustomPaint(
            painter: DecorationPainter(snows: snow, snowImage: data),
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
    // canvas.rotate(angle);
    canvas.drawImage(image, Offset.zero, Paint());
    return pictureRecorder.endRecording().toImage(image.width, image.height);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
    _timer = null;
  }
}

// }
