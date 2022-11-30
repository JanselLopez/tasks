class Task implements Comparable {
  late int id;
  late String name;
  late DateTime endDateTime;
  late String importance;
  late int priority;
  late int? idBoss;
  late String place;
  Task(int id, String name, DateTime endDateTime, String importance, String place,
      [int? idBoss]) {
    this.id = id;
    this.name = name;
    this.endDateTime = endDateTime;
    this.importance = importance;
    this.idBoss = idBoss;
    this.place = place;
    this.priority = _getPriority();
  }

  @override
  String toString() =>
      "$id: $name(i:$importance, p:$priority) end $endDateTime";

  int _getPriority() {
    var prior = 0;
    final diff = endDateTime.difference(DateTime.now()).inDays;
    if (diff > 0) {
      switch (importance) {
        case "very high":
          prior += 20;
          break;
        case "high":
          prior += 15;
          break;
        case "medium":
          prior += 10;
          break;
        case "low":
          prior += 5;
          break;
        default:
          prior += 2;
          break;
      }
      if (diff > 30) {
        prior++;
      } else if (diff > 15) {
        prior += 2;
      } else if (diff > 7) {
        prior += 5;
      } else if (diff > 2) {
        prior += 10;
      } else {
        prior += 15;
      }
      if (idBoss != null) prior += 10;
    }
    return prior;
  }

  @override
  int compareTo(other) {
    if (priority < (other as Task).priority) return -1;
    if (priority > other.priority) return 1;
    return 0;
  }
}
