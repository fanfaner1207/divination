import 'package:sqflite/sqflite.dart';
import '../model/writing.dart';
import 'package:path/path.dart';

class WritingDB {
  // 為避免重複創建 WritingDB 實例
  // 可以重用同一個實例。使用單例模式來確保只有一個 WritingDB 實例。
  static final WritingDB _instance = WritingDB._internal();
  factory WritingDB() => _instance;
  WritingDB._internal();

  final tableName = 'writing';
  Database? _db; // 定義一個變數來保存資料庫實例

  // 定義一個異步的 getter 方法來獲取資料庫實例
  Future<Database> get db async {
    final path = join(await getDatabasesPath(), 'divination.db');

    // if (_db != null) return _db!; // 如果資料庫實例已經存在，直接返回

    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT, -- 自動遞增的主鍵
        lastUsageTime INTEGER, -- 上次登入時間
        counter INTEGER,-- 目前欠的字數
        uploadWords INTEGER -- 每天增加多少字數
      )
    ''');

      await defaultData(db);
    });
    return _db!;
  }

  Future<int> defaultData(Database db) async {
    //現在時間
    int lastUsageTime = DateTime.now().millisecondsSinceEpoch;
    return await db.rawInsert(
        // ?是占位符，表示要插入的資料值將在之後提供。
        // [ , ]是實際要插入的資料值。
        // VALUES是Sql語法
        'INSERT INTO $tableName (lastUsageTime,counter,uploadWords) VALUES (?,?,?)',
        [lastUsageTime, 10000, 10000]);
  }

  Future<void> removeTable(Database db) async {
    await db.execute('''DROP TABLE $tableName''');
  }

  Future<List<Writing>> fetchAll() async {
    final db = await WritingDB().db;
    String query =
        'SELECT id,lastUsageTime,counter,uploadWords From $tableName';
    final results = await db.rawQuery(query);
    // 利用 map() 將 results (List的每個元素)--> writing 類的Instance
    // print('Database query results: $results');
    final writings =
        List<Writing>.from(results.map((row) => Writing.fromDB(row)));
    // List.from的範例如下
    // List<int> numbers = [1, 2, 3, 4, 5];
    // List<int> newList = List.from(numbers);
    // print(newList); // Output: [1, 2, 3, 4, 5]
    // results.map範例如下
    // final numbers = <int>[1, 2, 3, 5, 6, 7];
    // var result = numbers.where((x) => x < 5); // (1, 2, 3)
    // result = numbers.where((x) => x > 5); // (6, 7)
    // result = numbers.where((x) => x.isEven); // (2, 6)

    return writings;
  }
}
