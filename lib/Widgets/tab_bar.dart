
import 'package:flutter/material.dart';
import 'package:movix/Modules/HomePage/home_bloc.dart';
import 'package:movix/Utilities/extensions/colors.dart';
import 'package:movix/Utilities/styles.dart';


class CustomTabBar extends StatefulWidget {
  final TabController tabController;
  final List<TabBarContents> contents;
  CustomTabBar({this.tabController, this.contents});

  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  // TabController tabController;
  // @override
  // void initState() {
  //   // tabController = TabController(length: tabList.length, vsync: this);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          isScrollable: true,
          labelColor: Colors.black,
          indicator: UnderlineTabIndicator(),
          tabs: [
            for (var tabContent in widget.contents) getTabContent(tabContent.type.title),
          ],
          controller: widget.tabController,
        ),
      ],
    );
  }

  getTabContent(String title) {
    return Container(
      child: Opacity(
        opacity: 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Style.titleStyle
            ),
          ],
        ),
      ),
    );
  }
}

//* Underline Tab Indicator.
class UnderlineTabIndicator extends Decoration {
  const UnderlineTabIndicator({ 
    this.insets = EdgeInsets.zero,
  }) : assert(insets != null);

  final EdgeInsetsGeometry insets;

  @override
  Decoration lerpFrom(Decoration a, double t) {
    if (a is UnderlineTabIndicator) {
      return UnderlineTabIndicator(
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration lerpTo(Decoration b, double t) {
    if (b is UnderlineTabIndicator) {
      return UnderlineTabIndicator(
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  _PointPainter createBoxPainter([VoidCallback onChanged]) {
    return _PointPainter(this, onChanged);
  }
}

class _PointPainter extends BoxPainter {
  _PointPainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  final UnderlineTabIndicator decoration;

  Color get color => AppColor.tabBarButtonColor;

  EdgeInsetsGeometry get insets => decoration.insets;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    final Rect rect = offset & configuration.size;
    final TextDirection textDirection = configuration.textDirection;
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);

    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final from = Offset(
              indicator.left + 20,
              indicator.bottom - 5);
    final to =  Offset(
              indicator.left + indicator.width/3,
              indicator.bottom - 5);    
    canvas.drawLine(from, to, paint);
  }
}