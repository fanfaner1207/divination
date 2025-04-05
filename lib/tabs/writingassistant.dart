// import 'dart:async';
import 'package:flutter/material.dart';
// new class
import '../db/test_writingdb.dart';
import 'package:flutter/services.dart'; //FilteringTextInputFormatter需要
/* old class
// import 'package:divination/model/writing.dart';
// import '../db/db_writing.dart';
*/

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
  /*
  //todo 從DB撈所有資料(上次登入時間,目前欠的字數,每天增加多少字數)
  // late Future<TextEditingController> _uploadWordsController; //每天增加多少字數
  // late DateTime datetimePretime =
  //     DateTime.now(); //DateTime型別的當前時間 todo應該可以拿掉late
  // var now = DateTime.now(); //當前時間
  // 
  String dropdownValue = '+'; //下拉是選單預設為+
  final WritingDB _writingDB = WritingDB();
  /*
  Future<void> countingWords(int number) async {
    //final SharedPreferences prefer = await _prefer;
    // ??檢查變數是否為空，如果變數不為空，則返回變數的值，否則返回指定的默認值。
    final int currentNumber = (prefer.getInt('counter') ?? 10000) + number;

    setState(() {
      _currentNumber =
          prefer.setInt('counter', currentNumber).then((bool success) {
        success == true
            ? debugPrint("set counter success")
            : debugPrint("set counter fail");
        return currentNumber;
      });
    });
  }

  Future<void> setTime(int time) async {
    final SharedPreferences prefer = await _prefer;
    // ??檢查變數是否為空，如果變數不為空，則返回變數的值，否則返回指定的默認值。
    // final int currentTime = (prefer.getInt('time') ?? DateTime.now().millisecondsSinceEpoch);

    setState(() {
      prefer.setInt('time', time).then((bool success) {
        success == true
            ? debugPrint("set time success")
            : debugPrint("set time fail");
        // return time;
      });
    });
  }

  Future<void> setuploadWords(String str) async {
    final SharedPreferences prefer = await _prefer;
    // ??檢查變數是否為空，如果變數不為空，則返回變數的值，否則返回指定的默認值。

    setState(() {
      prefer.setString('uploadWords', str).then((bool success) {
        success == true
            ? debugPrint("set time success")
            : debugPrint("set time fail");
        // return time;
      });
    });
  }
*/
  late Future<List<Writing>>
  futureWritings; //late允許延遲初始化一個變數，我們需要在initState()中初始化一個變數

  void fetchWritings() {
    setState(() {
      futureWritings = _writingDB.fetchAll();
    });
  }


    /*   

    // _uploadWordsController = _prefer.then((SharedPreferences prefer) {
    //   return TextEditingController(
    //       text: prefer.getString('uploadWords') ?? '1');
    // });

    // _prefer.then((SharedPreferences prefer) {
    //   // 每天調整
    //   originalNow =
    //       (prefer.getInt('time') ?? DateTime.now().millisecondsSinceEpoch);
    //   datetimePretime = DateTime.fromMillisecondsSinceEpoch(originalNow);
    //   int days = DateTime.now().day - datetimePretime.day;
    //   // Duration diff = DateTime.now().difference(datetimePretime);

    //   countingWords(days * int.parse(prefer.getString('uploadWords') ?? '1'));
    //   setTime(DateTime.now().millisecondsSinceEpoch);
    // });
    */
  }



*/

  late Future<List<Writing>> Future_List_Writing;

  Future<List<Writing>> getwritingdata() async {
    final list = await WritingDB.getWriting();
    return list;
  }

  void updatedbDate() async {
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
    updatedbDate();
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
                /*return Column(children: [
                  Text(
                    style: const TextStyle(fontSize: 20, shadows: [
                      Shadow(
                          offset: Offset(0.5, 0.5),
                          blurRadius: 3.0,
                          color: Colors.grey)
                    ]),
                    '目前欠的字數喔：${futureWriting.counter}',
                    textAlign: TextAlign.center,
                  ),
                  OverflowBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          tooltip: "+1000",
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            // countingWords(1000);
                          },
                        ),
                        IconButton(
                          tooltip: "-1000",
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            // countingWords(-1000);
                          },
                        ),
                      ]),
                  Row(
                    children: [
                      DropdownButton<String>(
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!; //!是變數的null check
                          });
                        },
                        items: <String>['+', '-']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      Expanded(
                        child: TextField(
                          controller: inputNumber,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: '請輸入數字',
                          ),
                        ),
                      )
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        if (inputNumber.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('臭臭寶寶亂按,明明就沒有數字')));
                        }
                        
                      },
                      // ignore: unnecessary_brace_in_string_interps
                      child: Text('${dropdownValue}字數')),
                  Container(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: const Row(
                              children: [
                                Text('每天增加多少字呢？'),

                                // Expanded(
                                //   child: FutureBuilder(
                                //     future: _uploadWordsController,
                                //     builder: (BuildContext context,
                                //         AsyncSnapshot<TextEditingController>
                                //             snapshot) {
                                //       switch (snapshot.connectionState) {
                                //         case ConnectionState.none:
                                //         case ConnectionState.waiting:
                                //           return const CircularProgressIndicator();
                                //         case ConnectionState.active:
                                //         case ConnectionState.done:
                                //           if (snapshot.hasError) {
                                //             return Text('Error:${snapshot.error}');
                                //           } else {
                                //             return TextField(
                                //               textAlign: TextAlign.center,
                                //               controller: snapshot.data,
                                //               keyboardType: TextInputType.number,
                                //               onTap: () {
                                //                 snapshot.data?.selection =
                                //                     TextSelection(
                                //                   baseOffset: 0,
                                //                   extentOffset: snapshot
                                //                       .data!.value.text.length,
                                //                 );
                                //               },
                                //             );
                                //           }
                                //       }
                                //     },
                                //   ),
                                // ),
                                // IconButton(
                                //   onPressed: () async {
                                //     TextEditingController controller =
                                //         await _uploadWordsController;
                                //     // setuploadWords(controller.text);
                                //     // ignore: use_build_context_synchronously
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //         const SnackBar(content: Text('已調整每日要新增的字數')));
                                //   },
                                //   icon: const Icon(Icons.check_circle),
                                // )
                              ],
                            ),
                          ),
                          // Text(
                          //   '上次登入時間：${datetimePretime.year}/${datetimePretime.month.toString().padLeft(2, '0')}/${datetimePretime.day.toString().padLeft(2, '0')} ${datetimePretime.hour.toString().padLeft(2, '0')}: ${datetimePretime.minute.toString().padLeft(2, '0')}',
                          //   textAlign: TextAlign.center,
                          // ),
                        ],
                      )),
                ]);*/
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
