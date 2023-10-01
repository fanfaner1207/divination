import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();

  static void updateWidget(
      {required String name,
      required String androidName,
      required String iOSName,
      required String qualifiedAndroidName}) {}
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // 調用 HomeWidget.updateWidget 來重新加載 HomeScreenWidget
        HomeWidget.updateWidget(
          name: 'HomeWidgetExampleProvider',
          androidName: 'HomeWidgetExampleProvider',
          iOSName: 'HomeWidgetExample',
          qualifiedAndroidName: 'com.example.app.HomeWidgetExampleProvider',
        );
      },
      child: const Text('Reload HomeScreenWidget'),
    );
  }
}
