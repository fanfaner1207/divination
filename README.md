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
占星

    * (tracking)

        抽有延遲顯示的問題需要處理
        歷史紀錄需要可以刪除
        歷史紀錄需要可以永久保存

    * (closed)

        "抽"的基本功能完成  
        歷史紀錄基本功能完成
        歷史紀錄靠左但要有一點空格
        歷史紀錄"現在沒有喔"隨著抽第一次刪除
        歷史紀錄中間的字體變大、變成一個表
        歷史紀錄要有時間
   
    
寫作輔助器
    * (tracking)      

        與桌面小工具還沒有正式介接        
        預測功能-->之後開發
    * (closed)        

        每日字數計算
        UI 編輯數字功能
        query db         
        updata db
        布局調整
            目前字數
            增加字數(字/天)
            上次使用完整時間
            上次使用日
            上次使用時間

桌面小工具架構

    my_flutter_app/ 
    ├── android/                  # Android 原生模組
    │   ├── app/
    │   │   ├── src/main/
    │   │   │   ├── kotlin/       # Kotlin 程式碼（或 java/ 如果使用 Java）
    │   │   │   │   └── com/example/my_flutter_app/
    │   │   │   │       └── MyWidget.kt   # 小工具的邏輯程式碼
    │   │   │   ├── res/
    │   │   │   │   ├── layout/           # 小工具的 UI 佈局
    │   │   │   │   │   └── widget_layout.xml
    │   │   │   │   ├── xml/             # 小工具的配置
    │   │   │   │   │   └── widget_info.xml
    │   │   │   │   └── values/
    │   │   │   │       └── strings.xml  # 可選，存放文字資源
    │   │   │   └── AndroidManifest.xml  # 註冊小工具
    │   ├── build.gradle          # 確保 Kotlin 支援

    

其他
    * (info)

        flutter create sqlite教學
            https://penueling.com/%e7%b7%9a%e4%b8%8a%e5%ad%b8%e7%bf%92/flutter-%e4%bd%bf%e7%94%a8-sqlite-%e6%9c%ac%e5%9c%b0%e8%b3%87%e6%96%99%e5%ba%ab/


    * (tracking)

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
    * (closed)
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


