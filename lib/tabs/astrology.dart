import 'dart:math';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';
import '../data/constants.dart';

// 歷史紀錄
// 靠左但要有一點空格 V
// "現在沒有喔"隨著抽第一次刪除 V
// 中間的字體變大、變成一個表 V
// 要有時間 V
// 可以刪除
// 永久記得->DB  https://juejin.cn/post/7150064694584475656
// 針對每行可以手動備註
// Datatable要修改文字大小
// AppBar上下有點粗

BottomDrawerController controller = BottomDrawerController();
Widget buildBottomDrawer(BuildContext context) {
  return BottomDrawer(
    header: const Center(
        child: Text(
      "歷史紀錄",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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

List randomList({int house = 0, int planetNum = 10, int starSignNum = 12}) {
  String time = DateTime.now().toString().split('.')[0];
  house = Random(DateTime.now().millisecondsSinceEpoch).nextInt(12) + 1; //宮位
  planetNum = Random(DateTime.now().millisecondsSinceEpoch).nextInt(10);
  starSignNum = Random(DateTime.now().millisecondsSinceEpoch).nextInt(12);
  return [
    time,
    starSign[starSignNum],
    '${house.toString()}宮',
    planet[planetNum]
  ];
}

class _AstrologyState extends State<Astrology> {
  List tmp = ['NA', 'NA', 'NA', 'NA'];
  void addHistoryList() {
    setState(() {
      tmp = randomList();
      history.add('${tmp[0]}\t\t${tmp[1]}\t\t${tmp[2]}\t\t${tmp[3]}');
    });
    if (history[0] == "目前沒有喔") {
      history.removeAt(0);
    }
    if (history.length > 5) {
      history.removeAt(0);
    }
  }

  // int _starSignNum = 12;
  // int _planetNum = 10;
  // int _house = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(
              child: Text('飛星卡',
                  style: TextStyle(fontSize: 18, shadows: [
                    Shadow(
                        offset: Offset(0.5, 0.5),
                        blurRadius: 3.0,
                        color: Colors.grey)
                  ]))),
          backgroundColor: const Color.fromARGB(255, 255, 192, 209),
        ),
        body: Stack(
          children: [
            Center(
                child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                DataTable(
                    columnSpacing: 30,
                    headingRowHeight: 40,
                    dataRowMinHeight: 40,
                    // headingTextStyle: const TextStyle(fontSize: 18),
                    // dataTextStyle: const TextStyle(fontSize: 18),
                    columns: const [
                      DataColumn(label: Text('項目')),
                      DataColumn(label: Text('抽取'))
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text('守護星')),
                        // DataCell(Text('${tmp[3]}'))
                        DataCell(Text('${tmp[3]}'))
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('宮位')),
                        DataCell(Text('${tmp[2]}'))
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('星座')),
                        DataCell(Text('${tmp[1]}'))
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
            addHistoryList();
            controller.open();
          }),
        ));
  }
}
