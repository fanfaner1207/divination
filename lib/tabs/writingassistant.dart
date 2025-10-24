import 'package:flutter/material.dart';
import '../db/writingdb.dart';
import 'package:flutter/services.dart'; //FilteringTextInputFormatter需要

class WritingAssistant extends StatefulWidget {
  const WritingAssistant({super.key});

  @override
  State<WritingAssistant> createState() => _WritingAssistantState();
}

class _WritingAssistantState extends State<WritingAssistant> {
  bool isWordCountEditing = false;
  final inputWordCount = TextEditingController();
  bool isDeadlineDateEditing = false;
  final inputsDeadlineDate = TextEditingController();
  

  late Future<List<Writing>> futureListWriting;

  Future<List<Writing>> getwritingdata() async {
    List<Writing> list = await WritingDB.getWriting();
    
    // if (list.isNotEmpty) {
    //   try {
    //     DateTime today = DateTime.now();
  
    //     // 只有在 lastUsedDateTime 有效時才進行解析和計算
    //     if (list[0].lastUsedDateTime != null &&
    //         list[0].lastUsedDateTime!.isNotEmpty) {
    //       DateTime lastUsed = DateTime.parse(list[0].lastUsedDateTime!);
  
    //       int daysDifference = today.difference(lastUsed).inDays;
  
    //       // 只有在天數差異大於0時才更新，避免同一天內重複計算
    //       if (daysDifference > 0) {
    //         list[0].wordCount =
    //             list[0].wordCount + daysDifference * list[0].dailyWordIncrement;
    //       }
  
    //       // 更新上次使用時間
    //       await WritingDB.updateWriting({
    //         'wordCount': list[0].wordCount,
    //         'lastUsedDateTime': DateTime.now().toIso8601String(),
    //       });
    //     }
    //   } on FormatException catch (e) {
    //     // Handle the case where the date format is invalid
    //     print('Error parsing date: ${e.message}');
    //     // You might want to set a default value or show an error to the user
    //   }
    // }
    return list;
  }

  // 顯示日期選擇器並更新資料庫
  Future<void> _selectDate(BuildContext context, Writing writingData) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      // 嘗試解析現有日期，如果失敗或為空，則使用今天
      initialDate: DateTime.tryParse(writingData.deadlineDate ?? '') ?? DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2101),
      locale: Locale('zh', 'TW')
    );
    
    if (picked != null) {
      print(picked.toIso8601String().split('T')[0]);
      //這裡有問題
      
      await WritingDB.updateWriting({
        'deadlineDate': picked.toIso8601String().split('T')[0],
      });
      setState(() {
        futureListWriting = getwritingdata();
      });
    }
  }

  // 計算每日應增加的字數
  String _calculateDailyWordIncrement(Writing writingData) {
    // 1. 檢查截止日期是否存在且不為空
    if (writingData.deadlineDate == null || writingData.deadlineDate!.isEmpty) {
      return "N/A"; // 沒有截止日期，無法計算
    }

    try {
      // 2. 將字串轉換為 DateTime 物件
      final deadline = DateTime.parse(writingData.deadlineDate!);
      final todayDate = DateTime.parse(DateTime.now().toIso8601String().split('T')[0]);

      // 3. 計算天數差異（加 1 以包含今天）
      final differenceInDays = deadline.difference(todayDate).inDays + 1;

      // 4. 避免除以零或負數
      if (differenceInDays <= 0) {
        return "已到期";
      }

      // 5. 計算並回傳結果，四捨五入到整數
      final dailyIncrement = (writingData.wordCount / differenceInDays).ceil();
      return dailyIncrement.toString();
    } catch (e) {
      // 如果日期格式錯誤，回傳錯誤訊息
      return "日期錯誤";
    }
  }


  @override
  void initState() {
    super.initState();
    futureListWriting = getwritingdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: const Center(
          child: Text(
            '寫作輔助器',
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
      
    
    body:Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
      child: FutureBuilder(
        future: futureListWriting,
        builder: (BuildContext context, AsyncSnapshot<List<Writing>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error:${snapshot.error}');
              } else {
                Writing listArr = snapshot.data![0]; 
                
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50), // 控制與上方的距離
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
                          DataColumn(label: Text('資訊')),
                          DataColumn(label: Text('')),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              const DataCell(Text('未完成總字數')),
                              DataCell(
                                isWordCountEditing
                                    ? TextField(
                                      controller: inputWordCount,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ], // 限制只能輸入數字
                                      decoration: const InputDecoration(
                                        hintText: '請輸入',
                                      ),
                                      autofocus: true,
                                      onSubmitted: (value) async {
                                        if (value.isNotEmpty) {
                                          await WritingDB.updateWriting({
                                            'wordCount':
                                                int.parse(value),
                                          });
                                          setState(() {
                                            futureListWriting =
                                                getwritingdata();

                                            isWordCountEditing =
                                                !isWordCountEditing;
                                          });
                                        }
                                      },
                                    )
                                    : Text(listArr.wordCount.toString()),
                              ),

                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      isWordCountEditing = !isWordCountEditing;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(Text('截止日期')),
                              // 將 listArr.deadlineDate.isEmpty 修改為 listArr.deadlineDate?.isEmpty ?? true。這段程式碼的意思是：
                              // listArr.deadlineDate?：如果 deadlineDate 不是 null，就存取它的 .isEmpty 屬性。
                              // ?? true：如果 deadlineDate 是 null，則整個表達式的结果為 true。
                              // 這樣就能安全地判斷字串是否為空，即使它本身可能是 null。
                              // lastUsedDateTime 的顯示邏輯也做了同樣的修改。
                              DataCell(Text(listArr.deadlineDate?.isEmpty ?? true ? "未設定" : listArr.deadlineDate!)),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _selectDate(context, listArr),
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(Text('增加字數(字/天)')),
                              DataCell(Text(_calculateDailyWordIncrement(listArr))),
                              
                              DataCell(
                                SizedBox.shrink(),
                              ),
                            ],
                          ),
                          
                          DataRow(
                            cells: [
                              const DataCell(Text('上次使用時間')),
                              DataCell(Text(listArr.lastUsedDateTime?.isEmpty ?? true ? "" : listArr.lastUsedDateTime!.replaceAll('T', ' ').split('.')[0])),
                              
                              DataCell(
                                SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
          }
        },
      ),
    )
    );
  }
}
