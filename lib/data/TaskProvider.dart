import 'package:tasks/models/TaskPriorityQueue.dart';

import '../models/Task.dart';

class TaskProvider {
  TaskPriorityQueue getTaskPriorityQueue() {
    TaskPriorityQueue taskPriorityQueue = new TaskPriorityQueue();
    taskPriorityQueue
        .insert(Task(1, "DER", DateTime.parse("2022-12-10"), "high","Havana"));
    taskPriorityQueue
        .insert(Task(2, "MER", DateTime.parse("2022-12-09"), "medium","Villa Clara"));
    taskPriorityQueue.insert(
        Task(3, "Data Structure", DateTime.parse("2022-12-11"), "high","Guantanamo", 1));
    taskPriorityQueue.insert(
        Task(4, "Requirements", DateTime.parse("2022-12-11"), "high","Holguin" ,1));
    return taskPriorityQueue;
  }
}
