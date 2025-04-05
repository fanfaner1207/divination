// 創建一個schema
class Writing {
  final int id;
  // 上次登入時間
  final DateTime lastUsageTime;
  // 目前欠的字數
  final int counter;
  // 每天增加多少字數
  final int uploadWords;
  // 差異天數
  final int daysBetween;

  Writing({
    required this.id,
    required this.lastUsageTime,
    required this.counter,
    required this.uploadWords,
    required this.daysBetween,
  });

  factory Writing.fromDB(Map<String, dynamic> map) {
    //   countingWords(days * int.parse(prefer.getString('uploadWords') ?? '1'));
    //   setTime(DateTime.now().millisecondsSinceEpoch);

    DateTime datetimePretime =
        DateTime.fromMillisecondsSinceEpoch(map['lastUsageTime']);
    int days = DateTime.now().day - datetimePretime.day;

    return Writing(
      id: map['id'] ,
      lastUsageTime: datetimePretime,
      counter: map['counter']+ days * map['uploadWords'] as int,
      uploadWords: map['uploadWords'] as int,
      daysBetween: days,
    );
  }
}
