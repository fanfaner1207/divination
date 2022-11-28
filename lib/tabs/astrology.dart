import 'package:flutter/material.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'dart:math';

const List planet = [
  "月亮",
  "太陽",
  "水星",
  "金星",
  "火星",
  "木星",
  "土星",
  "天王星",
  "海王星",
  "冥王星",
  "星球"
];
const List starSign = [
  '牡羊座',
  '金牛座',
  '雙子座',
  '巨蟹座',
  '獅子座',
  '處女座',
  '天秤座',
  '天蠍座',
  '射手座',
  '摩羯座',
  '水瓶座',
  '雙魚座',
  '星座'
];

BottomDrawerController controller = BottomDrawerController();
Widget buildBottomDrawer(BuildContext context) {
  return BottomDrawer(
    /// your customized drawer header.
    header: const Center(
        child: Text(
      "歷史紀錄",
      style: TextStyle(
          fontFamily: "NotoSansTC", fontSize: 22, fontWeight: FontWeight.w500),
    )),

    /// your customized drawer body.
    body: Center(
      child: Column(children: const [
        Text(
          "1\t3",
        ),
        Text("2")
      ]),
    ),

    /// your customized drawer header height.
    headerHeight: 40.0,

    /// your customized drawer body height.
    drawerHeight: 150.0,

    /// drawer background color.
    color: const Color.fromARGB(255, 181, 200, 209),

    /// drawer controller.
    controller: controller,
  );
}

class Astrology extends StatefulWidget {
  const Astrology({Key? key}) : super(key: key);

  @override
  State<Astrology> createState() => _AstrologyState();
}

class _AstrologyState extends State<Astrology> {
  int _starSignNum = 12;
  int _planetNum = 10;
  int _house = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('飛星卡')),
          backgroundColor: Colors.grey,
          // titleTextStyle:
        ),
        body: Stack(
          children: [
            Center(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('$_house宮'),
                Text('${planet[_planetNum]}'),
                Text('${starSign[_starSignNum]}'),
              ],
            )),
            buildBottomDrawer(context)
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: const Text('抽'),
          tooltip: '無情開抽',
          onPressed: () => setState(() {
            _starSignNum = Random().nextInt(12);
            _planetNum = Random().nextInt(10);
            _house = Random().nextInt(12) + 1; //宮位
            controller.open();
          }),
        ));
  }
}
