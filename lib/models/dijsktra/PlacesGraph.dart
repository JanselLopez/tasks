import 'dart:collection';

import 'DistanceProvider.dart';
import 'Node.dart';
import 'PriorityQueue.dart';

class PlacesGraph {
  List<String> places = [];
  List<List<Node>> connections = [];
  int size = 0;

  bool isTwoPlacesInTheList(vertex1, vertex2) =>
      isPlaceInTheList(vertex1) && isPlaceInTheList(vertex2);

  bool isPlaceInTheList(vertex) => places.contains(vertex);

  addNewPlace(String newPlace) {
    if (!isPlaceInTheList(newPlace)) {
      places.add(newPlace);
      connections.add([]);
      size++;
      for (int i = 0; i < size - 1; i++)
        insertRoad(places[i], newPlace,
            DistanceProvider().getDistanceBetween(places[i], newPlace));
    }
  }

  insertRoad(String place1, String place2, double distance) {
    if (isTwoPlacesInTheList(place1, place2)) {
      var pos1 = places.indexOf(place1);
      var pos2 = places.indexOf(place2);
      connections[pos1].add(Node(pos2, distance));
      connections[pos2].add(Node(pos1, distance));
    }
  }

  int getPlace(String placeName) {
    for (int i = 0; i < size; i++) if (places[i] == placeName) return i;
    return -1;
  }

  List<String> adjacenciesOf(vertex) {
    List<String> adjacencies = [];
    int pos = places.indexOf(vertex);
    if (pos != -1) {
      connections[pos].forEach((element) {
        adjacencies.add(places[element.pos]);
      });
    }
    return adjacencies;
  }

  List<double> getShortestRoad(int sourcePosition) {
    List<double> dist = [];
    Set<int> settled = HashSet<int>();
    PriorityQueue<Node> priorityQueue = PriorityQueue();
    for (int i = 0; i < size; i++) {
      dist.add(99999999);
    }
    // Add source node to the priority queue
    priorityQueue.insert(Node(sourcePosition, 0));
    // Distance to the source is 0
    dist[sourcePosition] = 0;

    while (settled.length != size) {
      // Terminating condition check when
      // the priority queue is empty, return
      if (priorityQueue.isEmpty()) return dist;

      // Removing the minimum distance node
      // from the priority queue
      int u = priorityQueue.pop()!.pos;
      // Adding the node whose distance is
      // finalized
      // Continue keyword skips execution for
      // following check
      if (settled.contains(u)) continue;
      // We don't have to call e_Neighbors(u)
      // if u is already present in the settled set.
      settled.add(u);
      e_Neighbours(u, settled, dist, priorityQueue);
    }
    return dist;
  }

  void e_Neighbours(int u, Set<int> settled, List<double> dist,
      PriorityQueue<Node> priorityQueue) {
    double edgeDistance = -1;
    double newDistance = -1;
    // All the neighbors of v
    for (int i = 0; i < connections[u].length; i++) {
      Node v = connections[u][i];
      // If current node hasn't already been processed
      if (!settled.contains(v.pos)) {
        edgeDistance = v.distance;
        newDistance = dist[u] + edgeDistance;
        // If new distance is cheaper in cost
        if (newDistance < dist[v.pos]) dist[v.pos] = newDistance;
        // Add the current node to the queue
        priorityQueue.insert(new Node(v.pos, dist[v.pos]));
      }
    }
  }
}
