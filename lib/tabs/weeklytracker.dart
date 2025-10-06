import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WeeklyTracker extends StatefulWidget {
  const WeeklyTracker({super.key});


  @override
  State<WeeklyTracker> createState() => _WeeklyTrackerState();
}

class _WeeklyTrackerState extends State<WeeklyTracker> {
  // int _counter = 0;
  // 建立一個列表來管理7個按鈕的狀態，初始值為空，將從 shared_preferences 載入
  List<String> _sugarStatus = List.filled(7, '還沒吃');
  // 建立星期列表以供動態生成
  final List<String> _weekdays = const ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
 
  String  title="";

  @override
  void initState() {
    super.initState();
    _loadAndCheckWeeklyData();
  }

  Future<void> _loadAndCheckWeeklyData() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSavedDateString = prefs.getString('lastSavedDate');

    DateTime now = DateTime.now();
    bool shouldReset = false;

    if (lastSavedDateString != null) {
      final lastSavedDate = DateTime.parse(lastSavedDateString);
      // 找出今天和上次儲存日期各自所在的星期一
      final startOfThisWeek = now.subtract(Duration(days: now.weekday - 1));
      final startOfLastSavedWeek = lastSavedDate.subtract(Duration(days: lastSavedDate.weekday - 1));
      
      // 如果兩個星期一的日期不同，代表跨週了
      if (startOfThisWeek.year != startOfLastSavedWeek.year ||
          startOfThisWeek.month != startOfLastSavedWeek.month ||
          startOfThisWeek.day != startOfLastSavedWeek.day) {
        shouldReset = true;
      }
    } else {
      // 如果沒有儲存過日期，也算是新的一週的開始
      shouldReset = true;
    }

    if (shouldReset) {
      // 重置資料
      setState(() {
        _sugarStatus = List.filled(7, '還沒吃');
      });
      await prefs.setStringList('sugarStatus', _sugarStatus);
      await prefs.setString('lastSavedDate', now.toIso8601String());
    } else {
      // 載入已儲存的資料
      final savedStatus = prefs.getStringList('sugarStatus');
      if (savedStatus != null) {
        setState(() {
          _sugarStatus = savedStatus;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Center(
          child: Text(
            '點品計次器',
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

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle, // 將所有儲存格設為垂直置中
            border: TableBorder.all(width: 2), // 添加邊框
            columnWidths: {
            0: FixedColumnWidth(100), // 固定列寬
            1: FlexColumnWidth(), // 自適應列寬
            },
            children: [
            TableRow(children: [
            Text('星期', textAlign: TextAlign.center),
            Text('有沒有吃糖', textAlign: TextAlign.center),
            ]),
            // 使用 List.generate 來動態生成每一列，避免重複的程式碼
            ...List.generate(_weekdays.length, (index) {
              return TableRow(
                children: [
                  // 將 Text Widget 置中，讓排版更好看
                  Center(child: Text(_weekdays[index])),
                  Center(
                    child: TextButton( 
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        // 使用 setState 來更新 UI
                        setState(() {
                          // 切換按鈕狀態
                          _sugarStatus[index] = _sugarStatus[index] == '還沒吃' ? '吃了' : '還沒吃';
                          // 儲存更新後的列表和當前日期
                          prefs.setStringList('sugarStatus', _sugarStatus);
                          prefs.setString('lastSavedDate', DateTime.now().toIso8601String());
                          print('${_weekdays[index]} 的按鈕被點擊了，狀態改為: ${_sugarStatus[index]}');
                        });
                      },
                      child: Text(_sugarStatus[index]),
                    ),
                  ),
                ],
              );
            }),
                    
                  ],
                ),
              ],
          ),
      
    ));
  }
}
