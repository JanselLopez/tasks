class Node implements Comparable<Node> {
  late int pos;
  late double distance;
  Node(this.pos, this.distance);
  @override
  int compareTo(Node other) => this.distance <= other.distance ? -1 : 1;
}
