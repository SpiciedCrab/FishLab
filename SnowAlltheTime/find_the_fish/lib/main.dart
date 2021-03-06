import 'package:find_the_fish/snow/snow_bg.dart';
import 'package:find_the_fish/thunder/thunder_bg.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('最新更新：闪⚡️'),),
        body: Builder(
          builder: (ctx) => Column(
            children: [
              FlatButton(onPressed: () => Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx) => SnowBg())),
                  child: Text('下雪啦')),
              SizedBox(height: 10,),
              FlatButton(onPressed: () => Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx) => ThunderBg())),
                  child: Text('闪电啦')),
            ],
          ),
        ),
      ),
    );
  }
}
