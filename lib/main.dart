import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'tabs/astrology.dart';
import 'tabs/writingassistant.dart';
import 'tabs/weeklytracker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.comfortable,
        fontFamily: "NotoSansTC",
      ),
      home: const Mystatefulwidget(),
      localizationsDelegates: [  
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
       supportedLocales: [        
        const Locale('zh', 'TW'),
      ],
      locale: Locale('zh', 'TW')
    );
  }
}

class Mystatefulwidget extends StatefulWidget {
  const Mystatefulwidget({super.key});

  @override
  State<Mystatefulwidget> createState() => _MystatefulwidgetState();
}

class _MystatefulwidgetState extends State<Mystatefulwidget> {
  int _setectedIndex = 0;

  static const List _widgetOptions = [Astrology(), WritingAssistant(),WeeklyTracker()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('寶貝專屬APP', textAlign: TextAlign.center),
        backgroundColor: const Color.fromARGB(255, 233, 166, 197),
      ),
      body: Center(child: _widgetOptions.elementAt(_setectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.star), label: '占星'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: '寫作輔助器'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: '點品計次器'),
        ],
        currentIndex: _setectedIndex,
        selectedItemColor: const Color.fromRGBO(234, 100, 163, 1),
        onTap: (int index) {
          setState(() {
            _setectedIndex = index;
          });
        },
      ),
    );
  }
}
