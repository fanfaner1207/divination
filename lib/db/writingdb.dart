import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// 創建一個schema
class Writing {
  // id
  final int id;
  // 目前欠的字數
  int wordCount;
  // 每天增加多少字數
  //final int dailyWordIncrement;

  // 小說比賽截止日
  final String? deadlineDate;

  // 上次使用時間(for app and home widget)
  final String? lastUsedDateTime;

  Writing({
    required this.id,
    required this.wordCount,
    // required this.dailyWordIncrement,
    this.deadlineDate,
    this.lastUsedDateTime,
  });

  // 為了產出可以直接使用的資料，所以return出Map的格式
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'wordCount': wordCount,
      // 'dailyWordIncrement': dailyWordIncrement,
      'deadlineDate': deadlineDate,
      'lastUsedDateTime': lastUsedDateTime,
    };
  }
}

// 創建實例
class WritingDB {
  static late Database database;
  static String tableName = 'writing';

  // 建立一個私有函式來處理資料表的建立與初始資料的插入
  static Future<void> _createTableAndSeed(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY,
        wordCount INTEGER,
        dailyWordIncrement INTEGER,
        deadlineDate TEXT,
        lastUsedDateTime TEXT
      )''');
    // 插入第一筆資料
    await db.insert(tableName, {
      'id': 1,
      'wordCount': 10000,
      'dailyWordIncrement': 0,
      'deadlineDate': DateTime.now().toIso8601String().split('T')[0],
      'lastUsedDateTime': DateTime.now().toIso8601String(),
    });
  }

  static Future<Database> initDatabase() async {
    // 完全刪除現有DB
    // deleteDatabase(join(await getDatabasesPath(), "writing.DB"));
    database = await openDatabase(
      join(await getDatabasesPath(), "writing.DB"),

      //onCreate用於「全新安裝」的使用者。它會建立 新 的資料庫結構。
      onCreate: (db, version) async {
        await _createTableAndSeed(db);
      },
      // onUpgrade 用於「升級」現有使用者。當 version 號碼增加時，它會執行。
      // 根據您的需求，這裡會刪除舊資料表並重建。
      onUpgrade: (db, oldVersion, newVersion) async {
        // 1. 刪除現有的資料表
        await db.execute('DROP TABLE IF EXISTS $tableName');
        // 2. 呼叫共用函式來重新建立資料表與初始資料
        await _createTableAndSeed(db);
      },
      version: 2,
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
    return List.generate(maps.length, (i) {
      //List.generate根據指定的長度和生成邏輯創建一個list的方法
      return Writing(
        id: maps[i]['id'],
        wordCount: maps[i]['wordCount'],
        // dailyWordIncrement: maps[i]['dailyWordIncrement'],
        deadlineDate: maps[i]['deadlineDate'] ?? '', // 如果為 null，則給予空字串
        lastUsedDateTime: maps[i]['lastUsedDateTime'] ?? '', // 如果為 null，則給予空字串
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
