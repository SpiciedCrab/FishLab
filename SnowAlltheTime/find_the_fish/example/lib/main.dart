import 'package:example/testWidget.dart';
import 'package:find_the_fish/snow/snow_bg.dart';
import 'package:find_the_fish/thunder/thunder_bg.dart';
import 'package:flutter/material.dart';

import 'package:find_the_fish/decoration_old/decoration_bg.dart';

String url = "https://res-qa.app.ikea.cn/content/u/20221118/af49ccc4856341f98be02370c748d52a.png";

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
          builder: (ctx) => Container(
            child: Column(
              children: [
                ElevatedButton(onPressed: () => Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx) => TestWidget())),
                  child: Text('new掉氛围啦')),
                  SizedBox(height: 10,),
                ElevatedButton(onPressed: () => Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx) => DecorationBg(imageUrl: url,))),
                    child: Text('掉氛围啦')),
                    SizedBox(height: 10,),
                ElevatedButton(onPressed: () => Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx) => SnowBg())),
                    child: Text('下雪啦')),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: () => Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx) => ThunderBg())),
                    child: Text('闪电啦')),
              ],
            ),
            // child: Stack(children: [
            //   Container(
            //     width: double.infinity,
            //     height: double.infinity,
            //     color: Colors.cyan,
            //   ),
            //   TestPageWidget(url: url,)
            // ],),
          )
        ),
      ),
    );
  }
}
