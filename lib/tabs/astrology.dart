import 'dart:math';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';
import '../data/constants.dart';
import './overlay_page.dart';

BottomDrawerController controller = BottomDrawerController();
Widget buildBottomDrawer(BuildContext context) {
  return BottomDrawer(
    header: const Center(
      child: Text(
        "歷史紀錄",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    ),

    body: ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(history[index]));
      },
    ),

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
  const Astrology({super.key});

  @override
  State<Astrology> createState() => _AstrologyState();
}

class _AstrologyState extends State<Astrology> {
  double sumOfProducts = 0.0;
  int n = 0;
  List tmp = ['NA', 'NA', 'NA', 'NA'];
  late List listSumOfProducts = [];
  OverlayEntry? _overlayEntry; // 直接在 Astrology 管理 Overlay

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            // top: 200,
            // bottom: 200,
            // left: 100,
            // right: 100,
            top: MediaQuery.of(context).size.height * 0.1,
            bottom: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Container(
              // color: Colors.white.withValues(),
              color: Colors.white.withOpacity(0.8),
              child: DrawingOverlay(
                onDrawingComplete: () {
                  _overlayEntry?.remove();
                  _overlayEntry = null;
                  setState(() {}); // 强制刷新畫面
                },
                onSumOfProductsUpdated: (sum) {
                  setState(() {
                    sumOfProducts = sum;
                    listSumOfProducts = [];
                    listSumOfProducts.add(
                      sumOfProducts.floor() +
                          DateTime.now().millisecondsSinceEpoch,
                    );
                    listSumOfProducts.add(
                      (pow(sumOfProducts.floor(), 2) +
                              DateTime.now().millisecondsSinceEpoch)
                          as int?,
                    );
                    listSumOfProducts.add(
                      (pow(sumOfProducts.floor(), 3) +
                              DateTime.now().millisecondsSinceEpoch)
                          as int?,
                    );

                    print(listSumOfProducts);
                  });
                },
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            '飛星卡',
            style: TextStyle(
              fontSize: 18,
              shadows: [
                Shadow(
                  offset: Offset(0.5, 0.5),
                  blurRadius: 3.0,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 192, 209),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: DataTable(
                    columnSpacing: 30,
                    headingRowHeight: 40,
                    dataRowMinHeight: 40,
                    headingTextStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontFamily: "NotoSansTC",
                    ),
                    dataTextStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontFamily: "NotoSansTC",
                    ),
                    columns: const [
                      DataColumn(label: Text('項目')),
                      DataColumn(label: Text('抽取')),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          const DataCell(Text('守護星')),
                          DataCell(Text('${tmp[1]}')),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text('宮位')),
                          DataCell(Text('${tmp[2]}')),
                        ],
                      ),
                      DataRow(
                        cells: [
                          const DataCell(Text('星座')),
                          DataCell(Text('${tmp[3]}')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          buildBottomDrawer(context),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 255, 2, 69),
        label: const Text('抽'),
        tooltip: '無情開抽',
        // onPressed:
        // () => setState(() async {
        //   // for (int i = 0; i < 3; i++) {
        //   if (overlayKey.currentState != null) {
        //     overlayKey.currentState?.showOverlay(context);
        //     await Future.delayed(const Duration(seconds: 1));
        //   } else {
        //     // print('Overlay is null, skipping iteration $i');
        //     // }
        //   }
        onPressed: () async {
          if (_overlayEntry == null) {
            _showOverlay();
            await Future.delayed(const Duration(seconds: 1));
          }

          addHistoryList(listSumOfProducts);
          controller.open();
        },
      ),
    );
  }

  void addHistoryList(List list) {
    tmp = [
      DateTime.now().toString().split('.')[0], //當前時間
      planet[Random(list[0]).nextInt(10)], //守護星
      '${Random(list[1]).nextInt(12) + 1}宮', //宮位
      starSign[Random(list[2]).nextInt(12)], //星座
    ];
    history.add('${tmp[0]}\t\t${tmp[1]}\t\t${tmp[2]}\t\t${tmp[3]}');
    if (history[0] == "目前沒有喔" || history.length > 5) {
      history.removeAt(0);
    }
  }
}
