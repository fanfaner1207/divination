// import 'dart:async';
import 'package:flutter/material.dart';
// new class
import '../db/test_writingdb.dart';
import 'package:flutter/services.dart'; //FilteringTextInputFormatter需要

class WritingAssistant extends StatefulWidget {
  const WritingAssistant({super.key});

  @override
  State<WritingAssistant> createState() => _WritingAssistantState();
}

class _WritingAssistantState extends State<WritingAssistant> {
  bool isWordCountEditing = false;
  final inputWordCount = TextEditingController();
  bool isWordIncrementEditing = false;
  final inputsWordIncrement = TextEditingController();

  late Future<List<Writing>> Future_List_Writing;

  Future<List<Writing>> getwritingdata() async {
    List<Writing> list = await WritingDB.getWriting();
    // 更新目前字數
    DateTime today = DateTime.now();
    DateTime wordIncrementLastChgDateDateTime = DateTime.parse(
      list[0].wordIncrementLastChgDate,
    );
    int daysDifference =
        today.difference(wordIncrementLastChgDateDateTime).inDays;

    print("調整前");
    print(list[0].wordCount);
    list[0].wordCount =
        list[0].wordCount + daysDifference * list[0].dailyWordIncrement;

    print("調整後");
    print(list[0].wordCount);
    return list;
  }

  void updateDate() async {
    // 更新之前上此使用時間
    String now = DateTime.now().toIso8601String();
    Map<String, dynamic> updateData = {
      'lastUsedDateTime': now,
      'lastUsedDate': now.split('T')[0], // 提取日期部分
      'lastUsedTime': now.split('T')[1].split('.')[0], // 提取時間部分
      // 'lastUsedTime': "1",
    };
    setState(() {
      WritingDB.updateWriting(updateData);
    });
  }

  @override
  void initState() {
    super.initState();
    Future_List_Writing = getwritingdata();
    updateDate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
      child: FutureBuilder(
        future: Future_List_Writing,
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
                              const DataCell(Text('目前字數')),
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
                                            'wordCount': int.parse(value),
                                          });
                                          setState(() {
                                            Future_List_Writing =
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
                              const DataCell(Text('增加字數(字/天)')),
                              DataCell(
                                isWordIncrementEditing
                                    ? TextField(
                                      controller: inputsWordIncrement,
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
                                            'dailyWordIncrement': int.parse(
                                              value,
                                            ),
                                            'wordIncrementLastChgDate':
                                                DateTime.now()
                                                    .toIso8601String()
                                                    .split('T')[0],
                                          });
                                          setState(() {
                                            Future_List_Writing =
                                                getwritingdata();

                                            isWordIncrementEditing =
                                                !isWordIncrementEditing;
                                          });
                                        }
                                      },
                                    )
                                    : Text(
                                      listArr.dailyWordIncrement.toString(),
                                    ),
                              ),

                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      isWordIncrementEditing =
                                          !isWordIncrementEditing;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          DataRow(
                            cells: [
                              const DataCell(Text('上次使用日')),
                              DataCell(Text(listArr.lastUsedDate)),
                              DataCell(
                                SizedBox.shrink(),
                              ), //直接提供空白 widget 可以避免表格生成時因為缺少資料而拋出錯誤。
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(Text('上次使用時間')),
                              DataCell(Text(listArr.lastUsedTime)),
                              DataCell(
                                SizedBox.shrink(),
                              ), //直接提供空白 widget 可以避免表格生成時因為缺少資料而拋出錯誤。
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
    );
  }
}
