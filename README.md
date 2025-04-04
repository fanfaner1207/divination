# divination

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.





## ALL ISSUE
* 占星    
    (tracking)
        抽有延遲顯示的問題需要處理
        歷史紀錄需要可以刪除
        歷史紀錄需要可以永久保存
    (closed)
        "抽"的基本功能完成        
        歷史紀錄基本功能完成
        歷史紀錄靠左但要有一點空格
        歷史紀錄"現在沒有喔"隨著抽第一次刪除
        歷史紀錄中間的字體變大、變成一個表
        歷史紀錄要有時間
   
    
* 寫作輔助器
    (tracking)
        布局調整
            目前字數
            增加字數(字/天)
            預測功能-->之後開發
            上次登入日
            上次登入時間
            
        數字加總還沒弄好
        與桌面小工具還沒有正式介接
    (closed)

* 其他
    (tracking)
        app的icon沒有正常顯示
        E:\dev\divination\lib\tabs\overlay_page.dart
            *withOpacity要被捨棄了，需要改寫
                'withOpacity' is deprecated and shouldn't be used. Use .withValues() to avoid precision loss.
                Try replacing the use of the deprecated member with the replacement.
            *MediaQuery.of(context).size.height需要改寫 
            Positioned(
                    top: MediaQuery.of(context).size.height * 0.1,
                    bottom: MediaQuery.of(context).size.height * 0.1,
                    left: MediaQuery.of(context).size.width * 0.1,
                    right: MediaQuery.of(context).size.width * 0.1,
    (closed)
        Android NDK 27.0.12077973
            Your project is configured with Android NDK 26.3.11579264, but the following plugin(s) depend on a different Android NDK version:
            fluttertoast requires Android NDK 27.0.12077973
            sqflite_android requires Android NDK 27.0.12077973
            Fix this issue by using the highest Android NDK version (they are backward compatible).
            Add the following to E:\dev\divination\android\app\build.gradle.kts:

            android {
                ndkVersion = "27.0.12077973"
                ...
            }


