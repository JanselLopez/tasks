// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tasks/data/TaskProvider.dart';

import '../../models/Task.dart';

class HomeCustomPage extends StatefulWidget {
  const HomeCustomPage({super.key});

  @override
  State<HomeCustomPage> createState() => _HomeCustomPageState();
}

class _HomeCustomPageState extends State<HomeCustomPage> {
  @override
  var _taskList =
      TaskProvider().getTaskPriorityQueue().getOrderTasksByPriority();
  var _taskPriorityQueue = TaskProvider().getTaskPriorityQueue();
  var _orderedTasks =
      TaskProvider().getTaskPriorityQueue().getOrderTasksByEndDate();
  int _posNavigationItem = 0;
  String _currentImportance = 'medium';
  var _importance = ['very low', 'low', 'medium', 'high', 'very high'];

  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showInputDialog(context);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.deepOrange,
        ),
        body: Stack(
          children: [
            _backgroundPage(),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(width: double.infinity, child: _welcome()),
                  _cards()
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: _bottomNavigationBar());
  }

  Widget _backgroundPage() {
    final gradient = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: FractionalOffset(0.0, 0.6),
        end: FractionalOffset(0.0, 1.0),
        colors: [Colors.white, Colors.white60],
      )),
    );

    final accentBox = Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        height: 360.0,
        width: 360.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepOrange.shade500,
              Colors.deepOrange.shade300,
            ],
          ),
          borderRadius: BorderRadius.circular(75.0),
        ),
      ),
    );

    return Stack(
      children: [gradient, Positioned(top: -100, child: accentBox)],
    );
  }

  Widget _welcome() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome User',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'These are your task, hurry up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                decoration: TextDecoration.none,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.deepOrange),
      child: BottomNavigationBar(
          onTap: (value) => {
                if (value == 0)
                  setState(() {
                    _taskList = _taskPriorityQueue.getOrderTasksByPriority();
                  })
                else if (value == 1)
                  setState(() {
                    _taskList = _taskPriorityQueue.getOrderTasksByEndDate();
                  })
                else if (value == 2)
                  setState(() {
                    _createDate(context);
                  }),
                setState(() {
                  _posNavigationItem = value;
                })
              },
          fixedColor: Color(0xFFFF5722),
          currentIndex: _posNavigationItem,
          items: [
            BottomNavigationBarItem(
                label: 'Priority', icon: Icon(Icons.priority_high_rounded)),
            BottomNavigationBarItem(
                label: 'Date', icon: Icon(Icons.sort_rounded)),
            BottomNavigationBarItem(
                label: 'Specific Date', icon: Icon(Icons.date_range_rounded)),
          ]),
    );
  }

  Widget _cards() {
    List<TableRow> list = [];
    for (int i = 0; i < _taskList.length; i += 2) {
      TableRow rows = TableRow(children: []);
      for (int j = 0; j < 2; j++) {
        double sigmaX = 0.001, sigmaY = 0.001;
        if (i + j < _taskList.length) {
          rows.children?.add(InkWell(
            splashColor: Colors.deepOrangeAccent,
            onTap: () {
              setState(() {
                sigmaX = sigmaY = 10.0;
              });
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
              child: Container(
                // ignore: sort_child_properties_last
                child: Row(
                  children: [
                    Container(
                      width: 10.0,
                      height: double.infinity,
                      color: _getColorByPriority(_taskList[i + j].importance),
                      padding: EdgeInsets.all(10.0),
                    ),
                    Container(
                      color: Colors.amber,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            _taskList[i + j].name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            _taskList[i + j].endDateTime.toString(),
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                height: 180.0,
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Color.fromARGB(175, 212, 212, 212),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    )),
              ),
            ),
          ));
        }
      }
      list.add(rows);
    }
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.deepOrange),
      child: Table(
        children: list,
      ),
    );
  }

  Color _getColorByPriority(priority) {
    switch (priority) {
      case "low":
        return Colors.green;
      case "medium":
        return Colors.yellow;
      case "high":
        return Colors.redAccent;
      case "very high":
        return Colors.red;
      default:
        return Colors.greenAccent;
    }
  }

  _createDate(context) {
    _selectDate(context);
  }

  _selectDate(BuildContext context) async {
    DateTime initial = DateTime.now();
    DateTime max = DateTime(2050);
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: initial,
        lastDate: max,
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                colorScheme:
                    ColorScheme.light(primary: Colors.deepOrangeAccent),
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child as Widget);
        });

    if (picked != null) {
      setState(() {
        _taskList = _taskPriorityQueue.getTaskByDate(_orderedTasks, picked);
      });
    }
  }

  Future<Task?> _showInputDialog(context) async {
    return showDialog(
        useSafeArea: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New Task'),
            content: Column(children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'name',
                ),
              ),
              Row(
                children: [
                  Text('Importance: '),
                  DropdownButton(
                      hint: Text('Importance'),
                      value: _currentImportance,
                      icon: Icon(Icons.arrow_drop_down_rounded),
                      items: _importance.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _currentImportance = value!;
                          print(value);
                        });
                      }),
                ],
              )
            ]),
            actions: [
              TextButton(onPressed: () {}, child: Text('Cancel')),
              TextButton(onPressed: () {}, child: Text('OK')),
            ],
          );
        });
  }
}
