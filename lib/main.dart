import 'package:flutter/material.dart';

import 'package:tasks/src/pages/home.dart';
import 'package:tasks/src/pages/home_page.dart';
import 'package:tasks/src/pages/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
          colorScheme: ColorScheme.light(
        primary: Colors.deepOrange,
      )),
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'home': (BuildContext context) => HomePage(),
      },
    );
  }
}
