import 'package:flutter/material.dart';
import 'tabs/astrology.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'test';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('寶寶輔助器'),
      ),
      body: Center(child: _widgetOptions.elementAt(_setectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.star), label: '占星'),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: '塔羅'),
          ],
          currentIndex: _setectedIndex,
          selectedItemColor: const Color.fromARGB(255, 9, 160, 219),
          onTap: (int index) {
            setState(() {
              _setectedIndex = index;
            });
          }),
    );
  }
}
