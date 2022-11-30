class PriorityQueue<T extends Comparable> {
  late List<T?> _array;

  PriorityQueue() {
    _array = [];
  }

  int lastParent() => _array.length == 1 ? 0 : (_array.length / 2 - 1).toInt();
  int leftChild(int pos) => pos * 2 + 1;
  int rightChild(int pos) => pos * 2 + 2;
  int parent(int pos) => ((pos + 1) / 2 - 1).toInt();
  bool isEmpty() => _array.isEmpty;

  void insert(T item) {
    increment();
    if (_array[0] == null) {
      _array[0] = item;
    } else {
      int left = leftChild(lastParent());
      int right = rightChild(lastParent());
      if (_array[left] == null) {
        _array[left] = item;
        _heapfi(left);
      } else if (_array[right] == null) {
        _array[right] = item;
        _heapfi(right);
      }
    }
  }

  T? pop() {
    T? root = _array[0];
    _array[0] = _array[_array.length - 1];
    _heapfiDown(0);
    _decrease();
    return root;
  }

  T? front() => _array[0];

  void increment() {
    List<T?> replace = List.filled(_array.length + 1, null);
    for (var i = 0; i < _array.length; i++) {
      replace[i] = _array[i];
    }
    _array = replace;
  }

  _decrease() {
    List<T?> replace = List.filled(_array.length - 1, null);
    for (var i = 0; i < _array.length - 1; i++) {
      replace[i] = _array[i];
    }
    _array = replace;
  }

  _heapfi(int pos) {
    int father = parent(pos);
    if (pos != 0 && (_array[pos])?.compareTo(_array[father]) == 1) {
      T? aux = _array[father];
      _array[father] = _array[pos];
      _array[pos] = aux;
      _heapfi(father);
    }
  }

  _heapfiDown(int pos) {
    var left, right;
    if (leftChild(pos) < _array.length) left = leftChild(pos);
    if (rightChild(pos) < _array.length) right = rightChild(pos);

    int max = (_array[left ?? 0])?.compareTo(_array[right ?? 0]) == 1
        ? left ?? 0
        : right ?? 0;

    if ((_array[max])?.compareTo(_array[pos]) == 1) {
      T? aux = _array[max];
      _array[max] = _array[pos];
      _array[pos] = aux;
      _heapfi(max);
    }
  }
}
