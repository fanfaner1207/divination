import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// 創建一個schema
class Writing {
  // id
  final int id;
  // 目前欠的字數
  late final int wordCount;
  // 每天增加多少字數
  final int dailyWordIncrement;
  // 改變每天增加多少字數的那一天
  final String wordIncrementLastChgDate;
  // 上次使用完整時間
  final String lastUsedDateTime;
  // 上次使用日
  final String lastUsedDate;
  // 上次使用時間
  final String lastUsedTime;
  Writing({
    required this.id,
    required this.wordCount,
    required this.dailyWordIncrement,
    required this.wordIncrementLastChgDate,
    required this.lastUsedDateTime,
    required this.lastUsedDate,
    required this.lastUsedTime,
  });

  // 為了產出可以直接使用的資料，所以return出Map的格式
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'wordCount': wordCount,
      'dailyWordIncrement': dailyWordIncrement,
      'wordIncrementLastChgDate': wordIncrementLastChgDate,
      'lastUsedDateTime': lastUsedDateTime,
      'lastUsedDate': lastUsedDate,
      'lastUsedTime': lastUsedTime,
    };
  }
}

// 創建實例
class WritingDB {
  static late Database database;
  static String tableName = 'writing';

  static Future<Database> initDatabase() async {
    // 完全刪除現有DB
    // deleteDatabase(join(await getDatabasesPath(), "writing.DB"));

    database = await openDatabase(
      join(await getDatabasesPath(), "writing.DB"),

      //創建table
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY,
        wordCount INTEGER,
        dailyWordIncrement INTEGER,
        wordIncrementLastChgDate TEXT,
        lastUsedDateTime TEXT,
        lastUsedDate TEXT,
        lastUsedTime TEXT)''');
        // 插入第一筆資料
        await db.insert(tableName, {
          'id': 1,
          'wordCount': 10000,
          'dailyWordIncrement': 0,
          'wordIncrementLastChgDate':
              DateTime.now().toIso8601String().split('T')[0],
          'lastUsedDateTime': "NA",
          'lastUsedDate': "NA", // 提取日期部分
          'lastUsedTime': "NA", // 提取時間部分
        });
      },
      version: 1,
    );
    return database;
  }

  // 避免每次開啟都重新建立DB，加上一個防呆的判斷
  static Future<Database> getDBConnect() async {
    // 檢查是否已初始化
    try {
      // return await initDatabase();
      return database;
    } catch (_) {
      // _ 是 Dart 中的一種命名規則，表示這個變數不會被使用（類似於「忽略」的意思）
      return await initDatabase();
    }
  }

  //query data
  static Future<List<Writing>> getWriting() async {
    final Database db = await getDBConnect();
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
    ); //query裡面放的是table名稱
    print(maps);
    return List.generate(maps.length, (i) {
      //List.generate根據指定的長度和生成邏輯創建一個list的方法
      return Writing(
        id: maps[i]['id'],
        wordCount: maps[i]['wordCount'],
        dailyWordIncrement: maps[i]['dailyWordIncrement'],
        wordIncrementLastChgDate: maps[i]['wordIncrementLastChgDate'],
        lastUsedDateTime: maps[i]['lastUsedDateTime'],
        lastUsedDate: maps[i]['lastUsedDate'],
        lastUsedTime: maps[i]['lastUsedTime'],
      );
    });
  }

  //update data
  static Future<void> updateWriting(Map<String, Object?> mapData) async {
    final Database db = await getDBConnect();
    await db.update(
      tableName,
      mapData,
      where: "id = 1",
      // whereArgs: [mapData.id],
    );
  }
}
