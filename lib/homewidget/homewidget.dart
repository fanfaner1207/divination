import 'package:flutter/services.dart';

// Flutter 與原生通訊 (MethodChannel)
// 要讓 Flutter 傳遞資料給小工具，需透過 MethodChannel。

// 定義 Channel 名稱（需與原生端一致）
const channel = MethodChannel('com.example.my_flutter_app/widget');

// 發送資料到原生端
Future<void> updateWidget(String text) async {
  try {
    await channel.invokeMethod('updateWidget', {'text': text});
  } on PlatformException catch (e) {
    print("Failed to update widget: ${e.message}");
  }
}