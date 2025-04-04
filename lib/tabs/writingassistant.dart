import 'dart:async';
import 'package:divination/model/writing.dart';
import 'package:flutter/material.dart';
import '../db/db_writing.dart';

class WritingAssistant extends StatefulWidget {
  const WritingAssistant({super.key});

  @override
  State<WritingAssistant> createState() => _WritingAssistantState();
}

class _WritingAssistantState extends State<WritingAssistant> {
  //todo 從DB撈所有資料(上次登入時間,目前欠的字數,每天增加多少字數)
  // late Future<TextEditingController> _uploadWordsController; //每天增加多少字數
  // late DateTime datetimePretime =
  //     DateTime.now(); //DateTime型別的當前時間 todo應該可以拿掉late
  // var now = DateTime.now(); //當前時間
  var inputNumber = TextEditingController(); //請輸入數字的變數
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

  @override
  void initState() {
    super.initState();
    fetchWritings();
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

  //顯示時間問題
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
      child: FutureBuilder(
        future: futureWritings,
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
                final futureWriting = snapshot.data![0];
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
                        if (dropdownValue == '+') {
                          // countingWords(int.parse(inputNumber.text));
                        } else {
                          // countingWords(int.parse(inputNumber.text) * -1);
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
                              DataCell(Text('1')),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(Text('增加字數(字/天)')),
                              DataCell(Text('1')),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          // DataRow(
                          //   cells: [
                          //     const DataCell(Text('預測功能')),
                          //     DataCell(Text('1')),
                          //     DataCell(Text('1')),
                          //   ],
                          // ),
                          DataRow(
                            cells: [
                              const DataCell(Text('上次登入日')),
                              DataCell(Text('1')),
                              DataCell(
                                SizedBox.shrink(),
                              ), //直接提供空白 widget 可以避免表格生成時因為缺少資料而拋出錯誤。
                            ],
                          ),
                          DataRow(
                            cells: [
                              const DataCell(Text('上次登入時間')),
                              DataCell(Text('1')),
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
