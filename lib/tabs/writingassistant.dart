import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class WritingAssistant extends StatefulWidget {
  const WritingAssistant({super.key});

  @override
  State<WritingAssistant> createState() => _WritingAssistantState();
}

class _WritingAssistantState extends State<WritingAssistant> {
  final Future<SharedPreferences> _prefer = SharedPreferences.getInstance();
  late Future<int> _currentNumber;
  late Future<String> _everydayUploadWords;
  String dropdownValue = '+';
  var inputNumber = TextEditingController();
  var now = DateTime.now();
  late int originalNow;
  late DateTime datetimePretime = DateTime.now();

  Future<void> countingWords(int number) async {
    final SharedPreferences prefer = await _prefer;
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

  @override
  void initState() {
    super.initState();

    _currentNumber = _prefer.then((SharedPreferences prefer) {
      return prefer.getInt('counter') ?? 10000;
    });

    _everydayUploadWords = _prefer.then((SharedPreferences prefer) {
      return prefer.getString('everydayUploadWords') ?? '0';
    });

    TextEditingController __everydayUploadWordsController =
        TextEditingController(text: _everydayUploadWords as String);

    _prefer.then((SharedPreferences prefer) {
      originalNow = prefer.getInt('time') as int;
      datetimePretime = DateTime.fromMillisecondsSinceEpoch(originalNow);
      Duration diff = DateTime.now().difference(datetimePretime);
      countingWords(diff.inMinutes * 1);
      setTime(DateTime.now().millisecondsSinceEpoch); //
    });
  }

  //顯示時間問題
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.fromLTRB(25, 40, 25, 25),
        child: Column(
          children: [
            FutureBuilder(
              future: _currentNumber,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text('Error:${snapshot.error}');
                    } else {
                      return Text(
                        style: const TextStyle(fontSize: 20, shadows: [
                          Shadow(
                              offset: Offset(0.5, 0.5),
                              blurRadius: 3.0,
                              color: Colors.grey)
                        ]),
                        '目前欠的字數喔：${snapshot.data}',
                        textAlign: TextAlign.center,
                      );
                    }
                }
              },
            ),
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  tooltip: "+1000",
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    countingWords(1000);
                  },
                ),
                IconButton(
                  tooltip: "-1000",
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    countingWords(-1000);
                  },
                ),
              ],
            ),
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
                      hintText: '僅可以輸入數字',
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
                    countingWords(int.parse(inputNumber.text));
                  } else {
                    countingWords(int.parse(inputNumber.text) * -1);
                  }
                },
                // ignore: unnecessary_brace_in_string_interps
                child: Text('${dropdownValue}字數')),
            Container(
                padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                      child: Row(
                        children: [
                          const Text('每天增加多少字呢？'),
                          // FutureBuilder(
                          //   future: _everydayUploadWords,
                          //   builder: (BuildContext context,
                          //       AsyncSnapshot<String> snapshot) {
                          //     switch (snapshot.connectionState) {
                          //       case ConnectionState.none:
                          //       case ConnectionState.waiting:
                          //         return const CircularProgressIndicator();
                          //       case ConnectionState.active:
                          //       case ConnectionState.done:
                          //         if (snapshot.hasError) {
                          //           return Text('Error:${snapshot.error}');
                          //         } else {
                          //           return Text(
                          //             style: const TextStyle(
                          //                 fontSize: 20,
                          //                 shadows: [
                          //                   Shadow(
                          //                       offset: Offset(0.5, 0.5),
                          //                       blurRadius: 3.0,
                          //                       color: Colors.grey)
                          //                 ]),
                          //             '目前欠的字數喔：${snapshot.data}',
                          //             textAlign: TextAlign.center,
                          //           );
                          //         }
                          //     }
                          //   },
                          // ),

                          //     TextField(
                          //       controller: _controller,
                          //   keyboardType: TextInputType.number,
                          // )                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.check_circle))
                        ],
                      ),
                    ),
                    Text(
                      '上次登入時間：${datetimePretime.year}/${datetimePretime.month.toString().padLeft(2, '0')}/${datetimePretime.day.toString().padLeft(2, '0')} ${datetimePretime.hour.toString().padLeft(2, '0')}: ${datetimePretime.minute.toString().padLeft(2, '0')}',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ))
          ],
        ));
  }
}
