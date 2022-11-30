import 'Task.dart';

class TaskPriorityQueue {
  late List<Task> _array;

  TaskPriorityQueue() {
    _array = [];
  }

  int lastParent() => _array.length == 1 ? 0 : (_array.length / 2 - 1).toInt();
  int leftChild(int pos) => pos * 2 + 1;
  int rightChild(int pos) => pos * 2 + 2;
  int parent(int pos) => ((pos + 1) / 2 - 1).toInt();

  void insert(Task newTask) {
    increment();
    if (_array[0].priority == 0) {
      _array[0] = newTask;
    } else {
      int left = leftChild(lastParent());
      int right = rightChild(lastParent());
      if (_array[left].priority == 0) {
        _array[left] = newTask;
        heapfi(left);
      } else if (_array[right].priority == 0) {
        _array[right] = newTask;
        heapfi(right);
      }
    }
  }

  Task pop() {
    Task root = _array[0];
    _array[0] = _array[_array.length - 1];
    heapfiDown(0);
    decrease();
    return root;
  }

  Task front() => _array[0];

  void increment() {
    var replace = List.filled(
        _array.length + 1,
        Task(
          0,
          "",
          DateTime.now(),
          "very low",""
        ));
    for (var i = 0; i < _array.length; i++) {
      replace[i] = _array[i];
    }
    _array = replace;
  }

  void decrease() {
    var replace = List.filled(
        _array.length - 1,
        Task(
          0,
          "",
          DateTime.now(),
          "very low",""
        ));
    for (var i = 0; i < _array.length - 1; i++) {
      replace[i] = _array[i];
    }
    _array = replace;
  }

  void heapfi(int pos) {
    int father = parent(pos);
    if (pos != 0 && _array[pos].compareTo(_array[father]) == 1) {
      Task aux = _array[father];
      _array[father] = _array[pos];
      _array[pos] = aux;
      heapfi(father);
    }
  }

  void heapfiDown(int pos) {
    var left, right;
    if (leftChild(pos) < _array.length) left = leftChild(pos);
    if (rightChild(pos) < _array.length) right = rightChild(pos);

    int max = _array[left ?? 0].compareTo(_array[right ?? 0]) == 1
        ? left ?? 0
        : right ?? 0;

    if (_array[max].compareTo(_array[pos]) == 1) {
      Task aux = _array[max];
      _array[max] = _array[pos];
      _array[pos] = aux;
      heapfi(max);
    }
  }

  List<Task> getOrderTasksByPriority() {
    List<Task> list = [];
    while (!_array.isEmpty) {
      list.add(pop());
    }
    list.forEach((element) {
      insert(element);
    });
    return list;
  }

  List<Task> getOrderTasksByEndDate() {
    List<Task> copyArray = List.from(_array);
    _orderByPriority(copyArray, 0, copyArray.length - 1);
    return copyArray;
  }

  void _orderByPriority(List<Task> tasks, int first, int last) {
    int i, j, center;
    center = (first + last) ~/ 2;
    i = first;
    j = last;
    var pivot = tasks[center];

    do {
      while (tasks[i].endDateTime.compareTo(pivot.endDateTime) == -1) i++;
      while (tasks[j].endDateTime.compareTo(pivot.endDateTime) == 1) j--;
      if (i <= j) {
        Task temp = tasks[i];
        tasks[i] = tasks[j];
        tasks[j] = temp;
        i++;
        j--;
      }
    } while (i <= j);
    if (j > first) _orderByPriority(tasks, first, j);
    if (i < last) _orderByPriority(tasks, i, last);
  }

  @override
  String toString() {
    var info = "";
    for (var task in _array) {
      info += task.toString() + "\n";
    }
    return info;
  }

  List<Task> getTaskByDate(List<Task> tasks, DateTime endDateTime) {
    int index = _binarySearch(tasks, 0, tasks.length - 1, endDateTime);
    List<Task> aux = [];
    if (index != -1) {
      aux.add(tasks[index]);
      for (int i = index - 1;
          i >= 0 && tasks[i].endDateTime.compareTo(endDateTime) == 0;
          i--) {
        aux.add(tasks[i]);
      }
      for (int i = index + 1;
          i < tasks.length && tasks[i].endDateTime.compareTo(endDateTime) == 0;
          i++) {
        aux.add(tasks[i]);
      }
    }
    return aux;
  }

  int _binarySearch(List<Task> tasks, int l, int r, DateTime endDateTime) {
    int middle = (l + r) ~/ 2;
    if (r < l) return -1;
    if (tasks[middle].endDateTime.compareTo(endDateTime) == -1)
      return _binarySearch(tasks, middle + 1, r, endDateTime);
    if (tasks[middle].endDateTime.compareTo(endDateTime) == 1)
      return _binarySearch(tasks, l, middle - 1, endDateTime);
    return middle;
  }
}
