import 'package:find_the_fish/decoration/decoration_bg_widget.dart';
import 'package:find_the_fish/decoration/decoration_model.dart';
import 'package:flutter/material.dart';
String url = "https://res-qa.app.ikea.cn/content/u/20221118/af49ccc4856341f98be02370c748d52a.png";

class DecorationWidget extends StatefulWidget {
  final String? url;
  const DecorationWidget({ Key? key, this.url }) : super(key: key);

  @override
  _DecorationState createState() => _DecorationState();
}

class _DecorationState extends State<DecorationWidget> with SingleTickerProviderStateMixin {
  late AnimationController controller; 
 
  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    if(widget.url != null) {
      Future.delayed(Duration(milliseconds: 500), () => controller.forward());
    }

    controller.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        Future.delayed(Duration(seconds: 3), (){ 
          if(mounted) {
            controller.reverse();
          }
        });
      }
    });
    
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.url == null) {
      return Container();
    } else {
      return FadeTransition(
        opacity: controller,
        child: DecorationBgWidget(imageUrl: widget.url, options: DecorationOptions().copyWith(small: 56, large: 70))
      );
    }
  }
}