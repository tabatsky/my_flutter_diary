class EventEntry {
  int id = 0;
  int type;
  DateTime dateTime;

  EventEntry(this.type, this.dateTime);

  EventEntry.fromDb(this.id, this.type, this.dateTime);

  int _deltaTime() {
    return (DateTime.now().millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch) ~/ 1000 * 20;
  }

  String toString() {
    int dt = _deltaTime();
    if (dt < 60 * 60) {
      int min = dt ~/ 60;
      int sec = dt - 60 * min;
      return "$min m $sec s";
    } else if (dt < 24 * 60 * 60) {
      int minTotal = dt ~/ 60;
      int hour = minTotal ~/ 60;
      int min = minTotal - 60 * hour;
      return "$hour h $min m";
    } else {
      int hourTotal = dt ~/ (60 * 60);
      int day = hourTotal ~/ 24;
      int hour = hourTotal - 24 * day;
      return "$day d $hour h";
    }
  }
}