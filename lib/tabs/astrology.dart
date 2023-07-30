import 'dart:math';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';
import '../data/constants.dart';

// 歷史紀錄
// 1.要有時間 V
// 2.可以刪除
// 3.永久記得
// 4.靠左但要有一點空格 V
// 5."現在沒有喔"隨著抽第一次刪除 V
// 6.中間的字體變大、變成一個表

BottomDrawerController controller = BottomDrawerController();
Widget buildBottomDrawer(BuildContext context) {
  return BottomDrawer(
    header: const Center(
        child: Text(
      "歷史紀錄",
      style: TextStyle(
          fontFamily: "NotoSansTC", fontSize: 18, fontWeight: FontWeight.w500),
    )),

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
                DataTable(columns: const [
                  DataColumn(label: Text('項目')),
                  DataColumn(label: Text('抽取'))
                ], rows: [
                  DataRow(cells: [
                    const DataCell(Text('宮位')),
                    DataCell(Text('$_house宮'))
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('守護星')),
                    DataCell(Text('${planet[_planetNum]}'))
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('星座')),
                    DataCell(Text('${starSign[_starSignNum]}'))
                  ]),
                ])
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
