import 'dart:math';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:flutter/material.dart';
import '../data/constants.dart' show planet, starSign; // 只導入需要的常數
import './overlay_page.dart';

class Astrology extends StatefulWidget {
  const Astrology({super.key});

  @override
  State<Astrology> createState() => _AstrologyState();
}

class _AstrologyState extends State<Astrology> {
  // 將狀態移入 State 類別中管理
  late final BottomDrawerController _drawerController;
  final List<String> _history = ['目前沒有喔'];

  double sumOfProducts = 0.0;
  int n = 0;
  List tmp = ['NA', 'NA', 'NA', 'NA'];
  late List listSumOfProducts = [];
  OverlayEntry? _overlayEntry; // 直接在 Astrology 管理 Overlay

  @override
  void initState() {
    super.initState();
    _drawerController = BottomDrawerController();
  }



  // 將 buildBottomDrawer 移入 State 類別
  Widget _buildBottomDrawer() {
    return BottomDrawer(
      header: const Center(
        child: Text(
          "歷史紀錄",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(_history[index]));
        },
      ),
      headerHeight: 40.0,
      drawerHeight: 300,
      color: const Color.fromARGB(255, 255, 192, 209),
      controller: _drawerController,
    );
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            // top: 200,
            // bottom: 200,
            // left: 100,
            // right: 100,
            top: MediaQuery.sizeOf(context).height * 0.1,
            bottom: MediaQuery.sizeOf(context).height * 0.1,
            left: MediaQuery.sizeOf(context).width * 0.1,
            right: MediaQuery.sizeOf(context).width * 0.1,
            child: Container(
              decoration: BoxDecoration(
                // 使用 withAlpha 替代已棄用的 withOpacity
                color: Colors.white.withAlpha(204), // 255 * 0.8 = 204
                border: Border.all(
                  color: Colors.pinkAccent, // 您可以自訂邊框顏色
                  width: 3.0, // 您可以自訂邊框寬度
                ),
                borderRadius: BorderRadius.circular(12), // 加上圓角讓外觀更柔和
              ),
              child: Stack( // 使用 Stack 來疊加 Widget
                children: [
                  const Center( // 將文字放在中央
                    child: Text(
                      '塗鴉後占卜',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  DrawingOverlay(
                    onDrawingComplete: () {
                      _overlayEntry?.remove();
                      _overlayEntry = null;
                      // 移除不必要的 setState
                    },
                    onValuesUpdated: (values) {
                      setState(() {
                        if (values.length == 3) {
                          // 使用新的三個值來生成 listSumOfProducts
                          // 為了增加隨機性，我們將每個值與當前時間戳結合
                          final now = DateTime.now().millisecondsSinceEpoch;
                          listSumOfProducts = [
                            (values[0]).floor() + now, // 起始點乘積
                            (values[1]).floor() + now, // 滑動過程總和
                            (values[2]).floor() + now, // 結束點乘積
                          ];
                        } else {
                          // 如果發生錯誤，使用備用邏輯
                          final now = DateTime.now().millisecondsSinceEpoch;
                          listSumOfProducts = [now, now + 1, now + 2];
                        }

                        // 賦值完成後，才執行抽卡和開啟歷史紀錄
                        addHistoryList(listSumOfProducts);
                        _drawerController.open();
                      });
                    },
                  ),
                  
                ],
              )
            ),
          ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  // 檢查歷史紀錄的第一筆資料是否為初始提示訊息
  void _checkAndRemoveInitialHistory() {
    if (_history.isNotEmpty && _history[0] == "目前沒有喔") {
      _history.removeAt(0);
    }
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
          _buildBottomDrawer(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromARGB(255, 255, 2, 69),
        label: const Text('抽'),
        tooltip: '無情開抽',
       
        onPressed: () {
          // 按下按鈕時，只負責顯示繪圖層
          if (_overlayEntry == null) {
            _showOverlay();

          }

        },
      ),
    );
  }

  void addHistoryList(List list) {
    print(listSumOfProducts);
    if (list.length < 3) return; // 安全檢查，避免 list 長度不足
    _checkAndRemoveInitialHistory(); // 抽卡時移除 "目前沒有喔"
    tmp = [
      DateTime.now().toString().split('.')[0], //當前時間
      planet[Random(list[0]).nextInt(planet.length)], //守護星
      '${Random(list[1]).nextInt(12) + 1}宮', //宮位
      starSign[Random(list[2]).nextInt(starSign.length)], //星座
    ];
    _history.add('${tmp[0]}\t\t${tmp[1]}\t\t${tmp[2]}\t\t${tmp[3]}');

    if (_history.length > 5) {
      _history.removeAt(0);
    }
  }
}
