// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tasks/data/TaskProvider.dart';
import 'package:tasks/models/dijsktra/PlacesGraph.dart';

import '../../models/Task.dart';
import '../../models/TaskPriorityQueue.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> _taskList = [];
  var _taskPriorityQueue = TaskProvider().getTaskPriorityQueue();
  var _orderedTasks =
      TaskProvider().getTaskPriorityQueue().getOrderTasksByEndDate();
  final _importance = [
    'very low',
    'low',
    'middle',
    'high',
    'very high',
  ];
  int index = 0;
  var _currentImportance = 'very low';
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Tasks'), actions: [
          MaterialButton(
            child: Icon(Icons.priority_high_rounded),
            onPressed: () {
              setState(() {
                _taskList = _taskPriorityQueue.getOrderTasksByPriority();
              });
            },
          ),
          MaterialButton(
            child: Icon(Icons.sort_outlined),
            onPressed: () {
              setState(() {
                _taskList = _taskPriorityQueue.getOrderTasksByEndDate();
              });
            },
          ),
          MaterialButton(
            child: Icon(Icons.date_range),
            onPressed: () {
              _selectDate(context);
              if (_selectedDate != DateTime.now())
                _taskList = _taskPriorityQueue.getTaskByDate(
                    _orderedTasks, _selectedDate);
            },
          ),
          MaterialButton(
            child: Icon(Icons.place_rounded),
            onPressed: () {
              _shortestRoadList(context);
            },
          ),
        ]),
        drawer: _getNavigationDrawer(),
        body: ListView(
          children: _getTask(),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepOrangeAccent,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              _displayTextInputDialog(context);
            }));
  }

  List<Widget> _getTask() {
    List<Widget> list = [];
    _taskList.forEach((element) {
      var color = Colors.lightGreen;
      switch (element.importance) {
        case 'low':
          color = Colors.green;
          break;
        case 'medium':
          color = Colors.yellow;
          break;
        case 'high':
          color = Colors.orange;
          break;
        case 'very high':
          color = Colors.red;
          break;
      }
      list.add(ListTile(
        title: Text(element.name),
        subtitle: Text(element.endDateTime.toString()),
        leading: Icon(Icons.note_alt_rounded, color: color),
      ));
      list.add(Divider());
    });
    return list;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initial = DateTime.now();
    DateTime max = DateTime(2050);
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: initial,
        lastDate: max);

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    String name = "";
    String place = "";
    var dateController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  // controller: _textFieldController,
                  decoration: InputDecoration(hintText: "Name"),
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: "End Date"),
                  controller: dateController,
                  onTap: (() {
                    _selectedDate = DateTime.now();
                    _selectDate(context).whenComplete(
                        () => dateController.text = _selectedDate.toString());
                  }),
                  readOnly: true,
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      place = value;
                    });
                  },
                  // controller: _textFieldController,
                  decoration: InputDecoration(hintText: "Place"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField(
                    // Initial Value
                    value: _currentImportance,
                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),
                    // Array list of items
                    items: _importance
                        .map((item) => DropdownMenuItem(
                              child: Text(item),
                              value: item,
                            ))
                        .toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (item) =>
                        setState(() => _currentImportance = item.toString()),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('CANCEL', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: Text('OK', style: TextStyle(color: Colors.green)),
                onPressed: () {
                  setState(() {
                    _taskPriorityQueue.insert(Task(
                        0, name, _selectedDate, _currentImportance, place));
                    _orderedTasks = _taskPriorityQueue.getOrderTasksByEndDate();
                    _taskList = _taskPriorityQueue.getOrderTasksByPriority();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  Widget _getNavigationDrawer() {
    return Drawer(
      child: ListView(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          DrawerHeader(child: Text('UserName')),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: (() {
              Navigator.pop(context);
            }),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: (() {
              Navigator.pop(context);
            }),
          ),
          ListTile(
            leading: Icon(Icons.place_rounded),
            title: Text('Places'),
            onTap: (() {
              _shortestRoadList(context);
              Navigator.pop(context);
            }),
          ),
          AboutListTile(
            icon: Icon(Icons.info_outline_rounded),
            applicationIcon: Icon(Icons.local_play),
            applicationVersion: '0.0.1',
            applicationLegalese: '© 2022 Team-3-301',
            applicationName: 'Tasks',
            child: Text('About'),
          )
        ],
      ),
    );
  }

  Future<void> _shortestRoadList(BuildContext context) async {
    PlacesGraph graph = PlacesGraph();
    List<String> places = [];
    _taskList.forEach((element) {
      if (!places.contains(element.place)) {
        places.add(element.place);
        graph.addNewPlace(element.place);
      }
    });
    print(places.length);

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Shortest Roads'),
              content: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: DropdownButtonFormField(
                      // Initial Value
                      value: graph.places[index],
                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),
                      // Array list of items
                      items: places
                          .map((item) => DropdownMenuItem(
                                child: Text(item),
                                value: item,
                              ))
                          .toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (item) => setState(() => index = item as int),
                    ),
                  ),
                  Text(getRoutes(graph, index)),
                ],
              ));
        });
  }

  String getRoutes(graph, index) {
    String roads = "";
    int i = 0;
    graph.getShortestRoad(0).forEach((element) {
      roads +=
          "from ${graph.places[0]} to ${graph.places[i++]} takes $element km\n\n";
    });
    return roads;
  }
}
