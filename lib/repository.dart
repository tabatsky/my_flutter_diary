import 'package:sqflite/sqflite.dart';
import 'event_entry.dart';

class Repository {
  static final Repository _instance = Repository._privateConstructor();
  Database? _db;

  factory Repository() {
    return _instance;
  }

  Repository._privateConstructor();

  Future<void> createTableIfNotExists() async {
    _db = await openDatabase('my_flutter_diary.db');

    await _db?.execute(
      "CREATE TABLE IF NOT EXISTS diary (id INTEGER PRIMARY KEY AUTOINCREMENT, type INTEGER NOT NULL DEFAULT 0, time INTEGER NOT NULL DEFAULT 0);"
    );

    //await db.close();
  }

  Future<void> addEvent(EventEntry entry) async {
    await _db?.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO diary(type, time) VALUES(?, ?)',
          [entry.type, entry.dateTime.millisecondsSinceEpoch]);
    });

    //await db.close();
  }

  Future<List<EventEntry>> getAllEvents() async {
    List<EventEntry> result = <EventEntry>[];

    await createTableIfNotExists();
    List<Map> list = await _db?.rawQuery('SELECT * FROM diary ORDER BY time DESC') ?? [];

    for (var map in list) {
      int id = map["id"] as int;
      int type = map["type"] as int;
      int time = map["time"] as int;
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time);
      EventEntry entry = EventEntry.fromDb(id, type, dateTime);
      result.add(entry);
    }

    return result;
  }
}