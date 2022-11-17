import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:image/image.dart' as IMG;

Future<ui.Image> loadImageByAsset(String asset) async {
  ByteData data = await rootBundle.load(asset);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  ui.FrameInfo fi = await codec.getNextFrame();
  return fi.image;
}

Future<ui.Image> loadImageByUrl(String url, {int width, int height}) async {
  ByteData data = await NetworkAssetBundle(Uri.parse(url)).load(url);
  // resizeImage(data.buffer.asUint8List(), width, height);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  ui.FrameInfo fi = await codec.getNextFrame();
  return fi.image;
}

Uint8List resizeImage(Uint8List data, int wid, int hei) {
  Uint8List resizedData = data;
  IMG.Image img = IMG.decodeImage(data);
  IMG.Image resized = IMG.copyResize(img, width: wid ?? img.width*2, height: hei ?? img.height*2);
  resizedData = IMG.encodeJpg(resized);
  return resizedData;
} 