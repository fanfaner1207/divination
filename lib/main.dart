import 'package:flutter/material.dart';
import 'tabs/astrology.dart';
import 'tabs/badfriend.dart';
// import 'tabs/webrtc.dart';

// TODO global 字型

void main() {
  // checkPlatform();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'test';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.comfortable,
      fontFamily: "PingFang",
      textTheme: TextTheme(
        
      )),
      home: Mystatefulwidget(),

    );
  }
}

class Mystatefulwidget extends StatefulWidget {
  const Mystatefulwidget({Key? key}) : super(key: key);

  @override
  State<Mystatefulwidget> createState() => _MystatefulwidgetState();
}

class _MystatefulwidgetState extends State<Mystatefulwidget> {
  int _setectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List _widgetOptions = [
    Astrology(),
    Text('塔羅', style: optionStyle),
    Badfriend(),
    // Webrtc()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('小玉妹妹&釩哥哥的天地', textAlign: TextAlign.center),
        backgroundColor: const Color.fromRGBO(234, 100, 163, 1),
      ),
      body: Center(child: _widgetOptions.elementAt(_setectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.star), label: '占星'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: '塔羅'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: '月曆'),
            // BottomNavigationBarItem(icon: Icon(Icons.star), label: '視訊'),
          ],
          currentIndex: _setectedIndex,
          selectedItemColor: const Color.fromRGBO(234, 100, 163, 1),
          onTap: (int index) {
            setState(() {
              _setectedIndex = index;
            });
          }),
    );
  }
}
