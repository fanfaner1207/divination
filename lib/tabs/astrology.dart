import 'dart:math';

import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';

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
List<String> history = [
  '目前沒有喔',
];

// 歷史紀錄
// 1.要有時間 V
// 2.可以刪除
// 3.永久記得
// 4.靠左但要有一點空格
// 5."現在沒有喔"隨著抽第一次刪除
// 6.中間的字體變大

BottomDrawerController controller = BottomDrawerController();
Widget buildBottomDrawer(BuildContext context) {
  return BottomDrawer(
    /// your customized drawer header.
    header: const Center(
        child: Text(
      "歷史紀錄",
      style: TextStyle(
          // TODO 修改成只有字體大小
          fontFamily: "NotoSansTC",
          fontSize: 18,
          fontWeight: FontWeight.w500),
    )),

    /// your customized drawer body.
    body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(history[index]),
          );
        }),

    /// your customized drawer header height.
    headerHeight: 40.0,

    /// your customized drawer body height.
    drawerHeight: 300,

    /// drawer background color.
    color: const Color.fromARGB(255, 255, 192, 209),

    /// drawer controller.
    controller: controller,
  );
}

class Astrology extends StatefulWidget {
  const Astrology({Key? key}) : super(key: key);

  @override
  State<Astrology> createState() => _AstrologyState();
}

List<Widget> testhistory = const [
  TableCell(child: Center(child: Text('John'))),
];

class _AstrologyState extends State<Astrology> {
  void addHistory() {
    String time = DateTime.now().toString().split('.')[0];    
    _house = Random(DateTime.now().millisecondsSinceEpoch).nextInt(12) + 1; //宮位
    _planetNum = Random(DateTime.now().millisecondsSinceEpoch).nextInt(10);
    _starSignNum = Random(DateTime.now().millisecondsSinceEpoch).nextInt(12);
    setState(() {
      history.add(
          '$time\t\t${starSign[_starSignNum]}\t\t$_house宮\t\t${planet[_planetNum]}');
    });
    if (history[0] == "目前沒有喔") {
      history.removeAt(0);
    }
    if (history.length > 5) {
      history.removeAt(0);
    }
  }

  int _starSignNum = 12;
  int _planetNum = 10;
  int _house = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('飛星卡')),
          backgroundColor: const Color.fromARGB(255, 255, 192, 209),
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
          backgroundColor: const Color.fromARGB(255, 255, 2, 69),
          label: const Text('抽'),
          tooltip: '無情開抽',
          onPressed: () => setState(() {
            addHistory();
            controller.open();
          }),
        ));
  }
}
