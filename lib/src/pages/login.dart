// ignore_for_file: prefer_const_constructors

import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        children: <Widget>[_presentpage(), _loginpage(context)],
      ),
    );
  }

  Widget _presentpage() {
    return Stack(
      children: [
        _background(),
        _contentPresent(),
      ],
    );
  }

  Widget _loginpage(BuildContext context) {
    return SafeArea(
        child: Column(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        SizedBox(
          height: 40.0,
        ),
        Text('App Name',
            style: TextStyle(
                fontSize: 20.0,
                color: Color.fromRGBO(47, 72, 88, 1),
                fontWeight: FontWeight.bold)),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter your data',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold)),
            Padding(
              padding: EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 40.0, bottom: 10.0),
              child: TextField(
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                  hintText: 'email',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 10.0, bottom: 40.0),
              child: TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                  hintText: 'password',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange)),
                ),
              ),
            ),
            _register(),
            _getLoginButton(context)
          ],
        ))
      ],
    ));
  }

  Widget _background() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromRGBO(47, 72, 88, 1),
    );
  }

  Widget _contentPresent() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40.0,
          ),
          Container(
            width: double.infinity,
          ),
          const Text(
            'App Name',
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          const Expanded(child: Icon(Icons.note)),
          const Text(
            'This app is lorem ipsum',
            style: TextStyle(fontSize: 14.0, color: Colors.white),
          ),
          const SizedBox(
            height: 50.0,
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 70.0,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  Widget _getLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamed(context, 'home');
        });
      }, //This prop for beautiful expressions
      child: Text(
          "Login"), // This child can be everything. I want to choose a beautiful Text Widget
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        minimumSize: Size(200, 50), //change size of this beautiful button
        // We can change style of this beautiful elevated button thanks to style prop
        primary: Colors.deepOrange, // we can set primary color
        onPrimary: Colors.white, // change color of child prop
        onSurface: Colors.blue, // surface color
        shadowColor: Colors
            .grey, //shadow prop is a very nice prop for every button or card widgets.
        elevation: 5, // we can set elevation of this beautiful button
        side: BorderSide(
            color: Colors.deepOrange.shade400, //change border color
            width: 2, //change border width
            style: BorderStyle
                .solid), // change border side of this beautiful button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              30), //change border radius of this beautiful button thanks to BorderRadius.circular function
        ),
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }

  Widget _register() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Text('Don\'t you have an account?'),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextButton(
                onPressed: () {},
                child: Text('Register',
                    style: TextStyle(
                        color: Colors.deepOrange,
                        decoration: TextDecoration.underline)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
