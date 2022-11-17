import 'package:find_the_fish/snow/snow_bg.dart';
import 'package:find_the_fish/thunder/thunder_bg.dart';
import 'package:flutter/material.dart';

import 'decoration/decoration_bg.dart';

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
              ElevatedButton(onPressed: () => Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx) => DecorationBg())),
                  child: Text('掉氛围啦')),
                  SizedBox(height: 10,),
              ElevatedButton(onPressed: () => Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx) => SnowBg())),
                  child: Text('下雪啦')),
              SizedBox(height: 10,),
              ElevatedButton(onPressed: () => Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx) => ThunderBg())),
                  child: Text('闪电啦')),
            ],
          ),
        ),
      ),
    );
  }
}
